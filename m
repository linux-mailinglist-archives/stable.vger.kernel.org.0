Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81B46AF999
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 23:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCGWx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 17:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjCGWxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 17:53:03 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC88B6D1F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 14:49:47 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327CTFdn013637;
        Tue, 7 Mar 2023 22:48:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=Mw8L/TYqeXxcHRL/al1GQNLxsRIOdzjh8+1G8fPUEkw=;
 b=j0Xb0KHnOW1KOVzSb352KLc3anlO8GhflKvxPGYNA6RMGjTLvKOEQ+eWtFPhA1eSK/wu
 oJ7Bn5rE05r47zWcWXUpvQ8/QfBpIkGr9FpiF/uN1QfYvkAs7tnKsu/jiYxrgtjQJ+qd
 HNmK4c193pD0Bke+8OmYNlbSoXWKpoUAeh4qDdPZbYTyfMeoHX1XnGjm8eArgsNa3hVr
 P5kmqlnoawZUIVw7VPLqgx/Fek+KsgWc2xh0B7anfw5x0TM+kjQYte8VQHDW/FgaQh2P
 y++lWEUN7V5sq5Y5jqfve61lFzDw6qDTLShsfLFUCiKElYuxkej/eWUFJy6HLCNUOpym yw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3p3u72kq6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 22:48:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GN4DEhwqeUJIRtmXT7zDpariaVuckgNNeg2P29C4+AvsTpld/7j/sDeBwnEG9DY77bSA94VU7LhirPmuRYqzTTWmhbGaN3nhhLuTz+xsdV2yL5fo7tmMGuneqgLd+cJXiTYbKw63wctV7LXt94Xfe8DW8TV/y3+wk4EGEIjefTz2e0vhM0eBweYL7e7Zzy/E75VNjQ5cKV8ft+czXksRIUWj6n/0hPFll3ApfcTjU2Y0sxehX2E0St6s5pa25vXu6irEx+Ba8HRfuwEJiWpWE+LvvHBVOfry0bfvwZsz90FGuafWYPQ+jZg91VPQfWSw0KEhXVLs9dbdv/2cwLlqgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mw8L/TYqeXxcHRL/al1GQNLxsRIOdzjh8+1G8fPUEkw=;
 b=fMhNzvVdSRQgi9gmdDMfritDZNlCHCNBvgAfaN2cFi94/4PqgjOfRsXAkZH8ctAU5NLy7V9ugpAOPI2IISIL2HLJyQrTcmaEE34baDc5Cltqetzh869D/kP2d+6UNsHTsBv24LRHtJFkMpHJheZN68i239EOqXRli4vpdr2mhpoGdDt8zm76kUDK+e0NaS4UJUAJUSAov2BETcDJr5VO2OeU80tGT/S20bDsT4Z76yNQcwbpF8X1WztfXoHaIuO6gELWcgnxOf1SWL8oJXlqw8gU+cQAwE3uYd/fuXNe0kijPJH5XfbYUduz7tUhWws5iWQ8Lwosa5oc4VMgLBkd/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by MN2PR11MB4648.namprd11.prod.outlook.com (2603:10b6:208:26f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 22:48:07 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%8]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 22:48:07 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Miaoqian Lin <linmq006@gmail.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.15] malidp: Fix NULL vs IS_ERR() checking
Date:   Wed,  8 Mar 2023 00:48:25 +0200
Message-Id: <20230307224825.8132-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0268.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::41) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|MN2PR11MB4648:EE_
X-MS-Office365-Filtering-Correlation-Id: 955d1286-4b56-4ff3-2d6b-08db1f5e0513
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: luvy5IGO4QSJxtwx7r5WzDtIukb2hjJQZq2Gsod+qAQrlMrrYbNbSz7O/m/l20Vk+8mso9kKlD2v1HH6yFzF0rAfbLUEkpVt9SXxG3e1QjTh/rwm7JgnmxX+I2Pqoy00VTnkuZiXK3rsbaenGkNtQNR4jY08Lr66zcFxrKK66CJnhSDbi5eD1U70XMmorzn/CA+Eg8deIz11G/qYCetqyEPtvzl626rTroZTC3oFjE6ZH7m6MfZ3KRJXqex/BOI9EOmqAgleeAuqTZraa1lSWpaaqe0ju2/eGj+KFTY1Wa53Hq54L9osOyRikfEtU4yaszTBddMA0W4AjqHfyTShBAC+yAkcDaHASd4GYNfa+N70WX+A0x+aO6nzUo9igTA9JMqIAmxehoiY03oFxiiS1bYSM4d+pL6KcMEP38jcwxWv/MgGaFeSt+7cYDSVbz+MHqeCUci5PlpufKSlK1lyFAx8zRal5GVXdhbyd1sQkYwaSvwzyWyICoN91MSFAEe3JVNHPoikJOMtJEwWz5WZwFDbHwVQSifVCpP9BwVNQHBkr/mzDsWXGz3XPk6HSC3aMG7xee0Gs4rgRH9e/7Xlch21BrPidnvmpnJQVd17lkvq72wXS7OxFzz/3wjzEaQwK83oHmf1O37fH8GvwcFkgu1vkxYQ43vycdN3JOEG/2pBDbGtXCGSN90poteQO4gK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199018)(4744005)(44832011)(6666004)(107886003)(52116002)(41300700001)(6916009)(8676002)(83380400001)(54906003)(86362001)(36756003)(4326008)(66946007)(66476007)(66556008)(5660300002)(478600001)(6486002)(8936002)(966005)(186003)(2906002)(38100700002)(38350700002)(26005)(316002)(2616005)(6506007)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ePRQ59QuEq7zAOl/1VHxAFhbRqH+vL6x/oBORrAJTqKgIQEaEhVUeK8MS1Rv?=
 =?us-ascii?Q?uL0PiVcSYC8fmS3/eWNVpIeY36tbvsYRNZlgSympnUBQ8mfLMB3EbxN5Upd6?=
 =?us-ascii?Q?JvWs/PGGnTAC8M3X0alwbkTS8Uz8e7M+GmlfZKrCMmC0R3xvgTo/Cm6a8oNi?=
 =?us-ascii?Q?NqT9roxvK7A1KOa0jLpg2MhsgNAoyhb3pinBfL50k5u6btFNh5G/pYPWbYqE?=
 =?us-ascii?Q?JbIdzm8MOmwZWgzZPcI6psuSZuLQuV+Ph77TGFpWNetMTVZ6pGlyouj3VzzK?=
 =?us-ascii?Q?QHdmeobtvKnSW+7nE13ZJrYDgxcAnqo7mqGSA+zaWHnl/G923l4OK1ymfKty?=
 =?us-ascii?Q?rXay+Wynp3GxHDh+gjrQZDEu+8mwUy0w9aIWl46OfMacRyv4ccAkAWLCL4TB?=
 =?us-ascii?Q?vXr4x6YHjSQCGwF+5W9y/KpWlbqlqSto8KI9Kb3DhZ4BfiXyC8mxgXQSmplM?=
 =?us-ascii?Q?yuQz/kt79u0ze7MVhNr8QoYexPFNVYn77C39OhHf2VtuPVzT2/9IPtE4Pgte?=
 =?us-ascii?Q?rZO9ujdpFXo+3AUkfbjOKfAFuOVCjzeQGOiUMkeJZ+2GEkVNRK9ZgvK5kGUP?=
 =?us-ascii?Q?THANOnUUXPSOauB5YFN1qHtr/6dTnHznMXi8MDD+6oAr+xPbOBKcau48FBYx?=
 =?us-ascii?Q?ozPvJcnpPqBdrfJzaLJ6HBYI2z5gaax8vcR6/oQjRm9C2jMpXI5mPN7DZBbJ?=
 =?us-ascii?Q?KiKUxoFh0F6gzfvYBRt7OQLjT2N650RbYkDB8UmH5xRMaAiGECH+cDttFaJF?=
 =?us-ascii?Q?TbLYtUO6FhwPS+5AWdzr2j/VQaoLtlkFs3QiMbZbMjblbigP4UpFR15I3sLn?=
 =?us-ascii?Q?+g8At77lN8Zq+B+f2UarKOWm0Z1HGPbquOIJ8fDe+txy98AO5w9D1A1AE4Li?=
 =?us-ascii?Q?G0pBmyn2+iLd1DAInRwwWRTaVO6MSGFMGxO+MAPvwwOg2vLjsrhKyYfoYFze?=
 =?us-ascii?Q?3Bup/ojf5Gv7HDumQtFo6xuqXr5rCI9mrNT3QgwalZr+eRvRDHkQAtGZEl7i?=
 =?us-ascii?Q?XxzccDnc8il4WcVzr7f9CUvD0JWdrWwv4qUcJNiWYq86WKuivFByfhtYFqjB?=
 =?us-ascii?Q?0YymhP6UNApmrYot0OYeDgRDvpfO65QzNYyEFLC5bKVBXDRKD3zmhGAgfPaV?=
 =?us-ascii?Q?Rn6dg5xFn6cPyC1iUGo7ufRxId4v9Nr99Jb5Pc3YeCViDnt2Fhr3UWsYIm6q?=
 =?us-ascii?Q?w3CZ6KHEFifUaarWN8hNGd1pJkfNv7fOW1f3N9z+648aMDlo50tlszx1ljge?=
 =?us-ascii?Q?UDe+wnVu57zRjHamSzF/ihUb2ywlg0TLSUQ+KUlDNfGwZV1lPrjeqULgw9zq?=
 =?us-ascii?Q?U5SXiBDkmjiVOcwJDFgQLhtrXvYuNhRog4Gp6K5qcTqssE0UvL3cn02+fyOS?=
 =?us-ascii?Q?Jr79FMNPUhhjh8po5uHt80Vcdgrpyc+FrUagR1kzDbCFIsAxNXUjWPGlyxlf?=
 =?us-ascii?Q?VYQ6MVFTaiRStzmGqP8otqNE/oyX13kDveFcgAOHQACFUZxLgHQE1Y4WPz9J?=
 =?us-ascii?Q?AoBiMnVF2eTUGxEJpS8678lWGc2QnZZAm7tYCuVunI7ZAmDu072L0mMY7Jok?=
 =?us-ascii?Q?FPhIpMk1uKGUIeZ4kN1dI2AO+REA29qrW3AMK4SdNQv8wkhBR0mlGk6HE1du?=
 =?us-ascii?Q?Sw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 955d1286-4b56-4ff3-2d6b-08db1f5e0513
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 22:48:07.6680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VU6v9jU8I0nir4MvwRjBfu+aHLv7qX7lj0xwd2YcrzGuhJ93+P9NS0Q9MN2naDsyglqawc9e/7SWKQCIwfGWKpYkkbbdr2S9wMLBNkBujpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4648
X-Proofpoint-ORIG-GUID: IQ1b5VD9SeWWPw_4yAgxtuC0V8t_MU7n
X-Proofpoint-GUID: IQ1b5VD9SeWWPw_4yAgxtuC0V8t_MU7n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_16,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=826 phishscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
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
index 8c2ab3d653b7..f67c816050f2 100644
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

