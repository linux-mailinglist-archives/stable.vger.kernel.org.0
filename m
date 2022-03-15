Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC644D9C15
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 14:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiCON0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 09:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236768AbiCON0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 09:26:45 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CCD41312
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 06:25:33 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22FBakOo002660
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 06:25:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=H3YeaypH+0hwSB0aOvTxnvTzTSeq1kfmVPhFihFFFfw=;
 b=TsOlap0HKKok0MxshgVNiqmdMfO7DUhA3KGcWb1swcxbfqJMZf0oqJ7b+zkvpOs1A8t4
 TOFig2f4C77fnmsyjc5nqEwqzzTCrx595keig0EBprLiDyWgGp9taSXVqjQIHffeAjoE
 jEKfJhhDQClS7tkCMdEgIaRyMqybk4iE/jvWVzms86OP2XowYDTLDlohts6BLjERC1hx
 K0tT9jLC7WXEeClCwzspWTDPSKwc5GYkRraUDuxlqnZqPw/00rTdS0QFXN0FS+7BPdIh
 sj7+Gfp01eeTuoITM67Bth6Cb8xOAw3RbT/KnYHogbjl4GS2EvWlLb8S0GY40woTu33z ag== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3esq04sgbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 06:25:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvQDPIafW9D4wltE0gupUADSvkfNeeVeChIjcANWeqvIHvajwgtH7SsNwGLTNu7eGvRxyq+jS0Gz0Pc22vwJmEnNwWU2ykR1lfS5zu5ElMgX4Sy6f0nUjPKZZXBq+H+65NxCFi5CCjlyHxx7l3pMtvQopPj148FzKuDyp3mDzucWwlK3sz5QKujbMw27++3jUWfdLNDPF5sq7JTaeJz1OzoyQbQjkHDEul3l/FyCPa1knVbRQHe+0z9jGtIwdv2D0oqn6p/GduvWs5rRbolCFV1ktnoR+8iwOhZ9JBBiL4sDk4lnj29wmVLtL3XfaRTVLgezSUqhhmlZ99nEpWg2WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3YeaypH+0hwSB0aOvTxnvTzTSeq1kfmVPhFihFFFfw=;
 b=dHnKQ+iPvBlAWSLpOGsBS4oWLOz50dibC/7L0T/ncbHFoGKGpgyDT+Jd2dzhBP/pzm1rtcuMUJtWd0E3dWoVMFL+dcDDGNTzCfIVy7x3jgcWjEw9AgOs0HWNiDyUoa+/OxsrJQCNsD8qbuhU7T11S+b559pUsOmTzL6UprXTh54Y6NtmEAHyv17Y4MRv0A86lcm5p6HID/ElKp7XuQR7Dpsi1wxT1gxkDpxrOS8R+EsDWCDCHLDNqxA9ZHbO9P64OBX5MFRrfTk8JKRDXy7C22QojeZ0loK/DPaoWlI3jhZx0mgDldpk1wsuyNZr10IHvbGD2Y0j+7BbWy3tDyCG6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN7PR11MB2756.namprd11.prod.outlook.com (2603:10b6:406:b4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 13:25:26 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::4ceb:e511:4a4e:17af]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::4ceb:e511:4a4e:17af%9]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 13:25:26 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 2/2] sctp: fix the processing for INIT_ACK chunk
Date:   Tue, 15 Mar 2022 15:25:10 +0200
Message-Id: <20220315132510.2088935-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220315132510.2088935-1-ovidiu.panait@windriver.com>
References: <20220315132510.2088935-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0194.eurprd07.prod.outlook.com
 (2603:10a6:802:3f::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a8234e9-8c2d-46a5-575e-08da068743f7
X-MS-TrafficTypeDiagnostic: BN7PR11MB2756:EE_
X-Microsoft-Antispam-PRVS: <BN7PR11MB2756BA4D64622732869AD1D3FE109@BN7PR11MB2756.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IJYwqRVK99LNOuE7cuwAKMr65aQwh/ygUr7oa1wXoYQnBn15Oh771WQTSf1fzka8sNXXFEfY0zWHjiQqr7xHlj/uLr9rFRmA4nMa0zH2b2ZLUxUSdqqhCVWceAF9AB0BASK0ME3RnobI6Nlpvfc1KPS2QLF5sOA6XX5YMBCzufSB1N0rsf6aIrdSqvf5jpzxuwW12iFTAHg6SeroB268Lmvm7rbIh6vHupl9mjeFedIWXsfivceKovjKVWkXHUcaoxQbk/J0R/161MOEkFvyoxAYI+6Dy8WguVo21VudyKMdMqx5X6GP2eaf3TPQbsgyWNsTTCp1M6s2L9hJ8IqdK5RQm4sXOa44ju71vd0n5J7ijigM9qhkaxXUvUUP8HnbdHcUo7pVEPrwLqAlGzRjS0Qp/womENkQHVz79oCrXkmPLEQ7A53ZxH2nL6vjssGsrsrv2x6Hf2DeAVNhBxRHo1OrZw6zLCnxzMfMb26Ki+TIY54OY35BAF/f5vSNun0e0pQp26kmw5C35Js2jS3Ri5VnUlDhGDCUb7n/mvzcnPsPcmIXrnpQns79TPWDjMFtuHo6RUfqEKvUFB6QQwt2xZic6ykGybE8Q63vbnQEv52ESROJFN/3kCu5V3HiB9h45RZDYdGZq3OxBsh3enuJSLAyX/mRU/Yi+TUA2nld+iSPjXyNEx3jwslwtrNkrncS1P8+RHEPqDeZk/ofBE/ivg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(38100700002)(6506007)(38350700002)(44832011)(66946007)(6486002)(8676002)(66556008)(66476007)(52116002)(508600001)(26005)(6512007)(2616005)(83380400001)(1076003)(6916009)(2906002)(5660300002)(316002)(6666004)(86362001)(8936002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HSOiP/BQaDE/F+zM6KYrV6aCMl0E42RR6dmR9ZUeJ66dhBxlpVhnVSCWUyXu?=
 =?us-ascii?Q?Ga1qvq/VPjEZ/5lyNUcRB3UtTeg5hs/2ctJa65rmKPGZsLQkLtudfmL9DTmA?=
 =?us-ascii?Q?ZI8fktEqtnEu8pEkk62GIMyjtpKWXTcEhCvY+VP1xL8kVdYO77qRTUChNrV2?=
 =?us-ascii?Q?dj2WJm/k1F4n0myOPjZ0i3YFDTLElKKzOJlwqzM1Z8nU8Sy5jsf8if3LQij/?=
 =?us-ascii?Q?RcNXyVPXNIdMM5HMU3wTeZn7L5/T8uTJ1okwldOifxSB9FwJ4dhoDyQDJSfD?=
 =?us-ascii?Q?6aDJwXC4yFTAI4Soc4e+kD+hnscOhcX5ex+i91ZwbFo1KQx7ufukM7uFO7N6?=
 =?us-ascii?Q?mqgZyoXSOtx3yvKpW+9GO/koQtRRfOIjSDwlkk+LcdnRuWjqWgAEMRvXODaV?=
 =?us-ascii?Q?ExyXxsuGvElKHSai+9XVkXHk5GrgLEfLYrPC+JqFDFjRI9Z/SYqK75h2F0HD?=
 =?us-ascii?Q?WmEUCc42GeWYuVSgJa36Pa09QL/0pZgMydQpUxWnX5iBSh7MKumtdsPM+YfA?=
 =?us-ascii?Q?1yqnG4Khue/z61lVR98XqH56wb0U+23DRSeBqM+WBvPQXJ2n++JmeojOkCQ1?=
 =?us-ascii?Q?vVEgBVLWfV787qIXJEAGrODmX1nyEhTEjx+pyjXhg9Dd8UjO2x/5Xz+r6gI8?=
 =?us-ascii?Q?FaaoXlY9PmxVbWuousz3atwFcgcDNEtcrJwDVM362Co832Lb9U5DGqHH4MT/?=
 =?us-ascii?Q?xpjDm9lUQWxpchJs5xVmz/D9ePYOhB0t2OYBiCHPB/v/rlDUiw21hhW6u7zJ?=
 =?us-ascii?Q?va5c5sFk2FtxC1bGMGainzNtWRC3FlxOiUyhjzbn9bNyUiDkPwkyn81Izp07?=
 =?us-ascii?Q?uihQpE5kYOJkb6ROIqbr4ij9+7hpZUwRV90a/du1EIeHpCHFYNFwllr7nucr?=
 =?us-ascii?Q?DQj/dFHrBwDFd7i4wUptlooDIwsVMs8vokg+7GcLdpjvzV30OMesqJ9ytY0i?=
 =?us-ascii?Q?TheBgBC9X5gY9KEgAd3c+4hU1eAD7Blc2xLQk+DQpF0F1KwDrj+rVfQQ7ZAs?=
 =?us-ascii?Q?fa6HB1vRV3ZfXRTrB0xDmjA6HPr5FIsft+WJ4SzMtLR5Hc/Ej9DPQjSlwoGT?=
 =?us-ascii?Q?VaWvjQSXvfJaClIw1hQIQnMFNMz764v0P95lhMt/NaqLgZ1tFzzI24z9q9UL?=
 =?us-ascii?Q?i5a0ZEM/kO1o0tRPDbR02KNzQFKzg29zt/IClVr64thiTC1SruNstxxIRVJn?=
 =?us-ascii?Q?q4LpAoVdY1EvgVMQ15LmFIhMKP1tukSIfMQSvGBDjig7f7Fz9V/QLexV+elz?=
 =?us-ascii?Q?CjioQwN4QFV4ketTFmqnUdfAsF2VFBEJns5L4LWsg3g28aRr7YTwrSA8N7Ru?=
 =?us-ascii?Q?Bnk3g0wvr5eoIX1t3CFU3q98dZ4MLsHna3hASs+vOmKb2MIpDBRzQdifHSJq?=
 =?us-ascii?Q?6+eh+m+4WQL4Mdy3INYrYGW5J19hWvQU/v2UlucqvBfRD3IlAIn2+p63BsEp?=
 =?us-ascii?Q?BKCLFZOEeBzJjJ8OlovMBl3mM9v98xju4i+8/uN8EpNheYTOJAPwZQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a8234e9-8c2d-46a5-575e-08da068743f7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 13:25:25.8855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GLhMNKGo9PCsqdtFtsSWNjfdPJreadUVLNUTWcbdRYRbDcaqgXdyR9LpVE+2/6stWY+8DXMFHA0NOsPqHQJ3vqtCJidFzsAWPgiATu7UlSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2756
X-Proofpoint-GUID: -8D2J4cQCb05N4Z_vZkTkVqHzs_w55-l
X-Proofpoint-ORIG-GUID: -8D2J4cQCb05N4Z_vZkTkVqHzs_w55-l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
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
[OP: adjusted context for 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/sctp/sm_statefuns.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 5e17df88df5d..3d52431dea9b 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2304,7 +2304,7 @@ enum sctp_disposition sctp_sf_shutdown_pending_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -2350,7 +2350,7 @@ enum sctp_disposition sctp_sf_shutdown_sent_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -2620,7 +2620,7 @@ enum sctp_disposition sctp_sf_do_9_1_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -3787,6 +3787,11 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
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
@@ -3794,13 +3799,7 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
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
@@ -3929,6 +3928,12 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
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
@@ -3936,14 +3941,7 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
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
@@ -4515,6 +4513,9 @@ enum sctp_disposition sctp_sf_discard_chunk(struct net *net,
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

