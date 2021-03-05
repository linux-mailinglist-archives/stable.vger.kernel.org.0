Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BCE32E29F
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 07:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhCEG50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 01:57:26 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:47034 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229458AbhCEG50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 01:57:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UQXPcpp_1614927443;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQXPcpp_1614927443)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Mar 2021 14:57:23 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, jefflexu@linux.alibaba.com,
        snitzer@redhat.com
Subject: [PATCH 5.4.y 0/4]  dm: device capability check fixes
Date:   Fri,  5 Mar 2021 14:57:18 +0800
Message-Id: <20210305065722.73504-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <161460625264244@kroah.com>
References: <161460625264244@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

- patch 1/3/4 is from upstream
- patch 2 is to fix the code specific to 4.4 (has been removed in upstream)

Jeffle Xu (4):
  dm table: fix iterate_devices based device capability checks
  dm table: fix partial completion iterate_devices based device
    capability checks
  dm table: fix DAX iterate_devices based device capability checks
  dm table: fix zoned iterate_devices based device capability checks

 drivers/md/dm-table.c | 174 ++++++++++++++++++------------------------
 drivers/md/dm.c       |   2 +-
 drivers/md/dm.h       |   2 +-
 3 files changed, 75 insertions(+), 103 deletions(-)

-- 
2.27.0

