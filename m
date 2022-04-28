Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CD051367C
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 16:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348143AbiD1OOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 10:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348139AbiD1OOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 10:14:24 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD5B712D6
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 07:11:09 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SBCnXY018532;
        Thu, 28 Apr 2022 07:10:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=oLlLbso0+22WbydvYZ79DcC3J1W/dB16hp5knY2/e5s=;
 b=cQ1hwFXLC0KJ650lQ2D6cPhOIW3IRllszNcdYF/B0HD6bOcE1JgN9RQvXXvP6zo50Wt+
 YSd6tw9Uq5rwmtbgNicLvV4UE1pEpjU8+ApdXjtKmQEZO2s+mY+x/ZMD/pFoNK+Ct2rD
 khfxwO6L3KKd9ZMBB7RMum5IRQ7Ianb35DSXmr76ukgKRir/7MucMpgVZRy3A6ZV245P
 9zp1xE6xUdYdWf1xqPyEtCtoeUfnILeQt04bC9QSdz3QE9V6lCgJgKnEEy97Xe2bwhj+
 I6UXwhBktoT8IfsiSs0Wvc2KY1MaocAnfVboWXY2BYl9KC1LIWwEW8VTtkN0YO9qJ3qx Kg== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fps57sdss-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 07:10:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVme8LuLM14CTh+H/HXHyN2kVbWYNdWYv8gBdwFQLshrOh6p2aRSkfAM/GJwickp7LsXBPfRQ1oryvB5g2QoyzPT53NEvqZtetRdLhcec2x+L1FeSRObE2NULpEMtf/Tc8OERB8X4lfPkcNDrdA76HkzQxU2RjRS2zt8yrj75xF7Zgi4UY5NgvfwotY5l7cuamNzRzlxCx+V1JHLdEB9dfBMX6KiErYu5cHsg21pHCYiVJXKx+PL0NJxA4Opcn1m8AoAe46lko3liP1vIg0IYotfd3UAIC/TtZcKuCaji9mDQWa3ZiTWknnnaPyn+30RLQzCmc4B9nhF5Yxh7cCQtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLlLbso0+22WbydvYZ79DcC3J1W/dB16hp5knY2/e5s=;
 b=NTixEw5k76da5a/4PbzbHxpQoZTkhQ2rmRxhqSbia2wqXxDqw0R17ymUGhaUsf3XnjzdvogY++ORvI3p4yhTUaC+Pvf9p1QxQIpKcTN7xPlxTzniG+14jNYpN2LqunmzfZKhdjtpxQktk1j1cLIqTQ0oBxPuPeZKL+fgw54/wUM2Xmwv2vDhObF75/qpteQkChHEEkGqsRxHGgu85UG57WYVpOcnWGWj12HbyzagaaZojJjkvUwHUDAPHsOoT5/tGhvsSXrRDPINNRjDBXldiF5AlBIUHKZWs03SA8XBnaxUA3MkiTRPq5RJ9jW9YRe9GHQhd4zNhONJtkCvlwnwHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN6PR11MB1425.namprd11.prod.outlook.com (2603:10b6:405:9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 14:10:55 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%7]) with mapi id 15.20.5186.023; Thu, 28 Apr 2022
 14:10:55 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>, Jakub Kicinski <kuba@kernel.org>,
        Xu Jia <xujia39@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 2/2] hamradio: remove needs_free_netdev to avoid UAF
Date:   Thu, 28 Apr 2022 17:10:32 +0300
Message-Id: <20220428141032.1026227-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428141032.1026227-1-ovidiu.panait@windriver.com>
References: <20220428141032.1026227-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0024.eurprd08.prod.outlook.com
 (2603:10a6:803:104::37) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b822fea-737f-4637-43bd-08da2920e8db
X-MS-TrafficTypeDiagnostic: BN6PR11MB1425:EE_
X-Microsoft-Antispam-PRVS: <BN6PR11MB142559948221019AD5434A3BFEFD9@BN6PR11MB1425.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K/0fFGa4ADCPEHvtuXBPitCavGVN5JdbwbUxaz1Kii3JtjOBd8cLUfoyxUom0CaUXM6Ca7eNo/ATJLAoQsvaxLB32BQr1ALLUALOTA/MrnsxhXUes2Ls4+l9jdiT+nxiGkfHI3EyOKoeGM8NRq+pzfeQf55jd6c+0VXJbP8dzPsQpAJA/NpojlGpFQ65LhXFe4dl4l2wHVpHM3jhoxmFskDfpx4jjfWlcr/l3IA4yKHkiCwJbviC5fxgIV/5rU5rRptRTlSc4ZVKTxr8qrLFxl3dRGTzS5xUGAZRdz5HLymh9eWYTMnjAKNm7rLmnPYTdBR4CTwoPSvkizDbb1Omq53E/VAIe921FpbYPttQ473uQdRZTRA2NS7mWtTZzSHRqRDie4DaKZyMQpEEFMHr/ZqDQGFlglJVsjE4FXQ6seqaYqv8mZASk0hDe6pPQ7jDn7cH4KTFNZHtSmv/S1hctaVXiMTrKoHX/W1k6ORu9DTRZWW7Zp7a1S5snsJF2kpDNdWK6gRCKEjzvRQR3dl9l7fonGMs72HSBHxIhMju6VpjUH+iMWgZIaO7mKpr+3CMdMJGrVkv18UQapePWutQsIOqXr4bPuDOZquly0jYlwl6lEPqvZtMtR9RnmvhdpBEs9ZCCQ2kj5b+uQwOIlVObVZcM1c4UHM8YUjFKVew4GKKzSXTAXN8pq7yV5m/6MSv3wlezJy/LqFliAbUM/nEZQsRodmXs2adTtNFkj7FUk8yReb0Mbdy18jX6od+4g04p/fyY35s3D6pHKhSyWBcHDYulXga5QlTMvS3jBkiPF0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(38350700002)(38100700002)(6512007)(26005)(66946007)(5660300002)(2906002)(4326008)(8676002)(8936002)(66556008)(66476007)(36756003)(1076003)(186003)(86362001)(316002)(6486002)(107886003)(966005)(2616005)(54906003)(6916009)(52116002)(508600001)(83380400001)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ISY2N3hRVzOu84vgFvHHnkWJUbxFQ90XSy68OYfiSiV5MBnbnL2QN9L1Zqph?=
 =?us-ascii?Q?nnTOEbC3qvOTHZkG1xOcqXW1r5p2OvreCCPY2NA3aFwPwFmbKXv8E2L8Icsu?=
 =?us-ascii?Q?hgDBwc61WAdpmQiQOV0/lmJaEUCudwXsa7JGnyTwHY345Y/2Yq8kKO2LJ9Bc?=
 =?us-ascii?Q?QPaJoKe/aPFu9Pf6fbEbx7pehrdNWCb5rtomKCQvhGNLHK0OTNsGsKRY6m7z?=
 =?us-ascii?Q?BnA8hY6AnxYZl8ZjYusuNw+NWu8Ap7sLT8KNLrWAXzgCKT53gmFK2ikqvLRG?=
 =?us-ascii?Q?QSqfueZp7VhKoXazulb/zw3Vu1jKh1KasKVOpDePxDvHzxBFHsVL1HAleloW?=
 =?us-ascii?Q?igBr/lexh9oFYNGTv6v9C7gvKCgh0fQDaSrw3RWL3D5Bckz0XGMOtt8QT97o?=
 =?us-ascii?Q?ij3I1QAkZOWDEATzX4KtBJHle9h1WPlHo5xETu/TcgEeULQ8svrytOLdofRU?=
 =?us-ascii?Q?1rapkByhMKQIhRcec/pQBwszkapOS4AWe9t6i0WAvjogA4HmEu/q4+3O060t?=
 =?us-ascii?Q?hdaVPLyrq8HtXxarFrOSapjORwuOgXnFM7BFTiiIpCnDU5RLlPjWSadTL1Vd?=
 =?us-ascii?Q?8IhMFcIpnf7o6+PLHc3IQewQHj4t848D2s2qv9SU98SO4l6xKRK55V/hGoGW?=
 =?us-ascii?Q?DYDGvn7oOwhSVlQ7A1qr6ObVHC0D1IwlXVdTa3/OrWwxP3aFn+4f6YG6VSbQ?=
 =?us-ascii?Q?0Prcl9w6bnAdHlIiBT2IqZpVBBP/puJJQDO0afdQEMjawRj4OM0T3j3G03fB?=
 =?us-ascii?Q?yXU7XvAesFpPdUVldhEXTSX4vi5KCZwsjdLOEt7y+z/zl2829wZpxfwwyhS7?=
 =?us-ascii?Q?shmKlybp871zTHO499aJsudGmXAceQTa2IQEnx7xiyqERllM/jLPXtHe0T/k?=
 =?us-ascii?Q?/+GwwFBHPr2fAVgAZAjAfKwuPCYnMdodDQOJv5TzgizXwcj2Aue+GGu9XhBH?=
 =?us-ascii?Q?jFVBvp7WRN06KbXt7O4X/zH86OoeBrShgG70zAw3J8kvJ50sQ9y5jwIj9lBr?=
 =?us-ascii?Q?gEUBXkqI8UhyXXe2dfb3hDbBsbYnh3YgLfO9bzhe3Otd1TEbispELQti77yX?=
 =?us-ascii?Q?Mdi4naqFC7HrnYdgHgraD9P5mX4dmowcEBb0LeOmsPS64c+gkmoMTLhqZUbo?=
 =?us-ascii?Q?wHlkw7T7wbVC7fIxM/r1OWdyAPJ+0vy/mia4w3zaY8xYK+AMMYlxNA1ZPULv?=
 =?us-ascii?Q?bCiuMZ/xHIZAA1E3cYFi8mnrtAE4EB4yolW2lArme1aloiCDu/pkRs/ak2z2?=
 =?us-ascii?Q?6mf7oIt3dntRy6PnAmc459G0xKfV2kHVPHnQrkmKIFiFxRUKP5BPCPkQy/Es?=
 =?us-ascii?Q?AtuQz6xTxDiEf7nr8QXFYmDCKFYQbqUS9baRiEjyGu4OCDnrf5w3veV9bQD9?=
 =?us-ascii?Q?1xxmtCMEK5oFnmM5l7FmmD0xMyyQNebeWQCYkUnX+D74Aeiox5Mq0eAJlywF?=
 =?us-ascii?Q?lfNQvW329TWNGtzIFVgHIrrJW1EfJSo0/n5Z5Z6P3CBVMwtriX82haDlVI8y?=
 =?us-ascii?Q?SU+9eINNoLSpsXztVTn024P6Ia8u2kxk/2YTjeMEfwsx/Ut/OZq0tapzsFG9?=
 =?us-ascii?Q?1lyZ+CN45DNBkLve6yoDd/EldrWD5pCc3xjGwugOWLL6zKHabeopyNopvIHm?=
 =?us-ascii?Q?QM2D3jXNS5QdUXaQoB/teni3Ka5FgDM6mvWBNL3uFbJxWjgaJ/GbTuA9VhAg?=
 =?us-ascii?Q?6xiaySxFTm3/unjjbHfkOi3SATfeXeIgwly27+LLFIgXdDDnEnykJJ8AroeB?=
 =?us-ascii?Q?hrwF2sL/M775rRfPWqt2KNYZtPzwT68=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b822fea-737f-4637-43bd-08da2920e8db
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 14:10:55.0128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYd/uIa+BlB2RgXGz7V/zTETK2mXRuI/XwZtqX4hr2d3H29iAKMz3Zhm8yREdxD0U117+YgyllF9SJayzLvpJccAI/KJg4Tsf7/GgwjHCVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1425
X-Proofpoint-GUID: DtZMZD6u37FeuIyzYmbGJ5b5omfqbotz
X-Proofpoint-ORIG-GUID: DtZMZD6u37FeuIyzYmbGJ5b5omfqbotz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_01,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 phishscore=0
 mlxlogscore=838 malwarescore=0 clxscore=1015 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280088
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 81b1d548d00bcd028303c4f3150fa753b9b8aa71 upstream.

The former patch "defer 6pack kfree after unregister_netdev" reorders
the kfree of two buffer after the unregister_netdev to prevent the race
condition. It also adds free_netdev() function in sixpack_close(), which
is a direct copy from the similar code in mkiss_close().

However, in sixpack driver, the flag needs_free_netdev is set to true in
sp_setup(), hence the unregister_netdev() will free the netdev
automatically. Therefore, as the sp is netdev_priv, use-after-free
occurs.

This patch removes the needs_free_netdev = true and just let the
free_netdev to finish this deallocation task.

Fixes: 0b9111922b1f ("hamradio: defer 6pack kfree after unregister_netdev")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://lore.kernel.org/r/20211111141402.7551-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Xu Jia <xujia39@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/net/hamradio/6pack.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 7ff1c6f7eea2..2d239c014541 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -311,7 +311,6 @@ static void sp_setup(struct net_device *dev)
 {
 	/* Finish setting up the DEVICE info. */
 	dev->netdev_ops		= &sp_netdev_ops;
-	dev->needs_free_netdev	= true;
 	dev->mtu		= SIXP_MTU;
 	dev->hard_header_len	= AX25_MAX_HEADER_LEN;
 	dev->header_ops 	= &ax25_header_ops;
-- 
2.36.0

