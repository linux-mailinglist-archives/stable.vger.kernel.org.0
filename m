Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E145A089E
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 08:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiHYGEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 02:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiHYGEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 02:04:33 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF1D9F779;
        Wed, 24 Aug 2022 23:04:32 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27P60AUR011000;
        Wed, 24 Aug 2022 23:04:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=PPS06212021;
 bh=X9RNAuRl48yKaT3FZoepRQ1FjmBaxmqyZCz8sO6VjWs=;
 b=CQ/qfPU+0h5ddUlGDmeqyHjQ/quRKmF9eO4mnzYTdMSGBe0VDGMAgApI/EOzGAT269H2
 IbrUU29uQhNsJBNfTuat0VQjydR18zLLVVlVVgxtEls1/sWy1GcRieAj/VJJHxLoL2Pc
 S2dJsyxDRgH2FAQ7xfugBIXZiIURo5hxjb0aDw1vGfHIBDlD7/lMOtheofRTbtXIzbxG
 6/dY91glVBekz9it01iJKBykUBW1LK3ZfOmXofNYXjCNYliRCL+OyWvCLdSKJM+FZEg3
 4nzjoN1VBIz/N31vXjpdZ9s+ycuh5uf60MsI87XekvNpE4Hux9V65eXjxqU97yoSy4FT sA== 
Received: from ala-exchng01.corp.ad.wrs.com (unknown-82-252.windriver.com [147.11.82.252])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3j53rvhf0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 24 Aug 2022 23:04:13 -0700
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 24 Aug 2022 23:04:13 -0700
Received: from otp-azaharia-l2.corp.ad.wrs.com (128.224.78.230) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2242.12 via Frontend Transport; Wed, 24 Aug 2022 23:04:11 -0700
From:   Adrian Zaharia <Adrian.Zaharia@windriver.com>
To:     <linux-mtd@lists.infradead.org>
CC:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <jani.nurminen@windriver.com>, <adrian.zaharia@windriver.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH 1/1] mtd: mtdpart: Fix cosmetic print
Date:   Thu, 25 Aug 2022 09:04:07 +0300
Message-ID: <20220825060407.335475-2-Adrian.Zaharia@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220825060407.335475-1-Adrian.Zaharia@windriver.com>
References: <20220825060407.335475-1-Adrian.Zaharia@windriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 8ZGl-Ddu7gZ63T_cH1hE1rLUZ2vFDtif
X-Proofpoint-ORIG-GUID: 8ZGl-Ddu7gZ63T_cH1hE1rLUZ2vFDtif
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_03,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxlogscore=824 mlxscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250020
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nurminen <jani.nurminen@windriver.com>

The print of the MTD partitions during boot are off-by-one for the size.
Fix this and show the real last offset.

Fixes: 3d6f657ced2b ("mtd: mtdpart: Fix cosmetic print")
Signed-off-by: Jani Nurminen <jani.nurminen@windriver.com>
Signed-off-by: Adrian Zaharia <Adrian.Zaharia@windriver.com>
---
 drivers/mtd/mtdpart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index d442fa94c872..fab10e6d4171 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -118,7 +118,7 @@ static struct mtd_info *allocate_partition(struct mtd_info *parent,
 		child->part.size = parent_size - child->part.offset;
 
 	printk(KERN_NOTICE "0x%012llx-0x%012llx : \"%s\"\n",
-	       child->part.offset, child->part.offset + child->part.size,
+	       child->part.offset, child->part.offset + child->part.size - 1,
 	       child->name);
 
 	/* let's do some sanity checks */
-- 
2.37.2

