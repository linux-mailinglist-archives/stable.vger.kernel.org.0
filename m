Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4032633AC3
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 12:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbiKVLIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 06:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbiKVLIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 06:08:40 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC4F2CCAC
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 03:08:38 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMAhXLl001020;
        Tue, 22 Nov 2022 03:08:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=U5v20tWnAYIZ0a84O/4/2Ippa0uxTTsHsCw7ItvrwIo=;
 b=NQVwMkAz6YL1ize2xI/UGNFmTdF6IMpBEvDPG6wuqgOHeR1njg1xWb1dNTHZ13GDpWck
 GpataIFkGUh20ZM36uk7NzCGcfdhih2bty0Ej98icg2lqhHrMDcI+GeYAdWtqGKQXDqz
 /LLjOyrO3Y/BSQbmBMmP1GTkDaC/Jk/G38S8pDGGJx63oQI+WogxEqVHOKQVezYyDaz6
 7XlTNLkORtjVhCBmLj/lqeRSNYHTOiTbffG1ztqX9ObSUpzqt9VmiZVrcsJruC2zwGdH
 hFPB2umceDvT+A0XBkGgKxZwd6w9iBp4T+a8x7+1F1cRihsqwMsrxGDtIPtNJ67fpRz6 sQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kxyhqa7ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 03:08:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ci5D9MNKpfAydgnX8UND/m8cwU0T1R5czkexP5VgSIl1q0zDUVnfFJDxwGu/5c/mEPZxkB4/dbQ/jtYdIW+A6NjLoTnnqP1jE6gGnKhEIZBPiu8TaCe4a1mT84Uv5QpJyACF69wdIIv499Ad4a4TC7JSZn6uSALuyaHHj8WFDKqNxVB4KsKHOFw7gkULLgx8GH1yjXb0oGjXjDrllyh1mvGHdmXZksEi/XCL2tlGs2p3KQmdsxPvC1BpHyrgO3hhvsoGpnoAzhJodCdZAky/3t+sReuJdpuc1hkbgkZ+MTnVb0qVrQbIFz8NEXp0pmk7jlqdErZDarkAKOm8P5Hc+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5v20tWnAYIZ0a84O/4/2Ippa0uxTTsHsCw7ItvrwIo=;
 b=luq1A6gZoknFx1JLreVR3CCVTptfyUhnGX/K7j7ZRwCEyWew1HUpgrLA6q5JIvZhq6v2gWpNHO5XryLT+GWTsiJvLJvI+5y0gDtm2D7UkR7C3pMyLr6FvJXkKNUvDHKTxLiCL+J+/NjEPXZT/wh7cO2iPhtmqt/0yYEInOux6FtCyewTWh4K40g2sLz2vlyOUDQ+LpxcTbAURtY+jh7tibX58H4daB/kbAjG7BPlwWyWo8k0qbJpVgBh21y6W1gM86qXHMtzRm/4u56fC8vLO7/y4SAL7LlrLy5XYBpy6dgWAIfCMLKKKH2PWGlqVCAfU/uViR22HL8Otl2ecr6/VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA2PR11MB4985.namprd11.prod.outlook.com (2603:10b6:806:111::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Tue, 22 Nov
 2022 11:08:30 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 11:08:29 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 6.0 1/2] nvme: restrict management ioctls to admin
Date:   Tue, 22 Nov 2022 13:08:09 +0200
Message-Id: <20221122110810.3568811-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0157.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::11) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SA2PR11MB4985:EE_
X-MS-Office365-Filtering-Correlation-Id: acead313-9d35-476c-6ba8-08dacc79e232
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PE6DYfeiARiFslH39OvqE4QvEx64CU+4trFbftSXD2s4CbxSybTO78YpKjxewrykdWq9Pn0AXFWESoxbo1wkl3Yzd6wsFjAwee42zzIMdrQO1FL2RNovoIXDI1u+FL0bqbYj/qKizkcHE0y5rvHNLiO+FaBx7kLFwa6Ci9aJnPEiJiHENlCjlgW0z8QMCF5R1mNA5Ye+x53aUyN0ekA911482w/jwDKoRvkggIcO6qrMwPqeAbxqViURmWcIDCbSVzeRv44YmH+AbPhFN29QyRuFuDPExXUQTsw+fdXAg7nhOCCmNvAv0tWrNgjVVFFs8zKXWjfK9kLw1voDjYuoWbZgpSEIc88E8CCzsYdzAwp+Znsx2bvDdPj63G0ucV08zkt9a87e4PqTef1rgaAebZC6uqNWCFZEER1ICHgLMHP9jar1NfUc3crIfUYM53zRDzGrXKpkRkc2WsNTAqq62weuZlfMOonjs4GHtHavFZba33D670/G9KpXFdlKJJ2C/5xrGzgmQdGx5XScMINZEMhJYW8fGq4Sn3S3/Zi0tQkzXaQN/Fm5ZiQSlPLHusF7FV46y2pDHT3CgK2L+QpeulXQUpWxqGwZ1qvFyHgqluGnyzhu12vSWe14jjcRe9kIdisZRmlqY0OwaO/a3EVdB+RCIgLmrlKj2bJcU1/AoRvGwlm5u5dIzHUwk1amy3KU7puOOLPp8jeG10TpJyqfRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(396003)(366004)(136003)(376002)(346002)(451199015)(26005)(1076003)(6666004)(2616005)(52116002)(6512007)(6506007)(186003)(36756003)(478600001)(2906002)(107886003)(38350700002)(38100700002)(83380400001)(86362001)(6486002)(8936002)(66476007)(8676002)(66946007)(41300700001)(66556008)(44832011)(4326008)(5660300002)(6916009)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Fnzxizo/2KtPriv13FTxFkfiSIOYUD8JBfG2wXhv+U6bm7yVCy1wafiA/63?=
 =?us-ascii?Q?yJH5n+12Md6asptr3aYZptZhz6/wtonahc4tgo7x3cqG31l5UfR4V4gCEsNk?=
 =?us-ascii?Q?o4LBvdh5ZuPvsd/25TWpnA5pzi9FBpyvX9nB8FlX8bdZF1KtAZKz7NKb5/yl?=
 =?us-ascii?Q?e8g245YtGy35H2PgoYrr4UYVz52HbCKIeDCaUj7T7aHtbn0OgGptBp2pGile?=
 =?us-ascii?Q?KO4GrM9NfeQvY/y40ixslxcnFppn9sIrB/TVWePhmhexbp2JluGIUxmi8Q9k?=
 =?us-ascii?Q?A9XjKqgDaNrsNeJnUQv97koxDH9IV3DU9jIsWhxoZxxeGJZB08S4UdsZPoSj?=
 =?us-ascii?Q?rmwuBLeeGyht082Ff8fU77IX1Qxdx9MQoMQHv4nftJw3ATKT1780tNsPibuq?=
 =?us-ascii?Q?J3OpjLXIJ2Htb2ySeNVTS74MBqRLmz1cCewouXyDn3lsMWeiQRGCPxQ1GzpF?=
 =?us-ascii?Q?TbnvkvmR/b3l2g3/lKWtMK013l3nls9xD9lkMyEhvuTGDofJpq2BvgdY6say?=
 =?us-ascii?Q?eq3LMXujUhCIyrR+0JYybJbRzl610ET1IPbH1vF93cOQwQ1gscF4ymInNNe8?=
 =?us-ascii?Q?u+lqOGMh//aBK8/Z3NyqES9lagvQ24tCrrqcDvYDvgcEEYSKWWS+HOpgwCAh?=
 =?us-ascii?Q?tKWJHVfqjf1b/7wrVPP5HRenv1tWNms+oFU6VfXdLoxfOHluIHD7ueXbOvQw?=
 =?us-ascii?Q?Rvp9gUlnjTaVu5LPk/TeR/hD4yVUGWk2nVUlZyNHCVekY5Hk/M/g98gsI8p+?=
 =?us-ascii?Q?hBQGJDtXwyU7/1xHW5kmRaMVPTXM8hk3iyy9Jzx5sySkCq1A57H5vlNDc1r4?=
 =?us-ascii?Q?SIOy2USzPU3c4q3RRwulGoEvpVrgTcH0z6F/ua+s9GDkgk4XPXOtysY9T74y?=
 =?us-ascii?Q?Mo36vpwRtl5qN8TCBIpDW/efkPb6BGzy6VNLmchry/KmaXIYxQyOuuHOKUCN?=
 =?us-ascii?Q?0dleJs/vN8Z4vXNZGN1r0lsIOwR5+i53JUosAzdPNRNKkAwySL7Fu8jxfHdC?=
 =?us-ascii?Q?OEFTMnKVI90IhU1hrcgxG5n7pM0fUQ6PzC7kgXyWEwhLpE4uo1W3R2eb6cqP?=
 =?us-ascii?Q?MLSuB2CXIiYUc0KWxbVNLgdHK3/CHoIJPuK6bltYgQRXgQ71C3K+BkITctVl?=
 =?us-ascii?Q?aBxsKm2Al38xe1z4GMnJkuy5EmJOQafzNe7hAPiNL686xZZV+psPDxifcF9A?=
 =?us-ascii?Q?j+vMnuXHXfLG9i55RXkYndPZefr//A20lEYzeeoaact9uX3TjXjF3/Ioadb2?=
 =?us-ascii?Q?ImDA1c0AND6vqSj7iG+9nmqHiLRAhfu1JYwRcsZ7SFjvkHlLBFTeOPxIsibw?=
 =?us-ascii?Q?gR72rye58DGL/sFz12jdkgyTD/rznbsYdH9r3lKPXg+2gNOokFd6kvBOCkWB?=
 =?us-ascii?Q?SqT2hKK//bitSK8cNtHrHxY+JkqJ8xWKIv79jQlHCQ1qXF7mx455vonutKnI?=
 =?us-ascii?Q?06F/f7p0rugsLPWNlZDK0kNZbU+V3Pdb3ltau/mSqvrGEdx6TYM24J2v4qAx?=
 =?us-ascii?Q?WBY0Sj7ylUE95vyk7b4/dkb+j5sN1nggCBw76Q1Ad06u8lQ/bE+rbbs+E64W?=
 =?us-ascii?Q?CFHdlUFrP6B7xY+p+M+y2pOSnPx1jUF0B7pasAXU8ik9gmzwwUav716TpUe+?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acead313-9d35-476c-6ba8-08dacc79e232
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 11:08:29.8499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwRRNp+7NSTLHY3r5bnsXdUqLFuTZ3EcGTZ3UNoXfWUhahhstM4PnEqOODTWMPljkR/QRlKUiDaWVFcaLEBbEQLBfq1GhfcwrUnpGfp5DjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4985
X-Proofpoint-ORIG-GUID: jcoutTyT4eDgWzG9t1S66Uhb_1PWLzHS
X-Proofpoint-GUID: jcoutTyT4eDgWzG9t1S66Uhb_1PWLzHS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_05,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220082
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
These backports are for CVE-2022-3169.

 drivers/nvme/host/ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index d3281f87cd6e..a48a79ed5c4c 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -764,11 +764,17 @@ long nvme_dev_ioctl(struct file *file, unsigned int cmd,
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

