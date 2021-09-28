Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835E241B2C6
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 17:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241450AbhI1PSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 11:18:37 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:24010 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241471AbhI1PSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 11:18:34 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SEbVuD013175;
        Tue, 28 Sep 2021 15:16:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=C8qarWqY0gC9hHCrsqIj1TTPR/N69zDqYKYfLTPod6M=;
 b=SiP26sG9LBv4tedzaYQgT8h/XyEYL+EuvyhKSN5ezSmSHEIueiIvmmgGTIsGBgL1Fg94
 Hm617tcAIa///cmgUHyNyfT0h99tcGy9kspG6svlea3jrbVeEcI2r1kVablRncy8ZAVs
 spfBP7G7eLYcdp8JKyrYSK8NjlUoiDfURiEKwvFBddoCWDpge/TCG8uIRltap5FtWaTz
 bhyeq0WzMwo1+lRbkBnGIhX2NfNEW167zXVroQUYiAqzBMaOQln2O17A39VmVSb2IAsm
 dN6OHQ5KcIt820au8HNDqnOmji3Wodkvdl4LUHLNAHOpwZ1A6FslYFk+WzZhS3P336kC IQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bc0qfr9a4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 15:16:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4pU91GmJ+Jz4bV0A1ENvALUjDlK48fQbVIdVGjOHM7b+wUW8Si6xX4p60lY9ajV+6lSfQ1OVvrbQ4EL3GGpcmUgo3EgTWBUXJH2psoErwZw24hBqnXiQM5p1gALWg4FjsP1Fj+cBtdRUSXrr+JTAtmZ4i/ABxbbRjFt5Cxpqbbf7YnaujNqmA2Y6/Ai4CzaD3nrLjtq6kB9OdBerzEjsz1H6f5B4maLLlkOGv5BoSPSBrMudIf4gpQItY9BPWabQZATUf+Erg3ud6urk+vI/l7Tpb1PafD9ewR57oblmCKivho63zi4H0zKcudOKWM2NHzM6HFOWskulnxiLj9JRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=C8qarWqY0gC9hHCrsqIj1TTPR/N69zDqYKYfLTPod6M=;
 b=ObqPiZEz9avheOK0ypKxI3PAjqvcOcITClJEBgY6X7/gPC3RxJTa3+Qk74R+0e2cIYsuInYv0n8PLe47BUnQexnlcU2GQDmM1Wd4kO9MrV0cQRS6r72MVFGPfPrm8BLaEikuc8ce44xyP7zCahdhXFb23R0nyGhDFXMqZzuzjEsGSS90LSWCuCbcjb0KPjgJAVYjY+IeoSMIGCX2RkHW41KC4YReucu9KHIGu2KwcEyskzd9d4NZoovH88Lq/2wQb/l4DC5YAymoIY1JWmIAp3uRd+Uknd3ZG72BwpzjD2w/Ak0KGo61dE0KU94iCCGCA4LiZO8M3YBOErF2AtQH4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3609.namprd11.prod.outlook.com (2603:10b6:5:140::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 15:16:45 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 15:16:45 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com
Subject: [PATCH 4.14 1/3] hso: fix bailout in error case of probe
Date:   Tue, 28 Sep 2021 18:15:42 +0300
Message-Id: <20210928151544.270412-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928151544.270412-1-ovidiu.panait@windriver.com>
References: <20210928151544.270412-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0019.eurprd05.prod.outlook.com
 (2603:10a6:800:92::29) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0501CA0019.eurprd05.prod.outlook.com (2603:10a6:800:92::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 28 Sep 2021 15:16:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3170c51-6fd2-4f9d-a2bd-08d98292fc1a
X-MS-TrafficTypeDiagnostic: DM6PR11MB3609:
X-Microsoft-Antispam-PRVS: <DM6PR11MB360968774BBA42E9704DE51AFEA89@DM6PR11MB3609.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:409;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MoGRVVJi74TwuL2Y7rU+0KGCcIYRE0frIMbIOeFDOg+V1H7dRpi/VNpb3gKYDOg6mDvgS4S1jlyYrs4oyUMVY9lnys2vfYgmK2UiBumJudNdS6hMmLlS49Fbuy2zoHVAqj4D2icfAyCJf/86GE9NhLUP90Hr7Cb/M9FOLwXScEeG/UpilG2K5JPT8bmFYU6shzxver5Esv2l4rwdBciIn7ENP2YyBaArdx8cKC94XOvgoXCAvy1V3QPL9QpH8zL2Kt2LnqycpSJ2QsBA3RgW/HxK4HbyngIQ06TLcobmDEre3B7uidwkaiVo6Vedar3mLzvPi8HnrVYEPmbKCxeTJVmZyU9vdmoB2IcjDqOtuTWc9yQPPQ8vTO4JhBQKnANGq/eEWIMuQ/TZPWIU9Z9Jht7JTWKT6cFk1vYLpp/xcoEvidNnhJOgqGZpWvyBa3cMhYs3XphSxYbrUCf4HsEHx8WeE9lxYn3TuJ0ngwk6dCrBph1M42gBJm6hphFlgXKleW3DcUoFVjVmgwN3w7x5hjTFBpSvlWQFwWPHVeqdKDLptk3ueFjf8b+H16Ckw2n2drxuFzbyh83dDhJ915uwre6IuBqcvXJSStnV0blmt2BuT58OV88P1iadj5USwpvbAoBLK80vrLPsTwntQXu5zZWGuVST6e+2TWmdHdMwGNry1DbsVcXniTvv6r47nTXwdjBi5/0VvdKV/aBCDCW+OQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(5660300002)(508600001)(4326008)(6486002)(2616005)(8676002)(956004)(38100700002)(66946007)(2906002)(38350700002)(86362001)(316002)(66556008)(66476007)(44832011)(26005)(6512007)(52116002)(186003)(83380400001)(36756003)(6916009)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hBWSsIwymMoPSRBrErkQxyY9irQd7qI5euR71Ok55LihXXhCwU2z+Wt0b+JL?=
 =?us-ascii?Q?6Il+rsg3+KA0jXr1Pj7G7UR92MiSehEqiIql9X2wS9YSGgnAFhztrp1KKTNQ?=
 =?us-ascii?Q?xucO2H//8PtfZVqKc+eS8aYMao7QoyxyiRyrvs8+QopNcHPdnPKA6/bTdmly?=
 =?us-ascii?Q?Qfs0jqdeI5Qw1ylwG51cxO7PFOQjcNEftyr1/5TPnZ3empTxqiTb10hBOMyE?=
 =?us-ascii?Q?utI9s2z8alEPjpScxhrhOwhIBvFOblp5zhkQP1trRpj+44MdlW0BohBlgx8H?=
 =?us-ascii?Q?u1IsiJezB/CIFyF9SdizZ0s/vw04eqR49wjhBfhnSQfcz8xSzJfu21p/70Ia?=
 =?us-ascii?Q?FBTn/ld2Fl8/bp8tb0NnS1x3PhD3mbifac3kBt2cYALkFneerx4Glc2YILbp?=
 =?us-ascii?Q?wQuY0JrV8aQpByokce0Uyar0YIqHzJitX9K1UB2dud/ApqNwLKI4CLRQWG+A?=
 =?us-ascii?Q?XpBS+DBdDH7MFQfPEF+QjwwLPyqDLciLARGW5cTJstQ+uh+jNZU7SRapBDDy?=
 =?us-ascii?Q?nNAyH3DkqtXH4b+MQ195Mhshn7ecUHJKeXcObi/DqfpVz1kAjOWpD8KDW7QM?=
 =?us-ascii?Q?Va2rMV/j0+gKX0+vKMBM5rIeU1BBESV91ZUkB1wP/ksgnLAIHOn28DPT32IF?=
 =?us-ascii?Q?GXk1T9OQkFaGg2eRgkpH+Kk8W8jNIlUGxNUiwbVAVhrq0TzdBIE+d77LbhXv?=
 =?us-ascii?Q?HGjPsjV5MirkTgiye5/STqHyJonFMvfMMYhJ7vHyrUAfZTHly+UEnoLyuWl8?=
 =?us-ascii?Q?V2fOjsCIM/l+KqF0C6VY/PoWZp/t01QB5YbE7yg73CQIHpTKClyl+zTYppIP?=
 =?us-ascii?Q?Aj58axgnivdKogLzuMX3lWLwzY52rnafQLtWTCg9VjazxFaZrxXB3O9swdMK?=
 =?us-ascii?Q?TkOEvYuZiCBFO6Wsx/CvnsKd171MsVcnv0Ha0n0WytksMqE9uL3qdqjb0+Or?=
 =?us-ascii?Q?lU1qlRIjh0A3MUDiYeHgXFzFPvn5PiNEQDg7FJbH6gguu+p1UBbuvM/FM7R7?=
 =?us-ascii?Q?PxeQ3wJWWclzDNXCBnJg/X9yeCo7pKU1ItQsRFkAlAEdU07A6un4hu9JXOOE?=
 =?us-ascii?Q?+WbK+wP6x9QbYLMDbPFD44hHikLQvKJ6UKtcnDXkhfbpOQ1eSNBGUc7jVyJ4?=
 =?us-ascii?Q?qSboVyRtaOpadNZB+usq4ONVu/EUP8KxgbRX6SS4s4B9OyEsGxf+izshz/WQ?=
 =?us-ascii?Q?IhcNEx7aniuA3a8+xF6e/IvNJshqglXZkFoINJckBhjYcUDjtpR+W719XdZx?=
 =?us-ascii?Q?5K4BTs1uqwntbSPxY/LITnOwG0jT6nguUOmkLXemEuweXLXAdpllTwbDRyaF?=
 =?us-ascii?Q?zv5ToONknNeRzZ2mRFlFf+S3?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3170c51-6fd2-4f9d-a2bd-08d98292fc1a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 15:16:45.7420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CrRqL9a1Hg01B337MQDCizW8RtvQZj+ciAT2onek+SjQ9z1VrKbJ9SGNNIqhOrBI1SgcgfZu/ps8kpcMwPtmlTeMOmtSaj8f1mp5EZ5HfjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3609
X-Proofpoint-GUID: MoaMoaKgaFr9-xfzcOHY9JkfJlbLrdLk
X-Proofpoint-ORIG-GUID: MoaMoaKgaFr9-xfzcOHY9JkfJlbLrdLk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxlogscore=961 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280088
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 5fcfb6d0bfcda17f0d0656e4e5b3710af2bbaae5 upstream.

The driver tries to reuse code for disconnect in case
of a failed probe.
If resources need to be freed after an error in probe, the
netdev must not be freed because it has never been registered.
Fix it by telling the helper which path we are in.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/net/usb/hso.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 3c3c6a8c37ee..eb2b87f186a5 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2367,7 +2367,7 @@ static int remove_net_device(struct hso_device *hso_dev)
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev)
+static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2390,7 +2390,7 @@ static void hso_free_net_device(struct hso_device *hso_dev)
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net)
+	if (hso_net->net && !bailout)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -2566,7 +2566,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 
 	return hso_dev;
 exit:
-	hso_free_net_device(hso_dev);
+	hso_free_net_device(hso_dev, true);
 	return NULL;
 }
 
@@ -3131,7 +3131,7 @@ static void hso_free_interface(struct usb_interface *interface)
 				rfkill_unregister(rfk);
 				rfkill_destroy(rfk);
 			}
-			hso_free_net_device(network_table[i]);
+			hso_free_net_device(network_table[i], false);
 		}
 	}
 }
-- 
2.25.1

