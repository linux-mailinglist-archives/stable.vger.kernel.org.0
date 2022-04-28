Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5C7513537
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 15:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347270AbiD1Ngi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 09:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347245AbiD1Ngf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 09:36:35 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14EC22523
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 06:33:19 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SDVkuJ011009;
        Thu, 28 Apr 2022 06:33:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=Zsv1MX90teQTJRg6zUloxVxPrTw794jwkB5q0xxZWcw=;
 b=KHGDAmwpbvJt//e2/G7HOK0J6sDmQXTJiPkWcXaueBb8bc7u6HlsPUgUCDthpNeqAx62
 PqbSd59ALHpjZ52yevZarhrEBXwidT1T+qGgZHyhwy69yX3FP9zJ50tPQCXfGtDW2mjm
 LunwhBcZ6GgufqglC+hfHrMmcQljGViXIQMlz66GUqXlT+lQQW6fwIpMiB0z8GHtHc7X
 8ZoUSV+d2oB5S5W7AQzEWSCDdxPLRQ1VtfVh+f4nTbbNMYwbvVghM2Y1kSRmoqKxpsvH
 xp37CNtxl0dwsOLbHLcqPVTG/8IGC8s34MNlmMwQDTFSXpEGBPGOh9Jv+YnCAFdnF9k7 2Q== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fpshjsc6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 06:33:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjog+6L+r0hcjLswsisCi5oJUlqo/klek08u9SfRMEvrRo65YIity0umTdC5VByMWMmG2jVX7cn5YSbvOZVVl0zbvje7nSttXKujCpwZdkvZFcQhPUaoPMvvYNQ8tU/kEm2IwNOdMX9uM+TFeG4Vvod27KePG/qV99yIuYWATb8FFEHqrqwFPBL76ZYyfaFy0kMj7gPdj+pEiP9qlpltTYQ+I7d8Cu6QmltKPcdIHyM0INLkjXfVWsKNm/s/i8yJSAXZIQDXtwZzV3Vzvvihh+DmiuaKUtxnK2CRMB6TE86CbDge4bSzk04GQB1UIQMKdwFXM1xbqg+hMkVTfkMrRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zsv1MX90teQTJRg6zUloxVxPrTw794jwkB5q0xxZWcw=;
 b=UEFVFeDFadafRPRS0JllZ5wCAH4FOHwo6QeLBKfzGveS+25L66WYp6QSiOD7N2iGG6cC4H86eBZeBDL4hcxrZP1KbAfGecqI6iJq/KiBsknn4W9EJ0O80dwWH7VKsMvk31382TvIqi4YpBcl5oSPkp0lxPljrp//je5Idmv826XGlYQtcSSEY09Pw9LOFnL9qWHTavanoCYdz/FbwHQtwhRJvHqzs4473iImoTDn6RBakLQQa5l116Z18SAtq6wREk1cUqfSnntvbyktPzZdlESKyXM83ucU/ogUP4kS5Ukq+MTJugfs7fXOVZaLd9u3iMEkGf9rzQy9w8ZNyWngHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1467.namprd11.prod.outlook.com (2603:10b6:4:a::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Thu, 28 Apr 2022 13:33:04 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%7]) with mapi id 15.20.5186.023; Thu, 28 Apr 2022
 13:33:04 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Jia <xujia39@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 1/2] hamradio: defer 6pack kfree after unregister_netdev
Date:   Thu, 28 Apr 2022 16:31:10 +0300
Message-Id: <20220428133111.916981-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0120.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b799287-07ac-47f7-6acb-08da291b9f69
X-MS-TrafficTypeDiagnostic: DM5PR11MB1467:EE_
X-Microsoft-Antispam-PRVS: <DM5PR11MB14678002337F8C51E73EE3FBFEFD9@DM5PR11MB1467.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S42v0kgXl23962pD2eNBAn1cmW6Td7n0of6yO8Kx4z4iNF4IUFFaQlmrGVd296XK5EUfCpFZbo/Ew+Zrv+FVeGfJf+WRxsOtUf1i/LQ6YCwTkHjzS102XvCzJTItz4U9a5FB70zYdy4rvbgWZLOaktpUNb1EvrsKYHKeOzn4WgguE9xWKvgV5veeu6s5UO/vzZiMq/LBgJFdNA4C0GX554pkLUtwMlhvEwI2fdX5YHqYYBRhVFSTHgiL/AVJxPav7fo4diHNgd9R2nZzvU4gCHhU3vq/AnHrDBdnpC/klFQEkLU7J3Oov03McPL/FoIUCaEY/O125sWnwwF3EU+0DMs84bkwom/SQCm+qxtaf9Gu9aGbovvKCcT11v7WNf4PyRNaJ82tMnPgpIjdxq/lwYSVupFZAeCW5hSyHvv23gDdYv9dHFgimMdBUBqUI5nlJeL9KoYiLj+aBDgppduR/ZRYS/F7knHXAw1l/fg7juXhdyWCB2Kezkh7npfln+e0cn+IA/sCH7JLkzDESM5dWIDKEIfQIbB1gcZkghcXWT1fgXygRlKAAOX+FYwTv9y8PNV37MUcsI1d2892dQmjenQMppiqDrvYKdkPvoULZzMZSBRx/0rY5dyWxWOMWRTARQedF+dNB2ojsoeXyJqLN1EBdUCmyaRQYvenYR7zAajXpumajv2y8IQG1LG3ORRGavuu4ZZP61EXeWEWD/lmtE8rFlRedFWjvg46rgrpIIbpw82iI8UbDV0Iv8BaQrTga+J1qDGn6ySHiqL6NGmugB1QzwXTPD6N9hf/atW6II9vZfSLHMByaTQjVhmh9+d9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(38100700002)(38350700002)(6666004)(2906002)(6506007)(1076003)(52116002)(44832011)(107886003)(26005)(36756003)(6512007)(186003)(5660300002)(83380400001)(8936002)(6916009)(54906003)(316002)(508600001)(86362001)(6486002)(966005)(4326008)(8676002)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dwiT34XovY7LJPY9nGddgLCdMHoGQ8UenDEojJjifhNZ1N215+1yx6E7dcGC?=
 =?us-ascii?Q?pmllFAS3bnNBn2n5BpfXs0W2USSkQA5bgw3Ww4Qr2lYZa4x4JJFKR9zO27/L?=
 =?us-ascii?Q?aayIOusFw6MFdGEe6iXq5QG3lIX7C9gqJzJqJ/qtOtmfidpuibPynGV0H5D2?=
 =?us-ascii?Q?w3N6On7uujqyf6FQJieWCwx34HqWyZP5oK/6WnS0xV+/RJ6wRejOqDkFzK2v?=
 =?us-ascii?Q?nI+CHn3AL5oUHW7kE4I1Gt05iswmZxqexROxC5qjFn/MGyGGWq/w/CR+XIQv?=
 =?us-ascii?Q?dgdyweO8X1V/VIwiWKZyo6HeJh+Mv/Xl0HIcPL4NHJtWVtXIOn1BpySpQcCs?=
 =?us-ascii?Q?s/yoxe9wd+W8VAxIug8Zmeoqk29NfBqjS3EEN6wVCkVWX231yzWmfC5uimN2?=
 =?us-ascii?Q?PZTmrgpbkSYifsN7XUUOMFV/lDhQ6p4bt62nG243eJJA4ujcJX5naw2JRsic?=
 =?us-ascii?Q?6NjKjCOl0jlRKHdLDySLylQJiHnlqsWKaKI3IkDwTyic0QewEwP356jZY830?=
 =?us-ascii?Q?7F3v9DF8hO+Fr8vUbmzMmV5dXdRb2t6oDSvfEFA7lXRmmJLkHlJv7hhdsMmB?=
 =?us-ascii?Q?U+BYkDHStUVtMYMdV/JqHOTPAEinuZFDlHjrh854ZjIT4wIClR7/zdqlwqFq?=
 =?us-ascii?Q?ZXvOZtHs9EE5Nt8l14LBLPygsWC4svFK74DLpJJf8rFaPq6Iicz6iXokEEcZ?=
 =?us-ascii?Q?j7c86NgQMs74pARKd+cI7mJ31epJ5i/uGgXFnYOoL95zBcuUh+kirHPPFIyg?=
 =?us-ascii?Q?uUWDYYROWWOgNpCxhunS5IC3/CSXSfFQOeWEx5Nap5YaALo2fX/D3Hu0tpAx?=
 =?us-ascii?Q?3oCE3DwLV4BNjYjsQZa8XVgpZpSqAlBr56LDCfK+TeYlqursaqA1EJKZzIyU?=
 =?us-ascii?Q?82aislDmIT5XO+aen1C2/P/07ov7Ui4aV2xoMdbeayDM/FdhRrtryukEoB0j?=
 =?us-ascii?Q?c7mlwkhhcD9pX+QB+5tPfyS/HoIfCEvIKQdC3aMvr3JW2lyCkq7lbsl9fh9q?=
 =?us-ascii?Q?Qdaz38ejtwLtxcNh/tZDS5zHuycJdZDCqEyP46CkTRok1adMepojQEQjMO4f?=
 =?us-ascii?Q?TyB9vP82wBurccpItaa7jajGfrQMWdwxOxOXi1wf4H82bGB1P33UdmSTFz2O?=
 =?us-ascii?Q?DvfX8xQTez8fIala22I0TPhhAN+PQHgYdSgFuz+uraKppnSMgyMYflsPH6ix?=
 =?us-ascii?Q?oO++ZMuFW1X8MaLvBP3CJITzPuCEgcbk1ds/nRCQxKuQpEMMi6wjjDhzdKqf?=
 =?us-ascii?Q?rsfw5BlWrPSQzNAsY+HglHdUn0xTxZMiIX7XVlhl3Dzhbv7z3PxM3E6PfgRe?=
 =?us-ascii?Q?yYqBLwL1HD5JC7RQN48n+ViCFgYSWDGFPtlrMB8zddrxCUYIrZckpHWOBfK6?=
 =?us-ascii?Q?ZGLgKt2L66Abt03v6aqcQxpitHnRLU5hy9yf/segr8VXWhm/vTDgUMPxjk0A?=
 =?us-ascii?Q?db65V/QnQevyGtrqE/zAg3gs6FnYA1pUw00sZ2RXnypGtxKqcUo2OcWMnVlR?=
 =?us-ascii?Q?v1M+QwywtqUGrmpPCUXMEIucWXquC+T0aG2MmRSNmWZuFwSPtUklY1Rs3Ysc?=
 =?us-ascii?Q?KkgtKYPaDkbWVvSt3I+tqlzfJYw1HFUNXquZMUnRUUd7Qz6wev3eyLzXQRMR?=
 =?us-ascii?Q?QcPstpGIYaaewkRRiTND9q7SH3NsdbZeCVBgtKHCPS5kSiYwVwRB4DCPnOzC?=
 =?us-ascii?Q?pO+/a7wl7r604ISDzAY1avXhHSb8w0VocJIOrxhIYTKvws9D+EGHxihqWVD2?=
 =?us-ascii?Q?jxA9PB5aqR45xXalUFc/r8Y4qAnJkPk=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b799287-07ac-47f7-6acb-08da291b9f69
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 13:33:04.6687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2zQavv0vVHz8iUnZ5n93laQhnsnYj6JlqmpD2f4aTD3JgthaJOFtJRF5vfXTP6x1x4nEVi3hEMaMDjL27/JztTgAUELD9sxEZC00mimGrjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1467
X-Proofpoint-GUID: WWzCYLAr9CiyEWIeREHW8BWQcAFxOzpX
X-Proofpoint-ORIG-GUID: WWzCYLAr9CiyEWIeREHW8BWQcAFxOzpX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_01,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 phishscore=0 impostorscore=0 adultscore=0 clxscore=1011
 mlxlogscore=764 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280083
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 0b9111922b1f399aba6ed1e1b8f2079c3da1aed8 upstream.

There is a possible race condition (use-after-free) like below

 (USE)                       |  (FREE)
  dev_queue_xmit             |
   __dev_queue_xmit          |
    __dev_xmit_skb           |
     sch_direct_xmit         | ...
      xmit_one               |
       netdev_start_xmit     | tty_ldisc_kill
        __netdev_start_xmit  |  6pack_close
         sp_xmit             |   kfree
          sp_encaps          |
                             |

According to the patch "defer ax25 kfree after unregister_netdev", this
patch reorder the kfree after the unregister_netdev to avoid the possible
UAF as the unregister_netdev() is well synchronized and won't return if
there is a running routine.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Xu Jia <xujia39@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
These commits are part of CVE-2022-1195 patchset.
Reference: https://bugzilla.redhat.com/show_bug.cgi?id=2056381
[1] https://github.com/torvalds/linux/commit/3e0588c291d6ce225f2b891753ca41d45ba42469
[2] https://github.com/torvalds/linux/commit/b2f37aead1b82a770c48b5d583f35ec22aabb61e
[3] https://github.com/torvalds/linux/commit/0b9111922b1f399aba6ed1e1b8f2079c3da1aed8
[4] https://github.com/torvalds/linux/commit/81b1d548d00bcd028303c4f3150fa753b9b8aa71

Commits [1] and [2] are already present in 5.4-stable, this patchset includes
backports for [3] and [4] (clean cherry-picks from 5.10 stable).

 drivers/net/hamradio/6pack.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 02d6f3ad9aca..82507a688efe 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -679,9 +679,11 @@ static void sixpack_close(struct tty_struct *tty)
 	del_timer_sync(&sp->tx_t);
 	del_timer_sync(&sp->resync_t);
 
-	/* Free all 6pack frame buffers. */
+	/* Free all 6pack frame buffers after unreg. */
 	kfree(sp->rbuff);
 	kfree(sp->xbuff);
+
+	free_netdev(sp->dev);
 }
 
 /* Perform I/O control on an active 6pack channel. */
-- 
2.36.0

