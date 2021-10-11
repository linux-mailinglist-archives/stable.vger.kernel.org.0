Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B311428C7D
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 14:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbhJKMCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 08:02:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236045AbhJKMCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 08:02:31 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BBaqMH025554;
        Mon, 11 Oct 2021 08:00:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=qaCzsk2X6BjoPuaJEXDI1G2yrzJ+5MzB9x07BE2rhaE=;
 b=sGdMlAoxTyJ1bwobu5NSq9pnNgqtKmDZiXmAKgsGgmZVoUz4mJHaEP+gW9fYkn+4qxC/
 GfD0Iajj1+HjaWhMI8mu5NOshHadEOtwciY/uOCcl4wZMvH3ADvyvikXon4AGtDny/PR
 15AJ8uCVsq1OzSnfseEhnpxZFLk8c/4VpIyjBozYVz5XENzsGlnogNYvmWnZCV5fxIM+
 gr3C9OMhUAYqHvxC1WuLEsPPP1Z/2VZr7byqIiye9AQZLPL7fWcbMTuFtPP9YSvOGI4B
 J7tCqhWX84i+gSLcizKTbNYRChpP4uX10I8V4lH+wVwh/I4YZ3XgQHKww6PZl81rHdXs 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmka4j0fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 08:00:30 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19BBdPid000905;
        Mon, 11 Oct 2021 08:00:30 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmka4j0ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 08:00:29 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19BBvJcs032622;
        Mon, 11 Oct 2021 12:00:27 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3bk2q95ct7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 12:00:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19BC0JCQ40763670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 12:00:19 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A674AE085;
        Mon, 11 Oct 2021 12:00:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F7E3AE06A;
        Mon, 11 Oct 2021 12:00:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Oct 2021 12:00:15 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, bfu@redhat.com
Subject: [RFC PATCH 1/1]  s390/cio: make ccw_device_dma_* more robust
Date:   Mon, 11 Oct 2021 13:59:55 +0200
Message-Id: <20211011115955.2504529-1-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iDSaTA3xPLiDeK4GyH0kCZQ9ho-YUcyM
X-Proofpoint-GUID: dZkFaLNA89pbATjXi9ySpdiXFTiMcOH1
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=832 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110110066
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
classic notifiers") we were supposed to make sure that
virtio_ccw_release_dev() completes before the ccw device and the
attached dma pool are torn down, but unfortunately we did not.  Before
that commit it used to be OK to delay cleaning up the memory allocated
by virtio-ccw indefinitely (which isn't really intuitive for guys used
to destruction happens in reverse construction order), but now we
trigger a BUG_ON if the genpool is destroyed before all memory allocated
form it. Which brings down the guest. We can observe this problem, when
unregister_virtio_device() does not give up the last reference to the
virtio_device (e.g. because a virtio-scsi attached scsi disk got removed
without previously unmounting its previously mounted  partition).

To make sure that the genpool is only destroyed after all the necessary
freeing is done let us take a reference on the ccw device on each
ccw_device_dma_zalloc() and give it up on each ccw_device_dma_free().

Actually there are multiple approaches to fixing the problem at hand
that can work. The upside of this one is that it is the safest one while
remaining simple. We don't crash the guest even if the driver does not
pair allocations and frees. The downside is the reference counting
overhead, that the reference counting for ccw devices becomes more
complex, in a sense that we need to pair the calls to the aforementioned
functions for it to be correct, and that if we happen to leak, we leak
more than necessary (the whole ccw device instead of just the genpool).

Some alternatives to this approach are taking a reference in
virtio_ccw_online() and giving it up in virtio_ccw_release_dev() or
making sure virtio_ccw_release_dev() completes its work before
virtio_ccw_remove() returns. The downside of these approaches is that
these are less safe against programming errors.

Cc: <stable@vger.kernel.org> # v5.3
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
classic notifiers")
Reported-by: bfu@redhat.com

---

FYI I've proposed a different fix to this very same problem:
https://lore.kernel.org/lkml/20210915215742.1793314-1-pasic@linux.ibm.com/

This patch is more or less a result of that discussion.
---
 drivers/s390/cio/device_ops.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
index 0fe7b2f2e7f5..c533d1dadc6b 100644
--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -825,13 +825,23 @@ EXPORT_SYMBOL_GPL(ccw_device_get_chid);
  */
 void *ccw_device_dma_zalloc(struct ccw_device *cdev, size_t size)
 {
-	return cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
+	void *addr;
+
+	if (!get_device(&cdev->dev))
+		return NULL;
+	addr = cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
+	if (IS_ERR_OR_NULL(addr))
+		put_device(&cdev->dev);
+	return addr;
 }
 EXPORT_SYMBOL(ccw_device_dma_zalloc);
 
 void ccw_device_dma_free(struct ccw_device *cdev, void *cpu_addr, size_t size)
 {
+	if (!cpu_addr)
+		return;
 	cio_gp_dma_free(cdev->private->dma_pool, cpu_addr, size);
+	put_device(&cdev->dev);
 }
 EXPORT_SYMBOL(ccw_device_dma_free);
 

base-commit: 64570fbc14f8d7cb3fe3995f20e26bc25ce4b2cc
-- 
2.25.1

