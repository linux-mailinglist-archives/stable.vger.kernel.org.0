Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3CC2F1C68
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 18:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389454AbhAKRcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 12:32:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727121AbhAKRcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 12:32:15 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BH3PHv131115
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:31:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=HBqQvJqcO10ZgSTvxjIb819Nir9YKr9VbWPE4ALFgb8=;
 b=egg63wwZgdKCBrQHZYC+Yh2QcRJNoG7UnM5PUNGibij8UDbijv58TCNsPjGh3TH2D8OR
 JUQHnmChc61pWWQlf6bQGj8E+pmPl3AB1Wi0CQodjsTbTuFCpWKjNat3DM4opwP8WUz5
 yzJ/jqKh42hK4z7oR/NzgwlUtxcpCaL3JXS1rfGyqnDf67DEDAVPLrkgaoBV3MfC4eAb
 LGFYFiluBMu+WOILSahV1iiX32XEA0yKgr6YAZgFNs9M0R6q0L0qJ45Ls7cJp9+eqpIh
 RE7UOr6AfINRYaNcV6ZofMsz/GfOUaQkCJha2a9dgjMtc95k+BS18dO9aWJRvR9iZpNg ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360tewsh4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:31:34 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10BH3gew136055
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:31:34 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360tewsh48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 12:31:34 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BHNhYo026558;
        Mon, 11 Jan 2021 17:31:33 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 35y448r75n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 17:31:33 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BHVWr626411318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 17:31:32 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5786413604F;
        Mon, 11 Jan 2021 17:31:32 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EAFC136051;
        Mon, 11 Jan 2021 17:31:31 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.159.40])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jan 2021 17:31:31 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com
Subject: [PATCH] Request backport of a vfio patch for 5.4 stable
Date:   Mon, 11 Jan 2021 12:31:27 -0500
Message-Id: <1610386288-26220-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_28:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 bulkscore=0 impostorscore=0 spamscore=0 suspectscore=0 mlxlogscore=936
 adultscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110099
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 7d6e1329652e ("vfio iommu: Add dma available capability")
should probably have been identified as a stable candidate originally, as
without this available in a KVM host QEMU guests on at least s390x can
end up with broken PCI passthrough devices, as the guest is unaware of the
vfio DMA limit and can easily overrun it. 

The commit in question won't fit cleanly to 5.4, so I've included a
proposed backport patch.

Matthew Rosato (1):
  vfio iommu: Add dma available capability

 drivers/vfio/vfio_iommu_type1.c | 22 ++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 15 +++++++++++++++
 2 files changed, 37 insertions(+)

-- 
1.8.3.1

