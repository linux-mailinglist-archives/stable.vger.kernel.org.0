Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD09741C033
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 10:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244472AbhI2IBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 04:01:49 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:37170 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243331AbhI2IBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 04:01:48 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T7smXW020227;
        Wed, 29 Sep 2021 07:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=ByAdb+lchE9cedfrhsXVR3i6bzcSXr/66oFIUFQ+hR8=;
 b=quz+iHG17hHOXe9r50RmdrNCP6fOqNERSL7e5/bLgG1gCaLEeRH+eVibGT4xRjRa+peM
 g9Ad0ZLzfaupqlJHpUrCBQ4hRTldBwe9RfCaSp+E6X5+4QC8AykbMpYzJ/in1pyht53T
 B3O33GfrYM2GSW7StlNmrNg3Cq0F8lz2yzrDNca1AzB5lr9dYT1ZJjjZMYcxLegMbo5D
 Mpc2TRSnH1zzwWYpOGm1OCr9IrHjgi0x4VhC6nsaCLH6bzJbwheZ+0g9B3u+oEDqxzAf
 r3VT3zPU5wyVL19yqR/POFMOc9368dRIthX/R1AOAXQrDyCp4iaOL6ARNbG5QXx9ib0D iw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bc6rc0p4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:59:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FllNyuUYr8fy6vMDn9UTYGS1fnkBldBAq2eo27QkOiJBc4LsCa9/jQpXhkoNoda3RhibzN00YSaXHkYtvmJwgoVEgV6uPxWIzsNobHZ+g0qNHwvP9jX0cGI4OGDZQVgcdYq/ooL4AYjQ/PfldEFT+fozHCf8eGl5WMkUJRq8zts4vm6+6HlHH6i9R4ip6bDAzKKAc5lfO4/b6OffH3/uC901CSN0K0pnqcEycIsseZbnQNmNx/2WcKsZ7JZKfR+zhy5nWozVyOytt7eYDR2XH0Y+Y/sOdTyUQzPwi0h2r3tfxd5WrS+F7m1SK3FidQ3yIceqdcPLv83i0+05KJfX+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ByAdb+lchE9cedfrhsXVR3i6bzcSXr/66oFIUFQ+hR8=;
 b=HAwYJvKPLodDdllSwJeIM/t5iHhWrLyFCq3pS3NykFvTQ+fzuieWw+h1/8uqJSgPQROQUtLxMQcv343//KD8SEOiKCtv7F/Ok6TvvCQfTgYFyXA6IKAp+JnplqXx4ubqtMxYwP3bvDEOFP5k1EmC3NItkH8Pe1lNFBhJhui1hbm4wXWVeX3CoOlDuPtM+kc+D91egFyKSOxyoXlikArrFRKk3T8oIwJbtYbsNNcKhgR5WPHMFR+OgkPAuypwBAq9GHFUcgxWx6WfR+bsGZBzLprpoqrVGaLaQ8G8fX4brDoTwEZfzlTYBXNlVNfdD4fWT1ad99RKS0Jai16rORu0qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Wed, 29 Sep
 2021 07:59:55 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 07:59:55 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com, carnil@debian.org
Subject: [PATCH 5.10 1/1] usb: hso: remove the bailout parameter
Date:   Wed, 29 Sep 2021 10:59:39 +0300
Message-Id: <20210929075940.1961832-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0129.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::22) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR06CA0129.eurprd06.prod.outlook.com (2603:10a6:803:a0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 07:59:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6a05d23-1eb6-400b-ae72-08d9831f2026
X-MS-TrafficTypeDiagnostic: DM6PR11MB2841:
X-Microsoft-Antispam-PRVS: <DM6PR11MB2841B1C4C4E6C0D6C16B5F84FEA99@DM6PR11MB2841.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:62;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pw0lUJ2cy/sBpSWw6fZidPXIrKpFFZU6Pk/8TL1b6EPndyEQrzhE6ap2ueHUoUvMuRwYzpgrmU8IvlMOiu8vKl+XgQbtU6Fc3yCqqdcUEq5DP3MT/6ttZbB/mTE5g4Zsjk2Z/D0joASA8FGDtS+7P0WcvQb2DLUeI3OYIvO+5xe3BtYdCOuVEBplCarYnGpYiDi6EbHw09jRfX+POyw5OOLGgZV16byUK3zBgbJNc9Jt3rRKnC6kYIp2yF2Q7n+hXI7HH8IWu5YtbK3Ds4UklFjBoCf7vv/WkSEvYReGOnA00E14OPzJuVvmEUTqcVeJsAWXmK/ReSnu8LbZGGUvEgnhImftlrUkVSCjf4HW6X4ZVXUTFPlkwV8P+hGH4XJTtM8TeZdWCRnFIeup9/ljBdefnNkLsAI0dCKJoQA0Kr2dGOi0hUEFT1vtLgaekLF4rmhPlzTbEuIQrEoZQw4blge3FvSgYlKEEkraTrErjnO237Vl3c1jV6vpzAjgTeq4VLIYQF+Vrk9cS7craQs2rWhcJavIkZS6bircc1r/bhxSKKUN499+Yq6g38Ba3Jj1AclT+YdUEdtb5cdhnh2/gO0/WARmO+fgVjF42Nq7/VzbevS1EfnlK9mIzpyCh37+7y7/03ybk5bdxHdKlpBfLR7dYCQ4pFBG6mOYoDMqXMtMrjXKNrdXUUVy3Q1jQ3gUk7uNaLuWbBKIoANjFqi4BTi9V5m5qKtjHj6KUtoDqrJVptELkiTM2bUANH2kmbjk4dyx3B8bXk5YMl9iG6tpXQVsgDtg6CdiBS4BsxVreC+IBE8n2918n5IEta8DPs6IIg7LKt1Lfy9bfe3MHVeYgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(2906002)(966005)(44832011)(52116002)(36756003)(66556008)(956004)(86362001)(2616005)(66946007)(508600001)(6916009)(66476007)(4326008)(8936002)(316002)(5660300002)(1076003)(6512007)(38350700002)(38100700002)(8676002)(6666004)(83380400001)(6506007)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qE9buuxksVPs3DDIyF7rm27PAvrcWOn3nSMHNwJr0UE3urrEtS3hQEgbQlGw?=
 =?us-ascii?Q?8a4D/YzQo07z+rTJwhXFHTt79pDKaNR6LuUNZwjRLANu624DIaPCa00i/jux?=
 =?us-ascii?Q?6PJStlBBc5FvZMZt3Q82xw8yVg6aulGvUj4y3lna1XJIPVUr0Moa9A6Husd9?=
 =?us-ascii?Q?EYHL9gWwjsxifhejRJGwcQtFVnLZDyW7ompQxkv8pR3NwdYCCAbaSytTcubg?=
 =?us-ascii?Q?7td5XMK6ZdY8YURfNkSz4RG8vIiCQQSHcYhEz9izTrInIEROpVb2AlCKnmDo?=
 =?us-ascii?Q?IeAPlgqPy3uQI6A5x5ZKQwNC4HDcLUo/plwZwDtgRJvkn4VIE9xPNLKmRuK0?=
 =?us-ascii?Q?CkirwQTrDL+CUMaoQKwN/Srm8my5Nej1FlLzlaL3G63KtAuCUFmGdQFWB62R?=
 =?us-ascii?Q?tjUE8mFD14dIXvA+maTBkwxpe7O75FTzpo0ZQ2AjKhPKH+r4wM9PPZpBZ+ca?=
 =?us-ascii?Q?CDo75WwcvJNSV9lDec9zWYNfsUjR82g5WJocaFGbyPoXNf85e8NnoflgNTCV?=
 =?us-ascii?Q?n/1N3eAuxbJ72KaVU+S60Ik/UCeqrBnPy5Wc6wgVGsMKntUoY7uOMlU9uBw5?=
 =?us-ascii?Q?5UicGKSdKzVEMSWnBxUAliowy5p6VnCSq5DCcK5Q4Zd+8/Nr28Uj+/UBgD82?=
 =?us-ascii?Q?DwvDR9L6LT5GQK4x+uWKiBaws74V+vK4yfcLVFNtSSOp3EISYnoz8b8bR5Ix?=
 =?us-ascii?Q?/65j1fh+DvWo4iwrPS4hO9AS8Hpue/ciBjsNw0gEXCjn/Pi6O2fnB71VW0QQ?=
 =?us-ascii?Q?ysmKL1EowqH8cNDpPff4krHaZECj9O9nlEju5F7w6lV8IlMtIPVACYUVrDWq?=
 =?us-ascii?Q?E9QCT2X2P1el0eiVqorI3K91SSGMEmok2aab8kbbVLBHutiGYXadioimjArn?=
 =?us-ascii?Q?a6gnYcaqwlooJa4UFV1Av16/7bcUwgnJZUsEoEHrnTHdtDYZtOWTgt2j9N1J?=
 =?us-ascii?Q?qxMnF2slaafB3vf1pEMdAh5EUAOSWQ+MquK4Xe/vU02dnZl/2ZPKLz/B2PPD?=
 =?us-ascii?Q?PiCh0Id+nbv5sMrIEZiX6H+17FwL/Zw8czhDRsxyZDri77cYatrFREQdvgQa?=
 =?us-ascii?Q?yC48Nm3zL1tpgddytyP9XLS1sxv2qpV8O67qRiPJsDdQiCtIwtVM/rQPGwHZ?=
 =?us-ascii?Q?EB8C+R+Fo91Whsz/d2Q5OcyDBlz8cFA4sn25wFgvD4+5JhnLzXdaPQMRSU0i?=
 =?us-ascii?Q?r7KxbHM+aBSAK5VBCk27O265gQDszQciaxoEPFZU1Pi93jQSGmRgha06iiat?=
 =?us-ascii?Q?LzZMelVmB93rqAWkEqFJht2P2IHNYLUTFI0ecBJeFQg2snNizh5g6KUICsdy?=
 =?us-ascii?Q?6d0TS5YMHaI64g6HE48qhDUR?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a05d23-1eb6-400b-ae72-08d9831f2026
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 07:59:55.7750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w7CGRwWoJBj9rmqZWSHYpvoMU65yU7pl9D8cPNxXS2UFdY3Wz1vfwm5Au6+NP3/IGHN2OI+OEQhTkL3vZcGwCkX8p1nIO0upL5iEze0FynU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2841
X-Proofpoint-GUID: qOU-C8rWnvpSXRCouUyEpfWRKOKEeVdb
X-Proofpoint-ORIG-GUID: qOU-C8rWnvpSXRCouUyEpfWRKOKEeVdb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_02,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 mlxlogscore=396 adultscore=0
 phishscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
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
index f269337c82c5..6940fbe4f096 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2354,7 +2354,7 @@ static int remove_net_device(struct hso_device *hso_dev)
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
+static void hso_free_net_device(struct hso_device *hso_dev)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2377,7 +2377,7 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net && !bailout)
+	if (hso_net->net)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -3139,7 +3139,7 @@ static void hso_free_interface(struct usb_interface *interface)
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

