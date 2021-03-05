Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B9032E23C
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 07:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhCEGbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 01:31:08 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:8257 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229458AbhCEGbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 01:31:07 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UQUb6uz_1614925851;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQUb6uz_1614925851)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Mar 2021 14:30:52 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, jefflexu@linux.alibaba.com,
        snitzer@redhat.com
Subject: [PATCH 4.4.y 0/2] dm: device capability check fixes
Date:   Fri,  5 Mar 2021 14:30:49 +0800
Message-Id: <20210305063051.51030-1-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <161460624611368@kroah.com>
References: <161460624611368@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

- patch 1 is from upstream
- patch 2 is to fix the code specific to 4.4 (has been removed in upstream)

Jeffle Xu (2):
  dm table: fix iterate_devices based device capability checks
  dm table: fix no_sg_merge iterate_devices based device capability
    checks

 drivers/md/dm-table.c | 83 +++++++++++++++++++++++++++----------------
 1 file changed, 53 insertions(+), 30 deletions(-)

-- 
2.27.0

