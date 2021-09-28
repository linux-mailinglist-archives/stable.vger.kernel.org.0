Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB78441B218
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 16:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241016AbhI1OcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 10:32:04 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:47622 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241247AbhI1OcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 10:32:04 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SCb2K5008498;
        Tue, 28 Sep 2021 07:30:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=zH+Q3UoQxwkETRDZmJMG9FFIJmHuct/adb5qA1uT8AE=;
 b=keK0buxoTqZepsDVsu34ME9nGdVAzLNx3FcSMheSpm0cOhbKN7UMpuhatYiMTgkYqhvF
 AMqtttLohz4kZ036mH+5gzq2A494NiFNmJWAvOHVuLOgEKEKZibyfdOKEUMJDxBw9KOT
 0PPPBPlt5e53m+RyLvVFIEb2hwRhfdyEQtGRch/tZpDsX+kaEg7dxV0l+dm11qIPWqwY
 e11C4UvUhY5MI38XE8zsNBVVu96q/YjuuYyr0gPMKQiBARQZ4C31ksMijX9oEpdQU99u
 2inxcWNMTaFSfoDQ1KQc8cTQPAJM69w7Zf0EAfBQFnVlOv3fsroBrd/RHjdrw/sVco9C Gw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bbk6ygqdm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 07:30:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K63pNkS27FqR0SUhdd3Skw7+bZlY4hHt64sc0YqKtu2dwM0WC8wNy9r3vnKuJT0ds+SzIQYbtN4sHspiXVSIxoGC99XSZxecrs8xv29USb+lOe9ohXTCuVxjSEdxjgJxhKTleJn44m4DjPJOksPRPsGnJOiNrSIxu5jAlh7I8z0sHT7POTc1aan0AAjmuXqf1mbLb+yqhfiuFCibAFxK5xTYSxrye9BOuFECN06+1L6LHc/KapS+9ucSzkHNY+CyLST6H0SGI2fkjBWMA0Ib/ec0C/FxZVB/5aWphugmkJbBee+1VXQPT/VMo8BoSuXA0/WRHyOUjdVMA4qIs+mShw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zH+Q3UoQxwkETRDZmJMG9FFIJmHuct/adb5qA1uT8AE=;
 b=E7CtMJ9NLJAVHXTscmyY9oZts2SW/cEFZLPbDvkLHlUST4sejWuGrZk2PwsIfZ16zR0iA42hdbI6pM5odUS3fHr+0roO8HJEzdwhSBpzfz39ugkZJOBXiGMLhgz0aFLVciyBobvgQAMUKRXR7vyWEm3S1dueHRSos7o8v1qwrwtW8ZurIPqPWkgEZbHgzskYNLejZMpk0+wS30OmziPL3p4PraIofIbA5nqAfacR0foZ1diRL3EwqtFcvBQ2S2NB0rAQXBgVeMork+NFoAkEUvrUWYRIJEBuB0HqnLy2STMEDX0DWvtjC8NpcYyyePcKiEOlFQifDCMy8yLq+rVJ+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2345.namprd11.prod.outlook.com (2603:10b6:3:a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.21; Tue, 28 Sep
 2021 14:30:21 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 14:30:20 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com
Subject: [PATCH 4.19 3/3] usb: hso: remove the bailout parameter
Date:   Tue, 28 Sep 2021 17:30:01 +0300
Message-Id: <20210928143001.202223-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928143001.202223-1-ovidiu.panait@windriver.com>
References: <20210928143001.202223-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0028.eurprd07.prod.outlook.com
 (2603:10a6:800:90::14) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0701CA0028.eurprd07.prod.outlook.com (2603:10a6:800:90::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.9 via Frontend Transport; Tue, 28 Sep 2021 14:30:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d7db07e-213d-4652-f64a-08d9828c8036
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2345:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB23457C4A31779A15066D9D3CFEA89@DM5PR1101MB2345.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5uXiJKuj5UVTNcg5kUoeBl0nvF/lAnNa0BI2mltuC7BaDNUJQdZJxEUnaCYW+KUjnwm6l6RvUYh7sUie34NvciNBQ5/AtXzwStb2j/Kp0CCge1gIz3YmGLMyZVMY16p+uLJr4v0Z2cREatJKscA2g3sxiqbx831DQxjo3UQt6J/t9bJ0k+ZDKaK2F/Lju/QzIQGcGNAzJDGdpd14zbia5VnmHn+kGGaUzT8RIt+C8v5XJAQsr8y9y5+vJnBinUcU6oQpYNW+ihaiyovMFm1q5J1VzxGAtjhdhZLVxG2mXrWVb+FI56RweWxhG5FJxLOG/psvEmqe1eqh/S00sOin1hy2H9TFPA0zL0m0GWql4KaJ1aBrNhN2aNd+uZxfQTQVECsgDzov2uL6lYf5vvrcSimL0fneq/DzIPF/2QDmVXY1b6FAqD73rzMZlgtjXeeexxZaVydnpNfhkEXj0j7UY8P/FdQo1wv+H0VowdEAzgspJHmdqlyHmeIHUooLcDHFd9XpNfRmFa2AxN+4frwKYDrBvjPsDGbCyEHoU1TQM9a9He4qE6LM6zbks/Z9YTup6C8/yQz823lCTqvElWIuDHnrfUimvfYI9WsLYgqaE/TCYV6rZQ4k/E6DGLKE3D7jVVlcSm91sVFM9d1gohcnZ3dUtvwFq0Ufp+WT55thPjGQnRAD3HzkXSpm2wnRKhg6NXcJ2/X4XNxBYiaz4sCLnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(956004)(6486002)(8936002)(1076003)(8676002)(508600001)(38350700002)(6666004)(38100700002)(86362001)(316002)(6512007)(83380400001)(66946007)(52116002)(36756003)(26005)(6916009)(2906002)(44832011)(5660300002)(6506007)(66476007)(66556008)(4326008)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oJRrYT2cowcRtUPglBu/BM8L+PZNvrs3CMkofNjQHxY/ec644avlj8djz65+?=
 =?us-ascii?Q?BBW2EajNu8WEaJRJ4tvMFumnt9RKtthXT6Rx7oamprd01KmBoGfhditdbQVN?=
 =?us-ascii?Q?kMAisu5To8iBi8JGbexW/tgko6nCIKymydHg6c3VZ0B3Mfq26YgtQjr8Kd2q?=
 =?us-ascii?Q?BHTOSPkIVBbCIE42etyS/dgPejxGsbbrHX2wYBnfVcrtHs5wHHUxqBnQpL8a?=
 =?us-ascii?Q?ODI6p8KJaxq4M7qJQ8ZFXIaHI1ylMtzPAR5/ALhKYk19+0RkzcWYoHNy1mjt?=
 =?us-ascii?Q?qHEplvm1TaP6DxdAdJqDEQDmcDeoHptMn8DeX4lFena5zISn110KLdFiOV1i?=
 =?us-ascii?Q?nhENFUxH0zletK6U0EratwP7/L8fpnMSKk83J2gjMy6mHftFIxgwjx0luNHR?=
 =?us-ascii?Q?PnJbTMGwoUO9PYcI1VVshpOLfK+84L9lI8Mv7rzBDTkUTt+rGXWnxfxJZg6l?=
 =?us-ascii?Q?ikQQclqL7WHOrrBA/EdFfULlIuEul7R/5vdP2P9d7wKsP8qhHhKgywLG83Pq?=
 =?us-ascii?Q?Ujt0toWXEiHU4FZuRcrJ9tQZtiwDQPZYB/uSCPU0u/JSob47VjCH4Uqc3nrb?=
 =?us-ascii?Q?oNZpqcIhTberBOdNL4BeaSH7ciB4Yg4fzm1WimPJOFhNoJMQjRx4S9APXtIw?=
 =?us-ascii?Q?nfJckVhhUrkQH9EplSsN0w0qYOPs9W4O/GR/nJe8ikOVWOjBEA70F4epNjO5?=
 =?us-ascii?Q?w+9Mu+RpweGPsTbolLOG6w7CJs14+46oWWztNBmt1i4a2/WzGu6CIgIMqBKI?=
 =?us-ascii?Q?EeUAqmM3MddYqIsqPH21lEhLGCVYtCp95TiLibjwSmLZClJM4MszKGZ7WBp0?=
 =?us-ascii?Q?mNvwBLWmPV2nV2pnX7Z5lDFdEqyVCRVEaN5KWd/CG5KV6D9UtG1+h+BaWjyL?=
 =?us-ascii?Q?i7UFZhL9wRH8uYRzHwR1jI2gsxmRCpWF/bF5DX/8omsYuC0O3vzj5XipvYNF?=
 =?us-ascii?Q?IKQNXnUJwlLR9gpwJCCv8snqi1lPx3NVHLanyntGOzCzsNAT4o1hgK0JgHJC?=
 =?us-ascii?Q?s/1TvuvEE/ug+3dKGVar3LWICLjvfPk+UPf9a/dpaTv3DUDwUOoDg3CLYGWr?=
 =?us-ascii?Q?nypI9AiI9xSHuq5j9UdCAImVsZQcxEL7+PcxKLWvRyD87tkZG3/Bddt27a0h?=
 =?us-ascii?Q?6+dHL/9c8jyMJdk5XjSCnE+I6V/uZTCxuIKy/lw9/WXUQCZUJDtpDyiIMubK?=
 =?us-ascii?Q?/hXLidU++cgp5YgL1NI6sPGHvIJ4GKAkS3srBgSkh1e/oLAr8vWYGMxOaHM9?=
 =?us-ascii?Q?tWMHZ6qeO4vjMxk5/hJ4tqk4DiIH8qEQMvVTmmtB9qNVkeCZCrhCu5cVdPHe?=
 =?us-ascii?Q?05FDy0b2xJUHPYU1mUcjnE0i?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d7db07e-213d-4652-f64a-08d9828c8036
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 14:30:20.8809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 85jGbcdehMBpHAkT5U9l2ALdKv/U0PlekjL0lYYGPefialSA34Nl7b18+5y2VgSXRKFKFWdLWrzASgWwCo523Cu+NVT3yr+7k//u5rtsIYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2345
X-Proofpoint-GUID: lsdqhT7zXTg_Yyca58Y71-Je1dqGlbaQ
X-Proofpoint-ORIG-GUID: lsdqhT7zXTg_Yyca58Y71-Je1dqGlbaQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=689 spamscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280083
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
index 8f0d86f91c5c..681b19901a94 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2368,7 +2368,7 @@ static int remove_net_device(struct hso_device *hso_dev)
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
+static void hso_free_net_device(struct hso_device *hso_dev)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2391,7 +2391,7 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net && !bailout)
+	if (hso_net->net)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -3145,7 +3145,7 @@ static void hso_free_interface(struct usb_interface *interface)
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

