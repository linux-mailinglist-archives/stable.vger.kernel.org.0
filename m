Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0934532E290
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 07:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCEGza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 01:55:30 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:49483 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229446AbhCEGza (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 01:55:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UQXT1zE_1614927326;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQXT1zE_1614927326)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Mar 2021 14:55:27 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, jefflexu@linux.alibaba.com,
        snitzer@redhat.com
Subject: [PATCH 4.19.y 0/5]  dm: device capability check fixes
Date:   Fri,  5 Mar 2021 14:55:21 +0800
Message-Id: <20210305065526.72663-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <1614606251118245@kroah.com>
References: <1614606251118245@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

- patch 1/4/5 is from upstream
- patch 2/3 is to fix the code specific to 4.4 (has been removed in upstream)

Jeffle Xu (5):
  dm table: fix iterate_devices based device capability checks
  dm table: fix no_sg_merge iterate_devices based device capability
    checks
  dm table: fix partial completion iterate_devices based device
    capability checks
  dm table: fix DAX iterate_devices based device capability checks
  dm table: fix zoned iterate_devices based device capability checks

 drivers/md/dm-table.c | 174 ++++++++++++++++++------------------------
 1 file changed, 73 insertions(+), 101 deletions(-)

-- 
2.27.0

