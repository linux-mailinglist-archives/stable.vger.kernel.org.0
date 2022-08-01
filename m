Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2AB0586DBC
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 17:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbiHAP0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 11:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbiHAP0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 11:26:32 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FAA220DF
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 08:26:30 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271BFd85030076;
        Mon, 1 Aug 2022 14:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=orasJS6QsQjjl/aDpF4472TdWplEy37cFDfYhVx8aQY=;
 b=q2kr7h4Qx2a+vuGsUVdfp33syx9KIRJ25quGN02y40SzgB6Q4g222PScy7C+cim0cTbD
 EEPMkwuemkE1DEintlYUzmLF+xeS9eqOtj4C24+aWsNOgOjs4V3j8qI5V5QcDWjUrmhW
 EdNvvN264YRqFaAPP4l+rc+nPANn06Jmh/Bgvt3Av6Leg4tjJSRbNlzZTYv5tqsrw2/p
 wWVp+7dPFGw2dYuJdyTu+Z4mzJMXUowD0bk2vV6KlgGgJpc7IE+Im6gZYnnMAJcTgOXQ
 10HzoUzfLac/d/qUa0+qjU2C7vWhfLyFi4HviXq3TFLKvihBcHmXceu9EZE7Q4bgJeDn 7g== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hmum91jrq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Aug 2022 14:57:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMv0UtcDX4kRIIkUqiQpjkvBNjqZ1IHQPw88jNIFM1vVXbGdp3N7sDKa85eDsvprsnhhAd1doqYgiEZL20OzItGSn/hOtEXCWnDVABZYiK0+YpSmtGVKPXDLp9sgsb96NI+HEWG2q2L8OEESiAxu7xqw/FE+MdYTo6OQMR8gYhiJSYBz8aAqyhxriK4AjSIRMPcVXi4sFseNSM23CLOoXeFIW7aI6zy71Ieo45a8pfXddsnByVdmivm6gajXcHqfMb1CtWzBhsraHgCqLJAoMRRvdrnWcr/YoQojuooJ9Fsa2RXw7Fri/LDsKeX50fntbChTj6qa5Totnj9DmOirsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orasJS6QsQjjl/aDpF4472TdWplEy37cFDfYhVx8aQY=;
 b=h/7tA62lATS75u83PW+2iGuzJ6QZU9vc2lTtI9tbyTKCjd5XeEsbqhLWTdukla63v17TFprQ7erdgyAxGF/e4XKrb7gdF1xg2DdU3oiFEtHAAAkc+qA622BlbnwXcrwWlwz3ZNfxWfG+gzRMJN4nwfVFfSSRwP1gBZ5cigpps4lYyEr964lpx7i+2ihgwMMigQVvHyzvYWpLgg1bfM6Pp35jIg4ITgEJ9p69CAZ0fK61skN3P4Yn9AoLJ03DmMWk3n6uubaO6Akhw6X6uCHPona7jjs/w3M6SZIhQrqVVE76PyfQ/mi4rUw2z3EeLnQ/N1sSwgdG/gnEdjlEfnEpRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MWHPR11MB1456.namprd11.prod.outlook.com (2603:10b6:301:b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Mon, 1 Aug
 2022 14:57:20 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 14:57:20 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 1/2] selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads
Date:   Mon,  1 Aug 2022 17:57:02 +0300
Message-Id: <20220801145703.1929060-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P193CA0015.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::25) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba3ac480-1a78-40e4-5e58-08da73ce2247
X-MS-TrafficTypeDiagnostic: MWHPR11MB1456:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZP3Yh/D26XS9Njc8T+0lHOiih8G4+F1V6REtr/N4mEnJtxDj6LZPFyV2nL+cR34AO/ztTloSONNM/FtC8nyErnE2gKOFjCSUVkKDvu3fOHhequg3adedSjY3K0resZzVNxke5DcbxeagutiCAclOeNhY3IA9Otb9DuojNUN8U0nzYiR/S8ZS6pCZkCdg0UDckESgTR1MaSlqaZ38W8Wjpi/P1gpj6zb+ej3IwOW8Z7xQ8he30gFyxXOVxu3MfFgY4nBcv6BsLFPYnqstq8mJ7UFjpcAHsTi2hC56k8yEr9m+IKtDpBl7FRz3dWOtDXWhV6AZQCLHfUFWIlQMR+EruYrIrQk1tmvzhkokFDtb1nEMLbv/6sRJM9IfLcrp84/pGztvSTvwcY3ZvAlHKzNo0JjGct9bSw9iyNqTUdxm2etZjaySVRIXXcQfeyyFh6sRShrqD+zvPlnMdkcGyMAvCjoUcvm54bya1+9bCNyB8o15T9lWvcRFRVRcqJQAMU7/W+RFYpgDZnhcEVZtIpSxHpaOWU7R936aEWiFhJWtGgWjcmYNt4dWTGoIhPxhz39a/df3BnP9CacSDmt4MyA0uQqUgrkFksT8hQWmY8m4+p96BbB+F4iuR7NOQ+Uu4RCTBGNDyCQIC/kXHOjJVCduGew9GSPLPsqiM0k48z0c5p1RS74GZBC1c8JO77cdzh+AJXJyeBCWQSnBPppdUzkNsQcE+4vw9QYYUw/04rKhxKG5AuUGSdGOhkEzC0deUHJ3s+G/cgO+XFERZU5SZoP5GIuumLAYWSbcKBi49xf/MMukuExujeWbwCM9Spu1pZd/lQBNEer5CoYIrgiKtmYPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39840400004)(366004)(376002)(346002)(396003)(136003)(66476007)(66946007)(8676002)(316002)(41300700001)(66556008)(2906002)(4326008)(36756003)(186003)(6916009)(107886003)(6666004)(54906003)(1076003)(2616005)(83380400001)(38100700002)(26005)(6512007)(38350700002)(6486002)(86362001)(5660300002)(8936002)(966005)(478600001)(6506007)(52116002)(44832011)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z3wYlbLn7FlvocAv5cPtrrr3ecpHET81u38SFx5RDZJXxixG5+YV5qihdmfa?=
 =?us-ascii?Q?1CbljW+T4RKm44mjUxXtPmpXbS0ryrX/zPeeIBzgIoHrz5b3k1nIM5u6Q+qL?=
 =?us-ascii?Q?fgF690L9guQXCR3hjRgC+HIhdYkwVPStXjRtYbq4pyZzu0oSdFMQJMJkt3mC?=
 =?us-ascii?Q?wR3zs283wE/AAWZikgGRVgWPIrPLZ4JhuhrDH6zCSFeJnmlK55WQjjVnVlur?=
 =?us-ascii?Q?vwWDd8xMGLfP/1cuefbaIut5OfPrEDmugFLsZgD0GssIKE7eGnajhANwvOVU?=
 =?us-ascii?Q?1tE3fO4YpWD6EqS2YtpnWLFYRz5WfnWwiy9J4f1WvOKnBkipXYOpcWiuDejs?=
 =?us-ascii?Q?1emnAWdXhuri/uydCHmW6yUrjKTHw02HE37lKOvlLGk2tZyZdZxS3/cn7K4e?=
 =?us-ascii?Q?G8tcLomjj2tHPIHaZR3DkwQtWmrE9z/X62sU2Xebra71eQdJFV6tB38IcazE?=
 =?us-ascii?Q?gHzvhM6gCsZolejJqVcU6D4PkCb2mRT4niWO9kX3yHC+Ff2MXPvrlJf93T/D?=
 =?us-ascii?Q?Z6bd72BTUBVXlrrnY8jz4ct20HySIwfl60B0t180Zv9uNswvmYfAOlF/TKc0?=
 =?us-ascii?Q?avyvqMCXna6YA6RLyBK6H6TbFs+fUair6lQGr46PBJEgx5duTjdEKmqZ/Sqh?=
 =?us-ascii?Q?douw90qZ/tUKwPVe/tvIWuakxnj1uZJkEssbi6LsNy5+u/fzClUFK30MMudg?=
 =?us-ascii?Q?tx/Fomwk0R5QsU8F3uAuZsDzoFeqgImGSElfNNBgxFbtRc1+KJ9TuN8E1dUb?=
 =?us-ascii?Q?cm+5qu5g8pj6PVWH/cXP7er4mji3alg6hW4Fcal3Ay8mEMSEnHwH7Jb7LLEB?=
 =?us-ascii?Q?hNxf/RFgmHqGnZnKQqErIz3YP/oicwU+sEE+yq9Z2WCaqmU7riHChxanVrEj?=
 =?us-ascii?Q?cZhpoZsxe9OSSK6vWRBzoMbyb0vfXnOmJDwAcB0s0ukYaXs6K3U2TSB7S2nj?=
 =?us-ascii?Q?VA5t5ArSyIUrxq945rYXWkweuTTWAbGjHMdAqAojX3GAgjzFQaQO1rTRoIRy?=
 =?us-ascii?Q?UZ6ZIpNptH6iFx4hfVwtGuE/e0VEaKUfMtmdAQsBEK2ZNpjH09GLe0/I8y4h?=
 =?us-ascii?Q?+6TIqAoFwXLTfojAZ1ZX9QNaar98oT1vlA1jnCs6f9f4Bg3FlgfQ+df9vbcK?=
 =?us-ascii?Q?L1SZW9go+dfLEjRiylqSgRNEeHINsp1aMxn9D4Xuhn8kuSoVsj+NuMqrpAnS?=
 =?us-ascii?Q?xNkyToncwq3YKDLiQiqWdegi8LjVUQQlik3Pf2x8bevDxIOK/gBVj2/gvzWy?=
 =?us-ascii?Q?eF6EN9/0435HFjbzkPPaomarewq1WvBsItI5JOXmiRbosrPVNux3lAdSmLNs?=
 =?us-ascii?Q?Yx1IPOMnRMtrRuOIlMjyJc7qVboBAmj3JOw399M9K+CSy5NarcqgoBhG9ipK?=
 =?us-ascii?Q?8mrhOdOoZCqRDmVKtQXmDXylfQnVom1t96bFLpLc8EQSX3wDs6Yoq1oiJWDS?=
 =?us-ascii?Q?X8mgDUsrRhRvePj/vGyDGkIZK/N0+10S7hUr+YatG1M0UT1ye99zYwX8jxPc?=
 =?us-ascii?Q?idn/kGnNJPgcq66VveWz/fzt4auv2nX+pj9XmQGHv9DIrPajWqJzQhAxBUYN?=
 =?us-ascii?Q?nPFDXnLTe4/L2aK1WO/Spn319UjgIvVKGRvRAlg7XHIXkgrTXXKe51kKrGDw?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba3ac480-1a78-40e4-5e58-08da73ce2247
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 14:57:20.4239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jFNEqgm5bnPHkuW3a/C9D8+JMcNkJ2WHEfysEMbDL5T0QK/7IA+dhN5UIQbW157UZZtaVFICYncvbmQbVbMh5iSO5KZtEmGBR4Z4qCXbO0o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1456
X-Proofpoint-ORIG-GUID: 7iiBrGljZReNCo2Sa6D0nfMLH2dYHtlf
X-Proofpoint-GUID: 7iiBrGljZReNCo2Sa6D0nfMLH2dYHtlf
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
[OP: backport to 5.10: adjusted context in sock_fields.c]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
This series fixes the following bpf verfier selftest failures:
root@intel-x86-64:~# ./test_verifier
...
#908/u sk_fullsock(skb->sk): sk->dst_port [load 2nd byte] FAIL
#908/p sk_fullsock(skb->sk): sk->dst_port [load 2nd byte] FAIL

 tools/include/uapi/linux/bpf.h                |  3 +-
 .../selftests/bpf/prog_tests/sock_fields.c    | 60 +++++++++-----
 .../selftests/bpf/progs/test_sock_fields.c    | 41 ++++++++++
 tools/testing/selftests/bpf/verifier/sock.c   | 81 ++++++++++++++++++-
 4 files changed, 162 insertions(+), 23 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index e440cd7f32a6..1dd4b1acbcb0 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4180,7 +4180,8 @@ struct bpf_sock {
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
index af87118e748e..e8b5bf707cd4 100644
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
 	CHECK(err == -1, "bpf_map_lookup_elem(linum_map_fd)",
 	      "err:%d errno:%d\n", err, errno);
 
-	err = bpf_map_lookup_elem(linum_map_fd, &ingress_linum_idx,
-				  &ingress_linum);
+	idx = INGRESS_LINUM_IDX;
+	err = bpf_map_lookup_elem(linum_map_fd, &idx, &ingress_linum);
 	CHECK(err == -1, "bpf_map_lookup_elem(linum_map_fd)",
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
@@ -353,17 +373,20 @@ void test_sock_fields(void)
 	if (CHECK(!skel, "test_sock_fields__open_and_load", "failed\n"))
 		goto done;
 
-	egress_link = bpf_program__attach_cgroup(skel->progs.egress_read_sock_fields,
-						 child_cg_fd);
-	if (CHECK(IS_ERR(egress_link), "attach_cgroup(egress)", "err:%ld\n",
-		  PTR_ERR(egress_link)))
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
-	if (CHECK(IS_ERR(ingress_link), "attach_cgroup(ingress)", "err:%ld\n",
-		  PTR_ERR(ingress_link)))
+	link = bpf_program__attach_cgroup(skel->progs.read_sk_dst_port, child_cg_fd);
+	if (!ASSERT_OK_PTR(link, "attach_cgroup(read_sk_dst_port"))
 		goto done;
+	skel->links.read_sk_dst_port = link;
 
 	linum_map_fd = bpf_map__fd(skel->maps.linum_map);
 	sk_pkt_out_cnt_fd = bpf_map__fd(skel->maps.sk_pkt_out_cnt);
@@ -372,8 +395,7 @@ void test_sock_fields(void)
 	test();
 
 done:
-	bpf_link__destroy(egress_link);
-	bpf_link__destroy(ingress_link);
+	test_sock_fields__detach(skel);
 	test_sock_fields__destroy(skel);
 	if (child_cg_fd != -1)
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

