Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0714B5A089F
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 08:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiHYGEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 02:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiHYGEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 02:04:33 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580F49F77A;
        Wed, 24 Aug 2022 23:04:32 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27P5vOCC004173;
        Wed, 24 Aug 2022 23:04:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=PPS06212021;
 bh=faTEiM2JXFLbZRmgbMJeeabYaB8qDwx444+BAMfW2UI=;
 b=VdGhr0kEfk1QLU455brEhATO6uISCYAVTmeKypcNjG/e/MqYo6PEyXW4jzp/Sqpr5NlZ
 jkzrHTgVCjFQiXodJIgjB3xItr1iVOnxH5Wu40XubWhJjZWHPfKKpeQ6L8f5A5LeT2B0
 4F9wQNhPi41qW5tV006mRH2A5dGL7c9Z8FkKA/IznJnOUsYhIsa7XqChEEnDTdwp0qBR
 yKu6PXYIoHigKt/ueO8eyxQIMSlPq+Z7eI3DKwuIUyafcihnKRa/YFn0paXyD089M//G
 0t7+ZsP177ZLW9SexdlrklFpjKs0C943NdUmGRMEJ7qXOGrHhW5HGhwrLCN10cnCpNj0 4g== 
Received: from ala-exchng01.corp.ad.wrs.com (unknown-82-252.windriver.com [147.11.82.252])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3j53rvhf0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 24 Aug 2022 23:04:11 -0700
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 24 Aug 2022 23:04:10 -0700
Received: from otp-azaharia-l2.corp.ad.wrs.com (128.224.78.230) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2242.12 via Frontend Transport; Wed, 24 Aug 2022 23:04:08 -0700
From:   Adrian Zaharia <Adrian.Zaharia@windriver.com>
To:     <linux-mtd@lists.infradead.org>
CC:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <jani.nurminen@windriver.com>, <adrian.zaharia@windriver.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH 0/1] mtd: mtdpart: Fix cosmetic print
Date:   Thu, 25 Aug 2022 09:04:06 +0300
Message-ID: <20220825060407.335475-1-Adrian.Zaharia@windriver.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: yXX5wKaTX_POmSS2U_h6-5Z60LOu4GHN
X-Proofpoint-ORIG-GUID: yXX5wKaTX_POmSS2U_h6-5Z60LOu4GHN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_03,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxlogscore=579 mlxscore=0
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

The print of the MTD partitions during boot are off-by-one for the size.
This patch fixes this issue and shows the real last offset.

Jani Nurminen (1):
  mtd: mtdpart: Fix cosmetic print

 drivers/mtd/mtdpart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


base-commit: 072e51356cd5a4a1c12c1020bc054c99b98333df
-- 
2.37.2

