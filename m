Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3B748F3B1
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 02:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiAOBBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 20:01:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38238 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiAOBBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 20:01:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91DF46208B
        for <stable@vger.kernel.org>; Sat, 15 Jan 2022 01:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9320C36AEA;
        Sat, 15 Jan 2022 01:01:47 +0000 (UTC)
From:   Jaegeuk Kim <jaegeuk@google.com>
To:     stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@google.com>, timmurray@google.com,
        longman@redhat.com, peterz@infradead.org
Subject: [PATCH 0/7] rwsem enhancement patches for 5.10
Date:   Fri, 14 Jan 2022 16:59:39 -0800
Message-Id: <20220115005945.2125174-1-jaegeuk@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Per discussion [1], can we merge these patches in 5.10 first?

[1] https://lore.kernel.org/linux-f2fs-devel/CAEe=Sx=6FCvrp_6x2Bqp3YTzep2s=aWdCmP29g7+sGCWkpNvkg@mail.gmail.com/T/#t

Peter Zijlstra (3):
  locking/rwsem: Better collate rwsem_read_trylock()
  locking/rwsem: Introduce rwsem_write_trylock()
  locking/rwsem: Fold __down_{read,write}*()

Waiman Long (4):
  locking/rwsem: Pass the current atomic count to
    rwsem_down_read_slowpath()
  locking/rwsem: Prevent potential lock starvation
  locking/rwsem: Enable reader optimistic lock stealing
  locking/rwsem: Remove reader optimistic spinning

 kernel/locking/lock_events_list.h |   6 +-
 kernel/locking/rwsem.c            | 359 +++++++++---------------------
 2 files changed, 106 insertions(+), 259 deletions(-)

-- 
2.34.1.703.g22d0c6ccf7-goog

