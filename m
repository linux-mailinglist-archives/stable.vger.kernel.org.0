Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0170263A645
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 11:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiK1KkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 05:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiK1KkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 05:40:00 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1009B2B4
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 02:40:00 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AS9da6b005155;
        Mon, 28 Nov 2022 02:39:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=qIlbiefebpuG7cyGZBQ7lQ5fXCCA7+m1oyk3QI5WrHs=;
 b=oBWt2HR1ZC4/y0vyIlgzLOEQm4DmnIDVvbkl8K721fUWdyr+8615WahQRU9Ym1X7hBDv
 rOudj2m11DDIq6vHgkRBoJQ/w2BHJJkJ+Z45ZJtjnlyVPoPv2be3ouEHnJAGcg6YZE8E
 RUD6wasgn0qD8xRrvynee8slNBzRUAgv5YHDvwY+IUuL1dg9dpFOCd1WTijKFVLrdvdO
 ANNsHwtR5i8nw1siDiDWZi1erKjiCo2e5RpWTXzi3uLYfJ+8VVQEVNCsNScjI877WHLV
 2WBeNlO8hHs60X1LmtIE2Kpqe2v4C0QhmOOEf6a/Fk7cLsBS/2ex3trCTa6yx3FiQAnX Qg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3m3k6r95p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 02:39:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GN8zXeybRNQhIMURcvX5+gW2yD1SJwH1w/Ozz+uEmixNriWqpE+rjeu7c/d44hzS8V0aHLjNdkATH/SysMfAchj/0UTNBnhqMkHyFPrvKRbLDhPgX0k9vcK3uAAJ4ySr8agnwy5tYpDhAB0Xol6iy2UgakVPgD+VFYu+MIeCgyo5VYnZfMsUsv+jWdIsKmjmU6YpT800W8N1rDhiWKz2446/7EzVPkkmDpYHze6iZGofCgHKzQ1eDoSDh3Cht8nyGgSQRbhsTOi58SfTLtzq0YpdTYcozeeLvp0PMdxKrV+6zArsxbqpV0FZiilrwa1K8m7DkqJNi2stz9M6ZtrPBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIlbiefebpuG7cyGZBQ7lQ5fXCCA7+m1oyk3QI5WrHs=;
 b=NQJI3UTDaSy2ezJNsvYlyuoHEjkZVNCUnXDpVblbot/u4qAfq0pgzknnK7KuxQu59SpQh57vCUkhTcFyko3cjIQMEyzx8wtkvOku4rWQfsijiXYoTM/Fl8RXawWWVGN2KMaQf9gU+t+T616+5PQ2xKKAluWZ4USSnICM8zVZxmUFBN/cCy7QrnMv4ZIYwpiN6mClofxeud4qI4OAqkrKNUzha2kjYZsIVIbnbETcBP6py62WnYjpHo4jWGjZrQkIP2Oj7o+lBlilkabILahwud2N5ufltxFpyBCceZpOoyBhAv2AFXveYXPULF0w4TBgNk0pp8Uyw8kDEVRDVRUr3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4676.namprd11.prod.outlook.com (2603:10b6:5:2a7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 10:39:51 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99%7]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 10:39:51 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 1/1] nvme: restrict management ioctls to admin
Date:   Mon, 28 Nov 2022 12:39:34 +0200
Message-Id: <20221128103934.2660595-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0045.eurprd07.prod.outlook.com
 (2603:10a6:800:90::31) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|DM6PR11MB4676:EE_
X-MS-Office365-Filtering-Correlation-Id: bbdf8744-b44a-4eea-0052-08dad12ce100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LVEQQVJrOMMdk3iIg1oIiBt95qlaeqlPH6FUKcDh3Umk9Hqy+5PUKYRDX3uDzRr4xbRHMsky48I9f+WxmDg57JiGO4itdEEcEvWIG0rmEiX9YfZgmROLSdKYZEuZ+bA4PWOkV+Tmkd8z65DObm7wOhhZLuY4sn/l2ImOtUVze7EMvVY/nDZsi491bw8HvBD+eeBJL4VJQDiKKP2RTbMOpYUmgY1xev8A3kHHZompOdHg9++FjOT8IxPKtRYHSK2e43KEiCYPD6+qweLvDg3tBdh70s/49DAHFZHMqYY1xQB6dwul2Cau+0ygRLAd5Uz5GeMTZ/AfQIivJ7JeAu5MzfBfoqExSVfrJ7P4Or8x8195XUgkAmAXaieKiqSIpoO8/wCJTpH/aZHaMTdbNZsFP3hIJNKG2aXRUZy994Iq+VUevO5RvY0qRpnw7G6E6ilAfqOgHAIcKtdigp7xWbFMRzALHIYfqoL9gghWNZErFBrcXPTN4GhdyAAR58r3XUBt5STyzFERp7/WMlrOFnC3IB7Jm+JMOuj4lwuRxxzWA4c/2wDEO1sfm/VN13C/dqX4RRXUoYS/Hpu2Xo4VyqOloqHQCjoIb2IlKRKsuWrtfW629XnmjPP9bbbiq5pHmWj0TM98llOturLGvLx649sY9pCpGs/Li0sKD5CKkQ7F/QmQbxBs75BDFynsesEAzUZ+Ftkqf70fFkFcQWzbvWukNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39840400004)(136003)(451199015)(8936002)(5660300002)(186003)(8676002)(66556008)(66946007)(41300700001)(4326008)(66476007)(36756003)(6916009)(54906003)(316002)(38100700002)(38350700002)(83380400001)(478600001)(107886003)(6666004)(6486002)(2616005)(26005)(86362001)(6512007)(1076003)(52116002)(6506007)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/lySIMLIVFl80dKW2yqHtTDC6mVqYnTwzuqIN7kZGOBMIFIw3BKBjSH0LEHZ?=
 =?us-ascii?Q?gHkClc1PoxVbYZI3RINK/KGAdft0RrQUEvmlc0uYMOBM1eeucTOvC8/byN75?=
 =?us-ascii?Q?WPt8yTEJqzpgpt+j/yr2B05pKkBvsosVRrMJiIEnnh+pCXTJ7cYEfztSmEUk?=
 =?us-ascii?Q?8585ZIrdSL/ZdSHALBbC4qC6dhGwFe2K1GUfSLGfh107pWT+hn9CG6KRnOjK?=
 =?us-ascii?Q?JyrMXbuLQrNSp/Tt008B4sZhqacQADI0Qq+I8dc8JxSPgT3u60xU0xQLPfaq?=
 =?us-ascii?Q?aB1xCuBJMi133wWUeMUexIPk2ellbRO8ttAZbxt4e71Vk8QJkzYYUGk7ErCV?=
 =?us-ascii?Q?NlFSamT5NIGcBidc1K0nXOZjPUxAPzZHSUMXNMm6OS2sTGm6WAyi9+NUrqiN?=
 =?us-ascii?Q?EJEZnBK+xQrO7QUDy/Twh++yM/knD/hS5oOrLVAVhHIOfbx01XQF4o/sD8cW?=
 =?us-ascii?Q?FMm91H7I6DdXWgHAerYySx1alI8xkodbG5l9ILrU0hDXpKDVgK2yzjtTokae?=
 =?us-ascii?Q?+lNzjkuqGrY+OoE6TLqUVlaubj80iDcsQp6L1aHV1TugEEEEDu888MEtH+KX?=
 =?us-ascii?Q?L74TwNeX4lL+YvrZgzQ6b2m7YbJft0+1hig0TRT/p3kkStQ9zAUr/ME8tFtE?=
 =?us-ascii?Q?xnL+E7BNiQ6BT+8VE87J0mcvk/MsUDJHvk4D4F92qYnkt0OPL/oJ0I3JdZ9f?=
 =?us-ascii?Q?QjuBpisCxtThecG5ki9tGIckjp/DMdaK/7WP5+TX7ynedJTqNPvNBPB0Pu96?=
 =?us-ascii?Q?jIFCCKhQP/7lmvff9rS0OFBQgUfAMmXYV7e0hUTvK/uu5nic73NSaoxp5HZM?=
 =?us-ascii?Q?Eyg9NvJ2cP0bcNk+xChRURuIrGY+0y+wiKYBmW3YThzSrN4FNRleaWZIiisr?=
 =?us-ascii?Q?WEBEyU52qet5Bgl8quNzHnX7bpvITTl1VdCHS0KclYhaA19BfdOlK9C1zRux?=
 =?us-ascii?Q?0vhi7l72W4mP+vrXKUL1eXopFqfUwE215+LBlNSQ21XcayHTw0peODMZBl4P?=
 =?us-ascii?Q?AHftUmhFtMLQw5MK0gO2RSFPEfQEogQH7Nww5JtXNYuxB7AnPlR78/PqgnNA?=
 =?us-ascii?Q?lxFHxSTyTcXIc7l6iLCl1WkXDUJajrWCqvFp4w7HTDzEtxVn6QNASUoecmAS?=
 =?us-ascii?Q?M7z0VYrojlK4qsRlclNkrl8D/lGje0CadkB4SNYpT54oVWZfFo0oqqXzPJhf?=
 =?us-ascii?Q?GPurSURKYVTkQSUqEBNNz5QkQzmcY7IYZ1B/hZ8FGI7DgJBCPdRJLHGhXrg2?=
 =?us-ascii?Q?iULRdTRIoJMM00I3j1W5N7hjdPBt+ukAoeNvU/zsCxFkR/KNfT5vf0jtrLzH?=
 =?us-ascii?Q?nBQcKJV6rlUMrfC3uB0rlw8cq2F3a236xY7Urun5pMwuLXmNnvO597JSjUcQ?=
 =?us-ascii?Q?hjPc2OCEqSDJxdEosigeHkwkzVvLci7KgHaDMWRzG34BW7tq47J1MqMablPY?=
 =?us-ascii?Q?+iEI6mlfGe7tpIAYGdh5S+iG95uqR4mLj63YMSzq9h7s0wtgPzj+DSBRx4uj?=
 =?us-ascii?Q?lkodmBIV6jKuyCstf2PrkkyhmbOwrFE+nW1zC12PwEixSBgrp2AEWWxKwg8n?=
 =?us-ascii?Q?LrVzj80XWnmythg8aIQeSTdmftYLUcHePQHi2OuBtM/t4YS1YEKjm+sphQQh?=
 =?us-ascii?Q?YA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbdf8744-b44a-4eea-0052-08dad12ce100
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 10:39:51.5454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wHuKXX+FRpFWtU/SrgzDaDyMXsg5zSOtya2l8k7cHYg4+loaNYHOkqSS0tR1e1tSwIVpeXGABRf7kADBGImATebs2JpGpZL0jvEkbu87LUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4676
X-Proofpoint-ORIG-GUID: Y-OEd_kEGxjsYLbruDFHb25l797zVoUt
X-Proofpoint-GUID: Y-OEd_kEGxjsYLbruDFHb25l797zVoUt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_07,2022-11-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

commit 23e085b2dead13b51fe86d27069895b740f749c0 upstream.

The passthrough commands already have this restriction, but the other
operations do not. Require the same capabilities for all users as all of
these operations, which include resets and rescans, can be disruptive.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
This backport is for CVE-2022-3169.

 drivers/nvme/host/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8e136867180a..b018e7236629 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2022,11 +2022,17 @@ static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 	case NVME_IOCTL_IO_CMD:
 		return nvme_dev_user_cmd(ctrl, argp);
 	case NVME_IOCTL_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		dev_warn(ctrl->device, "resetting controller\n");
 		return nvme_reset_ctrl_sync(ctrl);
 	case NVME_IOCTL_SUBSYS_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		return nvme_reset_subsystem(ctrl);
 	case NVME_IOCTL_RESCAN:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		nvme_queue_scan(ctrl);
 		return 0;
 	default:
-- 
2.38.1

