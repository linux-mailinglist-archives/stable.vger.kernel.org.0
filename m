Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01DBC458303
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 12:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhKULF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 06:05:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhKULF2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Nov 2021 06:05:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B847608FB;
        Sun, 21 Nov 2021 11:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637492544;
        bh=/tFBvgDK6MegfggxuHVpghuxh/h4q2nzXw53CKvWRiw=;
        h=From:To:Cc:Subject:Date:From;
        b=utebRiPrQ3xof51+m39xg362UWzqxbJRsgy2PyUVaRT53nsHBEsNihlUJ+jrbjp5F
         PEVMsgs3H0vxye9Xpfn7lxi8/vJxkUmYfJZFkZKE/NX0KpkekP1WjK393teshyOdfV
         vMJoezlWxhXm+ZGcodD/iAvP4WK/LEHrA8eUSZ0g2quISs0NjvIZVu7qO7oFsWSrj9
         Sq5abOlvz+js0lgdebIkncZQWaSFu3aXhFGS3792/Hf/kTrrqX6pGaEmj3JmkDNWYE
         4tGRSKg2+EA4xOCAmJwrrslPyRdXpiSntL+HnGccl8TrfTStU+21lIXmjy1L09W2MT
         WpE1LUzTd+4bg==
From:   SeongJae Park <sj@kernel.org>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>
Subject: [PATCH for-5.15.x 0/2] DAMON fixes
Date:   Sun, 21 Nov 2021 11:02:09 +0000
Message-Id: <20211121110211.17032-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patchset is a backport of DAMON fixes that merged in the mainline,
for v5.15.x stable series.

SeongJae Park (2):
  mm/damon/dbgfs: use '__GFP_NOWARN' for user-specified size buffer
    allocation
  mm/damon/dbgfs: fix missed use of damon_dbgfs_lock

 mm/damon/dbgfs.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

-- 
2.17.1

