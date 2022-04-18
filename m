Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3880F504CBA
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 08:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiDRGgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 02:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236801AbiDRGgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 02:36:14 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5490718E32
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 23:33:35 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23I6A5q5022712
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=DL0AA2D+zQF8o7EDM+U+b8/yFwF77LqfeeesiJU90w0=;
 b=DMInvpkzUpL6R8ZNqDEu4praP5m/MFR+VvmlSI0RAU2nNLPZm03U3Z0ewpuTEJi6Jh2H
 YXG/fuWBYcwmle2RUhFyxQLSwYu/4d17bbX1m5do5Sa3lKFpcigz6G5xg0XG6Ee5vY0m
 DlvoBdk5ku8/Sza9c/G/p/mOZpNvthw2afbhdEhDSI24Je23ax1J2uVjNMC9gyoLsT2h
 y+0YhjnGRKVLdYuYRGBjMCngdJArvlSREMNIGAsXXUr1o58qLla3AVkn5ZDhDta6m8Mb
 G0PU7pi7R1R//w3US/TXmNcudQVDHUPniV2zltKaC+fzdH+CcKb+zI/CbF1yXViquSrI Iw== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpj2s45t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GlBmes2O4QfJoBynKsU8bF/fc1w1eUI+MmWjvf2VcbHUTGtm9T0kJu2s9C3etFyEO4i+MaDb+E9yA4YxH1Ob7fQ1hjswAXZMF4skmlq5FfyJNczVYx4zT+Oh4S5tgmrcYL8qKOGtBNmJEb3hlXSm3KQ+7Dj4Nyja+aUoBYG9PU/nxVSVWlghucsUjhUp62JUmqZg+nfsLWCXY3kLKvRLxWRm7Q+fPq4Ymp7YiNLFGlKsFqkMALnlcM5gdSIR9KuVsEITCt77fJS38/6RDY+xPwV8PccJVvENOCF/nD5QtQRMiRO7yHW2ETyzkXesTkINBz6vgzcTH+GbRNNLvPGs7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DL0AA2D+zQF8o7EDM+U+b8/yFwF77LqfeeesiJU90w0=;
 b=YkG6O31BmCvxbv8DUu8a3nl8ySYISeqfvxRQSlo83VO8mU9U7D/SGjgJCDx1nBlrpzGZp4xU2V81HzbBPVsEdaK6ON7zsgy/VnhHvMBV+7drCYQ8r6uhHnT3R/057YZ4/3gLPH1Hf5/RMkqf1h5CEkwbkUA2cOcpnccwRSJ8rKvpu/4DDYsWUBVeIEBZxN0GeAVWK2R3aPOzE92KLVVbJ3Zofrj3YgDCwiGjHhYEG7w2bsrhMnfJP/2JXFc6Lx10nylEiq7BxEUUOcXng3iSEVVLXRlxonkECCuXve5/zW7dXYUq6ByLmjIPLkWWuNYLCTHF0cS/wgyRZ+papVLQgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR1101MB2135.namprd11.prod.outlook.com (2603:10b6:910:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:33:32 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:33:32 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 6/8] ax25: fix NPD bug in ax25_disconnect
Date:   Mon, 18 Apr 2022 09:33:10 +0300
Message-Id: <20220418063312.1628871-6-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220418063312.1628871-1-ovidiu.panait@windriver.com>
References: <20220418063312.1628871-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0042.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::19) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a719818-1e48-40b7-6a17-08da21055bbd
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2135:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2135D531B8F3F7D398820033FEF39@CY4PR1101MB2135.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dni1mO4VwqnaM+lRIVESRfnKAiHSch4wqmI8c6JfeI3BNH/30IMWTAnAqnhcPA2gaixqxHPT4YtorLR7fthzFHlYk+ILvCZgxOzJ1OMAZDwvaQYvCMnPXJt4adj0f/sGQ4HGk+4CgBFqR7XKM0fHLfeOgXMozPq+0GFfTc9RcxWI9zPKGm4YL9YQ0IGxVnjJBbgjF9lBkzRdCxdB0Em9pJ1TMCcxCoVwSUjeWTsYwKDWN9N0MEFygzXAAn1ahuQ8qMtaT2UTg5INP/n0HyWwC5+fpdmeLsBf0hknjMvsFa4GCi+ePSddSJqRMCQcplxX7gRi8RXffje17oP956OEI/lxni1Atv3/WG49QEOdraeqYh9cCFo7gr9nSCr/kV0u5ALVDG5DX+F+7qTzVpXshIAWc+7v0ZFd917fHFE2J/6NRcOLOqk/tif/3BIxlWBEnV87tb1M1s8zoXVhYHv0MpT54ug4N+a1g8npWP+VNspj1NU8fQnZC50ZkzQeaUwiup28nrgrU997M1XRDyLheDetyuDVEnXd/3Spp04mGb+RUWE0iCNbJuoaZCPd46oFi0EuxO3yzskYJVxybBMHIYH2vvcmrq2thUVsC2Gl8Bb46GBGVQHVko4L8oiWCQqrc5VGxpCYEcI5YcDnmPpj/hUiPQOt5y7mpWq/lDqYv33KdICrxERmdcCUOspfpuMGO1bkgrvLscIdh4aOPJX1IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(5660300002)(316002)(36756003)(66946007)(8676002)(66556008)(86362001)(83380400001)(186003)(26005)(6506007)(2906002)(6666004)(1076003)(2616005)(52116002)(38100700002)(38350700002)(6512007)(6916009)(66476007)(8936002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CTmsE9MknzmwjaTdpPnQ+hZLKpvALV9c/2izshshrsWD5phHtSb44z333be6?=
 =?us-ascii?Q?zI5g5tsaDn45uU2ok1k+DERTTK8hz+wOz1CvSlShLm8yDCcMSDOiPQbuJQNh?=
 =?us-ascii?Q?oIAA/eG+i+4pdQFK6STEObOpK8jzVahM7PQiRW8pFZ6qSbS6bQO8HvPqj8Fv?=
 =?us-ascii?Q?ODSfEadnWtWDzZuLLJQdFvtHbfRcza21P5kINjgcwnnkCZPmyHNqgIjS747G?=
 =?us-ascii?Q?6Ughbw9VT2vBIpx1a9MTBjTYGiTS4PKfJaTajKvHkWd68sZX8+sX+vspJMuU?=
 =?us-ascii?Q?3JkC8ypPZvC/HGqb919tQO1fLenJ/DbXqUvLvl9QrjzJcYgerSR0dxF32BUs?=
 =?us-ascii?Q?kku6yqGwwwQ2/1tkYFMVD0oq215rBQKB3NNm8BvsLuWwBE2kDM+10Jh6XsoR?=
 =?us-ascii?Q?2RDOSLZkwB9EdiMpOyYgm7YhLQJZMc1ET9E5OK4jYxuTQCuKYbM4dMEmRkP9?=
 =?us-ascii?Q?w3d6Iwk4KaGeSJColLzrbebwKJa8961YRBcsuEYorv0alO5LgL+tLaPB1Nk7?=
 =?us-ascii?Q?A7h+M4eXGGzUztCnCJM88gAAoCkrgLGrGjsCly3bbEnWY3wFLisYz18fjSPZ?=
 =?us-ascii?Q?S+T2UqSSLOR2Atmp2AYn1X9moZ2bGhHsy2jaqbNRJefZlrGU4aOpy5Ccbzjd?=
 =?us-ascii?Q?D3Ez9optJXUyZoI0k+0EYMac9DTwnWqZgmRtDMvrImWxzpwEM5i9nXIaMIPc?=
 =?us-ascii?Q?HCP4m/iPC84/2ff5eDbwGMMCNv+6yZEgdIkAymnO0iJA+RSWOV8t5eQTs4jj?=
 =?us-ascii?Q?CVGhiZYvydc0+NB76fccEofzTJPzcWyilkhTioLQgCDUU6KrQ7Slwxl2d1/F?=
 =?us-ascii?Q?2bnIpmYDpotbqpxXS24/2Lc/lq4pGOOY4G/KXQmLra4znBKyTYGF7QCoX+jl?=
 =?us-ascii?Q?AlKW9jAW7el1qFCxr9f2CLARIsPZXnPgKmir0x7Xun/rD3dQmsG/X+5CRGR9?=
 =?us-ascii?Q?IBHpxwoPvtCEXVH+S9w3Yg/UQUjy//P4rDNt65/zE5Gd8gcxWTP52AfgQEZl?=
 =?us-ascii?Q?bLvzwAQJrwSkOdglDXNyt58teQF0wAHhH8GCWrCsRoQ8D9GgnmESGhI0nl8u?=
 =?us-ascii?Q?wQ0VO8GxFEM0rupsTL6DNpKxf74TQLJwCgyqwZb4n3SHr/o+nn0vs2i0gP1Z?=
 =?us-ascii?Q?U1jWfvEknHuqM3rZ8zAeq6h0vAqt4hk79i+wR7ATwSs0cAC1j83o2watT+wW?=
 =?us-ascii?Q?rrXpGoHEf4qDqqD+2ph11fu/AYl3pvHpJvtdO1isSD0tpz3u5qvLxKkJis6p?=
 =?us-ascii?Q?kyrGLcDe1bQEVfFRiBU63ow7454E0hrdGHi70FLRzospOgANiCcn8BBEHBXu?=
 =?us-ascii?Q?7UBhfJiE8d+ToGOHFnU66PvhkNSoIng8fKqfJk7yQl9qYlb3zgrnv2AnMH1A?=
 =?us-ascii?Q?7pqBHRj/NnqklGsoLkQezciXcZxuFPMvrCY27BoUKCshvLEk65gbQ7C/CtBT?=
 =?us-ascii?Q?qWyKq7lqYQuf7hV2VqC2zcfjF5i/K7FVhDGLCl+spcxF2V2goGpWKuT51+fX?=
 =?us-ascii?Q?2XEruRmIUXM/W8ZaKM6DGFl6CYEbv6mVmazHwi/fGnGuS7GMddlaCjKU51cu?=
 =?us-ascii?Q?b7wk109YAGQ9acKrBhFOmvAtBC6wdDojsFaQZE47TFN5rDRvZdBeYlxgMO4K?=
 =?us-ascii?Q?WlxqIqgiplV3MNX/dyOCXl3aCa0MVIcL5ui0/B0J17tjcvKm9WEPezmwCEQH?=
 =?us-ascii?Q?tx++YS849iYvTqXwe/s6C18ifdDAU9ajWX5/cws6Cdzoa9bfhUVf3907//dg?=
 =?us-ascii?Q?pCW/yv6GP7FgsaU5vJNrsY/3wkliU5A=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a719818-1e48-40b7-6a17-08da21055bbd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:33:32.5289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VF54a+d+U+rlk3h9Gf4g8RHl99Dyk4QlNVS9/OJ/k+A6ob0RqJXIeE4usiG152OV7myKEjh8fdHpSu+UWlVqKXRGCfzUgdUaGigLJWgVX38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2135
X-Proofpoint-ORIG-GUID: 1hey2ZE08Rz-gZUNvKWKObIL_XQkUVrr
X-Proofpoint-GUID: 1hey2ZE08Rz-gZUNvKWKObIL_XQkUVrr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=882 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180037
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 7ec02f5ac8a5be5a3f20611731243dc5e1d9ba10 upstream.

The ax25_disconnect() in ax25_kill_by_device() is not
protected by any locks, thus there is a race condition
between ax25_disconnect() and ax25_destroy_socket().
when ax25->sk is assigned as NULL by ax25_destroy_socket(),
a NULL pointer dereference bug will occur if site (1) or (2)
dereferences ax25->sk.

ax25_kill_by_device()                | ax25_release()
  ax25_disconnect()                  |   ax25_destroy_socket()
    ...                              |
    if(ax25->sk != NULL)             |     ...
      ...                            |     ax25->sk = NULL;
      bh_lock_sock(ax25->sk); //(1)  |     ...
      ...                            |
      bh_unlock_sock(ax25->sk); //(2)|

This patch moves ax25_disconnect() into lock_sock(), which can
synchronize with ax25_destroy_socket() in ax25_release().

Fail log:
===============================================================
BUG: kernel NULL pointer dereference, address: 0000000000000088
...
RIP: 0010:_raw_spin_lock+0x7e/0xd0
...
Call Trace:
ax25_disconnect+0xf6/0x220
ax25_device_event+0x187/0x250
raw_notifier_call_chain+0x5e/0x70
dev_close_many+0x17d/0x230
rollback_registered_many+0x1f1/0x950
unregister_netdevice_queue+0x133/0x200
unregister_netdev+0x13/0x20
...

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 5.4: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index cfda476691c1..b7309baae945 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -102,8 +102,8 @@ static void ax25_kill_by_device(struct net_device *dev)
 				dev_put(ax25_dev->dev);
 				ax25_dev_put(ax25_dev);
 			}
-			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
+			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
 			/* The entry could have been deleted from the
-- 
2.25.1

