Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE6F5AAAEB
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 11:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbiIBJJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 05:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234776AbiIBJJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 05:09:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC82B6144;
        Fri,  2 Sep 2022 02:09:53 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2827mGCe029862;
        Fri, 2 Sep 2022 09:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=2GQZwhUVeap+MzbWy9ZW/PXv1irHpVYpn/SyMvU2TkI=;
 b=gSmRrWVuF30Ac7wSVL+jec463vJhhv0Ku2H/5OVVxbixxDZdCSdKyv8HB0IfTK2kNObk
 IOhT1kpgJ/2YnbO61sDftRbaLDefNrBqhbBJ2aMXncR2Ytve6UHQQyn1/3weMjYj3oLK
 zZ91qX9vSSrOFVwCQ44TcTy89vhAN7Ib9YeWTw2X6SIp53xpKsaUzmJQkkyFOUrcwgsU
 /qs5RjzsekMrA8MuShWsEv9GQCRkCYYRmPkey+F1vwVbftt0GiF7AGk5EKg9sCs/z7H/
 C0BHfz9+1OltY8BKxib7vU5LkcpWskq3BKKgRNFP1NyZzmkTaDpQr6cTDPhpgWa2JjIu WQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7b5a6e7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Sep 2022 09:09:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2826W58A019632;
        Fri, 2 Sep 2022 09:09:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q7cg1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Sep 2022 09:09:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXy0Xb0KW0TL1fis/b2ubZUxrJw7xTK80ABXXtrpqeViQY7j6lt0s7nXTtXoH4EfZFUUQ1ZpGAJpgPAznJC6sUAheMWQjUnH3B0RtDGEORoY49upSOqihIV3zWMpTlO5oMcLIbgXzKrPFitMZ1tnHrGDR1Tu9iD1qGr0T6AOatcomXgrotKPEuGSOtgJIBo4VU0ssxqJiyoVTFn19dyv7kuBWWBnmkW//7ugI3hGI+RZvRmpqazWQAzAPVaIbQigvhtun8nCSH0IZLyHftVcZO5lcGhKFqyT1KOLPA0BAU7Ci/5EmJ0rBMVP7gAzHKMQ2PkZ9MIMNA127Xg8BEPL/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2GQZwhUVeap+MzbWy9ZW/PXv1irHpVYpn/SyMvU2TkI=;
 b=KP+hi7lI/r/72Uv+WgmStTzH3aa9+O4LSyCe1wvWeXmxoCm4RVXpI3o/2ukW3DHFK0Vyk7iP/cJDHGK1QEbs8tmbIJlgpvbaaRp0fFroMECVIBYHP0Ack3RuAq5Zb2FjSuRCnCjhI3p1saQQGf6Iz20L2+g/uDmhSIpvU54AnMWJhXtAeXCtOYQdxRgFKYnbMISr9JTmbNs/cqSBv+hB082hgAfOvPcltVh1zeDBfmvHqk2LzpzSEwfGnaIy3G68DYCtw30JPKjNWTPzQbxHZCx7m6wsWoCUgteEc8CLooPxbhlqSFtNvzBu1SLt2IAS3zYOdns7WKjfDlQA45DhFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GQZwhUVeap+MzbWy9ZW/PXv1irHpVYpn/SyMvU2TkI=;
 b=dxpxxGugf3dO0yp1bJpLXq6a5GcLSPIUeiKX7eAvzpvtkI9mn5m3CIWlKkUG8OTPAZmk97kylUbeCtyYrfJ6Pc2Uhw1J93JHA1MToBBQrur/yHAkbug0pJFp0lEsxY0NFj9QMLEQJLg/pk4126W7ap0W7opTk/ORwvLBXuEDXaQ=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by PH7PR10MB6481.namprd10.prod.outlook.com (2603:10b6:510:1ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 09:09:45 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::f164:f811:6e47:b7cd]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::f164:f811:6e47:b7cd%2]) with mapi id 15.20.5566.021; Fri, 2 Sep 2022
 09:09:45 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.4] btrfs: harden identification of a stale device
Date:   Fri,  2 Sep 2022 17:09:38 +0800
Message-Id: <73979e98c7edc6690959f1d5e9e8d2bb678a8101.1661473186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0185.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::19) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4181f253-fb3b-4701-c814-08da8cc2e0bb
X-MS-TrafficTypeDiagnostic: PH7PR10MB6481:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZroRu59VjTCIRGx73knyfs3S+0mG140J6FTJPy+mCZF2Kq2IM5O4m+qwQveTHrQzkxH3oi1CrWq1fFSr15pVYxcUPb691yVoyLlqdwwI+OwYluN3ixW2FiTc4/XBDfjEN4pmv0/QMPvYrU0KV6bNzR/s4BQdGITttx7cLtyXM6rP2eT81+MxRR1ggWU6yiH+HHS6F/73GrsKg+2uDOIh8oW6T36Q5I1ql8wSR4Cdn/WrcARwaqTfY7tDD1yay2GtTyamygtxmopOhVD5ReMdOdM/a7qQo2AJTpg5N3++1DIH8YFm88+klQRA/JLDpi4/+freYizCqs+5LTyoFdFmHbApXxifob4QmWYNeS2652jH3Ga1tUymkNdlNWlIOBLpyOZJXixeXBSvWZe9MZ2rLjqaoK+KYnhfRODmnxWu5GtGVf4KeLSCMnTe1n3gFifld70hce95vXbpKqu6U4DXTpTLea3eIGBmM9W3KXLybzXwitgC5A3WNkdljaWs0k/jc3Sfq/Ui9y3JtRfi9n3xvX/xkqSJPoX4zkFgUM7i8taMZt57UBWlvs118n4hHnVWOhgKvl/Wgsm931Uiov901Zw4RhIQIRDSm8kkw6E8BYtxIQVEKf/Q480WUNYWQcyjEwKPBNsOr45Pr77rxijH69A0EYeFu/dwEwDVo2fYqcr1AVszyYR7z6bVydsLnNA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(366004)(39860400002)(346002)(396003)(83380400001)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(316002)(54906003)(6916009)(2906002)(8936002)(5660300002)(44832011)(6666004)(6512007)(6506007)(2616005)(186003)(6486002)(26005)(478600001)(41300700001)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z5IlCm+xfypyBRLmnuR6H2untZcrSX2J762p2ShANM0qUyNxtN194FZ/JaSE?=
 =?us-ascii?Q?WZGPsubqbrgcCeMPFXbhKxPso14AWvIseqe737+kHECN5rcvkk7lX5LWDTeb?=
 =?us-ascii?Q?ElR79YHpmGo5g4/8FHE5CwpLA18D4OT57ZA/BXYigq6OeJvbm8uUfIkw6JaJ?=
 =?us-ascii?Q?We6QT6BxIzV3IbWHz6SfJ7CEVBpBRcXsneiDXuXJ5ReixsT6rNpQ4umoivWB?=
 =?us-ascii?Q?6j4qTTiNit89srFZYA9Z/2RNSAhiQfUAvMqqtb9nJiAQfngy0BpHaKBtVzzw?=
 =?us-ascii?Q?EvtLraz4aVPIcOa5BkW2B+gB6l5juQs4wfKTDoaLMdfYGur2OKHhsluRBldD?=
 =?us-ascii?Q?ZLWPyf88K0GOqd7Cln1CpYnSebiCeEO5Kym8Hux7a8FZ3YK1L1p5mtjfKgVG?=
 =?us-ascii?Q?dlcblg+cMsBOJ/GP02EPrOOfPp7Z6/Ff56Nc3f1kundZIhuoqP89LZOvPqG1?=
 =?us-ascii?Q?xXNzNEUQuKwDvTsN/I1Z/RIQcAqetYpRChcRmQs5e4ZCH7+N6uuFODptFySx?=
 =?us-ascii?Q?XDNdReDnH/32zYoboLWAEXTqTp7KbhVZliSD68fCxT+XMoYtHgr15v7yRMPj?=
 =?us-ascii?Q?TY+NJHPu6Z+cpovXscMowIzo/bjRu0kBT6Yzm4VfAtCznJwFj5nUzBUfv8gq?=
 =?us-ascii?Q?jBRQf/tWTXKPKPlGBd9TKVpSmVFVZxbTYcifpiCjLKVI6OUQKlzu7sXLMwTw?=
 =?us-ascii?Q?h/No2elyDezN+Rxt9pVPgE3qAbjuH314UdBmG+BglLeKom/hPT7x+QPQWRw1?=
 =?us-ascii?Q?jXt5F063htZYFgbKBqRoUK19JDdw+OpAFuneHIBPH3ZHPvki1qpMniRVinq3?=
 =?us-ascii?Q?XtADf6zhxiAQUvQDSutZHw/10TvNTayjkErs5Al4R7Zx3QwPqXbrD7hfyPa/?=
 =?us-ascii?Q?oF4kv8TMegRhqOGPCzlWkjVwMds1zBQIJjq/w2A1XTM9xddV0fEGgo5IqFFm?=
 =?us-ascii?Q?hq5mritvDwSsxQE9OLqIIlhMqWAL+qWWyRRQMMMZrWhJIRRta+h/VkWVpXeI?=
 =?us-ascii?Q?04krWVPByBX6lpCDzqAI3zVSV7I9Ff9V82Sf3IbRIcpSdZl+Nbfmqe7BV70J?=
 =?us-ascii?Q?uAprXOCS79mEem0tHcB7vBe8nT/czRVMWESs+hOcp0cMSRYZzPTZEhwg6zkH?=
 =?us-ascii?Q?MqGUDTj8YqdofktDJMyU0Xuutx1PeqYP4FHav1QImgulYw4Erivr9V4glmp4?=
 =?us-ascii?Q?iKeSKp1uMyo10kW8mb/bFsPcrNNP2lnKObhWbnE05MIBQHZadfGuiVkMBXQM?=
 =?us-ascii?Q?rx/LP++PxQCw/oahWAdH9mpXQai0oe8wVOwqtpSl/OWmfZanj5CSypCQVZnE?=
 =?us-ascii?Q?mTfC139Bh/cwVh9o/oTzeIYP6NiJHQQTUzyh2oNl07RdiXRV/ciOe46Eevq0?=
 =?us-ascii?Q?+NsfnHX3EeZux3yaxl/oWJ08A+QMR2FAVHt2uAIVxdVU/oY5gSdTw0O8dcDg?=
 =?us-ascii?Q?8wB6TxH/gqw/eu4qFYuXJGx1Yutu9mrZErJqw5MhrX34Xk61tdfdc330zaXD?=
 =?us-ascii?Q?0kWuNE7pOdi3rVpewjECCBgeQaG4G0m99EyHgxjRp68IXtiJbbFYW8Pck2LM?=
 =?us-ascii?Q?rjR19nh1t8dzdff4CeQmcXHjKk7bXemOvYUe5WMb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4181f253-fb3b-4701-c814-08da8cc2e0bb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 09:09:45.1730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EyHZtFOxTPEBoXrRUcuo98GPid2xXH4kTKslJa6UxqpuwOKcYfS04CCO5V/9pH3MLeFp6nRPy9PJyDd2Szt4Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209020043
X-Proofpoint-ORIG-GUID: bphpyN-tLIPLiOuQ8Y-LoqTaxfbPPstO
X-Proofpoint-GUID: bphpyN-tLIPLiOuQ8Y-LoqTaxfbPPstO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 770c79fb65506fc7c16459855c3839429f46cb32 upstream

Identifying and removing the stale device from the fs_uuids list is done
by btrfs_free_stale_devices().  btrfs_free_stale_devices() in turn
depends on device_path_matched() to check if the device appears in more
than one btrfs_device structure.

The matching of the device happens by its path, the device path. However,
when device mapper is in use, the dm device paths are nothing but a link
to the actual block device, which leads to the device_path_matched()
failing to match.

Fix this by matching the dev_t as provided by lookup_bdev() instead of
plain string compare of the device paths.

CC: stable@vger.kernel.org #5.4
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c7706a769de1..548de841cee5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -713,15 +713,47 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
-static bool device_path_matched(const char *path, struct btrfs_device *device)
+/*
+ * Check if the device in the path matches the device in the given struct device.
+ *
+ * Returns:
+ *   true  If it is the same device.
+ *   false If it is not the same device or on error.
+ */
+static bool device_matched(const struct btrfs_device *device, const char *path)
 {
-	int found;
+	char *device_name;
+	struct block_device *bdev_old;
+	struct block_device *bdev_new;
+
+	/*
+	 * If we are looking for a device with the matching dev_t, then skip
+	 * device without a name (a missing device).
+	 */
+	if (!device->name)
+		return false;
+
+	device_name = kzalloc(BTRFS_PATH_NAME_MAX, GFP_KERNEL);
+	if (!device_name)
+		return false;
 
 	rcu_read_lock();
-	found = strcmp(rcu_str_deref(device->name), path);
+	scnprintf(device_name, BTRFS_PATH_NAME_MAX, "%s", rcu_str_deref(device->name));
 	rcu_read_unlock();
 
-	return found == 0;
+	bdev_old = lookup_bdev(device_name);
+	kfree(device_name);
+	if (IS_ERR(bdev_old))
+		return false;
+
+	bdev_new = lookup_bdev(path);
+	if (IS_ERR(bdev_new))
+		return false;
+
+	if (bdev_old == bdev_new)
+		return true;
+
+	return false;
 }
 
 /*
@@ -754,9 +786,7 @@ static int btrfs_free_stale_devices(const char *path,
 					 &fs_devices->devices, dev_list) {
 			if (skip_device && skip_device == device)
 				continue;
-			if (path && !device->name)
-				continue;
-			if (path && !device_path_matched(path, device))
+			if (path && !device_matched(device, path))
 				continue;
 			if (fs_devices->opened) {
 				/* for an already deleted device return 0 */
-- 
2.33.1

