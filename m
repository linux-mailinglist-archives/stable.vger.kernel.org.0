Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043AC6AF99A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 23:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCGWyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 17:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjCGWxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 17:53:44 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFCDB421F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 14:50:28 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327CliPW004263;
        Tue, 7 Mar 2023 22:47:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=8aYlnnef7NxPOc6Oz19jkTse5G1Zt0XrvrlanEReRaw=;
 b=gdOqsqclkmtVT12+bTMLGP+WGLf9DvrulqFfLgGMTalhqmi+D2wwh6LBpkWIuK2HZ73F
 KOp59aI8PVduF7koHULbHc81ZjwA/KNkIRd1osTyEQ1fLhENDNbFeCFRmKYq35Cnaaai
 JK1WW3mAFursWZaOYqTAiMLduBuYqzUiZurbXhJNh0mrJrx7vXcvThCpHJTWcUI3nf1+
 2GKmWq4DunEWhvV6M84GtPCCqqLWXOsazk92bhejAWM7pkFZbc5uewVQ3oOiAkcJkQzW
 f7NgBMIALooXvdi2QM2oOIqvl+3C3812Ej0esRXVlmvsjkeMPbKPNEoWV6mg2atAcqR+ Lw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3p3vyabnt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 22:47:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0cb217YkK0TR4rRPOsac6aYWN9/x03XtBVLHfCi4ko96WhcHHFTozZj33F83G3QfWMJDuTCl0+ttxkb62qxiOz/0/VHrs5QImA7/NffXgZjsmkizXB5DPiILwAkbaATPxizqFAAnX4yXaY8NmRX1w9KubnAkGYAroFwxeqgjqlIvAQyEKZBkVa3cflqNqU679ZZYdgGTdjzMJy9LxlQS4xAvI0v0PmkLHK5B43z5sy+0VWXm/Y/jP55urpjC3lm1zfu+GdQEBTWHhIXvUGONcMmDbVIxhmaWPOgsB1jUvJQG3zPPMCDpY0eSkvwEhaRXtHE7/S8UBjWzwPDLidHSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8aYlnnef7NxPOc6Oz19jkTse5G1Zt0XrvrlanEReRaw=;
 b=hV6tTyqm4SZk96LCeeShN1iwM0b3JjiBZr5ndencSsz/UAOSjysk9kM7x+uLc8LrwrTLt5i9Fi77TqKpF7ahdzcEvxdBwxzek1b7M6lwQnzaiE3NFF94D9v9SMu3JgBIbWnSa3T0BFmf/9U8mOQneiJ3XNr8EH0yKmK7kMJPZlRRKQn9xX3nvCt4oLtWJz4Aa2io3Ru85Y/Gk89CRT5bB5Vs1eg6BWXMMgMc/ftK5Hb1pgr6UEnxDkRLvbEcu3hPdmvf8tMvLxlJjPf4wJaAYvTD8D1vjhQlaKofT7HnaZSkaFRZAiILLAllZvnAvVIe6aXwjybfDRy95SQfic7roQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by MN2PR11MB4648.namprd11.prod.outlook.com (2603:10b6:208:26f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 22:47:45 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%8]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 22:47:45 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Miaoqian Lin <linmq006@gmail.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10] malidp: Fix NULL vs IS_ERR() checking
Date:   Wed,  8 Mar 2023 00:47:58 +0200
Message-Id: <20230307224758.8084-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0226.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::47) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|MN2PR11MB4648:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ac677c4-c357-49a2-7acc-08db1f5df7ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kR/rwly703/IcqXC08r9JBIu72pCtR+f8DDWRUs3Kg7k/XLHcdVv5Ej3VrC+HCU2gp3j60Mjo0TummuPduu/kJdkmzaEd4IkZC1NrrFFajRomJKbBum7rFFzXjS4i5angJUyooa2+rTWDddHe79PJd7HFgJ+itV0UT2u0qHTpD/Jpha6sWWC9yPK0TgH7T9mITHXKTWB9hzRurjyug2MXz43Za7/yP8xYXaa7WH3QCgU5S72QiWUJpFaTIVk0Marx+k6zKnZIe5AcFnVjYO2n3pCcRL5cyrTySo09Q2KQr8amUmtACDqsJdGJ7cUsdT/yNk8bCQ2sOzJmenp1pEF8IMkFIqQPQg2Trkw3EdDrGTynH5FcyAyV9CtvCmvre1V8hu+hTYYc/FmYu8qmeqGVfI9ILnMwfLN4jyHusBf1t37JP5MfJbK3rvd4vG183+x1hdOuAdYxOi+5wFdrdUiv/7Wzrkr7KJhqaMZmoQMe6Z4AEdZdqw88AVr6TOaAoKXEbM0ap3L0R3xnluwuGkW1mvFjT5goEcFZ0UqQQN22KOaJe6JoYzDLyi4JfI9gja6hvgc3qde1BzClk5tFdsmLw25Xj9fNNqkXE2qzMbUWZ8R2mH4rLQtBPK3Ah7MRZUi2ZNVj5CUh4CjGEYlBd/NWm2SRridVqEstoL+r7f77r6aUJoJbxVnRLFdQRsn7NIv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199018)(4744005)(44832011)(6666004)(107886003)(52116002)(41300700001)(6916009)(8676002)(83380400001)(54906003)(86362001)(36756003)(4326008)(66946007)(66476007)(66556008)(5660300002)(478600001)(6486002)(8936002)(966005)(186003)(2906002)(38100700002)(38350700002)(26005)(316002)(2616005)(6506007)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x1nc2JhDNOH3Pf39eZxF3lxcVEluWE3ucAC2CqXRIiN3gl3O4oFItlxmkEk+?=
 =?us-ascii?Q?Zz/n2CzDEBcjncvuhqcbQ7pb+/NAUbgAHAvs1ZsEUG1iXyQg41Y0NQJybvqC?=
 =?us-ascii?Q?jOApJvyB2uXMngf9YjtgKGSsn8IUCi0yqtaVGhNJEUDsf9C3Z7o/0oC7198w?=
 =?us-ascii?Q?w4cKE19lgOylrHT7/Sv3VGEZskjBC6X4llem0oEpj8jhs+voYMN84by2S6+a?=
 =?us-ascii?Q?gmnlunBk8lyjbaaZJh4FFirHuraWpyC25TF5JbzyofZczjIT//FM3TS6GU6w?=
 =?us-ascii?Q?V6WvWNcvdfl0pHgILMDS5bS3WJk5Be6FYxk5r0Pi5jkwS9CsiPg1ubGiESMx?=
 =?us-ascii?Q?ubo47ckps0v9tq78p3iOq5bAq0m1ufMAVNZ+v4mpApdiqVl0t3hPZ2Dg1/+w?=
 =?us-ascii?Q?NKSxQ5TyA+vdWcAVw1ZlRakdsa+FpsH7XInRmUwrfqXCXdR8P+odRu+jEd6s?=
 =?us-ascii?Q?bsa4KXbSNgnvgmCqlmTEXQu3VGo1q52928uCzf+0TNtwh050NqXYdV3z+brj?=
 =?us-ascii?Q?adtPUXFFU96XXRX3ZtVi2Yt394tpFTYDTNxCP3A8GPiWtpnC13bDeKc//ESC?=
 =?us-ascii?Q?/+2kk9uAZwjIoPtKr4+/FadIoVmu/2Ige1c6ubZiBx4q7fEeK4AORjKri54l?=
 =?us-ascii?Q?I6/KHSVgLv0WUb1mOKXCJo4kKypEdoTaGA3EN7WklH07cvxRSdw/n74JIFFf?=
 =?us-ascii?Q?NEpOWr9brSN+CrNsFwz1nSPhJ9Ka2CzuHwdtNsDfOpxkl7DY2apFKN6+cg4x?=
 =?us-ascii?Q?IFEydbKu4GdshR2X0Wx9LUk4bQpF7d9fSz94BaWx8BVSu2BXdSLZCwN61IY/?=
 =?us-ascii?Q?xzDg2jLWatEvCWy989SysZ6HkgLW602lTpD5F6ZqxKed/NlqB5p6d7/L76N9?=
 =?us-ascii?Q?gQL6i1VEvk8nOPqEje4RsK/KqFCeKaSpqkN67sscStoeI9NBaVd83okMdXXv?=
 =?us-ascii?Q?Sn6elKsdoClpezCdoe63Yu+QTeleMxzul2aH/Ioiz+vi5qOJt7tlkspUghs5?=
 =?us-ascii?Q?e8bZtqRJ3dUQqKyDydrhVT8KbRbrAd7hwpY/iODjET+JFKg3s4KqSEVr92ry?=
 =?us-ascii?Q?ZjZnuwf2UZML0omi1a/W/spGr4UtQCqxgUvWiFqa5iimjoDHq04uX6pDrdCo?=
 =?us-ascii?Q?giJd7FM+dFW/t2/52W4iBwP+WUKh3QnLAeuZ94rbOAOer+oZsNk+aG4Mjb3Z?=
 =?us-ascii?Q?RUZcv1JEpp/y0mPDqzTZUbTg3XEpywe/NUfmnHXOtxU5MDrV+v3yFac2pTks?=
 =?us-ascii?Q?SEeTIuf8T/IloBUXqctcTSrA/XZQypfA16apChymJG+WwUNZ3lDsm4JVWgY0?=
 =?us-ascii?Q?bnZefIQBv4gwYCu3vqPfeaHpTo3QECNjFWI5UqcDght4ZIS5N15WmbV08UrU?=
 =?us-ascii?Q?KWEEzq+6tzX2Zs+DK8Nml+8PgYg5CRcQbV1rGnmQC68vxeNLRfdFjJ0kh40d?=
 =?us-ascii?Q?r8eNxRL3tn51w4Ggqn2mWOkDrorjuN/IJ2RhhlYb+zHxCe08UOSp/psqA6z0?=
 =?us-ascii?Q?qQzTjZ0fFYjtZgiPjEBtaXto3KrBJ2PsZ2GSCyVqoJ5MfouDVm763pzlfb+H?=
 =?us-ascii?Q?STVSfW4LirTeyUmUNQghEoywC1LNt7V0EvT5qfF54bfwwd9/oHHIxW61eHhO?=
 =?us-ascii?Q?WQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac677c4-c357-49a2-7acc-08db1f5df7ca
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 22:47:45.5999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RUa9agDmrNVImqhXfeyP4CVKUtI2+KZAy3y0w6D8WQjyrPKvihP8t8MWEvhJ7nG/BWar7m2IcR62Ldp7jnE3kUyaq3KrLYalRi+KB+AuEG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4648
X-Proofpoint-GUID: qUhX2yCPRuiP5Jhx0VAPZesRbx4Rmdvf
X-Proofpoint-ORIG-GUID: qUhX2yCPRuiP5Jhx0VAPZesRbx4Rmdvf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_16,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1011 adultscore=0 malwarescore=0 mlxlogscore=826 phishscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070199
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit 15342f930ebebcfe36f2415049736a77d7d2e045 upstream

The get_sg_table() function does not return NULL.
It returns error pointers.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/dri-devel/20211213072115.18098-1-linmq006@gmail.com/
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 drivers/gpu/drm/arm/malidp_planes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/malidp_planes.c b/drivers/gpu/drm/arm/malidp_planes.c
index f1e8bc39b16d..24604b410372 100644
--- a/drivers/gpu/drm/arm/malidp_planes.c
+++ b/drivers/gpu/drm/arm/malidp_planes.c
@@ -348,7 +348,7 @@ static bool malidp_check_pages_threshold(struct malidp_plane_state *ms,
 		else
 			sgt = obj->funcs->get_sg_table(obj);
 
-		if (!sgt)
+		if (IS_ERR(sgt))
 			return false;
 
 		sgl = sgt->sgl;
-- 
2.39.1

