Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E9A439232
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 11:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbhJYJYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 05:24:03 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:47862 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229963AbhJYJYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 05:24:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=rongwei.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UtZwp5E_1635153697;
Received: from localhost.localdomain(mailfrom:rongwei.wang@linux.alibaba.com fp:SMTPD_---0UtZwp5E_1635153697)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Oct 2021 17:21:38 +0800
From:   Rongwei Wang <rongwei.wang@linux.alibaba.com>
To:     akpm@linux-foundation.org, willy@infradead.org, song@kernel.org,
        william.kucharski@oracle.com, hughd@google.com, shy828301@gmail.com
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 0/2] fix two bugs for file THP
Date:   Mon, 25 Oct 2021 17:21:32 +0800
Message-Id: <20211025092134.18562-1-rongwei.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch 1/2 had been sent about weeks ago, the original
link here:
https://patchwork.kernel.org/project/linux-mm/patch/20211011022241.97072-2-rongwei.wang@linux.alibaba.com/
It seems to be ignored, and send out again here.

Patch 2/2 is sent out first time. And Patch 1/2 and
2/2 both to fix different bugs for commit
eb6ecbed0aa2 ("mm, thp: relax the VM_DENYWRITE constraint on file-backed
THPs").

In addition, I find the stable version (I had check 5.14) has contained
above commit (eb6ecbed0aa2), so I will add "cc stable mail list"
when sending Patches.

Thanks!

Rongwei Wang (2):
  mm, thp: lock filemap when truncating page cache
  mm, thp: fix incorrect unmap behavior for private pages

 fs/open.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

-- 
2.27.0

