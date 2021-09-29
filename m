Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0574441C034
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 10:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243331AbhI2IBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 04:01:49 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:39934 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244369AbhI2IBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 04:01:48 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T7nEjr004834;
        Wed, 29 Sep 2021 07:59:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=Fwz0RgRycii3rhljWnfgvxaQ5K2w+A7pIBhOZxjb4kE=;
 b=Tn0cvuuPwWb5jj/B6DpVVSoQSC147RseWs4JFTQqufCHhrOq0+RzgH9ZLGRyL/Wwu4i4
 KZTYJ4GWtOt0cBA1vbd8FCGOdLdCORH8uaULvVRsCr6aQdMc277+okTdNjZ1dbB354wb
 7gDYr6Y2AKUWsl4XkbFafHV150IIes/d29fsjUWoUAALmqAgF6vwOObCiXBSg7LPOpTD
 CCNHlxuZLbbjHsdrDDd35cQHk3tWwZEzbakFDJP10Icpf1snFuZaCc1xayY51FgcQtJo
 Xqz+1FDOBQVBULLMSr1B8x2MA5TE//6U98occdlg3Aibi3fd8GEA6qw4nzFYP9zAewcr /g== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bc0qfs2m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:59:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atNvbYw4/A/57J6audgBOW4+RUkUfG7v9Z6tre2MFe1xoMWf/Hmm5Wt3iEoZTbCSOaTq2LD4b34H3dTvi4kGqk2Pz0i4vrbGp3J2OSeLIASKbwqvu+YL45NoV4eaRhfs3mUfmeL/oWohTS69CAL4uVSJLdhuUEaetN4k9IFwf4Zha7d6CC79CVyMJ1KugcZH27ykIYUTGMw+4BzA1zhLiQoXzaX4A6D3Jb5frI4Yf/jtheAoQgU9UKTj0pbG5Iu0tRE62U8xOtAcyRIQq4Le1k1sxY90RlbE+LiaVie3yzw+wvVYj56c04AjqEo530yFFVEnYnQw+ozo09ifNH8SVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Fwz0RgRycii3rhljWnfgvxaQ5K2w+A7pIBhOZxjb4kE=;
 b=l7q+e+nHula2Cj3Ifl0p8Ueh2pMntVILrHCXGdwEMC/mSnYAZl5FGdj6tQDqMr4ado/ukN2v4Fjy/tppySTWX9wew60VJqpm+Ar5ijnRgUuTSNXDTyrAEGyvzqz/e70vQ8FlJF8XLsPUrvprQT9zc0MB22KmP88qbyW/QbKxRVu2d6DC2Jcseg/6le/obTmUs2r2LRUoUB7lXA5zfTplQzXFj9LVovsLembi8jO6nPB1g2vNljMrwTrvNZKjOSRdKfCUqPSYzhVOz5BKCXJ6vbXJkvHCRvENvVhg1MDQGttle/EpFz+JwlyUDtDH4GS6WynpDwvjdNBv0EmN3Li8LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1836.namprd11.prod.outlook.com (2603:10b6:3:109::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 29 Sep
 2021 07:59:57 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 07:59:57 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com, carnil@debian.org
Subject: [PATCH 5.14 1/1] usb: hso: remove the bailout parameter
Date:   Wed, 29 Sep 2021 10:59:40 +0300
Message-Id: <20210929075940.1961832-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210929075940.1961832-1-ovidiu.panait@windriver.com>
References: <20210929075940.1961832-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0129.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::22) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR06CA0129.eurprd06.prod.outlook.com (2603:10a6:803:a0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 07:59:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6baf5be5-dc32-4ba1-0337-08d9831f20e7
X-MS-TrafficTypeDiagnostic: DM5PR11MB1836:
X-Microsoft-Antispam-PRVS: <DM5PR11MB1836B0A9A5E0440DA848F9E1FEA99@DM5PR11MB1836.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:62;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mn9xA0+8cg6FxCHjLETFzvEdp1gyELkf2nL/fNwtEmm6a4aInjzMC4VHEwh89CG+Y6fdehZlLPtOaYe8PU4J10rcU5OCfcArKOiQnRredK2kmNupdDduFn6EjvrzumTccnQacUmc2472+Ri+AHFQr4TBeGsG6EGM9b84IurMp6sLf9R0sLfSIW0c53McLI1Zry2Jo+4OdcSWOAwURIi8zvSNY3GCZf+VwnOyfO4MNS0/Cd+caIG4gVnt4nnL7RQcSipV+updIPSOWAh4Au9XVDrfSTFDrViLui/uPl10zBPAcFpr4ElW2RWCo1+4S/4uAgt27jyxTK7prFrTIyJzYlHMtNUiLUGRdhFiohF/zWiesLdE/SRbM0Noij34ahk3lLUG+NQrSfK7kKzWEp440eevUUalgdh+Kzl3ub1fxVdNeSquK0dheuEE+6nMrUR0yLGAvhnmRoPb8Xf20TeQ0A0y7TFfe0brcI5OtAhsyji0dHZAT/BGZz3xUUJHzrQ2Vikn0IWcGuuzfhAqijKtl+dXx5bbiVTEOdYJ1nWmH80DOPtGS/SKxU8mEdRbJ6EOrlYmf3enhoI4GlEiTAiTKnU1IKrHheqpjdSPO1CHxjnl5UFDtthOGK0m/4kJ6aZQsfbyt8hZ7qyjK9+n/Wh1gpEIxXT0K+UUEEhWqVajcuId6ALkFLj2yH6/fhytlrVQO3QUI87L6eCN5b9Wpfsuhv/9vOCCEsyH0br9rYL6NR8IDK7FCPmMavOV74Xo4PAR/LgNDa0D3JoCe1wXmrS/c+f5cBiuRNgNeaKiSfJPGfoZv7cd1d1jDXV8hOVY7u0nGcDwElcOOmVlHZpEUk+BRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(186003)(8676002)(66556008)(66476007)(6666004)(6512007)(36756003)(86362001)(26005)(2616005)(956004)(6916009)(8936002)(966005)(6486002)(2906002)(66946007)(5660300002)(44832011)(83380400001)(52116002)(1076003)(38350700002)(38100700002)(6506007)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XBpy2Re5xMf8+F9M6wYA5bSdxmF37y3tJf0gbaKMpCGMoWUcI7Mlorl9GIQB?=
 =?us-ascii?Q?trIuKxRr4e9Uyhun6PX5hnCJMT8CI3/Wb1rWcEPHS06xslF8KCjnDbMpPX70?=
 =?us-ascii?Q?10EaiDpTnrn5J34LvbM4G06TBy1EH9433q+rAnKxyqYs+62usjmpZ18iCNqb?=
 =?us-ascii?Q?QLIx9kNarIUsx2JnpoAw7WuK4X0YOTGoUC2fSlbD44kot75MXq0WASr4j94Z?=
 =?us-ascii?Q?ePYandl7PKvxUtVSXIiyf92fw/Te37I9pIg01qvXFWMP6qgiGvCdppI0tGNP?=
 =?us-ascii?Q?rHvmhzoODJ0tig/UZXftVs86JGss2J5bnr5QOEBfSsTlwFfV+00RpwFBMDGX?=
 =?us-ascii?Q?s7mfDDZAFYeBn1FRN2Cyg960tOAqjsJK+P5RNbcc/f2t4Hq29dEtHXSV9MiG?=
 =?us-ascii?Q?+UQ1ZcTFR54U9F9WmR6Ni54hOCiz52InFoE1kIrohr8PwO7+mBZVHXP6j6OK?=
 =?us-ascii?Q?P4lOxlk+NvwAy5uNkCk2daAbERAEa7WMAyU5WBkdqzuF7jHL57sHyWFtiLMG?=
 =?us-ascii?Q?rTQ/kv7nseq7CsI3qlTGo1wa1qqgUm7cTDd7AeoogHOibo2xn/tp4ZX2r0zC?=
 =?us-ascii?Q?+m9Q3BmusJC0m1nx6u62hl+EEDK2eUb/Nps5Y2dvN8Nnxg4jTh3431dBJxhO?=
 =?us-ascii?Q?sAZArNrcDj+MGR4rK2D8EjEnvbcIOiio5uUDtElEsn6Zts9mRdgFnBZeE0k8?=
 =?us-ascii?Q?0LUUA7H0LNYCYlQAYrtiB0ud76lSfC1e52a4QwjRnRkyCi+Nj5KontFEotCB?=
 =?us-ascii?Q?rDZ7La9QvjbTWk0SNmbOngFPH8RnLB44LJnnACbDr9KEcBTMmxEqaAl4y/06?=
 =?us-ascii?Q?hvImxnf6zbo+QGTDKCVNSZUG8gOIULRi35hvuLEMW5qFKJUl4wBOVePHYeCb?=
 =?us-ascii?Q?6viSzMpdoWhrxKxj3+tlpeInO1qSBgAo0sLJzOcvbAhqIaYAlbJpYMQReo15?=
 =?us-ascii?Q?0L6Gwgc3+z6TR9odr/4mwH8s2EoYpcD0ekWTiGIIWgOO3cwO4jDANB4tcbyk?=
 =?us-ascii?Q?4mlbb50pkLolxRx5CAVVFewf61C7rjSZHwJTiIG22Qfe1lphspcCTFMLdcsT?=
 =?us-ascii?Q?6zunpZgh9DSz1qKNEOd07X2YRLnK/Ck+AGawJlJ2NOfLmodnqVvGxnR8ZRDS?=
 =?us-ascii?Q?c4GcOoXuDSE1s+5WDfXg5HFgXWpRC45yKgH2B90RE44gSAO8tIFjXJTZsXzy?=
 =?us-ascii?Q?7F5ULgFC+mUwjhjQEfMSLsVCjPS9lPmUJxL3upGoPyddKIGRtto02SHYrXkY?=
 =?us-ascii?Q?pZl/1a3GAkoO+Tb+E878ktd3SZ8brlNlAsjswB1mCp7ZkAIaRutxVnGkj4dY?=
 =?us-ascii?Q?mcKzGMe2d8W3dkRkjhcr4C5d?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6baf5be5-dc32-4ba1-0337-08d9831f20e7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 07:59:57.0205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GPPpeIi5BqIyF2IOLlrUOa0391GHJw4+BV4zW+FH/e0mziUhx4ITa+xs+PzLaYTzXUrYSFEbmEEivCRd807K9+opdTLhKnPjZB7RX+94Dn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1836
X-Proofpoint-GUID: afjdEcZtlGlSkbnloZxprPMd6nUnoHr2
X-Proofpoint-ORIG-GUID: afjdEcZtlGlSkbnloZxprPMd6nUnoHr2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_02,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxlogscore=422 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290046
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit dcb713d53e2eadf42b878c12a471e74dc6ed3145 upstream.

There are two invocation sites of hso_free_net_device. After
refactoring hso_create_net_device, this parameter is useless.
Remove the bailout in the hso_free_net_device and change the invocation
sites of this function.

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
Backport this cleanup patch to 5.10 and 5.14 in order to keep the
codebase consistent with the following 4.14/4.19/5.4 patchseries:
[4.14] https://lore.kernel.org/stable/20210928151544.270412-1-ovidiu.panait@windriver.com/T/#m3212ee8701e6e6a532c681e26aa557a324628577
[4.19] https://lore.kernel.org/stable/20210928143001.202223-1-ovidiu.panait@windriver.com/T/#mfc27ef6f6bb647d051f27ebc6ea19a423e8b67cc
[5.4] https://lore.kernel.org/stable/YVNs%2FmLb9YXNz7G+@eldamar.lan/T/#m5a020c3314a5e1c686f923efdf6fdb6a6aa90652

 drivers/net/usb/hso.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 18e0ca85f653..bae881608f47 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2353,7 +2353,7 @@ static int remove_net_device(struct hso_device *hso_dev)
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
+static void hso_free_net_device(struct hso_device *hso_dev)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2376,7 +2376,7 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net && !bailout)
+	if (hso_net->net)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -3138,7 +3138,7 @@ static void hso_free_interface(struct usb_interface *interface)
 				rfkill_unregister(rfk);
 				rfkill_destroy(rfk);
 			}
-			hso_free_net_device(network_table[i], false);
+			hso_free_net_device(network_table[i]);
 		}
 	}
 }
-- 
2.25.1

