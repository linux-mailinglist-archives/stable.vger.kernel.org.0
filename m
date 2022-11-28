Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4C963A587
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 10:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiK1J7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 04:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiK1J7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 04:59:19 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A6819C15
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 01:59:17 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AS9q8gX009834;
        Mon, 28 Nov 2022 01:59:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=mqBhtFSQi/1ack9omJSIgDwZyToduQgxrjX+5SMfTpw=;
 b=b5f8ZX31Lx2j1QAgA7QnAivnwgt+XPlPzfoKMQAlh7op+GqFpcUasdAXKG80JSGgcFEg
 VHMS1gEu8059wRZc3GgC7s/mXHmISQHkL8nlESVELu2MO4u+hAx/kWmQXxl837fyWJq0
 z3oYOrr7GlQn6ZGf5FBukb30rKu8FMLvqvXWpafXb7+vHQicyOMiVXOyEHanb0lgH/sU
 givyrP97PQEaBvxl4S5h39VEI/0NyhqHQC/l3PoxlfwDiaAgVMFdIGXvWPHO7MsuIZ9a
 Co8C54MTvr/S+s5Qt958+Hrtnh6eqtibu/fIbvydFVisEVz9dEo6BVO+lNS7AH8bNAIh 8w== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3m3ey918g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 01:59:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TsSsSfBrUavcTTHbuvL6py2cEAGKmRc5XIZE2rQ03OgJ9DEgb93ACGNaz8/GWBvwg2l4GR6441kGvj8eLlRzATII1bkDlBSORZYa4gO9+ztBfucvhEK3KfAY0qZN+F9MuquKdcVshzlDg+3GXRhjVwguAF7bMDFqFVlVkAFDdn9Mtg4+YUKzGLxUr0uwcwrgqbo4ZYgWOFs0ChDq7p6Y/iu+q/CGXfIeEuAEuAitK4+HaefH8bKX4DNAF3RTtqlUaXPTdziq0KwxHGRP/opxNnUPluLvKqqUGWh9p1GyYX1s89RfE5eqJArN5rJXsvjgZ1Eq/JfH2rWsW3M3Q2MwDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mqBhtFSQi/1ack9omJSIgDwZyToduQgxrjX+5SMfTpw=;
 b=Lr+1miRfpQL7qQziY0shI3vdtPCRjKy37BrNcWnwINxzJau2IPh1uhaZsAPRIFH6XSgc/EweV7c5DMNXye6EDpG2n4z3sC33N9huvjGZybT8+Cazx03s4HwLlQvX2vNe4zytjoPiTpfBn0rbxrCEgqbzu4myWK71Z1LPtfiFzeVV5SqcNrERpW5Eox6ng/JtS4QFzBysgzNMzkLgnud5OPxgYBveNESdVw00sj/m2gM6ZTBFr2Kr0BVXCKLdEwxYH25QrO6GdPkjs7TS6z5KrZz7uTkdpkSIC0TuUAVcp+MJ/qXrubBSYoO5RNUaEbxkeZdjvwYvBRoFZ+OQFpkTGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BL1PR11MB5368.namprd11.prod.outlook.com (2603:10b6:208:311::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 09:59:07 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99%7]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 09:59:07 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 1/2] nvme: restrict management ioctls to admin
Date:   Mon, 28 Nov 2022 11:58:46 +0200
Message-Id: <20221128095847.2555579-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0187.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|BL1PR11MB5368:EE_
X-MS-Office365-Filtering-Correlation-Id: e543532c-67fd-4085-43fe-08dad1273083
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z9Zn2pNQx5RtyHnSUDeFfs+P2c/VBs5mm7EhJ7aiZHmJwV4zUkXQMzxCGkbOjEOySYRYklIJe8CQH/HCtMYx+zETVY4P4tAja1iMVq0k72apRXxg12SgeUnVqOi/52RY81bwqHdF/dVUvWD5a7NULyzWAEfkZ+c3PYqHbIh5TVmojnyPxuKfq/Z1S1c7KabeVX91HRGDX49i+IfbTGTXOVB+Zp4mxi3rZYAPkJBcst09lE1bmtQC7ZMMSpiTUFDvOuWwuNqHJWLYDiHhmL50DHCSvlCfQhlsBzZ2rFhtm+YDchIV+dHNKn78jAuthMLeJSmwMs07UxLYfQjrRle0L5gCbMWSY4WLvsYaBwKkMzIoZeUNof8hGPaQ2AsRI0RaPolG8z3KxTVU8SvyrZeglf8y5221/RyHNcRLx28EYPuPfeaADzw7pw2QeWwwhAtKMVrW+9lPl8oeut4cFXH29vjizXpOikVXO23YAmpdhOR4v9WzXvpGRChvCsML4DOz0vWJWadYdlcViUbWyUmQ4maQLP/LtR2uQugbaWRZLrt+OaBFqQ+9N0YWwfCc0b0NCpYOeu6wqnJTEI6caX7HxwenG/nugFQ2f0ARlIBU+FQu3hQOJIRrVBROnk0wPhzbP/Xv2vhbkrLeHtgSczIbFIHKEhYCUd35MsRnDR+1CHgK7L5LFoechfc+nGCPA8Iy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39850400004)(396003)(346002)(136003)(376002)(451199015)(8936002)(2906002)(83380400001)(41300700001)(2616005)(6512007)(26005)(66946007)(44832011)(52116002)(5660300002)(6666004)(107886003)(6506007)(36756003)(66556008)(66476007)(86362001)(186003)(4326008)(8676002)(1076003)(316002)(38100700002)(38350700002)(478600001)(6486002)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qM4W5zYnILzdP7VyoAZz+OcYNETavYWfT1LX3MdcvmlXiXRcOUPZggR/hOGG?=
 =?us-ascii?Q?wP3CmxT8g4zCBRBVnEvfg0UlIiOulKgoiiN7r4Nf6/q0XqS6KqbALAmL8bqa?=
 =?us-ascii?Q?esqCj5mF4KEm36H0zexBESMEPhlSde+EGhJBhS8YptaRUqKwDOHWICbKHQg4?=
 =?us-ascii?Q?U0+/fS+bkogXQMu6nL6720o4sgKTAxNjKWehejO9N+MGXmLMsy4ADwrIWB7R?=
 =?us-ascii?Q?eu4LA0SMb/tW2XUv57gdPJsoOQ/n9UjgxsC6XgonhHz/bwYUI7K/esVix2ja?=
 =?us-ascii?Q?ZXQ2g9aEyKH6+yMQyqvlrQ8aoiF/sy5/NLmwg1b0h4r0+vZeB147TErXnlkc?=
 =?us-ascii?Q?uMVFtstGRocmJwW9eIVVBeO1BP3IlOrcRkqqY0LWoQyekeisjkJfsGv9IZGt?=
 =?us-ascii?Q?5coAgEif+CtdpYO+sigXGlErhOQXFUZ+lkfBnuds0AKpuCOjRjZzx2pDKqoc?=
 =?us-ascii?Q?RhAlYPIz/YLEd29uZ2OGOyJv9jOP50csIZtVCH7tNCVZ/LpVPEjuTkbJORdY?=
 =?us-ascii?Q?UMlXkgLquTbedKMXt/ZlzGfbpXMDx+iGw34nBFJx+6hFEKmS/BnLo3PHYOtO?=
 =?us-ascii?Q?+G11rPO8ghyKQ+WoRrHF8nsMRQiX8CjZ79Vf37djxsS1dJLU7HXFZJX+vUqC?=
 =?us-ascii?Q?Zqm8bn44rge3iQd+kqz2TH7Q1qSBs3NRUAOF/3ugY/qkqgq4ZmkbOEvT+bJd?=
 =?us-ascii?Q?7utlZU0Aimmk3aHhEiuumfm2ycXPB/nEelQPnBNndcUTzMxH2R2vBfVZe2ve?=
 =?us-ascii?Q?nksjaOXcuilcLMo6QNhJi5nDbLCqAaOdS07RpUxvJa+4xXMgZ6PRbxmJ4Hx6?=
 =?us-ascii?Q?Q44mVdyQcg97JZgigDbqanQPjZZuiut9oSSudYDcOJav9CCKWj1CmLVyLoxD?=
 =?us-ascii?Q?e9OuExY9T2X5hV2yLghn5k/pBxsLCSPWeiOFiz9afmBus3PT/FTOWgixxyVM?=
 =?us-ascii?Q?PXJ+or8ZJGa9FjzMZimwUppe/tl81nJQvmXym416abtCpI6qcK4AAZCTKoJI?=
 =?us-ascii?Q?G62WFMFTEvYqogJm+h4ChaaYAl8xhe/1ikuugUyLHGFcKIF808QNQ//dxfa5?=
 =?us-ascii?Q?9MyL0F8hO4MacCiSEFKA/4m0Vi8VqEOFyg21YuRdfvbHQIMPrBfmc/HhUSOl?=
 =?us-ascii?Q?pEghuFxs8kjrrWe30PrMSATUQ+JkgfuwXIpNyfLgAaQFS0ufXpwmDQv1aVv6?=
 =?us-ascii?Q?Az2iMJxMkUc6QdIm7TR3wQSETfK2gNQS1AXVLi2krzcm51WNQhX40cnq9xiY?=
 =?us-ascii?Q?lvGLmX9ykzcHDlnNkjHTTNSElakDoTGOXkG9IriywM35gq/ye2Q7wa18sfgo?=
 =?us-ascii?Q?wcMeLkzd2bYTmP4+4Mfkmww/DyL0sGPynnlvm8Ty3rQE+HNKC6/bQa0H8nZV?=
 =?us-ascii?Q?+2lgtan9SZEA6sj9UZU/3Utv3+06j+DvlyTpizTeoggoVvlx6xhgX3jcUdxa?=
 =?us-ascii?Q?HFz4rwjEX3fZRmW8AtCL10XKYgWplgtR3RviUnh3n044q2tSma9rh0cZ385i?=
 =?us-ascii?Q?q58oxqM5lRZ6PCf3P38ZhAnbVBZcEYLAoE+jGiisraQtvwQ1i2R3HBVI9SPW?=
 =?us-ascii?Q?cgp/OGdfvb5k6elBHS5/27lsv/XlHDXfXruD0WVq4rACsDps1ybW0I/YAKJc?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e543532c-67fd-4085-43fe-08dad1273083
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 09:59:07.6923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: giZC/cPauc/jr9PXMNMtYQd1PX7t+BDnLTNNOiHH9nGWHevJlGGaYkjhltveiw8EXK1PAev+/u8FFPcJ9SUkHBpLFzqDd0QoxpfPLq95EmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5368
X-Proofpoint-GUID: 3HtgTPqrHUmxdFeCxvJtzttVVtVpbCqg
X-Proofpoint-ORIG-GUID: 3HtgTPqrHUmxdFeCxvJtzttVVtVpbCqg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_07,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
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

commit 23e085b2dead13b51fe86d27069895b740f749c0 upstream.

The passthrough commands already have this restriction, but the other
operations do not. Require the same capabilities for all users as all of
these operations, which include resets and rescans, can be disruptive.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
These backports are for CVE-2022-3169.

 drivers/nvme/host/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 6627fb531f33..3b5e5fb158be 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3027,11 +3027,17 @@ static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
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

