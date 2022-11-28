Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2688963A586
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 10:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiK1J7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 04:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiK1J7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 04:59:19 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67084193F8
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 01:59:17 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AS9q8gY009834;
        Mon, 28 Nov 2022 01:59:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=S1LIxyz84dE2AlqcSF79rjHack4c244S2CSVAIO2wAQ=;
 b=IrVfy7uPBwu/FdJ0pzZLMLrOP0J3dYY2U99Vop0SnTc6kdCzvAaeOer+hJzNv//0+17t
 vPclJXLvwTfrIMH0hjJ7Aoracb2DSMJdKYTjT7ji1Nkg8cGlAT8uZUYnSa9+XuVyFfz1
 nnp93X7UPHl/E4sRsHNfzHnOVShFdumWHeYv+Vj+sVCiycpvF1F0eeGiALgsb2B+DfyM
 d1lzSnQsqYzHE9Mhv/LvL5OHcqs8oc7sE0GUCqfj/ZkOrv8b3AFTkfK2gwh0kzI5BrvA
 BYTXkrO3lU9nVwuAWl/UeUIf4tMEfOH2f02JaIEA2qiE3OUBVMz/EAk7zl7NWIq3BZrs 8g== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3m3ey918g6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 01:59:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rw2PeViJyDZGKxPQ4Y+/PZN1+mNvyPZ2rJJE5Zt2AJUq2Bh6+F6y0qye2uQn0jyQtKc6PODylRMtpfUy3MkG3XsCN+Gg7gPangKPB6sm4sTpwPsddi/sdVm8Fy10F8fimF59DLjNcFd476aV4chrsg2mcgVsWwP27QmR961lV5bBAKnMK3A1auVxtBCUwohjTOsCIJo9Jeo5wNPccW6RuRqUBrp0D+D7pjzhMC0IQ5KQDAqShHmvtI3jMRVJIUWivwWcrxTH9RFEHgTPZ4fTTnv94uxQCpcKd1n4k/gAC+vQl6+pt6+ItsG/3iGk5aidaYwFRXuC73aWww+qBUCQ2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S1LIxyz84dE2AlqcSF79rjHack4c244S2CSVAIO2wAQ=;
 b=fIIvNUNDxxYLXLdUddLVKrB7q24DxCFTtiRfk5WI+E1n+g6eareT/IGTWYtbKbs1RQ22mItFj36JEXWnD4phcKUTsMRDOBhqPhuAQnw6+gUlWT8g4bkMAC9YzM9lPxZCoBPV9WPBtg5cGKWCv1L7ZgKLUPlWwWcKhOEYKQbzWa4iCVnW/oZ8pnADeAEKrp1L3UJLnS4Itrv5gXE4KyFuzbBnnlzkn3I5nEkT5XcCc4WUQx3wLIEqwjmvrHCviml1jo/ys8wkldpPyHbecFCm0YPCTgNeJiqCaNuSLMZmQtDpXATmkoilxBxn+78sBHVzGl3e9ESsVxpsijU2gYhJTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BL1PR11MB5368.namprd11.prod.outlook.com (2603:10b6:208:311::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 09:59:09 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99%7]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 09:59:09 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 2/2] nvme: ensure subsystem reset is single threaded
Date:   Mon, 28 Nov 2022 11:58:47 +0200
Message-Id: <20221128095847.2555579-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221128095847.2555579-1-ovidiu.panait@windriver.com>
References: <20221128095847.2555579-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0187.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|BL1PR11MB5368:EE_
X-MS-Office365-Filtering-Correlation-Id: f8c6559b-4eef-4252-1a6b-08dad1273168
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i57hGB6r+Ga9H52a29ceNGDa9nAAiRz8nVvws9lhISNvgTtZ8U1cIwtsxXXu2wlsCityIfdjqXdUT/8oLPPt/VmGd4XpUpOKaDIRIfqUvwFeNlXdIrT6W7Y6qRi7ruL/fbr5bH1eXfJ69/Umj+j1EKgl8YFxzphfig552fXZfQIPhaF8RgOGS2gxOrrZiBFQ1fYjSzyurVyCrs7M246GZs2FEZP1uAigXMnIfJ07qk5f8MzhRsJP/BWSiJGEN8RaWfvfsZ61UT1PdwL/yVWph0032VCwUCj4NULm6ByIVVwJ2uC/c8tdZxCX9WmRHXIMhBpemfKS7dE8ByFonmtUgUmmy719e3+ghHJeGTMyZSaZwnG2SdOoO4yda5dbdVqD7l4eYw0/WqcXIqOzUaDfa4CcHVucABDJk+NBOsK+OKB8yyAlF2Uuc7XEs8untfzIMlRHU0beeE7yGLraLSzIuf9eF6d1+yZabH6XJgY/fwYuxYw/INlcN42kXnoOp/zJBsJUJII3+FRWUxLnL+KnurM35ZvlL2ddyNCHwicyGnW6c/8GbYGfxkQ3dv7bmFPpT7t5wZO+WobIkUzHptIwi+pRRELc6y7LxrMuwaaEYY7jB/UaGMNQZSySfPE29Ts2ganmpjmAaRqjFTnNOPOlzXnMpEbrixEdvZ7vyi4PU/WgAgnDRjO7/jdqWyzfUtkGyPXYdBouwrMAyIpxtZy3iDNO/X1kbtOz909DC2k6bEc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39850400004)(396003)(346002)(136003)(376002)(451199015)(8936002)(2906002)(83380400001)(41300700001)(2616005)(6512007)(26005)(66946007)(44832011)(52116002)(5660300002)(6666004)(107886003)(6506007)(36756003)(66556008)(66476007)(86362001)(186003)(4326008)(8676002)(1076003)(316002)(38100700002)(38350700002)(966005)(478600001)(6486002)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DVboEAaUHk0S8tAD3IOqZzHflk8bWH7/26Va4EOm/MFXHELtWCX6wWfmM2yI?=
 =?us-ascii?Q?630BIg7qDttgbwra13QMOHRA6wCMScrBPy/43C/GcEldWQJjBH4gJMfJvUdW?=
 =?us-ascii?Q?lWMTfQvxMAyrAdR36tNqVkXnRapwaA+8iPWZFfmzXjXV//8szXJhSTwlRbNO?=
 =?us-ascii?Q?QDAs519t+lhNVj3ibIOtUGtWIn+SmDWi1uz9dhbH7aPL5NeouyZcXgG7UrRq?=
 =?us-ascii?Q?11Rij6x+OBzrT9xSRaMM7Q2Qd8umVYt5q9YbwL7v6oejxK1FfatAd8pMNK38?=
 =?us-ascii?Q?/lK/JB8s/bx3L//KxTc+p8Q7yCGrh9PjC71NVAy5kCMgLf0Q7xxSE43GsdFr?=
 =?us-ascii?Q?iFW5KHw9cQp28TfbobPcYQDsOgdrb/HFHgT/H05rDAMBGc7uTj5I4Ae5pePJ?=
 =?us-ascii?Q?AKIcJcGpWDF+KTTZrwIvHkJbnChRjO+sepvrTi/gU4KE3Z2YcL/ywGrdAnaz?=
 =?us-ascii?Q?dZwkIaaei5YU7BXEbkjZAhIYHfGLvlv4sU0Zs3m47ZvX8UU3KXkwUbyvY9a0?=
 =?us-ascii?Q?/QBkDYOVlobjMQcZatJImfcat+SI5btuGkb7XFlMxAA8dnSdkvt7sdc0t27F?=
 =?us-ascii?Q?iV+SQKJLjpR/wC/nPo5xJEao+EXbo9YKZSbxkuObILbrARG7CH2gnjJaO2oM?=
 =?us-ascii?Q?Cvt0rXfXXSvSCjj3mMgVeM8oRYbd+CPXZ87WJyt3RXO8cnxOOhyJjDM9CJ+b?=
 =?us-ascii?Q?o88OXsL7T+1OdQ0h+MXn3Jqdgihnu+5oDef1NSRo7IT2BZEGKvmD1pTqwnCy?=
 =?us-ascii?Q?+TkdUAMCd50ekcPvRDge9FN10aaX9JOrKeozcZVyq9lPh96mYuxFrWSHKjgi?=
 =?us-ascii?Q?5GAUtAxyhWZkIrP5Ua8GtbecUFFo9dkWWsbo6wVZJ55W3VOstfF82jhKzD1L?=
 =?us-ascii?Q?70J/biBC3Pho12MUf2cvfjIFPC6naF1kMNQ9yDOlsAgNnAjFpJDT4Ss0/HpI?=
 =?us-ascii?Q?lkiywHTKTcSurekngDZWanJE2U0VmTWSw+hcgHoTPYoY9MpkQmykgkMgHq02?=
 =?us-ascii?Q?U74b5GNutvw05BrMRzy0fcHaqRXFyu2srr8d6rP2d248mAL3GHJ3tDyAKiUV?=
 =?us-ascii?Q?D+TiN7x1PTN46VPsEk8zpTaOdVTqfDehcLzyRxR6frUqtaCY//Yr3uIeldTT?=
 =?us-ascii?Q?naycPB0r2M70YInFt/a19Wc0ywHa19LVZQNdkdpSOB3eO6nB8oTy4FpMrf8F?=
 =?us-ascii?Q?h+k880os/u4kZUrI24gHvudb91jlK/ixk2dOwAu9/6OgL9jcGrqmFHgwn5nQ?=
 =?us-ascii?Q?z2kECCzU1j1jeT8VC41NfrZPbiB1uBgnH5T+3/z9DcCD9yS8YsY+M9fx7qkw?=
 =?us-ascii?Q?i3+m6Jx5xlu+m/64BMKy1rgBMXoWAkEpRQIFGZST7ATuMZxFuzCRRGE63rCP?=
 =?us-ascii?Q?suwtM/PENFoFzAjDn2sIC8lzxExtYFrZSZ8pQdKMDjMb35nu5bpal0JowbBi?=
 =?us-ascii?Q?l21VYn4Uvl54/Cj9zlmzhaXoBbDuXMHxbbyst7eMtYtW+crQprmBNjPAW4qj?=
 =?us-ascii?Q?8EmHcHkA8pN2U5NDf5XIxqSI70wKWZz0L/5Bkjad+HKdXKayWbk9Yx6sWEay?=
 =?us-ascii?Q?JHfYiINPhAN0iD/2TqQoiMZ8Lm/vJnzXUBLtKWFMvpJ3XbAoSKA1Ml87u4Qv?=
 =?us-ascii?Q?fQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c6559b-4eef-4252-1a6b-08dad1273168
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 09:59:09.0900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3wI3dG6VFGBkI3kwMx0zuGHf0awOtouULz8QszAIcoY+NdI9i07414MyKhtiR99+RMEmQ++yMqq7r5We0o0lt3s4JEgmbdwrzJccXDYzwTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5368
X-Proofpoint-GUID: gCHPOazdJRu-92UKjlM3_g4RvjivMx1K
X-Proofpoint-ORIG-GUID: gCHPOazdJRu-92UKjlM3_g4RvjivMx1K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_07,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=971 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211280077
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
index 81a5b968253f..17c0d6ae3eee 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -422,11 +422,23 @@ static inline void nvme_fault_inject_fini(struct nvme_fault_inject *fault_inj)
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
@@ -473,7 +485,6 @@ void nvme_cancel_tagset(struct nvme_ctrl *ctrl);
 void nvme_cancel_admin_tagset(struct nvme_ctrl *ctrl);
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		enum nvme_ctrl_state new_state);
-bool nvme_wait_reset(struct nvme_ctrl *ctrl);
 int nvme_disable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_enable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_shutdown_ctrl(struct nvme_ctrl *ctrl);
@@ -525,7 +536,6 @@ int nvme_set_queue_count(struct nvme_ctrl *ctrl, int *count);
 void nvme_stop_keep_alive(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl_sync(struct nvme_ctrl *ctrl);
-int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
 int nvme_delete_ctrl(struct nvme_ctrl *ctrl);
 
 int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp,
-- 
2.38.1

