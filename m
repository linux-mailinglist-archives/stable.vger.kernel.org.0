Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E84941B2C4
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 17:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241442AbhI1PSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 11:18:33 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:18656 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241399AbhI1PSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 11:18:32 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SEvOpf004030;
        Tue, 28 Sep 2021 15:16:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=e+IKItZN/l4bduo4nL7AYH2bbIsxCVQoRFDo17Es7JA=;
 b=jofplDeCBcpOUUPYiJyaaqOPSCLF/6qtNOZ1VpoBxCCJD1Ho3GyQcYna+rzumI/4sm3l
 sixXjXBdCZhQ2foUnfpdNVgV/ROWOmaVY8MbeyTQ1/b56qi1fzH7J9CSTCgqffAvL5LD
 pgd8H3ZVQRv3R4SdYeb11a9pt3h5r13alCHgAC5l06HLaB/RuJ6mNtn1nJiV8I81VHBP
 7LO3FN6y9pF+n/AkubLLietBL2vGm40x5VJLAPNd6TUs/6QN2lVwIKLa1r1Rw9xmPJa3
 zIKP7ms+z8ERtUbsEiY39JS46H0+4kbDaUSOV47qBkozERue/k8Nyg7qP3p46HPDyMCW gw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bc0qfr9a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 15:16:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFuJRl1N0NybM2hTttve/SZw7ZBVfZvYmJzMHmpb3+npy+HpRazeMGri63rI56NqitrUHiujIj34enk/4uVdoa/iXMqmmFD+QxYZabh+JBdONwU4Wz4kIwoYr8cm+r/YarVIBOgW0bm41iWGBQDfq+OyVQVEOsZYLgRU9jLuTvuYEX3Chfrko5Dt2ZlKjbZ3TLoiC43rBb7mh2yaZ7SKK0bBc29G30sph1G36jNngsTIIq90Gz+2wHaN+lZB1WA52zESM3btqfOEhBBNLgaUPWwjuzsjroDyltg4/54I+6sWZLkf/SvqOY5GT2xF94EpZWqHr3WeJ4pjf4hmCpZTHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=e+IKItZN/l4bduo4nL7AYH2bbIsxCVQoRFDo17Es7JA=;
 b=Hqy4kHZoT4WpeJWtjtzXppGTo9AkFfboeDOTwFaMQbXmJEoYgHF9szp6IVKsUDcYl2snYvllfLzuhs8xv6SOlfstjEREH1pD+rfwCfMHiicNMWtA3UQ4LwyDKSWI2IfZa2tNYUTPxY2kxp3E+okyXLxNHcnl82zZNwvC5Xds3cY9srJVdzfiBbEZCRd0r4TdWC5CRUrMWqZkykuneMhfv9R2UcLKTyio6CSWXXiDCvc5p5uWrD1epUepq2A8fpsuXnNxKSrdNkCOolj9i6gFBbAgYzz7B/Uypk0n3JI7TdrGhIsg8Dwvf53EdpcrcHjltykh619wtYEbsqn1TxUu+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5261.namprd11.prod.outlook.com (2603:10b6:5:388::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 28 Sep
 2021 15:16:48 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 15:16:48 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com
Subject: [PATCH 4.14 3/3] usb: hso: remove the bailout parameter
Date:   Tue, 28 Sep 2021 18:15:44 +0300
Message-Id: <20210928151544.270412-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928151544.270412-1-ovidiu.panait@windriver.com>
References: <20210928151544.270412-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0019.eurprd05.prod.outlook.com
 (2603:10a6:800:92::29) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0501CA0019.eurprd05.prod.outlook.com (2603:10a6:800:92::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 28 Sep 2021 15:16:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf9351cd-1257-4621-50e0-08d98292fd69
X-MS-TrafficTypeDiagnostic: DM4PR11MB5261:
X-Microsoft-Antispam-PRVS: <DM4PR11MB5261DBBC2AC04410FA315A7CFEA89@DM4PR11MB5261.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 08NspcJPMXyf3//vaUOs9zE4kPn6jj/ypWg90tUbFvYFMEiDnv+4B5Nn+xEPTepDILD2YJrSEtRxzFo8MV7tInCy63LEpsJ3mV9yVrNq/GjO/lERyR0o3ji60zk0HCsJ+tTzDIMsTdk+ITbF1coiQcCkhrEeJEmkyi2zM9x7V1lODJYkHf5UMpsU309tzTU9ZVRG1jo6NeOQmwktegOyqM4Y40dO+vbyPQcWyhr2bwwWJw1DHG4ZQww3ISSrJLZFcgUziSSSCCpEar9jfmpEcVu9gjCbbzEow5YfXRfx+c2mFya0orlXkm6PlLDOZFt2TEMyrsDQLe3cyDKzdwjKqxjJjevEdH1i4swIVetMK0dWM2wJI64TYbI3o8llW3hyuwUPLKml7jUv+7u4468oeS6an0wZq34WSVl26ruEbVysApx0aoGovhAqY8Xdiugw3H1AGo9sOYK8OqgFKtQsU65ABNhc906VcBCD9cBELDXq1vHSze59ZgacIsdLRfgOHKZy7Szjk2WNA/tDhhOxj5M3L9s/+z2wha28su2eALrFyHJtTpEsnCBb0n6+TJzGKKX9zYAeJxAIQpkTrk99qT7ZPDBwswc/PkRZei6D0eVw4mP3d4oFgojizyq+EJH55RlAJjIT+jCNgg8RkwKcuzrDzZEvL/sv5ZhmjmwM38N5PaG1MJzEv7C6P3XQV5UWb3TV20RVR/RcXeEn0ff05Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(2616005)(8936002)(26005)(6506007)(44832011)(66946007)(52116002)(66476007)(66556008)(4326008)(316002)(956004)(2906002)(38350700002)(38100700002)(36756003)(6666004)(5660300002)(508600001)(8676002)(1076003)(6512007)(86362001)(83380400001)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HUbftu+hsZUwv2h/40JCnGVkFKX9b0RkWAZUtCt/7Ta05NtAMtfiMfdCjreR?=
 =?us-ascii?Q?W+khwqrlioLnJU8B8FufAWx8B/07nDEMAOfs2kNvquaoggwdng6svZp2ieaP?=
 =?us-ascii?Q?Sf7e6BQNSSijkqhkYY4uKep0q2A8TIiWsD+L9L95GbD8K6PHVpeRtja+PjJA?=
 =?us-ascii?Q?lxlqx6WXYg7AjXLDJegDPv0Jpr6xkdaknAYyq1rDYhFLBejl16tw7KUHTpuG?=
 =?us-ascii?Q?OcgKJdC/NVDaj/qkHaKar0lRmJWniixk4GViqksXljaMInlCatLFZfeMWKSz?=
 =?us-ascii?Q?UIs3xGV4am+GoRToaelLxG+eDuLJtsbouT0cGBrjH+C5MrTuwz121izYg/X2?=
 =?us-ascii?Q?ZxLqqNFYSaK0Da09qeM0WpBEhG2BxRNbBsLh2CaYOLCGycVg0ozIoUsogqkJ?=
 =?us-ascii?Q?qijqvfUhp7FNDMIOXqfKTYTqgz9sk3fIhfs6ZD0UMLj1bMiagchr2w+QZ5jt?=
 =?us-ascii?Q?ND3Te7IIi+bRQsU9VFfgBOPAxlb1thuLiXazaUlLeuYGUbmtJabBLxJZlH2G?=
 =?us-ascii?Q?O4I+S3cic3bptUmmdzcaDkFjbfEMkFAwUy2lFHNvwPm8bRNbtra1HNQkGiqI?=
 =?us-ascii?Q?vCQxZXE5LUujNi73i6IlJIxNgJYK9YbLqhbiRmTYwVKrhxquLj5I3A3x4Mw3?=
 =?us-ascii?Q?Y9QXL39ACjb77tVytYoQKbDF0+r6MusOBKWktmMD/ImArHXItBhWBaA5/GFj?=
 =?us-ascii?Q?mpdyzHi1W80CHkx+jzIad5JnPBuysxlT4rUd5WHhIWRPaHcSgcw6KCbDytEE?=
 =?us-ascii?Q?q4SxSJAsbE0b80Wa6dKAU9YkOdoPjzQTrCfa1zuhzbn6YOsnMt0UuSxFrDNb?=
 =?us-ascii?Q?F6y0VObFhx1uU1AesKSu4bLZy7iddYsIo0UNVhVRsde6sT0iqjBHjYsZ4cV6?=
 =?us-ascii?Q?a7LmvtppgExHhQEAUF59xlKWHZh1+Uu/WlM6HqnxQLuNC6G+unwbRjHK00Ip?=
 =?us-ascii?Q?n1Ud+jdBC+BaEi4fy3/cFnRQN/+6Ui/3YELPlksS5ya+NDYeooSoPla3kfvw?=
 =?us-ascii?Q?Gs8TNz40f5ABQIcRjwsLkU+lPU/Kqqy63R57ZIxxMJ/WorBJ14Vm9PZ/Znc1?=
 =?us-ascii?Q?UKDWG0I5ZUY5url/qXjmeo2uzgWvt3QD04VtdNTyH9lq19YzzT2pJfGwuxmY?=
 =?us-ascii?Q?Y8J5/c2ij1jLvzWZGjpj+qEWT1CqE+7RwCSQMNdv9v7eEfx6TlI3cZs06zxq?=
 =?us-ascii?Q?Am3zXQBF4MrZXotmQx/clhazEmXY3doAtQ6EGU8fOVBXuWDdJGRqfpy3a9De?=
 =?us-ascii?Q?BPtMizeSXm0IGLcIdYbhte6hcNlOD4XvJNI+LAkH4PRIsRzORmXzYY/lxcYN?=
 =?us-ascii?Q?8LtPObiEU6uPmhsOXN+BZ/N1?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf9351cd-1257-4621-50e0-08d98292fd69
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 15:16:47.9642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rKvIHQ2Ugb4oeW4n9Xndcd/a3HP17BU/JnBoQ6HYDY6ejQPvvmoDLk7DBV9vOxPIiikhsjQaIryolPwXNiZe1+icm49Ouk5G8tb0bIgJvBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5261
X-Proofpoint-GUID: FoaF6W1l0H-rwyHD1QzllOUORvWixqfJ
X-Proofpoint-ORIG-GUID: FoaF6W1l0H-rwyHD1QzllOUORvWixqfJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxlogscore=689 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280088
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
 drivers/net/usb/hso.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index a47a01057e50..353f300686c3 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2367,7 +2367,7 @@ static int remove_net_device(struct hso_device *hso_dev)
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
+static void hso_free_net_device(struct hso_device *hso_dev)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2390,7 +2390,7 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net && !bailout)
+	if (hso_net->net)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -3144,7 +3144,7 @@ static void hso_free_interface(struct usb_interface *interface)
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

