Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1CE331D9E
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 04:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhCIDdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 22:33:50 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:46475 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229701AbhCIDdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 22:33:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UR.U57M_1615260824;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UR.U57M_1615260824)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Mar 2021 11:33:45 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, jefflexu@linux.alibaba.com
Subject: [PATCH v2 4.19 0/3] dm table: fix iterate_devices based device
Date:   Tue,  9 Mar 2021 11:33:41 +0800
Message-Id: <20210309033344.111111-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport notes are detailed in the corresponding commit log.

changes since v1:
- fix build error of patch 1
- fix upstream commit id of patch 2

Jeffle Xu (3):
  dm table: fix iterate_devices based device capability checks
  dm table: fix DAX iterate_devices based device capability checks
  dm table: fix zoned iterate_devices based device capability checks

 drivers/md/dm-table.c | 174 ++++++++++++++++++------------------------
 1 file changed, 73 insertions(+), 101 deletions(-)

-- 
2.27.0

