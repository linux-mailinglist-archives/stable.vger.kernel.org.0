Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEFF41B21A
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 16:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241014AbhI1OcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 10:32:05 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:4678 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241266AbhI1OcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 10:32:04 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SBlrCk009420;
        Tue, 28 Sep 2021 14:30:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=vB9Kk5ZhqSUI6UhB7qHyZtaCfuWoE32VDeZ3j5ptkTU=;
 b=sqdtGN+Yyi2zgfvFzwV+VLrfWJ0SenRGTtuYcj/LPBddRyottP++RzaYaAEimbbAABjE
 1F1aRN1Fh0VCgSPZNHC5mokpm6MSs7YGvViJ/l/UCpHqC2zuBKAS8tD/8ygzsiA0j/kI
 FQzLAQ0YyEpJmWkhXuZo0JEx91ZcRsgDPLSRzD2sy/jfFFrN+5+8Dvq40T6nPfylXO3P
 zB3sCE5NBo5e8mRfFtgeXni45nf8rkh7/tO9V61HmHJ5xWr6PcLNdOBMDRGb0uS53MC4
 qNan/uQNMZefuZohiRNujb8/qdZBP2HBbjc9rGB4RuduVuqw1drCKg+cI1fPztY2lFn+ cw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bc0qfr7sk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 14:30:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iO0Cvrv1bB6F610o703/w2e2GCoe64Je7P/SPZE1KAi4y3HU1afB5j3WQHgsKKQ/dV5a+2S1Pfnogc0LV4KyoFCK0W/Ef2XZpLJPlKlspwV+8ppzV5EtOr+00mKweb970ZbGdCWP60ZgZvCs14m9phBq0E5o5WljTHQcQ2dk8YmEe1kHnTE+vv9ERZy3ehozecFCuxpn6q2/z+xzdp4LhNdcfL91cHsyINcQ+dtqMHyiiBvYtr1skTVLDESR2A0dcccJc0lUSW4BiUCMhah0Pjb0asVCnzCqDn2qHsbUkaX+vBIoQAHWy65pl1rfyrXtB7gmWf2BB3WXlQW67HQrsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vB9Kk5ZhqSUI6UhB7qHyZtaCfuWoE32VDeZ3j5ptkTU=;
 b=BQDVUjP0gRgAOcrhLaFPxw9EJ9YJYFktgjVT+52bGHl5q0RwH2nG0bUf/HGdWsARkADxim246daCnHMfKE3fC+WANive/dqZqGSV9s8CrkwAUoRXjQxzJt4kofmyKPuq3xd05/X+8ZsQGBqlp6TOSAXz0GGKwO0ASRNKSIa2pPL27+jfDQS8m9kmT/P4vR8dP96EHGFDv7Vl5/dcx6tQ7TAiUHAO9ln5afZWzenfEXFobF+TLCySj3xktzExCA7n2hAE/WaSOAcEqAa03u7ddoiDH4ZYZr9zuaMspHQQF42vctqWJtnThUmlsPnCzFQETGUPFg+7Ve7OpJg1sVefdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2681.namprd11.prod.outlook.com (2603:10b6:5:bd::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.21; Tue, 28 Sep
 2021 14:30:18 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 14:30:18 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com
Subject: [PATCH 4.19 1/3] hso: fix bailout in error case of probe
Date:   Tue, 28 Sep 2021 17:29:59 +0300
Message-Id: <20210928143001.202223-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928143001.202223-1-ovidiu.panait@windriver.com>
References: <20210928143001.202223-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0028.eurprd07.prod.outlook.com
 (2603:10a6:800:90::14) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0701CA0028.eurprd07.prod.outlook.com (2603:10a6:800:90::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.9 via Frontend Transport; Tue, 28 Sep 2021 14:30:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7746840f-d880-4a20-da4c-08d9828c7ef1
X-MS-TrafficTypeDiagnostic: DM6PR11MB2681:
X-Microsoft-Antispam-PRVS: <DM6PR11MB26817165F0CB7BA77726519CFEA89@DM6PR11MB2681.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:409;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kafmRNIsYO4/K4JjYZe/DOS6lFZuqi+irD0cER9FfJkucSxYieodVMAtKjBjASzvmiejcZ2K+4DVtcPEEQPlukWAks37S4W4u5K4jbeYcbwbUskcD5SVphNyToMEl5XdJRuIl8BMb4kizYTe5XwsenGI4XSo5LKyaAIaen8nFLIVlHP/mk/925Pte4B2ijeFdhY5/vXvty4UAhiQ34NpVO46ob0hFdkoJsDsHZew+4Ib87Q0unoB3Xk2PTHx+fq0ymj1G2ENg0NrkCdr7x+PXZuZMp04a8qJbtw+sSxEhaAoKq2jFr9RO+f1TyImblIFIleXM2FWi1r8URpBYgihbnqp1raiGBcWjo/gjOaHFUJbizgH1e+7F+XF0flt1alO8tWOAd4tTS6tEZEwHPymuxHJJxlC1e76YVZnDOicNkRQJdO+Bb4ku2NHkCWLllD9eca7eft5dkCktzqP9W9mbAS+3yTTOv+DOj7jakV6XyGe4JP0TA0Z6veGHUoqrw1WGtnwcmtR9EXT97Y1P0j20XJ6faxeFSAnaVh8PWLMMaA2TXNu1TCSNjkDyjpRwZm2dtlmctw8zJlRcjpu7ixL9cSgYlfuFx/8cb33XKuEDhZ3lpEi467ri7qJNpXPBbZSh1AmmQuBqEzPwJol+bcfME2QVrfrnR/9XKBhBBneLjvZ33FMaH18ZudjbrqC2FlaVB5RiB5GA8HhzIBmPIIkPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(5660300002)(38100700002)(38350700002)(6512007)(6666004)(8676002)(8936002)(6916009)(44832011)(2906002)(1076003)(86362001)(36756003)(956004)(83380400001)(186003)(52116002)(4326008)(66946007)(316002)(66556008)(508600001)(2616005)(26005)(6506007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FqIINgSzh68xdDAxl5urj3HpgOfaAl0fqRKBgvtCPbZYWFhVJWyX86l7Ps5F?=
 =?us-ascii?Q?R72SilIjiAllNxNvv3z0Nkzr7XDEBOWB/DAmqOIVR8Zd/v+datL/K6f0Mi4k?=
 =?us-ascii?Q?42EgNP21xZjy8j0/RVOgLnSQVD+DC0NoiLbwB5wcjUXQqrgsSntTgpjsynUt?=
 =?us-ascii?Q?1ny9ITNOquo0+v5tKea+1l1gfNsg8tCCPHA5E+8RKywm1u+NW2SyikkG9KUi?=
 =?us-ascii?Q?S88F6dwOXu4E2IWjdTEDRvLvIsdSVgX/sKGwdg/Ms3Gdq70Y17qxelSskbqi?=
 =?us-ascii?Q?lECbXzhgwBTbHs3YrrEloxCray3SHbDNo9FdhEhld0WIVn9xXKk6190sIvda?=
 =?us-ascii?Q?GrCIxH0pjmdAU4IMqAQDxHpOEzzRgBVFuE5CdFWoSclWwUPNH/GzE6kU2hUo?=
 =?us-ascii?Q?ROe6HfacgVwO9P51hqdcJ53JcbtpX8mdNwsQ4dVaB30qqLajgK9JXjIJnuGc?=
 =?us-ascii?Q?TMir3HXU28X8VBR+wbcIY+bJo4Budl8vVUFaIu3IdGXjVLJJGN5Z8cdbabfY?=
 =?us-ascii?Q?Iw95FiSiBFX3b2xibi2zE+RlYgbDSZ7plzXs7xxI+lzyB8xtFmGBCqKd+7PX?=
 =?us-ascii?Q?j3TUTjg5Ff3YhVvUf5N/KxY5YxMMchm/rue0rILESpgLko2izRysk2MIREB+?=
 =?us-ascii?Q?r7cLlFs/JT9sakkMsT5S83BvFHsRoMuTYDowY3BEUKFV3gWHuEdCwfvVmPdo?=
 =?us-ascii?Q?1Jxe+pzJ95FgdOLrRp7V4eql3SRBrKPwLn/wc5wkpl9a6h5V56U+ljb1fZiR?=
 =?us-ascii?Q?JOS9MLsweDAGKPISxt0LXi8NmnXhNKMdDcAzK6our5kMZSZjeHBTEcz9cB+/?=
 =?us-ascii?Q?8OHfPcDRrYvmsLG/rq4OlE8gZ8a16Pyv7vYZlCma2Bod+m8oCVnBhy6ggxBz?=
 =?us-ascii?Q?jCxViUcoHj7F2GOmwkIJ4JctUQoa+I9pW7cFMdyd1BshwlD1ZKMYVQYPfK2g?=
 =?us-ascii?Q?OARoODjfB+Z2M+FNwP06vruGV+m+IModKa5Skn3tI2VPrQxx0DJavJlaIt8L?=
 =?us-ascii?Q?b4HTGRvzn809j8pab7vhDjG+b8aq1x1AsukTQWyL1p5iy7OK6ly7lkSmd7Ph?=
 =?us-ascii?Q?JB3Tr5qJVeneBrJrJKT5lkindPlOT1oyvQ+73gJ+lKiFArHJvLghNXJdKuHc?=
 =?us-ascii?Q?DdpA+9XONIL5cDRvqnWsRfl3DkalhkjLwEKRwmQVU+N/t7W5Wh5Bt1tdMutr?=
 =?us-ascii?Q?8uh/X9GtDiyIfqFVemyaztFrZxkZh6NJlt0T4JrHejRgvqyB8i1kUu8jHwAx?=
 =?us-ascii?Q?bbRR0drExroNdfb6He++kBfA80ISSPHrm7hxSqP5d+p0j5z7osxExidm23gR?=
 =?us-ascii?Q?Q6znZP88YrTtkkN1oeq/fNNG?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7746840f-d880-4a20-da4c-08d9828c7ef1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 14:30:18.7711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jt3vVc3pKeV9TxdSFwnE9VcWFfP1to9Yr+b4NvsetyV3JBP/LDkteJo32q3gzXR6bixZQNDFDD/nyNx2c4K9D4AplSBzCKWgHG5xStDYEPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2681
X-Proofpoint-GUID: GZuELomW-LRi6BA4LNYfe8Pv6At3sJdy
X-Proofpoint-ORIG-GUID: GZuELomW-LRi6BA4LNYfe8Pv6At3sJdy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxlogscore=961 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280083
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
index a66077f51457..0839da773e62 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2368,7 +2368,7 @@ static int remove_net_device(struct hso_device *hso_dev)
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev)
+static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2391,7 +2391,7 @@ static void hso_free_net_device(struct hso_device *hso_dev)
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net)
+	if (hso_net->net && !bailout)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -2567,7 +2567,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 
 	return hso_dev;
 exit:
-	hso_free_net_device(hso_dev);
+	hso_free_net_device(hso_dev, true);
 	return NULL;
 }
 
@@ -3132,7 +3132,7 @@ static void hso_free_interface(struct usb_interface *interface)
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

