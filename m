Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F324D9C0F
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 14:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241858AbiCONY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 09:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348628AbiCONY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 09:24:27 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F88E36
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 06:23:14 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22FCsCPs005140
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:23:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=SVWvtTPKTE1cUeRqq060NwaDEHuVRhjVAw98tqNNljs=;
 b=Dr2ysmjL/KNiTV04DWXKueNoWArjVVgUssVqDhZfqNEJTPn9sJqmoXHjfZSNlJ5KRs1b
 hsC6ARfU5aWa39hup3YM1B0eoO6EnE3Il0r2VfZ9nOvlibqqerXrdGZa7qjAfbOMNKAT
 RqwW+PzyKb/w+sansXsDFxuOC+Km67RWudo32UidI1gqAB5EVH0H1hJ+D/KZhxWSoH/1
 t+UelQ9yOUuJubFJ3hCs14QL5NEWo6nEqtwgSdvBj9ENxr/Idx/8GZP32RKBIxOx8QLs
 AB/EL1zWcd91YgltvykpMMpUcaSoYM92te9rRi0QUrln7Dqk5xhyDwTM3DYsdk6uDlI9 OA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ergr0aksr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:23:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CeFG7cIG/rPDQG/Vb4rL8jQQlyjLFPpb3L9zbKyezW25LcteOVx/VfoFfyWTC0WACrC+50HyCUd607v4LBfO0K44s3DGbSuwr4Nkcr+/Blu1tY5thNVFnfklG+bEevvA4db5vYjaUCbckXFYtc4RCQG2hDjW7089Zt7kqSLVVgtcVE0UCKXSeoHLM9J6PEZYkH+Ep7I6jaZTdQB819/GIJt2PIfSTg4wbeLDH8LN38zrm3j48JWR/YfULUslTTSeAnIVnEOxsL+xs0HEU404cRZJsl6pPXwP4TpntjtoOOi6QZMmuZmZmbkD+qH5UvzXQX1J6n20Z097qoBP3cp1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SVWvtTPKTE1cUeRqq060NwaDEHuVRhjVAw98tqNNljs=;
 b=FhWQM2l3oYK76AXYsEBDVIWE+D6gnRr4Sh8GXtmLLsQvUgBJYvpxnxSxFYuwXk5DVkUdJRYfu0pUcGTAsE8Cvpm0gMIGR2TyYQDn1ILg6ELejNry8heu7a7GFkgJhWPPiXy9HW6qFjJxnEqlEHOvGpHrPzjgglltr2+eVBLYZ1CJ6UzrHyuLyET2uxWcaxxQhGmfu4MFZWiXEjYDyYCG7ketTXbt9/phQhgV24VWya+T5I7VNNaUI3pcWM+IC6doNHi3m3P1J7XZfSVOdiNVmH1n0LxNauUZcr/ZZY9aKNVX+86jVD8dcjKv+UEsMKdIg70UKPNJZ1IWXciLZOTVqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3772.namprd11.prod.outlook.com (2603:10b6:5:143::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Tue, 15 Mar
 2022 13:23:11 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::4ceb:e511:4a4e:17af]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::4ceb:e511:4a4e:17af%9]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 13:23:11 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 1/1] sctp: fix the processing for INIT chunk
Date:   Tue, 15 Mar 2022 15:22:55 +0200
Message-Id: <20220315132255.2084596-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0151.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::35) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98d6b1a5-64eb-4909-03da-08da0686f3fa
X-MS-TrafficTypeDiagnostic: DM6PR11MB3772:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB3772DAF121D42B1BB9A772B0FE109@DM6PR11MB3772.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FUG0MrL0sUKI+0HgRtEQMDf3dNm+758/p9ZPl+0oDMAlOUTI0V7+IgY49z4zSN1BJEp2cmt/6lrI7HVZ+awuqipbCaJBZjqOVPEYJWSKMurpg4zI9/pqhBTZFHq2GQnrtXfRTfCxG6TvOe8r3NFspD9ruP+6+7ENyfkOy05gOZg92+sBJSe9gJOBqzrV45c6CRuhEJDO70fj48QWrAO43MNa+TQAQrDg/5W8+vbcgFOIZsdNpkQxtrA8uajnnSfthJ9VUkFxv0e2FqeTOtkbdpLktkP7G9I57vyR3Ckz84EJjqXZ2tIDZem/u/DsGSiCyNz8e01ngoq9PlApnKoIYOTnDM2Xvb3s8AuQFjEl8u0LAkfFsBcOpc5BPDS4QBjOIP+X7scDc2QwqbAGqQmqm+cUuhNTmR0cHG9z+pdeBvMpmQAu1aUg+tFrSlHEcfHlyfHKX3ljeF/mAy7xgYb3L/+bolhPNwoSxEz6Vbd1VXIfWm+VJlM7rdM8hBlPC9EsYDQA1YvHjTn466Ii4P8dOrpWbwChFhJpHAUFEdgMO624DwMGX6WoflL2nMtlvHIEhZuwMvKyG99OlfpDuxlek3FtbmQ5HhnSfDgaCRmqCXhkKy9xE6xWJ3KzFuKl0ZZgrueJylffLZHwYeAuRjLP0D3JpXnDn4N2jjYq0JGNrKdRi27sWVvuoRRY34YpcULFPl+d0AKUqCi6nSlFkKkRwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38100700002)(186003)(38350700002)(2616005)(1076003)(36756003)(2906002)(8676002)(26005)(5660300002)(8936002)(44832011)(86362001)(316002)(52116002)(6512007)(6666004)(66476007)(6916009)(66556008)(66946007)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c7W1VcJpgcR+HsvlFm9eIfqagdj/PzpmWS7d84OWXaYObTl0DYSB0pFy3/Aw?=
 =?us-ascii?Q?tsqSMpd+tOKaCVpoL1zcp1FJAzDfVdpMkhKg7Vtm7Mrok3IdDOOc013hMFv5?=
 =?us-ascii?Q?ps+R13at1tOD/h8BK1YHmL5FRdhuH8iq4PDHv9jGcRPmfCZ5S0MULZed/tax?=
 =?us-ascii?Q?IHsHnu/qj1i7S0//fFPsPTXd5lNERW7BR2sM7JRd6WLKPtkTayT+nJpuvAqC?=
 =?us-ascii?Q?+DQWUJ2cgn0U2X4EFgEFeQCsy5ymko0cXdMTSUAyezzHArXE7PSK/ABWoi++?=
 =?us-ascii?Q?WHJichLRCDVtOyZ6ixI3mbzZKWOBOV6zW3yDH+TLnXXdKXQz15g7sz5xuxfc?=
 =?us-ascii?Q?ER664hELCjdyGdpcgQoEI6dDz31dAce2MQLk9Lc/uBw0EnWt2wskGSX0pTVD?=
 =?us-ascii?Q?GtNRvds+P5tMaOITeV1cOKvuKggkDpN33BvmoAa0F4Q3KeabEwBJbbGVYpIb?=
 =?us-ascii?Q?49RLL1ANExJ+WHw47pqTRq4JYduSrRA0PUIyKqX1b9IVp65Ad5T9bfRuIkvm?=
 =?us-ascii?Q?+ROphgYGP2IgISUXbByC/IeohZjwjEqcHOgSMofkyCR1nl7CICC1GzF2TuCe?=
 =?us-ascii?Q?7UUnz0yu3B27yqbzGMSlxXBbMTHBtuUxF+PmbHycrkbi0UJvrpiTDy/zOvur?=
 =?us-ascii?Q?q2JIR84GR21k3e3iGepvTMOM4amhqex/oe1AO3oKgAl4aiSyys3PDfWEPrSs?=
 =?us-ascii?Q?Yb80gqtWKw8tttzz6ejENRH15fgpWnl7mg56yp/AtAF5rK+XnP11u1G1Z1Vi?=
 =?us-ascii?Q?hfK8/1k0l1hXLIR9xynzDQbNR+LS6PR7ZsMrfv9niE+v6Afx7LAxsD2PqTyo?=
 =?us-ascii?Q?G3e5jaRVkxjhk02q4D+H4WPjLJRGOxZ2gz1YsgFVKT6fVW9K5srt2cT7Qfzx?=
 =?us-ascii?Q?SciS2vxT5moJB5ViGUf5sxwiZFaLBJ6oj38gvqfMoJpFOXMB+cGewCsvspBo?=
 =?us-ascii?Q?8Jt8gskL4pqd5cFHkoIjmVloPEDq63k3menSegFmRTacZC2cSj6xziG2tLgv?=
 =?us-ascii?Q?AHY3/ll6rple6VcUucnMwwEFa73iDbFZMCHOvqQxqGWAhbhfRJb4sUhuP9w/?=
 =?us-ascii?Q?3O43x5VUcmRJECdPJqPLJOjBf1zMvYhxaYwNtZPRu3oO21dv5EE1yQNKcDX8?=
 =?us-ascii?Q?ASCKLJ/MOXxrS9iYqhrcyGjSqAf6ebs3+yQTVck5mfFd+iQFUAHnLb2Fz0+E?=
 =?us-ascii?Q?TZCstidP5ihTofXfeR9fUgDV716/zbz+teyo22ceeSUH9nWCXo6ZDTJ5UYak?=
 =?us-ascii?Q?J32A6114sroIAAurqdJvRpDDQuXsRGd+3PGIevjB31sPLRKfwfbmAdY7Y/TB?=
 =?us-ascii?Q?myDxE1MuF2c1ol4MWqJWOV7B8uwMO/SrsfxvjiXs/SLjRP3U5e79Ef9kEIBc?=
 =?us-ascii?Q?lJ0lnbuJzCWEVYqoegdIMTjln6oeCJDkpAVGnUh6TMDdSBnoDnrruxVLb254?=
 =?us-ascii?Q?gDmPPXlyRmM3flWIz+z6SIoXTKep30uXTSfOmd6sbKtlKEYwWJwuQA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d6b1a5-64eb-4909-03da-08da0686f3fa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 13:23:11.6229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NG/kHFa2C96jBp8DWfapzdfvMWUA6pe3BQ048CkJ4nLu5qru46sygfu8823YAyPxjNwFGdeyzlgc/MNldErYYtUIEidE73owq9ATuDek8/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3772
X-Proofpoint-GUID: 4aoehR9HPeHAGnS9SNFLpdzBMubHXcIL
X-Proofpoint-ORIG-GUID: 4aoehR9HPeHAGnS9SNFLpdzBMubHXcIL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=953 mlxscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203150087
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
[OP: adjusted context for 5.4]
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

This is a backport for [2], which is the only fix missing from 5.4-stable.
Only small contextual adjustments were made.

 net/sctp/sm_statefuns.c | 71 ++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 25 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7c6dcbc8e98b..1d2f633c6c7c 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -149,6 +149,12 @@ static enum sctp_disposition __sctp_sf_do_9_1_abort(
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
@@ -330,6 +336,14 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
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
@@ -344,14 +358,6 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
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
@@ -1484,19 +1490,16 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
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
 
@@ -1814,9 +1817,9 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
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
 
@@ -2915,13 +2918,11 @@ enum sctp_disposition sctp_sf_do_9_2_shut_ctsn(
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
@@ -2955,6 +2956,26 @@ enum sctp_disposition sctp_sf_do_9_2_reshutack(
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

