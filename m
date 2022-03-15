Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8644D9C14
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 14:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237131AbiCON0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 09:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiCON0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 09:26:44 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B118E3464B
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 06:25:31 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22FCv29m005187
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 06:25:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=oNXg5U8rhINvLvpkqZjKm23C0AS4u9u9GlEJyx56zgs=;
 b=haToLofN2Y4icAsnWGPoLJsp0IhFi2F4hGJJxqKHPLdbgqd7VeLSlRpqEoFn8dLRlOUr
 pCtGlLQaGd4BsPNlD7OV9P9MRanKd8id2N852yUEu3UOPtV+kF+uJPDezjxGmZswIY4D
 +tSZlI7yDsuHT9wDMRATWaa1bZzI5XoBOyzZkyj79iWCSkGvyleqAq1xg9JeKuj38HIf
 p0n7sJHMDy9h/Q5GnvOAA1gITuxYSsm/q6iTzaeBq85d3LIdE7TZvT7bRfAJYHSi9I5h
 z41j+5LdNQoHMSCF/gCt+T2Po9d5bvjuNij3n0oWEI1VjSuvokhY6LQzO3K+bgEwdB9N QA== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3esq04sgbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 06:25:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnpqdYChjd8o30yHmKJZ82/0biM/GW3/X3mhYZfeCT7u4q+K18I1aJcn2/EstnVllJAt/Rqjk6rVoC40/hzvxlbfQTII55KE5ZgPDHbqFIZS9LbKL92yFHJZnPo2KPCl56BZGkTB3kU7H6r8dMQr8m3qCTxtJKfWTWc4tXv8l4gKxsxkxqbBKrKEN4pLO790yVBjpVk2XPhwrOj4syrEn/19ikEOLaQ5HiESeHMP/9VZEPIeHrHmwBSOKmo6ctaTzex49L8ellsT2rb0nhVecHQ8fqCTRm4aYdDeYP3NW666f7nwLbkZbqIJyDxUH6t3hDgfmgxgPMXuxwuu6Wn+2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNXg5U8rhINvLvpkqZjKm23C0AS4u9u9GlEJyx56zgs=;
 b=FkkdGB0jmQiAQkbjxGXxoh8r5VyoHhTWohNVQFpAuL41nLAFYZOQxrHitIzJO1c1EzhYmg+vDHCqOnrghxAd7s0jkhsdBQqM60bcd/vJwCMq66i8eE3DPn3t1qIppadvk0fuoLFFBEndHXsCnjVKyx6ARIn+OqpEkues/2g6wC+UIFKFp1HOa+Y5Wxm6id0NKKJ/yp8yfpie6ZfoidcIeogWb+Up9rijsx5K4Y98XuWTYaMabCCys7O6a7HNxtEeJj7Ar1/8GxQAJaUY+8rV3eG+Sves4qm3iMTNPKKPiNKs5xgm2h46v11qdgRGiRt7EwxuFvSzjLPdRsngwLaw4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN7PR11MB2756.namprd11.prod.outlook.com (2603:10b6:406:b4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 13:25:25 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::4ceb:e511:4a4e:17af]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::4ceb:e511:4a4e:17af%9]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 13:25:25 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 1/2] sctp: fix the processing for INIT chunk
Date:   Tue, 15 Mar 2022 15:25:09 +0200
Message-Id: <20220315132510.2088935-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0194.eurprd07.prod.outlook.com
 (2603:10a6:802:3f::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dba988d2-d914-4843-9ede-08da06874376
X-MS-TrafficTypeDiagnostic: BN7PR11MB2756:EE_
X-Microsoft-Antispam-PRVS: <BN7PR11MB2756F2ECA38B9CC06C7FC43DFE109@BN7PR11MB2756.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: roG7J+6jk4PMRhkm/RT5Xz4txWYDOOrBoVh2+JNVAVHHmeR7Jb+1/bxV+7bmLewK+CZx97s2w54oyL1bQBrdWOTUYwaawfHBUx3nn7a1osDt4yGCluq69WapiOjBgtMLcDuB7Tc0nzquBI6N1Nm11mI6zS0NzfFsQ6TOs5/odRGinavIkDxX5zv6n1hV4G2Up/GBoI5ScZ97UHgitI+Zq+rPaEHF43LCT7DjsE0+wmsjHSLzB4tDqs17fdE6sKw8YdRIcxyNb2aRpIBUf98PkgZFXo4MvlFsCS0zNNQUMpiv9bL2MGQBL2dIafDAbxk2zOdM/Ko8FW6zLIXX0wSabQOEJClAU0aCr3nIRVlDlc2XtJfOooNJVImEYjbwmsvU5QFkzxEa8zIpadTARV4iFV5H1TrYkIIGTVTma69i5cEMeX63FCewGYfGvS2F1nqaQ425E1TeJSmU0AwOhk6PTrx9yY7T+0Wjdq22XbVJJItlw0vNnla1BqluZLUmveDUBL4LeIyHWnCbTCOJDLGE7agMB0sR8sQNVakak6wirC6YZWowXnBYLXzBG6Ls8/lavbZ/cfeBWUdDXvpweoNFhBIFD/bjgcbWQl6fJZgjk9aehRTtl19lWVE8vj6BCKQr98t+Ie7rJC/wxmu9cDWH2iv1bZ5oB9dWCHKv141L2p5LeqpZ4zbDdTKx2YMpZ3jTCeyv0sehvqXyG3jS4zZK0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(38100700002)(6506007)(38350700002)(44832011)(66946007)(6486002)(8676002)(66556008)(66476007)(52116002)(508600001)(26005)(6512007)(2616005)(83380400001)(1076003)(6916009)(2906002)(5660300002)(316002)(6666004)(86362001)(8936002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cU48WH8wg5Ch/7SPjeqgmBPRrfMDq7Y/WRvgVykqs2mgfzpMs0567jVqVTF1?=
 =?us-ascii?Q?ls1S3iK0JcpyxUIb3ZnvswGNOiOmMdQeeYiQ143S1OP5bKzjFfXu9pHCwYZc?=
 =?us-ascii?Q?n+votKehsSRCXHSI5nS9THOiaEUuiH5vYQ9IhRYwwOKKQSZTsA3cozXovI0B?=
 =?us-ascii?Q?sNyCdv6vufPyz+UANsLpkSyWh0nirCDT2c2WAVm/gHgBvp3Q7BhDjdfGKBTs?=
 =?us-ascii?Q?NV63VCmBtFJ05aaSnSvlYRtE4GTf15A4OwsFGs1yVTU75wcsKRgoE+Mv+O6r?=
 =?us-ascii?Q?eDcEB5DsfA0Z/L7m87Tg2z9cuYVFuTImiujXaibTf5u+aCPmcdQCRJY9XjEi?=
 =?us-ascii?Q?hF4cDDyDVWimBsZ6/XX/NoQp7jlEegQJ/N+yHJ5c3J5wq+Y7l8u+cK3a9rS5?=
 =?us-ascii?Q?fdIIWL1U/aWRmjioyTaD5ZTcqh9fHrBxDvSGqT7z5tmyJWYNLLdOxtzmrgsd?=
 =?us-ascii?Q?01Znqhjej5+SzuLPIKzlpHUNylL7zVy7nbIvGmIQVMwYVl7oAHZa8Q8hb5FK?=
 =?us-ascii?Q?bsOV0c0Wfn+LHJZHwbIAVR7BByRWbUC/wiqxgZ70iq9PouIIXZG4I02Bnr0O?=
 =?us-ascii?Q?nGXgXd4BQD0u573DlddTR3SnE06afMqg0twHpSmw1MX219VOXZ7U6/5efKUr?=
 =?us-ascii?Q?umq56sK5oMstSjp2qtN8bejjXlfSXzRZ11zPsbpo6afD7D+yUJ4WPMTdKQ47?=
 =?us-ascii?Q?p905yATa6dz4Tq6KliNPmyMsTsy6Kr8cFzTBg30vbmFbJY6k4XXDWmup3Dz6?=
 =?us-ascii?Q?LZXo9fSTHPkuo4mbsYysURBXoRyRZAEg8vN1ot4O01/3UkdVWZPUs2IHs/nP?=
 =?us-ascii?Q?X6+6RiVeqI8/9BRYCYSepbNX4kggai+gV7M/TN3LjYR2WXa0y2i7cGJpw8RZ?=
 =?us-ascii?Q?aEIPKL9NXpkksvV267m1VTIENczLVmW1edgUb3TS8hwP4vQj8W1T2ZPht1Rl?=
 =?us-ascii?Q?qs6rDcIni/cLmHjgiFlkTY3XRKias+fq7pnNXNMvamOXNOLkhlEOtmcQKGet?=
 =?us-ascii?Q?SQ9acVIjWZKiNAVj4RFDg1sjKCqg4e+ATp/P4qwC9GC7qBVklbVkxHZc/rEs?=
 =?us-ascii?Q?9XY3XlCDnauioTWnk6AvfHQaETXFfJKrxdgguqjNcWPs10mHXFgq1C6bNALi?=
 =?us-ascii?Q?LUcxl/iO2UHJQtaeK5YU52gghf8f2CCMzURkERHNTOwTjA0Ch5Wh2gFhn2CZ?=
 =?us-ascii?Q?mMnxdP6oIAwkmq0WA55zQ811SJvXeqqIO+vuQrZdWGWf4Tc9M6iIfCjy9eGb?=
 =?us-ascii?Q?e53H5EVARP8ku1G0fel749U1ABsO1+mty70fzFtUPY0XiAQ/4MiF8q2FZiTJ?=
 =?us-ascii?Q?hUP7ftGZjq2Z4ksztmQw1S+j3neNwr4z+9lwV6fKGXA94VlqnVMMTzj7BNiY?=
 =?us-ascii?Q?Cia16ONaqKXhqGWdiL34NQiIeWqjaYQUrzT5iBLD58oPm8rRL/z1wiTgpzn0?=
 =?us-ascii?Q?1Y1MNveL3CZ7meMSWRzdZ7vPwGBo7lVewf2Byn2wVYMmyE+sJZ/WEg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dba988d2-d914-4843-9ede-08da06874376
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 13:25:24.9795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 11X6UbQoIdop0lXpom4ntqjK8I8eB0adQy8l3GdTleVuVYACrCuo+lRAx9AddKEsJsCSCJpdxNsR5lwHxX0p4O87ksJKtXQ3erhawsU33+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2756
X-Proofpoint-GUID: Z2UIVspcUTB1fLJPgBCBu5sNpXpoXXwk
X-Proofpoint-ORIG-GUID: Z2UIVspcUTB1fLJPgBCBu5sNpXpoXXwk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 impostorscore=0 mlxlogscore=998 lowpriorityscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 priorityscore=1501 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150087
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
[OP: adjusted context for 4.19]
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
missing from 4.19-stable. Only small contextual adjustments were made.

 net/sctp/sm_statefuns.c | 71 ++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 25 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index ebca069064df..5e17df88df5d 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -164,6 +164,12 @@ static enum sctp_disposition __sctp_sf_do_9_1_abort(
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
@@ -345,6 +351,14 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
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
@@ -359,14 +373,6 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
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
@@ -1499,19 +1505,16 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
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
 
@@ -1829,9 +1832,9 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
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
 
@@ -2930,13 +2933,11 @@ enum sctp_disposition sctp_sf_do_9_2_shut_ctsn(
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
@@ -2970,6 +2971,26 @@ enum sctp_disposition sctp_sf_do_9_2_reshutack(
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

