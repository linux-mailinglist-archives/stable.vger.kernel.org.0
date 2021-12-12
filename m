Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC6F47194B
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 09:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhLLI2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 03:28:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57340 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhLLI2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 03:28:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F24FDB80B60;
        Sun, 12 Dec 2021 08:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC2EC341C6;
        Sun, 12 Dec 2021 08:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639297718;
        bh=o5UM4AzwW/jtx5EHtolAFPbBkFzJYuNmNenfj7A+BdM=;
        h=From:To:Cc:Subject:Date:From;
        b=X3/cIuJCzh9IPXNEk/XcVdNHUuW4tL3/0RQEmZ6HFcXPZ4tYsS8/Io9f5ddY9+kYU
         H+VZUYImhVD0+hqS2yb0au6n2KLnEkjplXgzl8hxlXiuzo0yU+Oe5n8e6jllvgiTSj
         /Fme3yQhSzGqYT2a72qwiPhm4pEvrjV8gwpe125H50VUirKN5HS/M8mYuvAEEgXgJG
         NkgwdINrdGkuJpHYeZJ0EaeWYRwAF5kgt0bQ504jXyUk3HbryYexS07hGptipX1iLY
         77rggVUx8vWbJuNTH8CQI21x0wV3IGM/WXS5f0MosjazIK60orhY1jFg1TToC1jimO
         1AvdOvzlhT2JA==
From:   SeongJae Park <sj@kernel.org>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>
Subject: [PATCH for-v5.15.x 0/2] mm/damon/core: Fix fake load reports due to uninterruptible sleeps
Date:   Sun, 12 Dec 2021 08:28:28 +0000
Message-Id: <20211212082831.26988-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patchset is a backport of DAMON fixes that merged in the mainline,
for v5.15.x stable series.

SeongJae Park (2):
  timers: implement usleep_idle_range()
  mm/damon/core: fix fake load reports due to uninterruptible sleeps

 include/linux/delay.h | 14 +++++++++++++-
 kernel/time/timer.c   | 16 +++++++++-------
 mm/damon/core.c       | 14 +++++++++++---
 3 files changed, 33 insertions(+), 11 deletions(-)

-- 
2.17.1

