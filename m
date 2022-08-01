Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E567586D3C
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 16:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiHAOte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 10:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiHAOtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 10:49:33 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D783C8C1
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 07:49:32 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271E8Hcx020614;
        Mon, 1 Aug 2022 07:49:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=EiElRW9YaoHPMhvNEknJpArkaElh9FoYgBlhLAfM2uQ=;
 b=URIa3lrk08fTWaZg9RWd+tFpmqLloT/ZtVF5EEmkxB5NG8aTLrVcnp+W7iI2VNflVS2q
 Z7eca1qy4o9AvwlnS6SRx77fzwRAAHJW0NwVmP0sBzoir+YDBGkE95qsh9AaW4V79Hf5
 svEEvzD5pMUMM4aca9Jqrq2NBu7Kmm+NZqBlYphgIFxphlRP847ma4AeGNujLqJYvfcc
 0EHgKsBcGypAsyKzVrfCgLGiXcK+Rt+zGuP36uZNGcB4etBdAXX7p2C+cB6REcd8lyhO
 2hD+pwWlh0xjeJks2oWtIHvVlbGyoAyhOBqDJPpZK+XwYIUSjIiKFpVN1GAXxVlEWDO1 cQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hn45jsbg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Aug 2022 07:49:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YpvnezgPMBoTGgn/yFEyJ4zjy74ONfBcgz4A2H8cOVYXOkidr/DZbC85np7sfM8xvtUfDF03Vapx0aEdTCo2wQFeo0wNvPy/3/WlcFA1AQqyv6NWBNWmPggV3h3N4G3CgcnWeDUyTWSE8zEKDkbl16ovrCBu9pYHr6yMGl4mYIF6C760XDf9UwfvAtHrFmUFDXkU/e8D8yohDeiy9sCxtMlJfeFLv/Vs53dBb4FNxnJkzYWhnQfBZ7/P6cSezwq3mzXtNmRQ2ZN6O8dSa3Gr6tiJ1vCPsxOrFxJYziqH6Q/xaRiB5eDsSHnh8Q2A/BWDKwyw3Rg2URrAguwfJWCqQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EiElRW9YaoHPMhvNEknJpArkaElh9FoYgBlhLAfM2uQ=;
 b=Loccd5wkQhpdPISNbrdul6qumqs441urX5QswIAy0jbxRQVASMvF5dtYtNzgCl5enW9jjmF57t8vLwgjYQ1cpIqhrzuL9sQXKJK4tC77AY/rxdf2gCtFplsAAg8Y/5zfkNtCC3F/Pm/IjSKllr9zSAgmXFKXWDah1P7+iHWfEd8glNeBPTNOU7t66c8RXm5d+Pu+dTHWAZAZddemz1Qt4cdq3eyqMXXU/nZ4Ee+/ZPCat9I335DdaxqPwgfaJmTx9A9tiaWruhVvqBIh7j6EX1/ay1QFJjyTKlVsVGmnGL20MD+TwDqautXrgYy44mP7fA8jyzaD9ykhQm1wDvRYrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR1101MB2216.namprd11.prod.outlook.com (2603:10b6:910:25::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Mon, 1 Aug
 2022 14:49:15 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 14:49:15 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.15 2/2] selftests/bpf: Check dst_port only on the client socket
Date:   Mon,  1 Aug 2022 17:48:51 +0300
Message-Id: <20220801144851.1924122-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220801144851.1924122-1-ovidiu.panait@windriver.com>
References: <20220801144851.1924122-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0221.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::42) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3c1d593-854a-461a-f8ad-08da73cd0127
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2216:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lLEtoNXO3vnekdanEeYF353ZWwuajwmgpTHcIGyK7ZYv/7lpZ5jpBrO8gp1IkB6gYADQUXUFISacz2cSqdr1PhJFuLgjka1eO2WRtzQXWmWqWV3seyPWHD4jIWuFIXwAM5ZVBAWTdUxEbnL4okvgUu6TYhqMIve/VJPnxU7ADbjKHw6MHttK9BgFVHWfPfmyz4AmL+hRU5AIJuyb9sySrYkUYnDW5KrNzoHlv0uWtQ3z09fgjVyzJ8i7GIxMJoKlkMO83xPVb3EFI7pswM4FMuXqf4Hw5D59qCs4MzlHiEE5BmZEFaY6I65KrD8NdudgDTfQYCvwt8Ey+KQZOM1oRlXBDkHPcOTMPwcuCSm7wybcnX40r39yIOUQcKPiRQ+5o6IvTw+uICRHejY263MAFVjGrNpjIOOn6QNhxY8EmyqRJzbGauzy9RKP6ycJofEkoIcb8uVtTFUyB3IVEWQKPMIxZCrrm4to19RJnFOlXF/MoJ5vZj/YsjIZ4/KayICeMCu9IV2xvOT56K3LrHfeMj8+NUrvYfCI7NJanXugDP1QqGjw+G3q7/6BH1kvvn6x4Gk8+wkDLm00DlUs/rZxmX5iODFaHMuXNaWUSFAV+GUi2+F+BZiXuQqCFv94DPCNZ6XVPj1WBb+OLrUq6BJYSABAjYnxHgG5mAJUt2OEpTC6YR3eIhiqxffvcxulnp76Te5K9JVoGqB4L/xX66ISQTXxHW/WhiUVyr22l1nbVrw9dlyCYNYlaebwNgAantvdDyXxx7Ji+mnvr/C7CZpEPhd/aXXing3NVQW9qYDGCauy7vw/2xmbUpYihwxA3Wb9hi02GMiCfxEdA+J851AmIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39840400004)(136003)(376002)(346002)(366004)(6486002)(478600001)(83380400001)(6916009)(966005)(8936002)(54906003)(4326008)(66946007)(66556008)(8676002)(66476007)(86362001)(38350700002)(38100700002)(316002)(2906002)(1076003)(107886003)(41300700001)(6666004)(186003)(44832011)(6512007)(6506007)(2616005)(52116002)(26005)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RTbCN3FXT5ESgSd7Eiwq+EFleDEFceXH8aBFbYi/s3NL5KPSPb7sINV3GTZP?=
 =?us-ascii?Q?6XF5YKP7xlvG8tyvXbpMMmzyVQZ0g0zm42zp1EbQIoHJPDi69O4kg5X54Wel?=
 =?us-ascii?Q?CVjGjJqv7WMccc0cHSiV/qsm4yKr1tHnTVR/7iPEwFDuLehKvipIEeipttqb?=
 =?us-ascii?Q?TwkrPIjjRuwNX7MQW3tS9sQEugLHbORCG88XSyP6b66tqRe14HiV+GRFpt8r?=
 =?us-ascii?Q?ClskqrYat20s1aSCRBgj9pRpU/GDK/XCfaBjVfQkvDiUbltnKEVUY5d3Kzio?=
 =?us-ascii?Q?8620sIXTKkslhh14jy+e+qMbJeykWr2k56M5Mu86I5N8JJbGP8P88f9GFZQy?=
 =?us-ascii?Q?e3oMRq2+98nXVXxfpqv0rMf04mGsG7qJJ9Wm2p58wPRxODoMzGxKnshsEA5z?=
 =?us-ascii?Q?c+QOBI2izbmMTyKM9aH/CCmkfstqmZhFZkyc+oyX1pvPtu0dQXUlG19xPlpx?=
 =?us-ascii?Q?krBvw6TEcc8yuthEo8ndqs4povYlT+dTjmzRBmIdxp1v6iXq0bomK6iVILtP?=
 =?us-ascii?Q?Wf8Zzdpu+QAPg/oLUTLy8jPFTSG/Wz6s3oGFdaCxBRB0ZmzwrY+4K2fuTjho?=
 =?us-ascii?Q?iwlbaP2L4J9YUKqv+KnF+T9ZlzdmdJTs6wr+43ONKN7jmBRBUzt1rWkK1Jur?=
 =?us-ascii?Q?b2SycU+zCZW8rWNNZjEM1Htz/LzjlA7gWmFSYzG39qcdWL6bxqxsE1YncEhf?=
 =?us-ascii?Q?2m1H/eoV8tQP17trQwNbPFD9/F0qTxIMipbRlvfYBbGqZXVqfcdnnk1MT5qf?=
 =?us-ascii?Q?TfYrA8OBjIP8LEl1wBV9+WhBO54EnBxQimql5qYK+J2CSU6E+1pDt0uqJSAS?=
 =?us-ascii?Q?TJBZmPEx/PGPOzvcwNFCxBpb+P6q4bkGsd0t4ngTbRCD6KM4Ozb9rLwqgbYl?=
 =?us-ascii?Q?h0YnHoxnC5T1W8j12lQBXLskqS1e10qIi7B/hlmvb1pAcda/+u2D17wRVdgW?=
 =?us-ascii?Q?pgt+qnMTnTgMoaEDB3B0qMmgxhNC6SFB6hhaBBgEbOwC0cDi2j0kzT/Mnj1u?=
 =?us-ascii?Q?bMHkO3QCgNC8iYcLAzsfaT/p4nmVYmnXiFuxRxK7IazYUMYgvkWRchdto5GN?=
 =?us-ascii?Q?Y0bbjpslT9yTSmN7R54TxvlgzovQywJc5PkT+v8SdII3L/ufTyX/Z8pZ2RB5?=
 =?us-ascii?Q?gjViUByICbtXXJys3aFa66A0zSky3HxioOROpiz4icjWoujykTaYIFmWLZRV?=
 =?us-ascii?Q?ErhauuOBKJWBYiFyR75rmDsGkj/ibDxrtQV5b244QAaPnZYZO/rH84SIS5+D?=
 =?us-ascii?Q?lBOYxIgfpn1f/Ek4sujCmjZDQTFY3wvZR2PzH3TUEh9vfypbhwaecFeMR4JY?=
 =?us-ascii?Q?CK2IClGmQqL3sY2I/HS97A9qDPMpUD0i38xV68W0wa/GUtHwP/1YaIJiTZ9k?=
 =?us-ascii?Q?fA86PE8E9vELXZhRFtnd1vBheMD1EUW2ZOf8cKwGESoWQdyWFpUXefHbXEeP?=
 =?us-ascii?Q?wCMIcW+zOF8hcLV0V6URR2ejkZh5OHpfJGM2Sv2pGzxLJyqEQpm3j2R9XTnu?=
 =?us-ascii?Q?tjjzss6VWCf7RTrB8dr77nsN6DaBOyyQkToOxfVxbdxQ0qLkANf/uQ+Ph88C?=
 =?us-ascii?Q?hhP1L9S4+2n8dQlrpXHZ+hcHpiUzIHOhPJgCIhgSD1SSHMDnR5RzGJCnoVA/?=
 =?us-ascii?Q?YA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c1d593-854a-461a-f8ad-08da73cd0127
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 14:49:15.2482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OiPbHSW4Vqw6cC4jeQo7UjHIbdhVcNcPKTqSaEuWbPrCITyIIq8saa+y5l2mklE30PiNK4WRgm5+vqPRNp2d8eyH7j9a4sUN77op2vDrPew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2216
X-Proofpoint-GUID: ae_0LUKW_TGeDkzkijV8h2-ZIVG8dBWA
X-Proofpoint-ORIG-GUID: ae_0LUKW_TGeDkzkijV8h2-ZIVG8dBWA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_07,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010074
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

