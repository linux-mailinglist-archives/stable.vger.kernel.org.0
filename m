Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56064D9C08
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 14:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348599AbiCONVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 09:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbiCONVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 09:21:44 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751093BA56
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 06:20:32 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22FC4Tlr002413
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:20:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=X8DMP/O0aW4rT+aYhiTzUOe0qVLcj/etbdOJUJzOwIM=;
 b=oOi1n/wcfXtc6oveghL23nio65IieB7gqII8+6nAV0QJNP5uVK2ar2PN08wiCWUfGq4j
 dHDNsaQs7xpaWOM2Rvd1AyHpTJsWLvfUzCUvDMcxR0XNP5NXn9Y50TAykchOY1NX1OET
 JRa6G4nDfldWFUY14R6EuslaNp5jP3eKEpgewJjbZ7EIZ6htL5ZzhhW+mA2KClvOFAhM
 zehOKnHHUAYT+ZRPij9yB77TAgr3GSPI1K0CGWFaBXR7cnWzZsZ/JM6eJFg8cDleNCdQ
 2zKaSmzTNMoDwIC2U3J2SKAKtzgzza0TT7dsINXStyEp5yEgSqseav1o02re7QK4Psge 1w== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ergr0aknf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:20:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZvzgNYT5aGDTDJb8nTiV92iSPZm9Db6Z8+yVOrEX/qEZaHdkdDL2xb29lssu69wXL0cdhgWK4KM6KGDEmD5uqvjBGUxeqDPgScfPMHHz/Wfl9F9H5wd7C0sDbCOgb9hKzKHSuv3jQyuLXHQSKbvMHpkvzrE3eZSmkZxS5oqhmkb5OBTe11XugNExQCXp3glzzlQyyONxX+vVVek4Q/7D7VXGn93/WvY2UJEYok1YVbZuZFkA0n5UE2hly0qfcvBK92kvIdp5tu/TiYzk3jS3rThDQgfkXBOPiGngydouXyfB46W+x3btjfGVMM+KMIP1H/xzUnFZFxeNR1iyGPC8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8DMP/O0aW4rT+aYhiTzUOe0qVLcj/etbdOJUJzOwIM=;
 b=B/7G1TS65/1KJYHEZYoxsRP1RuDNur875M2k6rzevMbV/CM+5CRRI/fjfBpGlLM8iT4Fi0kuIKjIXDy/wrji91kQocWG7mqQjaaSlhsMuqB78fC+ppS5YFA9CqdyO6v1IiF9Q0ezlIg3Twpkerr2ZFNSfmBSn4+x++6U0JbBrL0ZP8jyw6v6rqF91CL//toOVIImN3H1MsC0vX2W+09652suUKUsZIa2xCRA/+vM3nUq8zjl6xRna3jstSPPeNraFICdL20Z4Rxjtyt+TF/DyLQd28+rADqmu1Sx6jFpaLmWVIxTMupc1Uk3GExhzzlg1UPy/8+lEQ4OYOkJoER/jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BYAPR11MB3016.namprd11.prod.outlook.com (2603:10b6:a03:81::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Tue, 15 Mar
 2022 13:20:27 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::4ceb:e511:4a4e:17af]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::4ceb:e511:4a4e:17af%9]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 13:20:27 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 1/1] sctp: fix the processing for INIT chunk
Date:   Tue, 15 Mar 2022 15:20:09 +0200
Message-Id: <20220315132009.2080417-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0117.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::46) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2eeac21-1f0e-4f28-1a62-08da06869254
X-MS-TrafficTypeDiagnostic: BYAPR11MB3016:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB3016D5AC6A7575AAB048B238FE109@BYAPR11MB3016.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PCAapvGCNYRp2ZW6BZmHB9xeRdPbdWv95cASAO/RrMC1kvVIvwlBkp5Djch6ZVyezglRyVXHMy6LlVeNh/g7M6vx9+FELU/Bl5tzYHD8EXe6ST9a+lhtnas+TBbPsAmJYtiX41YcGSBK2TRT6GH+SO0vmZr/b4MzweGeQ8afGcDcSWSjqlxT6O2AgAPnfW9HSA3JC1KzN8tuY5QnCR4APwe4tE3YDogACYip6iQhHrRv1FmSJy9fXSvh7YZGIyHguxkkjYbp4S3yctTcHCjz3TLzR5uRwoKKq52nzMStS/V5N6z4IcyIA3LQTFOk4QIYEFLwaenQ5Fn+32iuj+z18GfCfCWX3VAl0jnHX79wLvmtcVyxbc1TU8l0ucFjDM6vsFOk76+aSpNGOJ+3TKWlU2Fk0A8onkQvViRQMoM48nNdilgB74e/5NWOGsbx0NZ3xHuo0SZILkDDnwfmKHlolIbqs0W5xJgpWwEkbEQXkb3vBvUrzV5k6CuMx0ILirypBRjJmB2Z2zYiP/fA2zmVKc8rY1T1pcD97k8V7V3gGX6NBudPfm2lkwduh4xkPISTlCcrnvw5k+fb1SFnAVt6uGCPxVcqFd2aoREYrb+CCJOfQSCn313Mgu7MgMKCq9ieEU6o02Q6p7tzB2TIAY/yCsMyYJDS3Z1FXinsCLrHPsvHcKc8f4I6847I+nt2wt8HyAWuuSrI7ztTgGvaXj1LnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(66946007)(66476007)(8676002)(38350700002)(38100700002)(6916009)(66556008)(8936002)(316002)(6666004)(44832011)(6512007)(2616005)(5660300002)(83380400001)(508600001)(36756003)(6506007)(52116002)(2906002)(6486002)(1076003)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H0o25cWc3zUaEKNDbnNsdiSBfKmjmVmpFlUWb7nJvIHZqg0moA4LWMfdvh2c?=
 =?us-ascii?Q?pQ3kviG+yG8stl2ifExlQ1dxcNFSdTL6eiy1316xTHlp2PFzmJm33pge1oVU?=
 =?us-ascii?Q?28T1+30gAfCj6QsR4TKYMK8PGt/hpvQnsBwIxa6y6Mgg66VvV5WOaoAx/M/c?=
 =?us-ascii?Q?zO/ymuZZLx++yenmwCckLF+Etv24vWM2keO045SLmGVly5RQ8bkF08IsW24V?=
 =?us-ascii?Q?uEvWrBuHh03ePTYEbQS5ZmUHOu3o67t8DrshlpYHGOj0CI1Pnub63DkWzSHI?=
 =?us-ascii?Q?G7ZL5G8t4VHUzGJArGeerEYEzTxWPDialY4sUS6375jziS+TYex3iCNkwh7H?=
 =?us-ascii?Q?WUAVejsJ3w/YfGyOqngEMxo8Kp4xeySTfCSk77Dx2sVVCUxZaO2QmZ2u/NSW?=
 =?us-ascii?Q?3IozF6u56Rk4YBPyY+7PSjxAhCkPsByM0ZdM/aFOouFOqlgX6xS6g+IBCa2z?=
 =?us-ascii?Q?f4s7oupOAVwbrAEKMHXRqQxN5j+npaux2EdwauESINVoq9TshUooJaXVCJ4G?=
 =?us-ascii?Q?Eq1uyEtrcB+lg8Ivr2No4lEVyHqGM6E2dskznoVIGEj9sEjy2n19fhNPmRPi?=
 =?us-ascii?Q?0xNhJ0+Vf/gfQ+aWd/pYhDaS7NrqKca6mYMZWyZKETsc69T37TfSWR26LFlb?=
 =?us-ascii?Q?UoCBNfiAT1pRl+y+ibAV+KQdYsIwI2bu/vBqI6M43inv3LbI6bdbeG0Lr91D?=
 =?us-ascii?Q?UezYB5OYXx7/XfskenL78OCXLAJXzQD9T2hdpPRn1ALNsOF6XVdgmXY3nQbt?=
 =?us-ascii?Q?fbZbQheHLUEwEj4l3eo3zBoQecFIw2ohxXlnvJ92qu0lH4Rlm7dvVABly1UJ?=
 =?us-ascii?Q?1Oko5yxpc3HjyjbmT2IVDpPZThfnorulgZr3IeMVEYmZOx/IwJXfHlFH1xed?=
 =?us-ascii?Q?osZJ4K/7xegKWH18XM0krU4V89ZVD5N2gaEc7cWe27430Q3xV2T5HIFyFpd4?=
 =?us-ascii?Q?KSnsnn0PVYNy6MImrmdWvfter8Wq1jJd2x7K7L+3QzCiDaqEKCMSrsKvOkYA?=
 =?us-ascii?Q?8+OK+G58bQeBS2EpBt++485PHBToAnKCm9rcYdP89vl+GmLo5zW8NGEXsLh1?=
 =?us-ascii?Q?8QDh+oL00Rze8gVLly2V4KUn8Hg2h6fLHwYJay+pkQR1tty6KciN7181aSDx?=
 =?us-ascii?Q?I/YjGLdF+SQq62hTuUBwlaMUhT7W6gF8qMKlbp5MdSTX0zn7vfk1ucB4O6bb?=
 =?us-ascii?Q?GqmFJgEYyqX5Yz/wy1amOEsA9/PpRMKreB8QTQgmUsg8svUdHw8Kuu9IG/5X?=
 =?us-ascii?Q?TFDK3eoJ64OtfF0Xgc1dxLK1XXLJYa48rhchez+GWqLzslAQj9aYDtjlcEG9?=
 =?us-ascii?Q?H7+tq0TAAnjB/pPSpwBEFmLVB7SCnDWo/k3rGi8F9K9NGwVUauQO5l0ilUrf?=
 =?us-ascii?Q?dMirDpWx3ki/QPUbWJamk7WMe2YxhJ4fdqgtJ3LTihpDBqE7++cQS+p18qzG?=
 =?us-ascii?Q?bajJqENEEGISHEY5uGIZVBzyoyuL6KL7j+dQxBcaGhqA4uJ7RCfMXQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2eeac21-1f0e-4f28-1a62-08da06869254
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 13:20:27.8122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nF3dpICwmG0xYT+DY8QD4la/Nz26ZSHXXFRsb2wNzCun/EZYunac4tZ0I1dAQhU+QGBKSJ6H8zANpY/P0we5ZxSAydwbvapcuKuh84MD7lc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3016
X-Proofpoint-GUID: sl0-vLdznS6KJpP5-P20B2wUi51sYH1-
X-Proofpoint-ORIG-GUID: sl0-vLdznS6KJpP5-P20B2wUi51sYH1-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 suspectscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=953 mlxscore=0 adultscore=0
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
[OP: adjusted context for 5.10]
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

This is a backport for [2], which is the only fix missing from 5.10-stable.
Only small contextual adjustments were made.

 net/sctp/sm_statefuns.c | 71 ++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 25 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 096e6be1d8fc..ee0b2b03657c 100644
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

