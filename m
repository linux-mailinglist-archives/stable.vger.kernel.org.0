Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4313C6D67
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 11:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbhGMJce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 05:32:34 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:11293 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234819AbhGMJcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 05:32:33 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GPFbZ4ftBz78Wx;
        Tue, 13 Jul 2021 17:25:14 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:29:40 +0800
Received: from linux-ibm.site (10.175.102.37) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:29:40 +0800
From:   Hanjun Guo <guohanjun@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [Backport for 5.10.y PATCH 0/7] Patches for 5.10.y
Date:   Tue, 13 Jul 2021 17:18:30 +0800
Message-ID: <1626167917-11972-1-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

Patches below are some collections of bugfixes, those fixes are
found when we are using the stable 5.10 kernel, please consider
to apply them, I also Cced the author and maintainer for each
patch to see if any objections.


Patch 2/7 will fix the failure of LTP test case 'move_pages 12',
and patch 3/7 is not a bugfix but a preparation for later bugfixes,
other patches are obvious bugfixes.


Gulam Mohamed (1):
  scsi: iscsi: Fix race condition between login and sync thread

Jens Axboe (1):
  io_uring: convert io_buffer_idr to XArray

Matthew Wilcox (Oracle) (1):
  io_uring: Convert personality_idr to XArray

Mauricio Faria de Oliveira (1):
  loop: fix I/O error on fsync() in detached loop devices

Mike Christie (1):
  scsi: iscsi: Fix iSCSI cls conn state

Oscar Salvador (1):
  mm,hwpoison: return -EBUSY when migration fails

Yejune Deng (1):
  io_uring: simplify io_remove_personalities()

 drivers/block/loop.c                |   3 +
 drivers/scsi/libiscsi.c             |  26 +-------
 drivers/scsi/scsi_transport_iscsi.c |  28 ++++++++-
 fs/io_uring.c                       | 116 +++++++++++++++---------------------
 include/scsi/scsi_transport_iscsi.h |   1 +
 mm/memory-failure.c                 |   6 +-
 6 files changed, 85 insertions(+), 95 deletions(-)

-- 
1.7.12.4

