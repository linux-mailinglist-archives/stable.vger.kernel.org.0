Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABE5633A0A
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 11:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbiKVK0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 05:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbiKVK0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 05:26:01 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624BE5A6CE
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 02:23:27 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMAMrJF012379;
        Tue, 22 Nov 2022 10:23:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=iOH6KMJlHPMtEEGX2rEVf2WTwTkjWTV0exswkYDwHOs=;
 b=rNyjXJFMjzHodeQqS+zHiGRC99ek8OcXZoOXUTIYToho6poWXUk1SmfPH0p/ZINh6m5z
 hvh8ZaVDlZJ86G50CZ3gy3XiBzC2kW7oDsApzNBh9+3fOtfu150T9SW+uX7e5XFRbl7v
 79FzeR+lBulJRq/Z8J63w3xEHZkL/PYAJLKVkycStQmd/eGri2kiXzMpjMN1ItO+akI5
 3ezRqQNcTeATA9g5IvfQ9x1r23eGFcnN1vnjOg2QucZpfgEoMGAvf/lIC94P5Qzqn2l4
 /gotvhT/u3cVD6s9G4QUiALMritRjyE3NV4AEFIXOLEXCplGBaCaC5BW8VFAxZ3luuCR vQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kxp48je4n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 10:23:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZAisJ1emkkpdxsXtxhYhujDFj0jOnOJwYHD61S5gV94lOUvkyCdhS/kThsz93oJpyT/E+eukJyd0pFaP3HJKuNgQosyTA/4lYdYbPmRGssCU4MfmL3+gWqmAp808P40A4hcT6RFRByBx395YUwm0AThDLZnkX1uBOGHvJSrz2rS3GtETNC+dIvg8cq3YEATqEHlFNzTNwb/XyF7bYCcjk2l84agX+NtB8N8RM4GCHTc6c6LtVqjXpL+Nk/o9+6uwaMVAZWuB3H+m/nY41HuLuYxFyuH7PuVk0n1yZ7IrFgAzwUIlPtsPGXqxEjhgTAiJItCVkkT8ZPTcywqv3C28Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iOH6KMJlHPMtEEGX2rEVf2WTwTkjWTV0exswkYDwHOs=;
 b=esTbKCQlHD/tA1k/LvzCG9L3CB2IJDdbmEHz2dX6xVdOoZlwu3o5URAA8KHPSmCqi+A5Tz+1PePwRl62og/llqHukOsH1MqX64qa8182mdiaEGLubxBuLNh+JgjFJuXTrysKKcl3umkuPO2HZ0FdNFW9KTwH5oSCNBh/UhP856rKLTqWZVS0cDuz5GpkxLtS9vREuYj0UJjO/5xGaz6clxFeO23r9quJTCVLsbrcJm7RrvEjjdlhATcXfdwPKrzK+P6wFmoWvpqGbF9v4itkLaH4mEOaaIn4z2+DQx7KmJS9X1WUE/RopoeOX+0LFEJYl8xXhxUXUN3SqVQcMMRzSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA3PR11MB7464.namprd11.prod.outlook.com (2603:10b6:806:31b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 10:23:13 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 10:23:12 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 2/2] nvme: ensure subsystem reset is single threaded
Date:   Tue, 22 Nov 2022 12:22:45 +0200
Message-Id: <20221122102245.3397604-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122102245.3397604-1-ovidiu.panait@windriver.com>
References: <20221122102245.3397604-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0005.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::15) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SA3PR11MB7464:EE_
X-MS-Office365-Filtering-Correlation-Id: 8427cb21-3355-40b2-95d8-08dacc738f86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KQZ/1H3UFeVM+nf1ZevenfUzadNvYD6qT7xCIHukLgO+MTsicNMekwyygEazsYrRxHZSHHayO7va6Y9A6bz/u4FrvHRuknBPRnCaGLfQ304Bd3dMiHRY0OMDNR0hp+rlaMU6GwWgSRskj+H2TFzGTKS/sgHpavC96CJ584rcTs2uDtTMtjtLFZ+MeNvGwS5owD/sy4Z+Q0yckx9qUwBsiNtXTxOsYxqz3FWzd2wTOgFHHS8thsjIv2ldBf5xmkHMQ4nETmKEX6nDNcyx0hKwG81o3vbhA8IS89hRpjT1p0jcRfXb7Z2+/r+o+P1T7fg7Bex3ZaB/Knnv6hQk+ypXXfORumIm0+41oGpLn85GRetKgt7LNVrya+TyaHiiI5+38C/bx2b0i3p0fDMHn0S00eQhuIwHkumUlX/DF8t8i10je8JJ+qATDCslHdYcNsPogyYcV6NEvyS3w3z8VitqbRXrxPCLKAEwYWxxAcm6JUiglfJqQ4kezGt0Rte0gNi8B1RlpQVqPzRZmGC/1ddeorvHLUzgkfcbEmqJrR4geiT06aOZubteirluE7nzWpqj067hCCaRjQh1xPZ6rG/+fPZHbmfBvXxQg1uuXG6YUY6amAhATM9cYd9x7t8ypxaQZDFJjTdHt9XpQkjGheONoov3E2r3a1JOXbBDORfY/4jmGeQXUaxrts9shF0/k0ZvNum8HS/sNl5mPKiikzvncUCvDNE2G9KsvdBhehhUgH8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39850400004)(366004)(346002)(136003)(376002)(451199015)(2616005)(2906002)(1076003)(186003)(4326008)(478600001)(6666004)(66556008)(26005)(66946007)(6512007)(6506007)(5660300002)(316002)(66476007)(38100700002)(107886003)(8676002)(6916009)(36756003)(52116002)(8936002)(83380400001)(44832011)(6486002)(966005)(38350700002)(86362001)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KeFATHXM39lXbF1QOe9OETh/+tqXNHfuyspKrBT0tI4IzZCmcLAGI4zSbE9n?=
 =?us-ascii?Q?u+G/y79S5JFacnRhnbKZNR0lSa2GOC1DtgvJvis9c2p9URZxBfByQC1/hKgZ?=
 =?us-ascii?Q?j11sWs3ILdUOGREcSb+Ed76uZHgrpjvZRbbvAt9DYnS7k4Fuz9TrvWpu5Vzv?=
 =?us-ascii?Q?Zz02XV3et7wuvwKvPuo+SN/VvXz6xZQeQKW9A+tndvgmtLuMr8uasu3CFqN0?=
 =?us-ascii?Q?NVqQ+01ITJI+CCITlGVkaZuVTaC9BZo3gDwu7Pjvf6D8oYEf00wWrksY8XUS?=
 =?us-ascii?Q?YAXKsodzKu1FNLgPQ6rge4vZX3yQMlWLMRW+d75GesZeXARXpz4IYgXXmjt9?=
 =?us-ascii?Q?cE9H2rde1dWkOJOvomHV3TsF/v7TyIFEE5vwO3ivHmtWaQ5pqvs3rc0GnOwm?=
 =?us-ascii?Q?TfAEJmzGRBOwOvv/Hzf4/XyixBIRghvdpUHg7LYZfA/vDLZIg1vaTEe31mC2?=
 =?us-ascii?Q?ibjmNTWqJcY2cZlPzi4qz/8Au+TAuCN3uB9QdkGNOrmVqzwA4P8a8sL972LO?=
 =?us-ascii?Q?HO9+0i2v92/pbfnpOmyPHrabH90E8usY72gY3XmiImeWHlIsKv5IycH5my4o?=
 =?us-ascii?Q?TD9BAR1RleF3dBP+VvT3OYiyvCUMw6ymHhylQNz0eo7VN2AvsHAoda7T86iB?=
 =?us-ascii?Q?Wdw5QsOJM2tTJamLw2IOQq+gsQa5DxU8WB8kxrXKJp00a5AySA+p6mzwXHjR?=
 =?us-ascii?Q?27zenFZ/gj/As4X8WFrfIaUMSmstsnYrQJEO4TffI7VR0eOrwQwxo6GvOTVC?=
 =?us-ascii?Q?bEWFu8iXqth9P9ieBfMHQ2rQUobdpVFeCVq4FSlwVhp3kfLvZr9kmdTPcq1J?=
 =?us-ascii?Q?YwPA3syj+39H7/XmJCRprAbmhoRAefQRleSY8v0p+DZ0JoCDzKDwgIrTcjwb?=
 =?us-ascii?Q?2uyZizg+6dHAjOkdsCRLieqLpWYVz+jwZhnVNWSyeusUIYFsZqkrJkj5DqmM?=
 =?us-ascii?Q?TQurmOJTX0fZ3USdH4t3sKYDG8A1bFdMinu94y+IHN+OfJfELPgmJ/Fkq8X9?=
 =?us-ascii?Q?U3XuhU2xZ4gfbh5aq/xevvz9HyAcAe9Co21b2Oui6cuQ/5rFMf6K1LQy6nd+?=
 =?us-ascii?Q?RnZPWhc45P2LbZKJ8w6CSKjFF1tP78KnYU0jioRY3CT89j017Dzf41yLIjM6?=
 =?us-ascii?Q?2ToyujUAq+nVe9hQrmI/gnXGhyBViR0aE+gZcznpSOEMgDq//l2ubQ8Ifztf?=
 =?us-ascii?Q?11l984nwxHRc/Eb9ehxlluqrv1NTRNeWUCtmp0tHZlL2wHoAyyu8XeddQQ/h?=
 =?us-ascii?Q?aw6EXlcSxKw/s8ljVvJn1zaW+j9XgDVHdSiraAhXXSFuCEMuTYZ4mmUaZoYi?=
 =?us-ascii?Q?Di8TrLjxHWZ3DHNaX+Xj8/Xp2ZimVC+8mQp36ZhgaSqUyklYBSZA+rm6dj6M?=
 =?us-ascii?Q?BsG+LvyhCUTUgRibUbBqBJ4qhWtLr0INKDzG1pNNkMEGIZZ/O7D+GvN8S92m?=
 =?us-ascii?Q?twhyWk1UQ/iom2hAejaF3KmVe9H/SVEZ8i1YTBDdETDzpUNIXMFKnGO35yDY?=
 =?us-ascii?Q?Dp2R1wQTNVqLVmM4Vna7vGZl0QVqJo0uJ7o+ldsEpBPtV/j11HeJF6m7oZ/q?=
 =?us-ascii?Q?lozbh7Z0BtQuK17YbZjxHExfpscmVIhwj8C6+bi6V4Ai9RaDpfrSWLtH8Wxn?=
 =?us-ascii?Q?CA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8427cb21-3355-40b2-95d8-08dacc738f86
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 10:23:12.9176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FqGUZJKiUdMUVkyXX5fLIcW7ZtQtDR2D9PNiAXTbcGaNBr2uXKUJxTp+yvLwHYQY6mgXxhL1LPjjvwgUu7J8xxK3xm2y101geIvFFjqTkyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7464
X-Proofpoint-GUID: G_mIyTOwB15ZpONtWBB7g3NScIBb2KnA
X-Proofpoint-ORIG-GUID: G_mIyTOwB15ZpONtWBB7g3NScIBb2KnA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220075
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

commit 1e866afd4bcdd01a70a5eddb4371158d3035ce03 upstream.

The subsystem reset writes to a register, so we have to ensure the
device state is capable of handling that otherwise the driver may access
unmapped registers. Use the state machine to ensure the subsystem reset
doesn't try to write registers on a device already undergoing this type
of reset.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=214771
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/nvme/host/nvme.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index abae7ef2ac51..86336496c65c 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -544,11 +544,23 @@ static inline void nvme_fault_inject_fini(struct nvme_fault_inject *fault_inj)
 static inline void nvme_should_fail(struct request *req) {}
 #endif
 
+bool nvme_wait_reset(struct nvme_ctrl *ctrl);
+int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
+
 static inline int nvme_reset_subsystem(struct nvme_ctrl *ctrl)
 {
+	int ret;
+
 	if (!ctrl->subsystem)
 		return -ENOTTY;
-	return ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (!nvme_wait_reset(ctrl))
+		return -EBUSY;
+
+	ret = ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (ret)
+		return ret;
+
+	return nvme_try_sched_reset(ctrl);
 }
 
 /*
@@ -635,7 +647,6 @@ void nvme_cancel_tagset(struct nvme_ctrl *ctrl);
 void nvme_cancel_admin_tagset(struct nvme_ctrl *ctrl);
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		enum nvme_ctrl_state new_state);
-bool nvme_wait_reset(struct nvme_ctrl *ctrl);
 int nvme_disable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_enable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_shutdown_ctrl(struct nvme_ctrl *ctrl);
@@ -688,7 +699,6 @@ int nvme_set_queue_count(struct nvme_ctrl *ctrl, int *count);
 void nvme_stop_keep_alive(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl_sync(struct nvme_ctrl *ctrl);
-int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
 int nvme_delete_ctrl(struct nvme_ctrl *ctrl);
 
 int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
-- 
2.38.1

