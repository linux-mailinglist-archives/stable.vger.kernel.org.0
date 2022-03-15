Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D154D9C1C
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 14:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348631AbiCON1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 09:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348629AbiCON1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 09:27:34 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD7A45791
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 06:26:21 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22FCLLAJ024383
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=7iNZZ7j/xe8sCCh6u0nHDQkmaFA1cloSksdtY93N3KM=;
 b=NEKbpawsuSs2UzGotgL9mmZvhym9OeT2OypRZK+GsGtrCQBoh8OMsGEWDFHj2EcOkyej
 /ZZqbGdLc1B+7Xsz60GTR/jhJqvxWJZIyCjLPTuMQDOjhkq6djTnLZAf7zJFmN+OEaaz
 Bg2cC0R+cmvRYBISvODi9KpLkCW9pCR4D2zSZTuRnleBAgVYXNJa6WvndT7NNqn+vjZj
 J4kgAg5hBjhhHVXJRyw5ZMk5P+CsT1moT/fvGNaGwszfW1YZ80BrriUr0uRJFg1y0jTk
 Akm6WlxNJWsnvz3SMhkASj2S6gmNcO4DVGBwSdFKdSd2kwE6piNSMuperdz5y2eLwV/7 nA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3erjg7thyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:26:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q60oH4pdBpvYgQ8XsAcmzIT6seVmOqg2yDIb2+410A12yPUSVPeHNocLbJfWwILHR+w8ZZwRvhZMnvE1nSqrxp7j5XKyF7eU+mtSdzArK7tCNpuQAVwPO920kuQNJu3QAzA5uzPwgjFgWWgsM0T/xdoadmYx+ZZ1LB4wR/Cp8JdhPt4ut1KnCudgyFbzTPxEIs+2QKko+BUs2VlQysFn/x5rbvkCVwNDQrsX05vXsZIatGesJbUiUprPgIAGUEd7g0qF524bZtnlQ5LVwHWXTiS/u2dWOjRg2jm03KTzRNPUJMzoHwp+jd2Bpv2WrufNfSNpOcbve52vZJqU65Pp2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7iNZZ7j/xe8sCCh6u0nHDQkmaFA1cloSksdtY93N3KM=;
 b=I6LkXN0z3hmtJLrULeoY7Vpw4btzEWUNT0hPobxG4K0+5EZRKGabQIg6EU6GLw626rmthy73qYyElzqXX9zVqd11ysfKnTz3CXlOrE3vqipsEWrq8ma/0Wi6QGOm4j2aXG/1rV038KVVxGQ+4Bq6/zoX57wlt9jtaAXFypKwqmFeKqTXNsKN2k6sd/lvaIL8xokx8qA9t/zVe3HwwkhSCjlcLGWTTpnpYJda5q+cqyMypLOWIgoJ+XyrR4fCRc91F92oe/04dG/46H5SLNUe8Eu+jOvpAA+lAXNbWGq754QTYPWi8eornNUwPXWi7S27MoxvS/BKbApv2JfrIjdbyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN7PR11MB2756.namprd11.prod.outlook.com (2603:10b6:406:b4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 13:26:17 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::4ceb:e511:4a4e:17af]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::4ceb:e511:4a4e:17af%9]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 13:26:17 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 1/2] sctp: fix the processing for INIT chunk
Date:   Tue, 15 Mar 2022 15:26:01 +0200
Message-Id: <20220315132602.2094562-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P189CA0032.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::45) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05bab88d-bd3a-4a37-3abc-08da068762c2
X-MS-TrafficTypeDiagnostic: BN7PR11MB2756:EE_
X-Microsoft-Antispam-PRVS: <BN7PR11MB2756BC36881DF37D7A33F16FFE109@BN7PR11MB2756.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZyAjUW5KdsDTRBJC7vaN6bkawdgp4Dys6wGp7BeCHfyApskE9eBNziaINoDT5BBBDyS8y0YhbiArGGbQzoe8JxUq3fa/n7oompt4XIvthQ5gSGzLeWqjHvsnRG0bYDkULE1ZG4rBasmdxoS8Oo1uobQ3xQunB0xOMX2+2NYe9kxFGf8BLGSjnhDTnuUWAzLFNlbPtRcLDrZlKmr5A09eslPb7gmoEGs8l3aJQsGdCdFrZQ4ccwtQtVxUOqbWQGsi+kondHayb2yBYZFqamQkU2S7DAdgb9fB+dfGqUd5rmC1oG1RJtuOZE8Wvrd6s6Pn980cScU/B57jXPZArdvegce/gtxo94WXZo+nB5Ft9B7EM7NjjlZOXeCfrkMw24te6hoXDiar6OuhdN7QUrZY5O0YidDEXOrkS2Itvu/Un/RXlbKPddhW4lFGlb1pmHXKIeIvOsCG7Wu8QMINQEzX9hkTM9/i9/rNb1f+t/Z3dV2nLlOfTP2ey6KKF+JbyiYAVqQS+HTFpHE5Cup0fyroDIX6TmBvskeBPLNXGDoJDdz1OEmEPs7+mBx71zOXwuQ8dfcf5U+bhV9OvDMa+02udubzJZ7LMo213akkspy6Ptlntp1gyHxyK7PW49FWJx3rjRkvyNlUbTP7aPc1nPY+/QmOUZsTxk8Xb0f4l9Kf9wRkvPIfWQCBkYnLedRxcUkerGPno4d5Uk9IijDfUlAtNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(38100700002)(6506007)(38350700002)(44832011)(66946007)(6486002)(8676002)(66556008)(66476007)(52116002)(508600001)(26005)(6512007)(2616005)(83380400001)(1076003)(6916009)(2906002)(5660300002)(316002)(6666004)(86362001)(8936002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Do3QfqLqEs+SYmVzlDXfqKEW7O7KeJGwhxSETfvAKNlI2p3nII53NuU87dCs?=
 =?us-ascii?Q?zGDBU21tqrN7e9xbPZ85Oe78D9kzNuPPmz7W8GOIwL5+myQlp1pDhdm25yf0?=
 =?us-ascii?Q?AVViHqoCQalZzeYA6GPZYrO+cOexTnhBsZtUj4qO8XzYTVgFUmjV4pEsUsfx?=
 =?us-ascii?Q?XeiE6bHI5TwtzketaLZggVBrccSkg1awIoRbT0KxjevGwoiUSz3gGMuQ5Q6Y?=
 =?us-ascii?Q?mgn8vll+KBQ6FuFXQf7ynUaZn3jiWRKedNGMoqcJRxQ16DR05ss8AbDUse6t?=
 =?us-ascii?Q?zmc9MkQ8l/8yQZwq0XEsWwquqnAidEU0mkHa1inUAypocgni1hXlrR9ndaW6?=
 =?us-ascii?Q?Jt1TQZjp38Tg72ho0THuynw6/Cc1sqInm40/PIs8iMthfl1RykSmXb/GeQ1H?=
 =?us-ascii?Q?/RuyB61rQMizA/9MoHVkDvp/uFJDfc1uvmOv5Lfdl6uj6v/96BlC11ugZRHE?=
 =?us-ascii?Q?IvtAIKZUGcbY3g7opd+Yp3cIJlzniJku49G1xv4ecmHCKx2tOCGrNUHOw5cK?=
 =?us-ascii?Q?RTU2oSB6UaQJeeAxdkcNbHpRbU5+FswdJImOo3GXPVyoWvTjiTZyBQNPJzC5?=
 =?us-ascii?Q?lqYrRwRsAhGm5tNsCbtOIk8NCaez/CNlaXLb3uzE2kuRMVPAZkfhctLww2nL?=
 =?us-ascii?Q?vUJbjHtCobJawkIaXEKso9SVziXKPaaGt7xx1Am1+g9u04jlT2nGJiO8v7Eh?=
 =?us-ascii?Q?iENYNQBI4JfPbvLy0URF/FNo5Ur2y4iY++Ev9dIdmZSouEKa6ss8ZYrvYX+f?=
 =?us-ascii?Q?nhz7wdR/B7rHvE0rATYkbC/IXUV77ePQmR6NjXWPhFO44IPIoaujcpLrT056?=
 =?us-ascii?Q?ktlMyIy+LzXVuChWBVpMGpl/3BQzxpL27D2ZrCY2Slm6fWQk4f3dpiybOloP?=
 =?us-ascii?Q?avNvesyEm/BWcHbdctAcXsv2rMhfS15KVzcAas6MFYZnL9ZKqcxITHWlg1Hw?=
 =?us-ascii?Q?XxWP7c+FpzR08gigRdEs7w1WLhbE8lcq2Qd13TwXptwlpx7e7lw39+lr4wZI?=
 =?us-ascii?Q?vY2tQzFMuDDG8id+5eMDQiB0idALl2SVHZuLEWnPCFeUUzV/RG3WfDxya48e?=
 =?us-ascii?Q?4ZD6U1xzxSmuY1hyWFVAHCFplkXNoJrsdVqc1ZrS5JvIMogrgPlB7/eeMB30?=
 =?us-ascii?Q?6botSwGw4RLeXAS8ABWuCv28ytO5qK13OGMOFokiudLMpmMtKpzG1JSnydgf?=
 =?us-ascii?Q?DQROSTamTt6v5DGXZ4FSHMW3ycxpyoLX3ELrvpsaddyo6Sma6WskBOSgi/lC?=
 =?us-ascii?Q?MBptlkK8SAeJIhQqi3q5UmTH2D3b9bxeqbHdxKz6ynO6u196QSyu5/NY655g?=
 =?us-ascii?Q?PuXnM+j1OipnOBm8O1AZoqOxVtjG81lP0k2zSaBjJVXBSQOE7pfkJlZm11M0?=
 =?us-ascii?Q?ORlcUWZ+MspdFhUwsg+FhiK7i1I65prPG6wa3Il54l2zrilTtULbxptGR2FF?=
 =?us-ascii?Q?XNlE+kbqO1Q6D+MoTjxAkS1SvEKXQpunX8S+wfbwjyivyqNXZb7mFw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05bab88d-bd3a-4a37-3abc-08da068762c2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 13:26:17.5156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bFw5zsl5z2u8WpcVwwfZ9sheZDmPrIndsHh6DpQfFn/hdnMx9Y5kwzdsGwiXBZFYReF4XIIawgwnURlgUaQy30ytLkPVcYi9e2rbg1QQrww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2756
X-Proofpoint-ORIG-GUID: QN3mXmeomRwrjUexrnzVYhDjKx2c3nka
X-Proofpoint-GUID: QN3mXmeomRwrjUexrnzVYhDjKx2c3nka
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=998 classifier=spam adjust=0 reason=mlx scancount=1
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

commit eae5783908042a762c24e1bd11876edb91d314b1 upstream.

This patch fixes the problems below:

1. In non-shutdown_ack_sent states: in sctp_sf_do_5_1B_init() and
   sctp_sf_do_5_2_2_dupinit():

  chunk length check should be done before any checks that may cause
  to send abort, as making packet for abort will access the init_tag
  from init_hdr in sctp_ootb_pkt_new().

2. In shutdown_ack_sent state: in sctp_sf_do_9_2_reshutack():

  The same checks as does in sctp_sf_do_5_2_2_dupinit() is needed
  for sctp_sf_do_9_2_reshutack().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[OP: adjusted context for 4.14]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
CVE-2021-3772 patchset consists of 7 fixes:
[1] 4f7019c7eb33 ("sctp: use init_tag from inithdr for ABORT chunk")
[2] eae578390804 ("sctp: fix the processing for INIT chunk")
[3] 438b95a7c98f ("sctp: fix the processing for INIT_ACK chunk")
[4] a64b341b8695 ("sctp: fix the processing for COOKIE_ECHO chunk")
[5] aa0f697e4528 ("sctp: add vtag check in sctp_sf_violation")
[6] ef16b1734f0a ("sctp: add vtag check in sctp_sf_do_8_5_1_E_sa")
[7] 9d02831e517a ("sctp: add vtag check in sctp_sf_ootb")

This series contains backports for [2] and [3], which are the only fixes
missing from 4.14-stable. Only small contextual adjustments were made.

 net/sctp/sm_statefuns.c | 71 ++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 25 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index b26067798dbf..91aecc3449d2 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -161,6 +161,12 @@ static enum sctp_disposition __sctp_sf_do_9_1_abort(
 					void *arg,
 					struct sctp_cmd_seq *commands);
 
+static enum sctp_disposition
+__sctp_sf_do_9_2_reshutack(struct net *net, const struct sctp_endpoint *ep,
+			   const struct sctp_association *asoc,
+			   const union sctp_subtype type, void *arg,
+			   struct sctp_cmd_seq *commands);
+
 /* Small helper function that checks if the chunk length
  * is of the appropriate length.  The 'required_length' argument
  * is set to be the size of a specific chunk we are testing.
@@ -337,6 +343,14 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
 	if (!chunk->singleton)
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
+	/* Make sure that the INIT chunk has a valid length.
+	 * Normally, this would cause an ABORT with a Protocol Violation
+	 * error, but since we don't have an association, we'll
+	 * just discard the packet.
+	 */
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* If the packet is an OOTB packet which is temporarily on the
 	 * control endpoint, respond with an ABORT.
 	 */
@@ -351,14 +365,6 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
 	if (chunk->sctp_hdr->vtag != 0)
 		return sctp_sf_tabort_8_4_8(net, ep, asoc, type, arg, commands);
 
-	/* Make sure that the INIT chunk has a valid length.
-	 * Normally, this would cause an ABORT with a Protocol Violation
-	 * error, but since we don't have an association, we'll
-	 * just discard the packet.
-	 */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
-		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
-
 	/* If the INIT is coming toward a closing socket, we'll send back
 	 * and ABORT.  Essentially, this catches the race of INIT being
 	 * backloged to the socket at the same time as the user isses close().
@@ -1460,19 +1466,16 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 	if (!chunk->singleton)
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
+	/* Make sure that the INIT chunk has a valid length. */
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* 3.1 A packet containing an INIT chunk MUST have a zero Verification
 	 * Tag.
 	 */
 	if (chunk->sctp_hdr->vtag != 0)
 		return sctp_sf_tabort_8_4_8(net, ep, asoc, type, arg, commands);
 
-	/* Make sure that the INIT chunk has a valid length.
-	 * In this case, we generate a protocol violation since we have
-	 * an association established.
-	 */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
-		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-						  commands);
 	/* Grab the INIT header.  */
 	chunk->subh.init_hdr = (struct sctp_inithdr *)chunk->skb->data;
 
@@ -1787,9 +1790,9 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
 	 * its peer.
 	*/
 	if (sctp_state(asoc, SHUTDOWN_ACK_SENT)) {
-		disposition = sctp_sf_do_9_2_reshutack(net, ep, asoc,
-				SCTP_ST_CHUNK(chunk->chunk_hdr->type),
-				chunk, commands);
+		disposition = __sctp_sf_do_9_2_reshutack(net, ep, asoc,
+							 SCTP_ST_CHUNK(chunk->chunk_hdr->type),
+							 chunk, commands);
 		if (SCTP_DISPOSITION_NOMEM == disposition)
 			goto nomem;
 
@@ -2847,13 +2850,11 @@ enum sctp_disposition sctp_sf_do_9_2_shut_ctsn(
  * that belong to this association, it should discard the INIT chunk and
  * retransmit the SHUTDOWN ACK chunk.
  */
-enum sctp_disposition sctp_sf_do_9_2_reshutack(
-					struct net *net,
-					const struct sctp_endpoint *ep,
-					const struct sctp_association *asoc,
-					const union sctp_subtype type,
-					void *arg,
-					struct sctp_cmd_seq *commands)
+static enum sctp_disposition
+__sctp_sf_do_9_2_reshutack(struct net *net, const struct sctp_endpoint *ep,
+			   const struct sctp_association *asoc,
+			   const union sctp_subtype type, void *arg,
+			   struct sctp_cmd_seq *commands)
 {
 	struct sctp_chunk *chunk = arg;
 	struct sctp_chunk *reply;
@@ -2887,6 +2888,26 @@ enum sctp_disposition sctp_sf_do_9_2_reshutack(
 	return SCTP_DISPOSITION_NOMEM;
 }
 
+enum sctp_disposition
+sctp_sf_do_9_2_reshutack(struct net *net, const struct sctp_endpoint *ep,
+			 const struct sctp_association *asoc,
+			 const union sctp_subtype type, void *arg,
+			 struct sctp_cmd_seq *commands)
+{
+	struct sctp_chunk *chunk = arg;
+
+	if (!chunk->singleton)
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
+	if (chunk->sctp_hdr->vtag != 0)
+		return sctp_sf_tabort_8_4_8(net, ep, asoc, type, arg, commands);
+
+	return __sctp_sf_do_9_2_reshutack(net, ep, asoc, type, arg, commands);
+}
+
 /*
  * sctp_sf_do_ecn_cwr
  *
-- 
2.25.1

