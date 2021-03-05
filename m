Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DF632E274
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 07:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhCEGq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 01:46:28 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:35582 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229446AbhCEGq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 01:46:28 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UQVyj5Y_1614926785;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQVyj5Y_1614926785)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Mar 2021 14:46:26 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, jefflexu@linux.alibaba.com,
        snitzer@redhat.com
Subject: [PATCH 4.9.y 0/3]  dm: device capability check fixes
Date:   Fri,  5 Mar 2021 14:46:22 +0800
Message-Id: <20210305064625.63098-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <1614606248249199@kroah.com>
References: <1614606248249199@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

- patch 1/3 is from upstream
- patch 2 is to fix the code specific to 4.4 (has been removed in upstream)

Jeffle Xu (3):
  dm table: fix iterate_devices based device capability checks
  dm table: fix no_sg_merge iterate_devices based device capability
    checks
  dm table: fix DAX iterate_devices based device capability checks

 drivers/md/dm-table.c | 91 +++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 34 deletions(-)

-- 
2.27.0

