Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B878082A
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 21:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfHCT7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 15:59:39 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:48085 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728961AbfHCT7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Aug 2019 15:59:39 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Sat, 3 Aug 2019 12:59:31 -0700
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 8FFB1B27B5;
        Sat,  3 Aug 2019 15:59:30 -0400 (EDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <aarcange@redhat.com>, <jannh@google.com>, <oleg@redhat.com>,
        <peterx@redhat.com>, <rppt@linux.ibm.com>, <jgg@mellanox.com>,
        <mhocko@suse.com>
CC:     <jglisse@redhat.com>, <akpm@linux-foundation.org>,
        <mike.kravetz@oracle.com>, <viro@zeniv.linux.org.uk>,
        <riandrews@android.com>, <arve@android.com>,
        <yishaih@mellanox.com>, <dledford@redhat.com>,
        <sean.hefty@intel.com>, <hal.rosenstock@gmail.com>,
        <matanb@mellanox.com>, <leonro@mellanox.com>,
        <gregkh@linuxfoundation.org>, <torvalds@linux-foundation.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@driverdev.osuosl.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <akaher@vmware.com>, <srinidhir@vmware.com>, <bvikas@vmware.com>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <amakhalov@vmware.com>, <vsirnapalli@vmware.com>
Subject: [PATCH v6 0/3] [v4.9.y] coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping
Date:   Sun, 4 Aug 2019 09:29:28 +0530
Message-ID: <1564891168-30016-4-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564891168-30016-1-git-send-email-akaher@vmware.com>
References: <1564891168-30016-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

coredump: fix race condition between mmget_not_zero()/get_task_mm()
and core dumping

[PATCH v5 1/3]:
Backporting of commit 04f5866e41fb70690e28397487d8bd8eea7d712a upstream.

[PATCH v5 2/3]:
Extension of commit 04f5866e41fb to fix the race condition between
get_task_mm() and core dumping for IB->mlx4 and IB->mlx5 drivers.

[PATCH v5 3/3]
Backporting of commit 59ea6d06cfa9247b586a695c21f94afa7183af74 upstream.

[diff from v5]:
- Recreated [PATCH v6 1/3], to solve patch apply error.
