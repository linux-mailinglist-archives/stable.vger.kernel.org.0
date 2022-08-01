Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CB7586DA8
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 17:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiHAPWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 11:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiHAPWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 11:22:35 -0400
X-Greylist: delayed 1497 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 01 Aug 2022 08:22:33 PDT
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DB6A1B6
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 08:22:33 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271BFd84030076;
        Mon, 1 Aug 2022 14:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=EiElRW9YaoHPMhvNEknJpArkaElh9FoYgBlhLAfM2uQ=;
 b=ntIiKdw1zRlRc49yhdAq2O2IC3MVeFv2pB8J37DZHu5CX4TK7CbPOjd7lQ8QaAKmP6dB
 iMt5QF96/V9n1xc0y1HllYGNQYbjStsoXNhJw8UtHHNg1JWXEZXKIlGmuheMudHP/4zc
 7nzpDer7i9i0DlrEnasf1ZMfLttL5AzUKL+dMsA+NGXYjk1JJtUvH9sjs7ZUy+xXEzeg
 6DDLhNwIEJ87iQFop71EDbrQ7148oHuOpBQ2tBfp4MdIcEKOsvZ7l9fthGINCrihnprk
 8/3MFgaB9xE4V+3VYKQLpKnpNKnmsdDjuZ5bzLItKAiUP/cdwCnYjP+nFVi1HUjsS7ff vg== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hmum91jrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Aug 2022 14:57:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0yGGBc1E9dX1su5+0WKhpTfZ2D8eUbb73cv0WkBRQ4SCCqN9AnbWf+HhdpEVOA2SU6fY0IBva/5TSffVt+zkwHMCqQR04viUUFrNzFpl5g9r5Ip4R1YLVGjN8QtZL15FfAgm5d05J0GzX311Xa8eSEN3M/gQ3ETMTf4uWFLsDRg4KkwdWKtENn/DN7dHgnZcK6kOZGQBIVzn3ZImZyjf6JlUnk5n4SOEDh3bQuZo40RFC9S317RicUjvfN8IHPNZutTIzyTlpWNTZSN914CIXnP6ro4+iUt9yQJHLDeut7Qd6CmWWSOn8TAQ8QBLGabyxnHax+0SWEvj8s2f+Rsew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EiElRW9YaoHPMhvNEknJpArkaElh9FoYgBlhLAfM2uQ=;
 b=ezCPIqhNbAhvcwx3VTVxlXp8yU46aGzHWSV2Zs+jq7nHyn0gK6zMleYu7wRl+0Sjsz8QpZ6FWGLc/3kk0YqmNF3C0jdtylLW8SGJC4Uody93TGgk1z6PMQkpCg8Ay9Xy3/JqVdJA4J5b7wwS7IkB0snmjxBwui6N9p0FwF7qPsS6Bnv9DZA826ya0gFcD2V8Fcd5Rz5okqUImLeE/BNTVKdJbxoW3OxsYwZsEZHZ8i15bI3GRJdNXfIIbnMqcOrOVAas8SJGAUkgc00jM7fVIkyke0dX2A8jboJL3TwoF6FytNXSjG99KU06xmG4yeM293ri9cKOBr7woZXJFO3AbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MWHPR11MB1456.namprd11.prod.outlook.com (2603:10b6:301:b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Mon, 1 Aug
 2022 14:57:22 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 14:57:22 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 2/2] selftests/bpf: Check dst_port only on the client socket
Date:   Mon,  1 Aug 2022 17:57:03 +0300
Message-Id: <20220801145703.1929060-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220801145703.1929060-1-ovidiu.panait@windriver.com>
References: <20220801145703.1929060-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P193CA0015.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::25) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d8a6513-3a82-4130-3c47-08da73ce234b
X-MS-TrafficTypeDiagnostic: MWHPR11MB1456:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QDm/aWtipxxhwRLQOIIt/PLHHTgB39GvxQ/iWc+7Mk4LZsE3FORxg750rVCNDKaONo58na+rsX86Hu233/W/75dzdD6cYHpZOjLE8dSKxN+TNHHqS707fHc/hJHQBftKJjx3kChvLy/FZCoR7gT/XBJsR5DEFWXMonFwcPAx9aZa5VBbpFFa8zxzqKjBPaoP0vuAnhcqDtHHwX7xoyF28XmNAlVHOOtTHxgnP7Tlq6wGdRv1XQohb5qDO+U703gd/65RVOjjHFRAHZHsCJudINmKnfewtjMNwzhxMWPK1+quywhs+gCF1j291NrBBgvWVHrcVEQzngYhKAHucIQdV0R0A9pToJ5jNMWvPiW1+bA7TXZitpoA1zCHKskQYEvsHfw3n2Rg2/J7H4asGsaaWul4PI+i77Pqpscg19A0DeEHAplkoMV9Fyo8kq2MMIlTi/l1gbTDYss2J5DrVSAqM1rxJltoCfvCogfz89mMSuLX5DtJg3qyb/BEqBUlDOnoODwfAvL6SgAIFUE70lUQNBvELSv6rh6DrFg7Zf959kUzDywIGqK7f5BwkjIZ5y0HGBYrw7/N0282V3XKxNhWZHRkncyUDZZXeRVHIrfoPcuY9cYrWxpQ+2FyBMfeA1K/lMqF3fqs7DCn2y+nFNspSqzUixUB1vpRA/EVa2ygcYJdVuJN3Zhy+utqY8KT95BxpLF7kj+D2vnHx0Bjc+gDgH2EsAF5bQpnP4dpd5IDdTMTdojNuIWYS1hTQKLQkVAfdpM/9ipzKVnBbekU2AsJdU+TwWxxuy+VpKWRxoubDrj9OA3l4gnXjRa4IMLacaBCm+1NgTen2m+gFbxQGMTHfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39840400004)(366004)(376002)(346002)(396003)(136003)(66476007)(66946007)(8676002)(316002)(41300700001)(66556008)(2906002)(4326008)(36756003)(186003)(6916009)(107886003)(6666004)(54906003)(1076003)(2616005)(83380400001)(38100700002)(26005)(6512007)(38350700002)(6486002)(86362001)(5660300002)(8936002)(966005)(478600001)(6506007)(52116002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vXfdQApQ6SjdchHlk1YCOTGB25U0SieUk8z7tLgzelzsDLkqsw0k4iTR1vDv?=
 =?us-ascii?Q?ijHDgUrVB1SpXdSC2mif9TDdegbZfGGvuoaLL/xAiD6K4Rg5iplAhybBWBx9?=
 =?us-ascii?Q?Vrp4CEcaQChy9OEqaShy0CRSzjkDDm5XvSwXSXrqf1sQOxyUuCZSOv7d37tz?=
 =?us-ascii?Q?pCG9zacqYAewrvaF9PsNjppH8a13+akKGfIh/0QX8/WRm4sOQ9SfA5MoV3sg?=
 =?us-ascii?Q?np9yIvDeShtMEVKf2cogvH6xRMv6q7U+SpbeZWc3hhRnfgr8lw98KAEfRYUc?=
 =?us-ascii?Q?MwmWY5SO4hVlbpN4nuxN0/H/A+L0MCm6IXu7fw6fGPKNss9W5iqWFgTfYV90?=
 =?us-ascii?Q?q+Ob5UTw59H9eKCS0fuTwAjeWTSpNfQKEjrtXts/2BKNkceylsgzK5FQNwOt?=
 =?us-ascii?Q?evJRG50z3buB5RuKpewGqxxva7Wy2DMGWhTRh14n5KAz/1NhVAvn/i/kyebR?=
 =?us-ascii?Q?LwHXwzsIGBpLG91fXsB/fxPaM5kXkaCcfFsQNZDCVAr180B4MabIM9XKCc/s?=
 =?us-ascii?Q?Wa27sVJmRhRAwDLdzKHx6JL6QY0l2pJkvfcJTmBW7DeC3eQ6ZdQFpsmjMxBp?=
 =?us-ascii?Q?DZ+J9XrwO4zsEuThRHq8cNK5L5200XTQ7EFqxCDHzJU88hUm694zfPF6eqLL?=
 =?us-ascii?Q?Mrjog11k0eoTl+Iiz7KXbcz+Uv127fgO6xaxTYDoheacCaR/hVJ1LGOIk5Hw?=
 =?us-ascii?Q?Ky/g6XW3mHWRQqlBBNhubb9rrD51lIcdArWkYByssSYB90xvSUB1a7IjjqTy?=
 =?us-ascii?Q?95PdiQjEDN2IwLCXIBl51qQKQ08nEDH72yQMkZZ2CINjcbYbPn0+v7ihBAiC?=
 =?us-ascii?Q?70x0bTniMuPB34HHMsF4Q7yP+pMUuBYekW7OI2L5LjbhSwL5G0X1YUbS5KLw?=
 =?us-ascii?Q?RZ00BzKGIF06EoHqKQpuyAfp8W55nRZfZGU2QuykmTKbGpEqWPdPTcOERSkq?=
 =?us-ascii?Q?qhpL+pkypRl2/qq2HJj2rcZmTywy6ItDZjniDVXdq7cfyVTQNTp4VEcqfjrL?=
 =?us-ascii?Q?z8JhKgIbXK4RotV+zUEeQtx/l0BtBTbTo6+9BCc+bQSaFFreGSDU79vDRYzH?=
 =?us-ascii?Q?i8MIm0qu1W57o2Gl/XmjignZDo8maGEj6pyY1KKxQV9i43nIfBHPWEzDJIe+?=
 =?us-ascii?Q?ySEIqZVWv4xQZtY+cQ5h8nfaQIZAIQgEs9yTbiMTmTwzd8vpC4XGVzQmttlF?=
 =?us-ascii?Q?FBO/i9NJacFfG1sjlLBHgUQ4m4cptSG9HGmYzP6aWbNXFeMTrw2sFkjjtsx1?=
 =?us-ascii?Q?E69izEfLmQ+9mejjmMFTGCyJpQuGUSJEXLxo7IgsqWjsSlK5ct0EN1iNJzqQ?=
 =?us-ascii?Q?g6RigDN2o4eXmuA5iCkq8nD5YtmYSjwC6nmXdvBHHfak4bSiUowDDhHIbYjT?=
 =?us-ascii?Q?Y2K4mlKgsqi3ymcsduIMeXSrA/IrNy0D3/5lyCTSBFv4Bxij9ILNw0wjxPVs?=
 =?us-ascii?Q?aM46X1sGjsH6ehGbTMnegn0N4YtaZcwPzRINdkV+rgu3QF4rfjrWys7LdTDB?=
 =?us-ascii?Q?op/k8fIyB0WzllYXPlkssxZmYQR23KQ9VFLOiUSQ0ZDB+QPp13JuMPktxR5F?=
 =?us-ascii?Q?asUbh85ITyvCnT+MHRWnYs2nGaMxWZ5lRuqCtXreSPntz9q3aPopFylPZeqX?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8a6513-3a82-4130-3c47-08da73ce234b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 14:57:22.0655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FzusZcdtXe0L9CgPZqSD8qdhXWVm1tjFnBYWlG5CDHk16L27qswuMltxDip+YNk68iUKylZ6Wh7PI6SAhRr5v3sz6MaK3qcKuEUhxp8WOKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1456
X-Proofpoint-ORIG-GUID: PLcf-HgMlLt1btSop7AP-GCzw5roxv-w
X-Proofpoint-GUID: PLcf-HgMlLt1btSop7AP-GCzw5roxv-w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_07,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010075
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

commit 2d2202ba858c112b03f84d546e260c61425831a1 upstream.

cgroup_skb/egress programs which sock_fields test installs process packets
flying in both directions, from the client to the server, and in reverse
direction.

Recently added dst_port check relies on the fact that destination
port (remote peer port) of the socket which sends the packet is known ahead
of time. This holds true only for the client socket, which connects to the
known server port.

Filter out any traffic that is not egressing from the client socket in the
BPF program that tests reading the dst_port.

Fixes: 8f50f16ff39d ("selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20220317113920.1068535-3-jakub@cloudflare.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/progs/test_sock_fields.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields.c b/tools/testing/selftests/bpf/progs/test_sock_fields.c
index 3e2e3ee51cc9..43b31aa1fcf7 100644
--- a/tools/testing/selftests/bpf/progs/test_sock_fields.c
+++ b/tools/testing/selftests/bpf/progs/test_sock_fields.c
@@ -281,6 +281,10 @@ int read_sk_dst_port(struct __sk_buff *skb)
 	if (!sk)
 		RET_LOG();
 
+	/* Ignore everything but the SYN from the client socket */
+	if (sk->state != BPF_TCP_SYN_SENT)
+		return CG_OK;
+
 	if (!sk_dst_port__load_word(sk))
 		RET_LOG();
 	if (!sk_dst_port__load_half(sk))
-- 
2.36.1

