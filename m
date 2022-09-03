Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83BB05ABEEB
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 14:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiICMZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 08:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiICMZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 08:25:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640CA286F1;
        Sat,  3 Sep 2022 05:25:15 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2839D1rN017559;
        Sat, 3 Sep 2022 12:25:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=8NBC9tR/3Dqf8bA009nXJcR+hZXEXy6ULJfEaYg2Eg4=;
 b=X3oXcJouJkRsNlsQDhpyx76JWXm2EvDBS4n1oN3KZbXIPPqU1TQgFGolM55d4jQXhO7D
 H4GAwctV6cAFTGF9d+BsQVqxWdwcIQoxrGv2gD9u7KcUUxdBqxP+0ejSs4/whZpT+Qnb
 AVoOHVVJSYz1tI+Mw5CeT9Z3I6b/hPQxaxEVA2Wb9pQbkBsAXnQdz68dqDoFh+UkLOf/
 wXhnT8YjCS6glMAit8ytcZOZuRpwOEs3f5koCyx5okDRXQyjurNLwHee0Wa5g34Z9pkG
 TdiCG7coy3su7aLVl28PPQyeCbGCwRvLeiala2VPW60HkZSNI8Ms71mMAxoC1MtoA9Ut 7A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbwq28nmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Sep 2022 12:25:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2839KBcD024440;
        Sat, 3 Sep 2022 12:25:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwc0fvcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Sep 2022 12:25:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mALYrbM8yXynCkMem4E3bZJy7DxoHBzJyHWQwmluJff6QX6Ihb8iZz1BwBqf4lXEi3BZ0CYafqT/h1wUc+1MjeCrUcrn+BK/f/HxNzx7vydPbJYECck8/gK/ZVzHQC+fhTnHZkSH+kt6J8I8lGGs26QIuMVg6tO+s+q58+PpeKJbpfP/1w7yFy6yZTbE+UTjP1sBHDleEfB5RWzkRs92dnkpWSnW/5xzGeQw984jQLqijHi82ysEFPrYBcoYtzfvBr/Um1WmgpoCa4HDSmO9Znh7Ww3b6/7+HXYvxIz5CHTZnyu+KG57kC3V1EywZEY2C39ImhfdQ/xMqAYVwJVskg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NBC9tR/3Dqf8bA009nXJcR+hZXEXy6ULJfEaYg2Eg4=;
 b=eTDiwVcQ+TDElgF22noK8fzRrUK13y83lATTEpDhu4CPaOxlxGok1nHGQZIempEfy0GwzIKLLaX8bklrLnQLRJmElmCI6vITFC/HahkdiKib/IHORmhLf++YwUi5y1EsfK0p1LQVKCENcqgGbbJ6nozfcDrWdrkofYwuo8Eo5hbV+XGsxrzUzW9aIx9JSJjJUpKISZxjdomL4ZhlXbko31QPM7BkZlLgEPgxuU02fEg1fzv8yyTT0Z1LDYGptC8xLq0pSLE0mKolVXeQf1QwTDUqoNZ6JOW43q/HPqyORJrM26JZOu3Nv7K+eLC0KvsWF9IjiXlotNnNJBOLMpLXFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NBC9tR/3Dqf8bA009nXJcR+hZXEXy6ULJfEaYg2Eg4=;
 b=VdV3UWwtHKNTwf7gJBC5uiL/jNWDy7LVZu6FOfJnVo+XzhoxaxwF709mbrFoGYVaowtKbhITZfuWdGZFS1/oOm0sF46MXz6ULN6975GBbXj1QzmYyKHVsKurRFqi66pGvJNYeazs9EuwtOfrku6KrzZWfg1d205E3mJSNPhTEEQ=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MW4PR10MB6347.namprd10.prod.outlook.com (2603:10b6:303:1eb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Sat, 3 Sep
 2022 12:25:07 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::f164:f811:6e47:b7cd]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::f164:f811:6e47:b7cd%2]) with mapi id 15.20.5566.021; Sat, 3 Sep 2022
 12:25:07 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.10] btrfs: harden identification of a stale device
Date:   Sat,  3 Sep 2022 17:54:54 +0530
Message-Id: <66d0d6e0fc0ec0f2892c48daa75e3bb56f09cb45.1662205330.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb2ff0ab-3603-47e6-06ba-08da8da755f0
X-MS-TrafficTypeDiagnostic: MW4PR10MB6347:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lE9nu/iwZpYpzGIYPQLvCQbWCmSblhQU7a0s2SeykiJ8TE3/URPm6OmsrvGhFEC1vUZ25c9q5OTQ/sNNMOkvfYRE099KxAqqEJzXOORDHsHe/A1rXAH8JMiYadMvxFHrxoiMwBiS9/QA4EREoo/AAJRFtTlFuhKL1sJUmJ/6BbcpzeZ5KFQML8fyhx8ahnuZ2jZ3IZG8rnS+PwWhDphoIhhza8AfzF08RDVhhgADslWT+Cxof1RQX2brJXCT2mKIgvXhgtVbeE0BFUxhOlQfBAcqOQYM36DIJv6a7/U4PyS7te8tGCZ/kjGNuxIP7QttntL1gW3FHujKy+Z6pMmaFbmzBiDCtif1eA+4O7XxE97F8DA1viQ+DQQDNPM/pgnh2FRXYfxAnLZe9xVDARdD0WJveqKrBpvoPx/LAgn9Vv1bBI4D+PRtVTcqFvTpaRk1yS/aKeX/jG20ZHijKr77Pvf/4QVd5Ff2b59YYoCHKYOt5TFUQAmbBpHru9mx4deA7NmrxrxdHNSOX4T9UnMnSupNB5AAftY69QjKjcFLB7cvOpVOIRcJ4Z3MknTLiudWF7g/+rQ1eoxjQvgBk8vewVZbftOV3Orsb06Jjeq9s1uf3aQFgYyVr9gFFxGIdm/ePLp9czXeYZ25MHjxS4+e4FNO0N38kgPNfUybGv+noX8jK+msQKW1fymyvltBodkJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(39860400002)(376002)(366004)(36756003)(66946007)(8676002)(66556008)(4326008)(44832011)(186003)(66476007)(5660300002)(2906002)(316002)(6916009)(8936002)(54906003)(478600001)(6486002)(6666004)(41300700001)(86362001)(2616005)(6506007)(6512007)(38100700002)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jYvhVknH/fUnl1pDZQN5GefGkWNPAqSsEbsqjdiaZ6HmIsocd25UneWL/4Nu?=
 =?us-ascii?Q?FnPY82YRic4/LaCXg4bFzmPeL47hOilGeLq44mMzShRW/ARZYO0SyG6NFI7H?=
 =?us-ascii?Q?imF4JVoOSB4a+UQHDaS0FGEBfUmdRNuEMC6fUNG+WQBPo8B64ob2O1EY+yxY?=
 =?us-ascii?Q?1i7H/aFqljM8+ClZJA/gjoAN4qGC8RluNYTePR1z1Y66bnUbIbVpgHfh+f86?=
 =?us-ascii?Q?9Za0C3OjJJXr8wDR/Wfz1wKDVLgDjJsx6bIF2S5SMoEkiQIXh3exUgcvVF7d?=
 =?us-ascii?Q?hJjYsj3TWNcFtToe3hsntP0NJ/RPRszYYulZl+WvReckMJUUTgB1yfZpZjXO?=
 =?us-ascii?Q?wsuFwLT4c/RUJX2bDCVZ6PGx3cgSIICgT5FKUPCjmFYgG83IVpptgqcrb/hm?=
 =?us-ascii?Q?O8/IbGyoh/WdyIrRMqn+X2imvTBIu0c+cZcfMX6LIqhQghXQLqSrZhVWh9PX?=
 =?us-ascii?Q?7FmUYAoRSLa10nl4gKr1aJvS8GMbUlTx/nkBvutQ525cZhKfcN/8Pteee70U?=
 =?us-ascii?Q?I2UnW56+SC2FBvEvW6kTq2mJ10ltMY+OcXogKe2ETKL1FAB/v5BJlLstEGzL?=
 =?us-ascii?Q?u2bD91t4jlUftF3//v79oIrKfkCPLki6zOeoTTaCjeeIKOvzU2ky3AFc4NKJ?=
 =?us-ascii?Q?Nlx4rQUQeSW1IQ9ZrAmczujbCweTQM9NdzbvwNuVDXn4s+t+/z1ivQSZxqsC?=
 =?us-ascii?Q?DiUCbJyFfEyPDNKQxqD6xahTsWRBs1vEpu+MePRepui2jR5osWpegVzmA/je?=
 =?us-ascii?Q?LO94SRqJ5Qeu0DRfkYXWzvJ5kBjQHJ+WmCymWEac/pxIq6lJRZnWMqYkVv4Y?=
 =?us-ascii?Q?/XNN755t1UD4NB5lEL7Dh0+AkFmfKUTT2ovMsERIoeXHruM16YLfnZbHVKlK?=
 =?us-ascii?Q?czdNPz+l7AynJE3e9MpHCrIA8AIOIlaR8Ha8s/UwvsI4TjrDCPL1O+2GxYzL?=
 =?us-ascii?Q?3z1i88ykENc6gJD5jeCwQVdm8LKCdWMVj1VLuDR2/n4IwIPrBErrnC1G+v8P?=
 =?us-ascii?Q?cF2IaVYNVAdbA9I4NiO/LyT4dAXMk29W4C8cBTNGXoMj9xVp9pkVKet10feM?=
 =?us-ascii?Q?iAotyv6XVg2umD7CpIEtQOYqz4VGo42Q/YL56b9LZBX5qU/rYZ7Id3bGNo3n?=
 =?us-ascii?Q?vv6i4WlC33OdVxpAg/VhP7VCx8a4XGEdskn0SctlP/9jtotohjRc7grrC3E3?=
 =?us-ascii?Q?IT5KrrhXA7KKumR6UX7QKBZfTI59WmT4pKCy20eq2aV7W4ENwBlG38wAKMEN?=
 =?us-ascii?Q?diPs4t2G8Z5T4MTPYiQr1wj6Q/ERfepRe3eB5VS8XDKIKvAsEX2c2jPXKnT8?=
 =?us-ascii?Q?6hUDSD9/1H4RxguRdm0c5Z2GvM/9iCF6lw+ABF85//e70Kq1jPCalRlaPB5B?=
 =?us-ascii?Q?eh6/7cmv0kixIy9+voTr5WfoptYBETC5mmlPR4zAtQR4gglQh/E4Qv32FOt0?=
 =?us-ascii?Q?pe+DukGhyRQDNeZJZI4jSMNFLj0t5MqbqyFO3Be9ZE3dLfXTLmJlyzsYzrcT?=
 =?us-ascii?Q?FOfgSw/fBLSrjdrg2FHN1rKbDvmUWkyMPrZGS2PJR25I8QizfL7tnonlCEbq?=
 =?us-ascii?Q?ww2qnGRHOydFtWyHA4zSpGznuV/Lli/vCZ9XOAyO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb2ff0ab-3603-47e6-06ba-08da8da755f0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2022 12:25:06.9685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2jIr7pVUgvtFBO8iJHNk/zOurvQ8aGNHZA++UEZgX71kMKJkYoBAw4QKfLfPJL08OrvtrWJevmVDTI6Vz9DVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-03_05,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209030063
X-Proofpoint-GUID: 4W9MewAhQjw7oRrM66OFUIyDZCF33Cfd
X-Proofpoint-ORIG-GUID: 4W9MewAhQjw7oRrM66OFUIyDZCF33Cfd
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

CC: stable@vger.kernel.org #5.10
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2fdf178aa76f..d4d89e0738ff 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -540,15 +540,47 @@ btrfs_get_bdev_and_sb(const char *device_path, fmode_t flags, void *holder,
 	return ret;
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
@@ -581,9 +613,7 @@ static int btrfs_free_stale_devices(const char *path,
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

