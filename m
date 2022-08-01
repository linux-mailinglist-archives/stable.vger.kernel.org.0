Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B83586D3B
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 16:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiHAOt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 10:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiHAOt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 10:49:27 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0203C8E7
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 07:49:25 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271EbfCX003454;
        Mon, 1 Aug 2022 07:49:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=PHpdUTK+oYasTN/puC0vGTIMrz9gw4JCQfRJe/Sjd6E=;
 b=lljqQU2IKA7S4+qa+eLfYUvrXbXrVXalyeEMdMNlPx8WRBnHX9qT0IxJAoqxfcn+XYgw
 qOyydrikF70/h8wSFje4ZKEF3vZbqIkWAKjvK21egsJqpUlKBoS4wv3qxmWpldbeR2qN
 s/mkIxKkc2mDJ9QacLOTbrS1oqSMsUdPpHqR6mGTgAGbwQiG3syeTzUatT8eOTZaeBh/
 Fg8Hp+eUPtKk2XCKs3pBS1+t+mNQQ5cTXjj7YuI9RsZI3W5wETS+Qdl7xphdw8Kw/uWn
 vT1OHygMfi1xzMAqo85lIfAy7vQP3ujR/qOPZUEjWSPbnyto0Hb+a+xlcQqNDw/yf2DX Nw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hmyx49fda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Aug 2022 07:49:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZR3d715oQl5M91Xi0gaTajG2CLHCk9COnPbyv8hXmhqbtncn1tFOoiCplhpffb7Hk5dDOj4FCo2EiKJH2Xxqugr2VWAHykgZzNmXlSWiAWSV6Yax3OLP7lZmOhF5TC4In7gn8DNDvINzsXIawZWE+DzHsk0s4qzGpeZ0kCv19sBb3Elafp9VQP0s2bZ+THMiOxICTT+Evd64SGSP4z3z9OYFzlKl83Ad618eRWjRVXe4GKaDz5M3Dlm5OWJ6xavY05w8I8FDGyMr7Ruy4XiMZTn8ew5852TkVv55vQiX/wS7B+oLvO9wDhRs+j7jsRxRWfLnKxIhL+Gc2luB2WwMMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PHpdUTK+oYasTN/puC0vGTIMrz9gw4JCQfRJe/Sjd6E=;
 b=Sk9SowYZoXHU4r6xbIzKZekNMmhOZcxjEbZuu/VNbnCvx06Ik3GSI5XFepoC/xC102msviZM5n2/h5PhckWu6hnVudQNAGNthbDwNgIlw2BS0cmDbTz7PM9pF4e7y5jyADxblCY+wZPca7ItL+8Bb0ALFwy9ubnq/B5Cq8eJkBoe1hT9f/1BVM57umxRMA/HvjZVq/WPzpnwWYpDY8RA1Stj43NQ0AVxHCX3hP8yjklGCIuWU/zD3IXTHLzF65aTkzU6TpdawXlTzF6oDZySNbVj/zXh/4n9zA303ifAVW+1N4IvI6vAeKqJ0PYleDinsd95bPBB/5N3vXvkHGSpRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR1101MB2216.namprd11.prod.outlook.com (2603:10b6:910:25::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Mon, 1 Aug
 2022 14:49:10 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 14:49:10 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.15 1/2] selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads
Date:   Mon,  1 Aug 2022 17:48:50 +0300
Message-Id: <20220801144851.1924122-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0221.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::42) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6f54c36-44d3-4594-f765-08da73ccfdfe
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2216:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4YmsYlgFjKDNHd7ZgQddnGZAHix/NlvsoCVwlIpdPugvoozuEs9pgcWtTBVedbJyF0BRsFB13k08MZ4jPvyxrbJDlXqt6+1UsQYO39qVVD34RrPgLIPjtXttyHz1J3ejxlAUc/CTUw0jaAle3Fk5wWjAVvsJZdz0/BD8d+juZx67OqylkthXWvIMGpV6iMFGsskHZzvTRWEu+QvTEksn7GP3enkVieU3TsAewmp97XqG8oyIodyABoleXqEW+UMYu1Jmx8UVDk1k4/yY7CEnwakB0ufzga3LWJ+PS5EZgpBczUhRrhNtBtBiVYWC17SUoYaYYMDENf+b3Ia/iCzsfbU/QvaYt4r+NMoQKrReTELFpCrQWDYWITNOiJR9VVpR2RjB27G6sDkt/PcRrWkg7WCWmfVWi6njtZ+R3FdzxSuTUugZ2b3xclrar/1UoDnEatmfR/mOZ1jz+Q9ZV8+DI4q0S8E8c70LeNODcZa9EDhEe8Z97KmRiMwhwMeIOtwIXeGOf6yTsolf4PT7scuUliDvcg2b6yISLTx2lBAznhy0U0IJuMFLYKdKLmjAcMHYKvAdKKhX/x47MtqMjrmlMzlDmJ9fYB86l5X5uQ8OtOsvPO2BlXqDyxGS7Ag39ByklKnLLKuaH6P62OSS/I8GdV9IlvjWnguvsck5yr0IdTDZAi+xcE1QCChjU7gX+f0+u/fLlpEJ+2XnAefiD/HTn3O4xEIFiQXMSGlwy59qEqn1bS7Tdvcuxlg+POl7I9A0kHoyMRXCr7YWp8B8kBkr8R162IrN3Jh9DYCpBH7wPhFPbQ5c/Q4/XkrkSZBprVOcgbWLfIAogD9ydI0s+NkxAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39840400004)(136003)(376002)(346002)(366004)(6486002)(478600001)(83380400001)(6916009)(966005)(8936002)(54906003)(4326008)(66946007)(66556008)(8676002)(66476007)(86362001)(38350700002)(38100700002)(316002)(2906002)(1076003)(107886003)(41300700001)(6666004)(186003)(44832011)(6512007)(6506007)(30864003)(2616005)(52116002)(26005)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c/+XBlJn8CDwxa1lFO1om/tI8nFnJMuUKt/DPbWaLaB2R6Wq7qJIfdyv8pQU?=
 =?us-ascii?Q?/tUlf08FLtUL5GOy21QZiFaga47bEv7hqgPkIiz6UdCNI1lW2vHwHadf4V15?=
 =?us-ascii?Q?u4U91YBrUVojBULxuRzQi9zoAwApd2A1PUXq4YvBiBm6gPRFxAHEklb6Iw/S?=
 =?us-ascii?Q?4mpXlIrn02c3Vt6GbN5jUPBa9HHdrXAMd55PTW/Nf3ly7RUIBhAIYPE/vfLr?=
 =?us-ascii?Q?k/ylwIwyvLbrs9IN/onmO1UuGFlaPN9orxL0m9ROH/9/UGXkPzufliI9Njw/?=
 =?us-ascii?Q?dnDCRDfwQ6pXz4m/wXSz9hAmQJ/Kme53Ud8Y+VC/59kQxFqD67udj2ZDQt1v?=
 =?us-ascii?Q?ljYKu+5Zo/ZmMadAlYmScn9NFmtdHm+WecRd0m6//24xVpMcbyWtTazDjHYp?=
 =?us-ascii?Q?M/6kzpldMA8XbXYafVQqtbCrru9ATyfu9ZgjhnQO+9TfPBbh4w5brXGqHwG0?=
 =?us-ascii?Q?sMiiCt2u4JzFN1d+zLKoiXM5VGxd+dBIOKZH0CwAR0RsmdVv11RQwznPPpmp?=
 =?us-ascii?Q?XG3gj8+tHBT63imYU5XndRLvqkPN3zgMA15uyrUADyxdCAoZbjWEqj6+v9Ws?=
 =?us-ascii?Q?4qOZrHnZGibgkIevZZOZSHQqLYJ8tD7K2995KO7Ze6SuSzajotazfj0Mx7IL?=
 =?us-ascii?Q?U0wxs+WFqhdmjks8ozUJcMm00vc6hRWiuFXsf0xBOlwtVJHmhPupv26Jp6OS?=
 =?us-ascii?Q?BAjObWtyOk/q9WBVCmGSVQHdLCLX0asuArcQQF8QFXHNHgOVEeNCDKhFXUPl?=
 =?us-ascii?Q?abqsUfbc9wRzTroN/FPGV3jtCyLOV2YiuwMdWesn0UV/k+C+DPEGarL4O3UL?=
 =?us-ascii?Q?oojNWtgxeJdlc6EhdXZh+pA/0cViEiibLtbJ89xqaCtmqe/VJUN0xRn9XYI2?=
 =?us-ascii?Q?fvCWnbBuBk/PC/4s+3sEGIDcaLIlC5csi1D4YdHBDue2PJ2VqdG0rNBrUD0C?=
 =?us-ascii?Q?XsXCW6ilY4TUnsz0uGCfgtWS7uhq+eRPMyROoPgI8Sep3y3csPq4MqDnOA84?=
 =?us-ascii?Q?9TxfrCrITvBgzh9U2AQ9c14Q7uC3Kco/9QeDQNs/l2z3f83EoUIxjv97CJY2?=
 =?us-ascii?Q?ry51BKZsYZvSPCsJ6y4XH3tN/7ZXUYt9FBWXMUA0z1ph29HyIy9mhkzupE6o?=
 =?us-ascii?Q?cMT3U4TnAw7YnyK3hrCRqNFgSNCdaBZne2x4q/PQ1QagINt2nIoXLrlgLMsd?=
 =?us-ascii?Q?30Al9lE3GYreU93gTJtona/GnIpQrLeSr2TS8DhGGm/118wyNaT7EhhRd0ZP?=
 =?us-ascii?Q?0YIKG2Myw4xDevitSd1rq6buMkdWjVdYFuhiyzMmAL4izcQwBMvvn0pPYYPc?=
 =?us-ascii?Q?/kqt9uAZzvn0gce/zpHJKr/lfjkU3yFIjfu/aZfwYDiRm0ZWy8Sh9n2d4u0Z?=
 =?us-ascii?Q?MpWpU7f2ZBsJ062VHIfO7nVb0et6WrgPAo2gaIFGroYAN3Rfz9vIgc84VJD8?=
 =?us-ascii?Q?3enVVOOocbtUDxoC/94qOF5thB3J0wLQqiUwcjO7YDjAl99HOs+zR5MFnE0g?=
 =?us-ascii?Q?ZBhBPzFKunhmVmbCcSa6Ahsz00ewud0ocsW1QnNmTaLN8jXERwHV4IHBfAdP?=
 =?us-ascii?Q?jT8sT/ZEthn+lKV+VcLBMdOf/2ICJd8xB7mOKEx/9b6uF9OYnBWCP1NZavaj?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6f54c36-44d3-4594-f765-08da73ccfdfe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 14:49:09.9932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gfPTFjTIuFecypz7FR1kn2+r2r4O2Wc4/uARg8oCOWQYM1CEuDWjnpvjCeD6Q2NfuLRmVlZ4xaqQu50/5LtJbZxqu7VxY5Vo62Cj+MoH6aY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2216
X-Proofpoint-GUID: OYZs3v25DM9AdnsS-xb3Q4NGQ1jGKwl9
X-Proofpoint-ORIG-GUID: OYZs3v25DM9AdnsS-xb3Q4NGQ1jGKwl9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_07,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1011 mlxscore=0 malwarescore=0 mlxlogscore=968
 spamscore=0 impostorscore=0 adultscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
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

commit 8f50f16ff39dd4e2d43d1548ca66925652f8aff7 upstream.

Add coverage to the verifier tests and tests for reading bpf_sock fields to
ensure that 32-bit, 16-bit, and 8-bit loads from dst_port field are allowed
only at intended offsets and produce expected values.

While 16-bit and 8-bit access to dst_port field is straight-forward, 32-bit
wide loads need be allowed and produce a zero-padded 16-bit value for
backward compatibility.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/r/20220130115518.213259-3-jakub@cloudflare.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
This series fixes the following bpf verfier selftest failures:
root@intel-x86-64:~# ./test_verifier
...
#908/u sk_fullsock(skb->sk): sk->dst_port [load 2nd byte] FAIL
#908/p sk_fullsock(skb->sk): sk->dst_port [load 2nd byte] FAIL

 tools/include/uapi/linux/bpf.h                |  3 +-
 .../selftests/bpf/prog_tests/sock_fields.c    | 58 +++++++++----
 .../selftests/bpf/progs/test_sock_fields.c    | 41 ++++++++++
 tools/testing/selftests/bpf/verifier/sock.c   | 81 ++++++++++++++++++-
 4 files changed, 162 insertions(+), 21 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index e2c8f946c541..8330e3ca8fbf 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5347,7 +5347,8 @@ struct bpf_sock {
 	__u32 src_ip4;
 	__u32 src_ip6[4];
 	__u32 src_port;		/* host byte order */
-	__u32 dst_port;		/* network byte order */
+	__be16 dst_port;	/* network byte order */
+	__u16 :16;		/* zero padding */
 	__u32 dst_ip4;
 	__u32 dst_ip6[4];
 	__u32 state;
diff --git a/tools/testing/selftests/bpf/prog_tests/sock_fields.c b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
index 577d619fb07e..197ec1d1b702 100644
--- a/tools/testing/selftests/bpf/prog_tests/sock_fields.c
+++ b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
@@ -1,9 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 Facebook */
 
+#define _GNU_SOURCE
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <unistd.h>
+#include <sched.h>
 #include <stdlib.h>
 #include <string.h>
 #include <errno.h>
@@ -21,6 +23,7 @@
 enum bpf_linum_array_idx {
 	EGRESS_LINUM_IDX,
 	INGRESS_LINUM_IDX,
+	READ_SK_DST_PORT_LINUM_IDX,
 	__NR_BPF_LINUM_ARRAY_IDX,
 };
 
@@ -43,8 +46,16 @@ static __u64 child_cg_id;
 static int linum_map_fd;
 static __u32 duration;
 
-static __u32 egress_linum_idx = EGRESS_LINUM_IDX;
-static __u32 ingress_linum_idx = INGRESS_LINUM_IDX;
+static bool create_netns(void)
+{
+	if (!ASSERT_OK(unshare(CLONE_NEWNET), "create netns"))
+		return false;
+
+	if (!ASSERT_OK(system("ip link set dev lo up"), "bring up lo"))
+		return false;
+
+	return true;
+}
 
 static void print_sk(const struct bpf_sock *sk, const char *prefix)
 {
@@ -92,19 +103,24 @@ static void check_result(void)
 {
 	struct bpf_tcp_sock srv_tp, cli_tp, listen_tp;
 	struct bpf_sock srv_sk, cli_sk, listen_sk;
-	__u32 ingress_linum, egress_linum;
+	__u32 idx, ingress_linum, egress_linum, linum;
 	int err;
 
-	err = bpf_map_lookup_elem(linum_map_fd, &egress_linum_idx,
-				  &egress_linum);
+	idx = EGRESS_LINUM_IDX;
+	err = bpf_map_lookup_elem(linum_map_fd, &idx, &egress_linum);
 	CHECK(err < 0, "bpf_map_lookup_elem(linum_map_fd)",
 	      "err:%d errno:%d\n", err, errno);
 
-	err = bpf_map_lookup_elem(linum_map_fd, &ingress_linum_idx,
-				  &ingress_linum);
+	idx = INGRESS_LINUM_IDX;
+	err = bpf_map_lookup_elem(linum_map_fd, &idx, &ingress_linum);
 	CHECK(err < 0, "bpf_map_lookup_elem(linum_map_fd)",
 	      "err:%d errno:%d\n", err, errno);
 
+	idx = READ_SK_DST_PORT_LINUM_IDX;
+	err = bpf_map_lookup_elem(linum_map_fd, &idx, &linum);
+	ASSERT_OK(err, "bpf_map_lookup_elem(linum_map_fd, READ_SK_DST_PORT_IDX)");
+	ASSERT_EQ(linum, 0, "failure in read_sk_dst_port on line");
+
 	memcpy(&srv_sk, &skel->bss->srv_sk, sizeof(srv_sk));
 	memcpy(&srv_tp, &skel->bss->srv_tp, sizeof(srv_tp));
 	memcpy(&cli_sk, &skel->bss->cli_sk, sizeof(cli_sk));
@@ -263,7 +279,7 @@ static void test(void)
 	char buf[DATA_LEN];
 
 	/* Prepare listen_fd */
-	listen_fd = start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
+	listen_fd = start_server(AF_INET6, SOCK_STREAM, "::1", 0xcafe, 0);
 	/* start_server() has logged the error details */
 	if (CHECK_FAIL(listen_fd == -1))
 		goto done;
@@ -331,8 +347,12 @@ static void test(void)
 
 void test_sock_fields(void)
 {
-	struct bpf_link *egress_link = NULL, *ingress_link = NULL;
 	int parent_cg_fd = -1, child_cg_fd = -1;
+	struct bpf_link *link;
+
+	/* Use a dedicated netns to have a fixed listen port */
+	if (!create_netns())
+		return;
 
 	/* Create a cgroup, get fd, and join it */
 	parent_cg_fd = test__join_cgroup(PARENT_CGROUP);
@@ -353,15 +373,20 @@ void test_sock_fields(void)
 	if (CHECK(!skel, "test_sock_fields__open_and_load", "failed\n"))
 		goto done;
 
-	egress_link = bpf_program__attach_cgroup(skel->progs.egress_read_sock_fields,
-						 child_cg_fd);
-	if (!ASSERT_OK_PTR(egress_link, "attach_cgroup(egress)"))
+	link = bpf_program__attach_cgroup(skel->progs.egress_read_sock_fields, child_cg_fd);
+	if (!ASSERT_OK_PTR(link, "attach_cgroup(egress_read_sock_fields)"))
+		goto done;
+	skel->links.egress_read_sock_fields = link;
+
+	link = bpf_program__attach_cgroup(skel->progs.ingress_read_sock_fields, child_cg_fd);
+	if (!ASSERT_OK_PTR(link, "attach_cgroup(ingress_read_sock_fields)"))
 		goto done;
+	skel->links.ingress_read_sock_fields = link;
 
-	ingress_link = bpf_program__attach_cgroup(skel->progs.ingress_read_sock_fields,
-						  child_cg_fd);
-	if (!ASSERT_OK_PTR(ingress_link, "attach_cgroup(ingress)"))
+	link = bpf_program__attach_cgroup(skel->progs.read_sk_dst_port, child_cg_fd);
+	if (!ASSERT_OK_PTR(link, "attach_cgroup(read_sk_dst_port"))
 		goto done;
+	skel->links.read_sk_dst_port = link;
 
 	linum_map_fd = bpf_map__fd(skel->maps.linum_map);
 	sk_pkt_out_cnt_fd = bpf_map__fd(skel->maps.sk_pkt_out_cnt);
@@ -370,8 +395,7 @@ void test_sock_fields(void)
 	test();
 
 done:
-	bpf_link__destroy(egress_link);
-	bpf_link__destroy(ingress_link);
+	test_sock_fields__detach(skel);
 	test_sock_fields__destroy(skel);
 	if (child_cg_fd >= 0)
 		close(child_cg_fd);
diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields.c b/tools/testing/selftests/bpf/progs/test_sock_fields.c
index 7967348b11af..3e2e3ee51cc9 100644
--- a/tools/testing/selftests/bpf/progs/test_sock_fields.c
+++ b/tools/testing/selftests/bpf/progs/test_sock_fields.c
@@ -12,6 +12,7 @@
 enum bpf_linum_array_idx {
 	EGRESS_LINUM_IDX,
 	INGRESS_LINUM_IDX,
+	READ_SK_DST_PORT_LINUM_IDX,
 	__NR_BPF_LINUM_ARRAY_IDX,
 };
 
@@ -250,4 +251,44 @@ int ingress_read_sock_fields(struct __sk_buff *skb)
 	return CG_OK;
 }
 
+static __noinline bool sk_dst_port__load_word(struct bpf_sock *sk)
+{
+	__u32 *word = (__u32 *)&sk->dst_port;
+	return word[0] == bpf_htonl(0xcafe0000);
+}
+
+static __noinline bool sk_dst_port__load_half(struct bpf_sock *sk)
+{
+	__u16 *half = (__u16 *)&sk->dst_port;
+	return half[0] == bpf_htons(0xcafe);
+}
+
+static __noinline bool sk_dst_port__load_byte(struct bpf_sock *sk)
+{
+	__u8 *byte = (__u8 *)&sk->dst_port;
+	return byte[0] == 0xca && byte[1] == 0xfe;
+}
+
+SEC("cgroup_skb/egress")
+int read_sk_dst_port(struct __sk_buff *skb)
+{
+	__u32 linum, linum_idx;
+	struct bpf_sock *sk;
+
+	linum_idx = READ_SK_DST_PORT_LINUM_IDX;
+
+	sk = skb->sk;
+	if (!sk)
+		RET_LOG();
+
+	if (!sk_dst_port__load_word(sk))
+		RET_LOG();
+	if (!sk_dst_port__load_half(sk))
+		RET_LOG();
+	if (!sk_dst_port__load_byte(sk))
+		RET_LOG();
+
+	return CG_OK;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/verifier/sock.c b/tools/testing/selftests/bpf/verifier/sock.c
index ce13ece08d51..8c224eac93df 100644
--- a/tools/testing/selftests/bpf/verifier/sock.c
+++ b/tools/testing/selftests/bpf/verifier/sock.c
@@ -121,7 +121,25 @@
 	.result = ACCEPT,
 },
 {
-	"sk_fullsock(skb->sk): sk->dst_port [narrow load]",
+	"sk_fullsock(skb->sk): sk->dst_port [word load] (backward compatibility)",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_sk_fullsock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, dst_port)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.result = ACCEPT,
+},
+{
+	"sk_fullsock(skb->sk): sk->dst_port [half load]",
 	.insns = {
 	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
 	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
@@ -139,7 +157,64 @@
 	.result = ACCEPT,
 },
 {
-	"sk_fullsock(skb->sk): sk->dst_port [load 2nd byte]",
+	"sk_fullsock(skb->sk): sk->dst_port [half load] (invalid)",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_sk_fullsock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, dst_port) + 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.result = REJECT,
+	.errstr = "invalid sock access",
+},
+{
+	"sk_fullsock(skb->sk): sk->dst_port [byte load]",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_sk_fullsock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_B, BPF_REG_2, BPF_REG_0, offsetof(struct bpf_sock, dst_port)),
+	BPF_LDX_MEM(BPF_B, BPF_REG_2, BPF_REG_0, offsetof(struct bpf_sock, dst_port) + 1),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.result = ACCEPT,
+},
+{
+	"sk_fullsock(skb->sk): sk->dst_port [byte load] (invalid)",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_sk_fullsock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, dst_port) + 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.result = REJECT,
+	.errstr = "invalid sock access",
+},
+{
+	"sk_fullsock(skb->sk): past sk->dst_port [half load] (invalid)",
 	.insns = {
 	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
 	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
@@ -149,7 +224,7 @@
 	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
-	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, dst_port) + 1),
+	BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_0, offsetofend(struct bpf_sock, dst_port)),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-- 
2.36.1

