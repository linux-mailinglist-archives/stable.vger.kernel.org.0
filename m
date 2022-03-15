Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2B44D9C1D
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 14:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348646AbiCON1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 09:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348643AbiCON1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 09:27:34 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6310B3464B
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 06:26:22 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22FCLLAK024383
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=5bEmOBSbLwLgTxnxSmhbzZSoAAz2xt8qrLd8O6v+mzY=;
 b=CebXVx1kJIXxiN98eSr5Kqtqh/noYO5VXeg2NYGYwH/6UBxdD7EPIo4P/SJcYbZE3rMb
 I9BbUyfES99btrDyMgooJj4U8z1+B4MGIntdHu7xYkQsA8/7AvxUDK3FX4n/cnKe6TQ8
 2cpIrcgrTEVjTQ65ZOwwfi3mPlTZpOdvNwnnb8JcPi6164uznApHTAy9WM7rHrsZ4M/r
 OWcK1KEJK490KrNNQi4knX8kri4nSNtCPVzeXWH+PvDExZ3Ba+WSg8c43k05O98nXuwK
 EGktRw/KwoPg9vDyeRHenl2Kgy0X5QED/PN9gg3LJRiei3+ksTIl9x/elOUwci5Oa3U0 Yw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3erjg7thyw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:26:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNQrqGzN4765k2dJmnX3f5o7akobiWumGCm13lss0sI5w7f7SmrvINqnEtnCKNttWXXECwR+2kokz3X3u+ujaNDPvfkN8qSPfotzolJAK+nXehNUT5Jb8LZ07emU7yrIJVhCiNVG3XpAMehwPO/fMCwNsxprM5WTy10O0FUCljXU7Iq/l3RE3qls0LbeNrpCuejsVfR+wXzYle/lpT8asOLMLek+q8pePawskU721b3MlE2XrLQQIB/+u7bCzA3kG3eknDBShSaWOjFHH/b/87nLQvEljWMaqMLquF3B01pu9sBflKWSsB2PKfexDaj+GkSnI6WCOJfLF8fI8l2QVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5bEmOBSbLwLgTxnxSmhbzZSoAAz2xt8qrLd8O6v+mzY=;
 b=cecUCNzBws3jkePU50hWJh/KFotbp8xv9LHhkkwhjxhvRqfqleR8fBKy95ettaSjB1ZQuuNr8caoo3cKeazT2P2AqYGkDKyei5oiQ3IHq8YdSrPUSPSyATHEMddkSrhpSZp9CtaGOYIlU9dm9Z2GMzo0RYO8hiFTBLOog/YrV3yJdx2aAk6CdjWxac1GWASZ22h+oQBlmel0oBB8emLEhJbhrtwVLPn/CSCm5B9AUJ8hBphsmFJAIqZbO+BSTCscnQdEeGviDSsXovzKD65ydfonvurcGS3Hv7yW4vBZPNU9ETEGt0RMGvP0pioPReTttE07jtmEF4UDYKAPzwNcHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN7PR11MB2756.namprd11.prod.outlook.com (2603:10b6:406:b4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 13:26:18 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::4ceb:e511:4a4e:17af]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::4ceb:e511:4a4e:17af%9]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 13:26:18 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 2/2] sctp: fix the processing for INIT_ACK chunk
Date:   Tue, 15 Mar 2022 15:26:02 +0200
Message-Id: <20220315132602.2094562-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220315132602.2094562-1-ovidiu.panait@windriver.com>
References: <20220315132602.2094562-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P189CA0032.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::45) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15a38503-86e2-4891-15d7-08da06876346
X-MS-TrafficTypeDiagnostic: BN7PR11MB2756:EE_
X-Microsoft-Antispam-PRVS: <BN7PR11MB27567E19712322D3208633F3FE109@BN7PR11MB2756.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jp/UGHDYpUrc2rb0o7ZLnL+hFKlt2HgPP4SqmiKJy21FqVj0BbKPC32cYtRa/K+iQXZLEtBC8gDwU0F/2+3m9pV8NUDl6TUaNyw4X+rahSrr1DxOTVi6kFljQfcUOo12Dp6gNckDquSOss/bCV7xrS/CKc810TTblCkaIAJMrGkxY7FqecW6PSlxrc3sDEtatVsSvsyqMsUUaOBd9YbziWzBlfKg0TGrcal7YPCqO/WfDq3jOyhJOk6wYom/lVlSy3L9sCOip7rDn+bpDGBiso15Ac5CRt9Vcn8AX3Pz6/orSh7mKTjd0Tmlb4HXU4ZJWAcmJ07L0xeP/ZMhNZ04ciC/2+172bc++QPI0svvEKRF8KTtyFunh7KGn1RzrclRbIWy1IqDCRWeKQiSYlUTGdzARapEsKRbqETHKJscZhR7F6zqLVea9Vo+AN7vkovZyl8LpqyXwumB0bRvtwwDf7FFwt7HrGSLkQPiYFnI2WkFY77hwstPheoJMLNskWeQYOOWMXQzGy7RYBj1t9peF0JzHNTNU0Hi4DaPGjmL2yKagM7FsK4emZyhY9643ouUeecvDwrEDq0VEKRls7orFQJfqfnfNbsxqUnPJifou4h7I/w/g2kh4Dz5AeR6Xgtk6hsIHshqn2B4zXKcCKxrMJHNSwUVl/5EzwS4Km3vwzwPi8f5/kNNrLIRGcA/R4EtW7uq1FisiYieaX0iWpRFzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(38100700002)(6506007)(38350700002)(44832011)(66946007)(6486002)(8676002)(66556008)(66476007)(52116002)(508600001)(26005)(6512007)(2616005)(83380400001)(1076003)(6916009)(2906002)(5660300002)(316002)(6666004)(86362001)(8936002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ASxU0z1addVQ9ElMynz5s1FQO+o2XrdO3/2bUYaZe9bpR5ddyxbo8d+cHyVc?=
 =?us-ascii?Q?ad7VMujIJw1rAtiTYO4WctcEbjymyOHT1Sa8PAD3MiSUuK4bWMG2HutFlYl+?=
 =?us-ascii?Q?SeSBR3JANH2b/trkzkQkGk9F4uXr+fM+703I0AuqrXFeurHUmVREL2AEOTDh?=
 =?us-ascii?Q?K0+B9CizAfh8DKZxeg8mrHjUBg1lgPkDO+mqAesxqumMrbKdx2PJctGe/Vgt?=
 =?us-ascii?Q?zqvMSAbNNog7MsynCfZaBLZRQkU96KUPl9xF4b+XwumiuVrpmOm0BhTke43q?=
 =?us-ascii?Q?Siq33nZrStNRxj57rfm5MmcjGqaqmVtU47rBFjfegNvzy2frGH7PCAp5bkBn?=
 =?us-ascii?Q?/DZ+b8+xocoFJP8rczK9mFXbkrzRrJX0h9byGk4uMMVMUoIPscYp476a/okL?=
 =?us-ascii?Q?XlJQW0573rqlMJnltmuQ31K/8iE6NdHsL1BIeDx3wB7Ujrd7YxNx2nsGZD9R?=
 =?us-ascii?Q?0MjHLF9l37eodeos8kMrv+LzDdS1Yeu0473CbZ6qrI9FHbBVZoLg9Q9Te7mY?=
 =?us-ascii?Q?MunMnke+hMpuauj2PvT/j1XZ+0Xrz+FzCfceF7VgzvSIUNXcFtC37o+is/Rx?=
 =?us-ascii?Q?uvkw0fPVR+BMEa5SSuZZ41+KAvelyjyN1GRBxJM+3F45p6LCJzfH3kRoGGHD?=
 =?us-ascii?Q?uKdvNwWJhKiNoMdICBzMzfr8yiZEeEizLZAJTn6495r7P/XXgawR70zPq56P?=
 =?us-ascii?Q?eKvtJkLFLB6qrB1GGGflCzV6pCBvt3Dnh/S0u6Bkq/ndY7HhSX+c7CtPoUt4?=
 =?us-ascii?Q?Nex0WmQo1lR4o7SdGX6iWDXxTAsAGT1J4EuUXNc/ZUCT//BUrHULyLC38VQE?=
 =?us-ascii?Q?YslaYTJfMDzPtPK+4/6EqsD208OZ01KB2SwrTFRIVTjgvH++0eVDcHu8MX87?=
 =?us-ascii?Q?YN7fojBxB44oRHydX93LlaKOTU6zotKDiH3+/PLWHH8NhHD3OkmqZtVomAVd?=
 =?us-ascii?Q?gfNVSh3FBt6SHQatVmH/3OvFhdraa7n5mdbFrjhYHk+B0EP4cRIUkRW3eNHa?=
 =?us-ascii?Q?2jfkj1Dkd7vk0OPmPuxc/D2iXbYNJJwM+g2f0t/zDq3BiQrzvGHhBZvQ6Qjn?=
 =?us-ascii?Q?C7YVqy/8y+7P3WGO05eUfdQYiWYZWh4RggVCFnB1C2Kw+faON/6JBFa5grIF?=
 =?us-ascii?Q?d7yFUIJhFCh8yu/twLJszGTdHAb3fH0ecwxlmylUsoV8ANgXcGRPMbSAsPT9?=
 =?us-ascii?Q?sYiT8DQTS4xk+Tvu6+UolCThX/K4A+oSZfX+KnxpGipP541KNv/HNmOJ4h3l?=
 =?us-ascii?Q?UB1cipkCvd4lQAir2qiEskNsSjGFTk+H1eIl0RFDVhmL1uP5XJ9MRDbSH68l?=
 =?us-ascii?Q?dawFfATDTgqFq9ggsR82t/wyWLPYNoru8gtEOtud3EO4Qn+vpFhVdq95iEVw?=
 =?us-ascii?Q?CdAS+F+R75ouTNcXfDRwFND+1OrMC2wrcGGu3UgnhElBxK7QMmTSQCc55Mh0?=
 =?us-ascii?Q?t5VuKM3wq4IFbH12yPDyNrbcIwZhnzsNltpSHVnXZIdJbhXerT9aKQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15a38503-86e2-4891-15d7-08da06876346
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 13:26:18.3529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8WQQw9z8533k1D/QBFuZhDNSkEwXtMXocUSc1guPga5/bgNyKfT8Ds5H8GfJ7dY5g6pZK7To3nAwIe304QKZj/zk3pLMXByAmXRupnFxoI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2756
X-Proofpoint-ORIG-GUID: 6A0ufF5BQMyqhDn79tiZaiAVDLjOR-4Q
X-Proofpoint-GUID: 6A0ufF5BQMyqhDn79tiZaiAVDLjOR-4Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150086
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 438b95a7c98f77d51cbf4db021f41b602d750a3f upstream.

Currently INIT_ACK chunk in non-cookie_echoed state is processed in
sctp_sf_discard_chunk() to send an abort with the existent asoc's
vtag if the chunk length is not valid. But the vtag in the chunk's
sctphdr is not verified, which may be exploited by one to cook a
malicious chunk to terminal a SCTP asoc.

sctp_sf_discard_chunk() also is called in many other places to send
an abort, and most of those have this problem. This patch is to fix
it by sending abort with the existent asoc's vtag only if the vtag
from the chunk's sctphdr is verified in sctp_sf_discard_chunk().

Note on sctp_sf_do_9_1_abort() and sctp_sf_shutdown_pending_abort(),
the chunk length has been verified before sctp_sf_discard_chunk(),
so replace it with sctp_sf_discard(). On sctp_sf_do_asconf_ack() and
sctp_sf_do_asconf(), move the sctp_chunk_length_valid check ahead of
sctp_sf_discard_chunk(), then replace it with sctp_sf_discard().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[OP: adjusted context for 4.14]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/sctp/sm_statefuns.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 91aecc3449d2..03434e7295eb 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2221,7 +2221,7 @@ enum sctp_disposition sctp_sf_shutdown_pending_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -2267,7 +2267,7 @@ enum sctp_disposition sctp_sf_shutdown_sent_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -2537,7 +2537,7 @@ enum sctp_disposition sctp_sf_do_9_1_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -3702,6 +3702,11 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
+	/* Make sure that the ASCONF ADDIP chunk has a valid length.  */
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_addip_chunk)))
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
+						  commands);
+
 	/* ADD-IP: Section 4.1.1
 	 * This chunk MUST be sent in an authenticated way by using
 	 * the mechanism defined in [I-D.ietf-tsvwg-sctp-auth]. If this chunk
@@ -3709,13 +3714,7 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
 	 * described in [I-D.ietf-tsvwg-sctp-auth].
 	 */
 	if (!net->sctp.addip_noauth && !chunk->auth)
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg,
-					     commands);
-
-	/* Make sure that the ASCONF ADDIP chunk has a valid length.  */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_addip_chunk)))
-		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-						  commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	hdr = (struct sctp_addiphdr *)chunk->skb->data;
 	serial = ntohl(hdr->serial);
@@ -3844,6 +3843,12 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
+	/* Make sure that the ADDIP chunk has a valid length.  */
+	if (!sctp_chunk_length_valid(asconf_ack,
+				     sizeof(struct sctp_addip_chunk)))
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
+						  commands);
+
 	/* ADD-IP, Section 4.1.2:
 	 * This chunk MUST be sent in an authenticated way by using
 	 * the mechanism defined in [I-D.ietf-tsvwg-sctp-auth]. If this chunk
@@ -3851,14 +3856,7 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
 	 * described in [I-D.ietf-tsvwg-sctp-auth].
 	 */
 	if (!net->sctp.addip_noauth && !asconf_ack->auth)
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg,
-					     commands);
-
-	/* Make sure that the ADDIP chunk has a valid length.  */
-	if (!sctp_chunk_length_valid(asconf_ack,
-				     sizeof(struct sctp_addip_chunk)))
-		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-						  commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	addip_hdr = (struct sctp_addiphdr *)asconf_ack->skb->data;
 	rcvd_serial = ntohl(addip_hdr->serial);
@@ -4435,6 +4433,9 @@ enum sctp_disposition sctp_sf_discard_chunk(struct net *net,
 {
 	struct sctp_chunk *chunk = arg;
 
+	if (asoc && !sctp_vtag_verify(chunk, asoc))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Make sure that the chunk has a valid length.
 	 * Since we don't know the chunk type, we use a general
 	 * chunkhdr structure to make a comparison.
-- 
2.25.1

