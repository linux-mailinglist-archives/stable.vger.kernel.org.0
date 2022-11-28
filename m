Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BCD63A612
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 11:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiK1K1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 05:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiK1K1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 05:27:54 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6471C75A
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 02:27:53 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASARCqO011334;
        Mon, 28 Nov 2022 02:27:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=liFzJPObeVghlBhu1USvpbthfp69+7Aswg75tm7EmyY=;
 b=MJ3YAVG3KcYk4HyhBT/sxYhOWkTKs/MOZRCfYz7rT93RJgoqY+/xT50kDKKf7J+hhqvu
 HtRQmoIIwViSVYB6RvetXiqaYG5UcyjzzoXNe/r+jwr3Gntw5W1gBWU0vfV6BO15G5mR
 bIrA/gTi3lA7vDalRxyI+0Z3yeZAN27sMJTg5WceIuUPjbPMlazQwHHQHeyJk9ca4RSQ
 LI+Pm1iz6ulgTZGS/cznR7YzQBtrHkuzWx37UgrMDvvYXheQ+Nbr8/gii0XwhRRhzK12
 FiSY6xAeG3B325r7clugBreOCKDWrlz4lvaVKuzrCHHbLhSYtgVswejiOUZ1G7ZOHtww ew== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3m3k6r95ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 02:27:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aX3VZ0rp7jwhmA+uPk4OaINOYGVQeg0FWqFOY4Fg1eCm4aWN1S+16Gx30Bt1BLH8nulk/R9F43zWGJax+PY8B5aYVVFCjRnxPCW+ubIQGbXurH5TAAfsJf+LbAOhndG0I1bLc5Su5gfRiNYhyfE/rOXC9T8I5X5fO+eorz3JipSXWc2krJWZrbQMfQ52FgwuH8mIBGPT4KN7zyGzwYs+BBl3fMvyJ4Di4Yy385c3a0+kO/+kCCobHiO01+cSM0LQvXe+/17FnyKrm4iKskH986SI6EwOJQBa2aOyYjF9nzADoWcLz9fWs/9Kofv4NgprNrgtVrdu8ASi1nTwQ0OAGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=liFzJPObeVghlBhu1USvpbthfp69+7Aswg75tm7EmyY=;
 b=CjjrmBYu1cbs2SNPUd2BbDhhvosLyS1Unr9wRzO8ptmMZgZQ8pwNnMOXGgsofjRqdVwIgilzImPHqYLZtmzmKxlFWKQy4VuZOeIp8Gk69ydPsQ6KSkZR0ICUft0oYU2PphtCt2RfG1DCzbRRDgRFckumMcughNoIfu56aNF9AsCXC+v0BsWk6e+nSD5fMMXj6JCfOQPqiM2qa12NetiiaNNFLOFrS/ug4iiUvphaXy5vQYuNqrAxFIxrwMJejjixdLnqonNEgxh/9pawm2fG34rnRKZUyOcovD7YMkgK0gntQhKUOCw2KmmrVkHIJUYi0yxqJhZYCJ9V11fWIa7Byw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 10:27:46 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99%7]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 10:27:46 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 1/1] nvme: restrict management ioctls to admin
Date:   Mon, 28 Nov 2022 12:27:26 +0200
Message-Id: <20221128102726.2593734-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0305.eurprd07.prod.outlook.com
 (2603:10a6:800:130::33) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|CO1PR11MB5154:EE_
X-MS-Office365-Filtering-Correlation-Id: 15dc2bde-142e-4833-4af7-08dad12b30c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ecaq60wBWoiA4K0gMUbpvL5InSWnQIuUJm6VFLHz3K56p8bIDlTNCd3kFrc4YK8E5inPl/bopQxsS4RX89M4aAXJ0Y+L38aR8IfZ8BQx7XXpAgM5PUFt2osO38ilx68ZMJxVmtN36/6NAQkFgu7Wdle7MK/NjvUjTxczE1AqAVF/ikOlL1gou8N6UFEGt8knzGyjaYgp7U3hCfIBP/qwlSyUOGnzjpx6/pEgtuJ1uUJlAlseRtFnT24aWrunwSxeEpGJM+7LvdY77Av+LpO2N+IK7h3aYnSkSFpNPNvqmP6wjy6i/fhGfkPPI891FkGBDRNDfJLtRDR/dhEGrgbZFjLohU7qnLji5yLqqUZnt59BcYp/3ykeExUS8Py6QfvmeqccaD49nAyUcmWqTaqjwdIdBTtaYdeM1D3X44R/HU0ZzWZ5guO/J/0lN8M6E+kfvH0L/e8uTc26ixwbtEUAfnaQUg0IOE43byNWKdIr5ZB4gdVANYVGng6Ugh8nRIwQhWgSvnhCDu02gcyuJMCtD4dO3W6NistySF7GEiHaWi6msqx71TiiqqbFp5sCgzuUTCP6YWROYFO6D2B/hWtMVQ8ElEj7wWnG0xQXKqaaNG6V3uWl5lcFTDC5/oafJ8OxIlnr4quKAiwpXoEcY76GnK+umUe19eIraB26+GUAYl6BbM1Fr/n4oXJF6AHO78ZojKJ79+eRl6k62xPuB5APUr64XCZ8QDRdbJRGaD5rS4bPUlJIb9BAqTYbTu0tWikd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(366004)(396003)(39850400004)(451199015)(38100700002)(83380400001)(54906003)(52116002)(6666004)(6512007)(107886003)(6506007)(6486002)(26005)(36756003)(86362001)(38350700002)(1076003)(2616005)(186003)(5660300002)(44832011)(8936002)(478600001)(6916009)(8676002)(66556008)(66476007)(66946007)(4326008)(41300700001)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TJ6bl5XSqNOEWXG2swP3aKUvM8W7pOazHPYJLAYdQTxr9ujgX3rsK1su2Eyp?=
 =?us-ascii?Q?n8HimZR1IBGuOM82hlPsVaCR+IBo17uS167IBHrozm9ybbXNoI21AC0HxYJb?=
 =?us-ascii?Q?1aTLTlz1yq6mF0CTLdqi4hWZMllPY/OjKfBieC5c2l2EvQakCKB8BhdEwDO2?=
 =?us-ascii?Q?0PQHgwOeTUGuaNIpM4KZ00srbj1zJA5kJJfGbS5s0oNmXaaM+pSPV94zvJiv?=
 =?us-ascii?Q?aiteg7bzpQd+rj9ICVAOfKeKZ59fZKXApfgpo+9bWKq/UECrSR/p2t7DZ9CI?=
 =?us-ascii?Q?zWQ+1B8j8l8S1/VncEnyZadX6XoW5gtGoLysovuIGK7wOdO5WsEQQy3op8nQ?=
 =?us-ascii?Q?09TlbTABnMgkuLg271X87A6KFWlpQeEcdoCFMip8kv1rIOyTqN9QjiuBG1pr?=
 =?us-ascii?Q?4JJpPcfiuu7ZvwajE0LtoJbiSwJHa147jCEebHEV5bVwATsrkPQbZnJ9r18M?=
 =?us-ascii?Q?RSkb4tjXE7twJOzKA689cpyaFdqOY6NR3yYENkBmj1iVWKKIJnipNxfVxWPc?=
 =?us-ascii?Q?w/09d6HalESnvuFB3ieg+PlMJnYW1rXtNzp//hK1NG8Dtd54AM4RkzLpbcXn?=
 =?us-ascii?Q?kVTnPGD5x2+17kmjicXuHqLJwEjG+LD2izlY3JkSTAMbO5hFuxuugQzGFcPS?=
 =?us-ascii?Q?s4hEFEUqo97F7COpXW4BggTJeNZv0bg93DtKsjJZvkO0r3KOsI693V2SO97+?=
 =?us-ascii?Q?QV+qR9p1liIx32n2LdO+R3Z+F/OV1suaal/LMJ/5P1D9tEALceG+SFSmuvfp?=
 =?us-ascii?Q?paPIz1Ymarq3BfaK9Wz/ktCEwt5zcnVQGiV0v2HXWtM5DOy43lyoKckSkmwN?=
 =?us-ascii?Q?+/4gpQhoqPjbQxzpSSx/AIlsHLJvh9QAZ7hthBA2oeaBQzHMrk7wNbGMv4Zs?=
 =?us-ascii?Q?NSFjrLrHAN51PnlbnhBoNK+Usw8k1tcT8FiofxdOUnOz5/3evrl+CKLAiqK9?=
 =?us-ascii?Q?sLkMadZ5us1oC7jsLiSBXs+Xukq3kPCPmuDpV2y6aqXiRdIgu3SRvhUAXhnA?=
 =?us-ascii?Q?nXZ/ecVCAt+oeBadN5nw2paCkNogBVSOroIAmczRanHkn6i16t7Bb06o/nVz?=
 =?us-ascii?Q?lMm5lDQc9CPjSYwpSnMQAEambMMLI5ExTwiq56W1UTu9XOc3LGJrmHcdd4Qt?=
 =?us-ascii?Q?ncbRwpiPd4SsxrETubKTsdxTyO6SUYheGvJXVlWL/NT/hVUUJx41uX8/VG/2?=
 =?us-ascii?Q?T8p7osUocMQfyBubO4scNgxqB+thm7J1iAuR1y2JLmdplMgXpGZKuhKLrvu0?=
 =?us-ascii?Q?ytYQvfgx3/oyvbx5uDboQPYZtYaodzY9rdIjh6em8tWArgrbnQdKYmphwJKW?=
 =?us-ascii?Q?FDL5ygWEwcatgIJ7HVjHZwoK7PgsISbOJrlQfU2a2Yaoyxe34YC4FzWRRcGS?=
 =?us-ascii?Q?jYxUs6DV7Ve0uwXg/DTFdPO08hlEiNF84rkAYHL/uIrs9/7W1Inf9yclIoYG?=
 =?us-ascii?Q?yMbxocMYBKPk9GbOzcKutTWfyqhSj0ONB1b0Ly3LWblY1pInkIzTGTUhSkAn?=
 =?us-ascii?Q?zlPRNZpFbjxZhXzIYkEkxHCepoHAb5Ye4pll8Zfo90mAPh7CyxWiyxuxJIpy?=
 =?us-ascii?Q?7uKjuRlPfddpLGC6wRFCaazjieHPORMoY/ealqppWjWKjms6iwSn9sURgHQN?=
 =?us-ascii?Q?vg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15dc2bde-142e-4833-4af7-08dad12b30c7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 10:27:46.0699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qB8wVPGPwz+dMn4ts4Lpd7IAzmpFI/4wmq14IfNE6C7QxKy3YAmhkGIZzDDZaEY9WjhyVHcVwHwYbTl0gqx71KuUOq+nFkcv5v1QXm+xdPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5154
X-Proofpoint-ORIG-GUID: 42IeWnJp9WqQf8qj6qzySbhxD7k5Y-S4
X-Proofpoint-GUID: 42IeWnJp9WqQf8qj6qzySbhxD7k5Y-S4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_07,2022-11-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280080
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
index 986912e680d8..f47f3b992161 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2675,11 +2675,17 @@ static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
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

