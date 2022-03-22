Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554FA4E3C21
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 11:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiCVKGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 06:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbiCVKGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 06:06:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A2D396A9
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 03:04:40 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22M9foIv020298;
        Tue, 22 Mar 2022 10:02:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=EYMYrliZDmslTdFuYORdZmH3kRcbTf+wwS8MDsS8+bg=;
 b=UpoT5wc8Q1NS+Al3YwvI8crkdUe5xim+NDPSoDSRj/m/V/gKBRzdpWmzlTeLtrOGL5B5
 BDoLazxaC0OVebgZHbu+oP3SlntALHj+YxYkmD5cmFK314WBurpcMrW+rbGdDkrSi7zO
 KN2FHD/0O04oJtSxdJL0ayLrSTCbMAAIUfhRITP6XbzlIs3CTC6P50Mx/YUenk3wBplb
 0VTeppvVVdxeJ23ftlPB5JOKcumkBLRFAadyNePMYas0ekEAh6NV0iwTmEeJayAAyXid
 6jgyQe3SpSsNkABrF9JrtycoEifo4RY7xayOPnjN2biAp9ErQrV4PaShdKVFY5UYs8p/ yg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyc20gewq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 10:02:32 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22M9rAXj015843;
        Tue, 22 Mar 2022 10:02:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ew6t8n236-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 10:02:30 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MA2UhR47317264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 10:02:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53176A4055;
        Tue, 22 Mar 2022 10:02:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 019B9A404D;
        Tue, 22 Mar 2022 10:02:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Mar 2022 10:02:26 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH for 5.10.y 0/2] backports of ddbd89deb7d3 and aa6f8dcbab47 
Date:   Tue, 22 Mar 2022 11:02:16 +0100
Message-Id: <20220322100218.2158138-1-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xoqvwBUVGguaI_VqhqR2TBiBG75S4eXj
X-Proofpoint-GUID: xoqvwBUVGguaI_VqhqR2TBiBG75S4eXj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_03,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=685 clxscore=1015
 phishscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203220060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Stable Team,

This is a backport of ddbd89deb7d3 ("swiotlb: fix info leak with
DMA_FROM_DEVICE") and aa6f8dcbab47 ("swiotlb: rework "fix info leak with
DMA_FROM_DEVICE"") to 5.10.y.  

I had to handle some merge conflicts, and at this point we have
swiotlb_tbl_sync_single() as opposed to swiotlb_sync_single_for_device()
so I had to handle that as well.

Halil Pasic (2):
  swiotlb: fix info leak with DMA_FROM_DEVICE
  swiotlb: rework "fix info leak with DMA_FROM_DEVICE"

 kernel/dma/swiotlb.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)


base-commit: 9d7b0ced5647e0df1b200ee29119cb58ff958339
-- 
2.32.0

