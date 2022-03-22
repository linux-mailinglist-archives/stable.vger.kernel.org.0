Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969D94E3EA7
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 13:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiCVMnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 08:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbiCVMnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 08:43:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A7C85960
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 05:41:43 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22M9fsGV020367;
        Tue, 22 Mar 2022 12:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=pAjl5M3sDtMeDxJpMb26TPGjn08cdoOyiyL6zU9uJWg=;
 b=hvEDpe16k8XCAdDJPwyRIZr9zQHth1iMo2AkAfV6HvhkAoJtVxDuXSiIxRlhWne3yTE0
 LwgQ+o7SPfndz9CWClQaqRxxnqY51lPFPrDaZ55rQR9TNecgLHWm87RWUMEOPkn+Rjsl
 gfILmv8gLlkyIy6WTslW0lP0swwKKXG+mhvNPFqnATTBI/mV5yyJMM3+G4u5FD2cJ6Zz
 tcx8iI42vfvfigrWQxnqnigySLSwtpxjD8RrxxXRqllM9XFmjLkZ2MyWnMd6lDA+If0D
 F+6h1VX9uFgxfxMlZ4kjCSVnxE4IHhXgikdh+/9Tr6bYeii95zP3VI7mzN0J13QUPKkQ 4w== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyc20krn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 12:41:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MCZHID010280;
        Tue, 22 Mar 2022 12:41:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3ew6ehx7en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 12:41:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MCfWCL43123138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 12:41:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24EBAAE053;
        Tue, 22 Mar 2022 12:41:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDE77AE045;
        Tue, 22 Mar 2022 12:41:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Mar 2022 12:41:31 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH for 5.4.y 0/2] backort of ddbd89deb7d3 and aa6f8dcbab47
Date:   Tue, 22 Mar 2022 13:41:26 +0100
Message-Id: <20220322124128.2232849-1-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: e-hd0Uhs2h0spTml2sYvfKS3FcocGCKi
X-Proofpoint-GUID: e-hd0Uhs2h0spTml2sYvfKS3FcocGCKi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_04,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=684 clxscore=1015
 phishscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203220072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a backport of ddbd89deb7d3 ("swiotlb: fix info leak with
DMA_FROM_DEVICE") and aa6f8dcbab47 ("swiotlb: rework "fix info leak with
DMA_FROM_DEVICE"") for 5.4.y.

I had to handle some merge conflicts, that at this point we have
swiotlb_tbl_sync_single() as opposed to
swiotlb_sync_single_for_device(), and also a file rename from
Documentation/DMA-attributes.txt to
Documentation/core-api/dma-attributes.rst. 


Halil Pasic (2):
  swiotlb: fix info leak with DMA_FROM_DEVICE
  swiotlb: rework "fix info leak with DMA_FROM_DEVICE"

 kernel/dma/swiotlb.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)


base-commit: 7f44fdc1563d6bca95ee9fb4414e4b8286bccb0c
-- 
2.32.0

