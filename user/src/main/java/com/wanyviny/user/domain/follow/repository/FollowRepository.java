package com.wanyviny.user.domain.follow.repository;

import com.wanyviny.user.domain.follow.entity.Follow;
import com.wanyviny.user.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface FollowRepository extends JpaRepository<Follow, Long> {
    @Query("SELECT f.followingId FROM Follow f where f.userId.id = :userId")
    List<com.wanyviny.user.domain.user.entity.User> findFollowingByUserId(Long userId);

    @Query("SELECT f.userId FROM Follow f where f.followingId.id = :userId")
    List<com.wanyviny.user.domain.user.entity.User> findFollowerByUserId(Long userId);

    boolean existsFollowByUserId_IdAndFollowingId_Id(Long userId, Long followingId);

    @Transactional
    void deleteByUserIdAndFollowingId(User userId, User followingId);
}
