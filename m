Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F9E58D4C7
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 09:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239686AbiHIHkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 03:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239657AbiHIHkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 03:40:13 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282A81CA
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 00:40:12 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2796rMfM013562;
        Tue, 9 Aug 2022 00:40:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=ZR1dmL4g7JeFohaGaWdNjm7vo6yYyIHUdiCRNxQpxII=;
 b=ZfsCwSvP68c8UzflW5Rek8YtQ4MtwRHMjCdqoflEWOxydlJ0wIxjbM6mTg4Ay5bbAwOt
 imDiBUK4rLFYChrHCpUX7KO8Jwm7iFoQSCYTr9BWBztQ2MFhsJMMEdZye3MJFMr8/jaB
 tm2NlDccePjHakArGnJigBzYl2Vat6evX9X2ZeKTQhwhC89E3hMuFPGFBtE+SxgJ5wwD
 HWd5/A9HDi6WAPcwKQ9UZ+sazrx0IvMlvZsp2u8Q5FSNqs/tklvchKl0cYdGv7aL7VhJ
 rHSSg7/iaLtQo0NqaaCoz6tOB4fsS4O3w41GAKMUcYmgC42jmpokrPw8gqfhXA5pmaf8 Wg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hskk4j77w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Aug 2022 00:40:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8Ei8BZb/qCoMcDC9NeoHVW7uCyJAJj/DejjIJifAcRkQMx4saTPSxo7gLlXcKOz8t/sK8PojWJKkTFq973H8XTcGh3AOszTurMeKoLhw9NqwGmdQ18HK+KaV3alFLWKxfzoAbLOVF4Wvb83yeXzOs7eymV2vrVydNII/Gu/Qp/1cI2cuRmEV93UDqRMur71hwAJDyI1a7bNQ92NwotOcW3rIOAZIj6T03o5nwYHuXbeVNC0/nvOBCiWA2g+aJe8VuQbSSNx/1WY07hTaPNaUrfTkjttfZr4ozExm2dRI+qapWEzdJxZBCMCVdNtWiBVKhO9WllHnHqegjLObiYzLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZR1dmL4g7JeFohaGaWdNjm7vo6yYyIHUdiCRNxQpxII=;
 b=e/3IqTMvJsZ3x0udlewUs3WDTcHBxU9N28KCif9nbgXClP/ypt5yIDfRU5iUB4lGi/4Czm3zt5KhHvcLzVoYRytmVeSDkG7HPubjoHFIaK8yTXkTjp77lBzw6rQG8xCfCK3CFminnO17T8zZ5RMczfoyXMz5FuhXuK/0SZ61w70hIypLx4HkexMAhsGdgDEfx0+zSKme76YEPR6AC0GrBm1A4cgN8/6ZJYHoZY2nBuFjKzc9y1Wm7pVbzvuEMpsibVlSzUWHAwVk/8wZVnA4AwHLCn97x1EFeIcIm0mRdkYziWDooFiWZu+e1Dd34/7hLNGaMkBC0LqcnDuw14SB9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SN6PR11MB3070.namprd11.prod.outlook.com (2603:10b6:805:d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Tue, 9 Aug
 2022 07:40:07 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 07:40:06 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 2/4] bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()
Date:   Tue,  9 Aug 2022 10:39:45 +0300
Message-Id: <20220809073947.33804-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809073947.33804-1-ovidiu.panait@windriver.com>
References: <20220809073947.33804-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0060.eurprd09.prod.outlook.com
 (2603:10a6:802:28::28) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 360de0ba-3d5d-4eca-7565-08da79da6135
X-MS-TrafficTypeDiagnostic: SN6PR11MB3070:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KqZmRqqtn+mcaYcPUC4sR0yCRG56DJS0a3gGCcEc7+vlcMZm2H3HOyB96fQr+bokw4nv2wlTZK8x0A/pMHrRDj5QMyGOyvO5GammQBlJT2dUuLZZWffti/X6fj1+Qx1TYQJi61LJ9GT7vN1YxOy+7X688OA6vn+GYDGBSaIDtXQtIjesaaws4Ok4+P7SDLKibgU+KugNoSOEcSj0a2kCplG6o/X1F5t09Z7FUUsWNV1hgFhoQqwO7QRL0zN5fHstouwue3Z+CM6V5LCttzdhSBO770Xq/DBv+DUII5mjvemDxkAXQrFhgUceBz1NEdLBVx1LsqDfLJ4mkFDoCOLnj1U/NdH8NWv8FClHyr5OFgmmr4zsefpLlPFOrL0mIC7Dcg3KSa41TlSw60WssrcakyBOAyDu/cHA9M2T32vzOCFCAbeVNzb4a1frkVrDMXMIzedGO7jsCXnTOP98oQEIIRZ6EADU4UJmV45WWHtUG/epaOGMNktR18BWoOVzDgOWmFSFpbwP46+NYZx02QXF+8SPPCaPKWktiKuojnEM1Ey+oVfEsNthVDKaTJVN+z7e+b8rwGAC314WBlbygGvtIheEsLk1RGVWV/WYh+Y5A6cG9Fzydoii5uHGGl1RZLVTylmuBq5pDBN2D14nz9Dk9L1RtFVLJo0OFaAw+00dSDBrIUoAN8mBHf22XkQI21ggr1hCyEeo7BaSm4boSvlaNoHKaBrpn4wwaw/ubbsFBXjN/VkoXNs78rZ+vVedzU7eOrv6rbpiWT8kcxvPRflW3ENOXUpztBmp3o9vlX2R0bGIAD4KWJt/REl4G76q0d+N2y6pCGcSxaIe6NJyzDU+4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(366004)(376002)(39850400004)(41300700001)(6666004)(26005)(6512007)(38350700002)(52116002)(38100700002)(186003)(6506007)(2616005)(107886003)(86362001)(1076003)(83380400001)(44832011)(66946007)(66556008)(8676002)(4326008)(66476007)(2906002)(8936002)(54906003)(6916009)(966005)(478600001)(5660300002)(36756003)(6486002)(316002)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zH426tmDs+BwqCdj29HxXDeEwibwOv40Ld0jEu5+Py6GpR7XbS8PUqZ6FXKd?=
 =?us-ascii?Q?/6zHWhaICBGjLneGrA3aUiogoVRtUp0qRxtN3VNaiUIyoeUxW7Cr0UhejZkq?=
 =?us-ascii?Q?P9z3vu6GweSF1h8LG8uVaQzIwrPG+wgVU6jTM6yTolL/riO59eKe92sVRhdb?=
 =?us-ascii?Q?yIdivqewkBdRyhx2tkO3DIaiOrSg7gIwOQq4Yn300LSKHD7RJD5bdOPP/Kvp?=
 =?us-ascii?Q?mDQbVnL+ISSuVtpnF804Ht6hMoOl/pX596PVqx2bArVrri+QrlgmKNKqJ7BT?=
 =?us-ascii?Q?dZmLlbbPiMWmtPAEGPyKftv/+8zmVSenqauYViZpYL5QH7Tkno5nUVrpm9EZ?=
 =?us-ascii?Q?9i74aN0S8c74bEiAxfAfhXRhj9KF0aECOplwnWH1V47HnhQb354QTG3dDyUO?=
 =?us-ascii?Q?cwE3pXcGGFrH4Al70pkmEc32FfHHoNtnw4NR7BmZv1bBLRNp4pvXUhP7+jjw?=
 =?us-ascii?Q?DnUtqZcCm0Sy8axkS4EYIVK6aVGANW7Hi2HZOorAf6Y3UO/0xYxq0hnjgIji?=
 =?us-ascii?Q?SGxDYDp8PK09jnJF8fWvEiOOSnewVzoLe9W0KwUndH28qb6DW6PIBUMxaRqY?=
 =?us-ascii?Q?ne4gS8UMZ7C6HKgt1Rh0wKuTcwJPriEyZqtszpy6oXHgRKCZIRvO3Ucw2UGf?=
 =?us-ascii?Q?yV/52kj2gAVJC8bcSkH5oZd6y5jWjpHM1UdJHBYis5ZGqnzOIA19170j314m?=
 =?us-ascii?Q?sf9/dMx1VJXBwJkNAP5hnIsMFd8PeDbAHpg4+A3o3WXHufCWo2hCdOLbuV58?=
 =?us-ascii?Q?vTiwURRfMb5hNb8e/9oylqdcVk/BjkF7EE2qBhJdZomeHu19ZmPIYuweFPvF?=
 =?us-ascii?Q?VVEoYtW+NQJCvpvze0XvjBWearfwM+gDtHpzdsbHWmY/aEj4FcHGlahyGedl?=
 =?us-ascii?Q?Lo8bKA/Vu/Tfel14QrA6RgQD6ua+GXmmwSFTS6h/KQX+oj5Q2YFgWmiCcQ1S?=
 =?us-ascii?Q?TU5usAZvdUoPz/AgsRzAk1HD0Uw1QJ6ZKKjD9mXk4Mpk2j/YfcKGnTuKIMio?=
 =?us-ascii?Q?Zh6aFS4DbIJBQT1ZZCy7Hzt+HCe+T1DEHOUOXwqjfeH2u+yZ70LEm3X1uITm?=
 =?us-ascii?Q?J2OxP7PkFrhObQUB03vo1LIynrxVJxge7Plr1dNt+965pPv459QKyWd59xJU?=
 =?us-ascii?Q?QPJYZap2EVFAWtnpQzZepfvUjNVBJu46RNg75ppmOa/u95qtc5yfIRwpxEbj?=
 =?us-ascii?Q?/YzpftWtWB2s067ZugWv36ZwWqU+DmOPfykfcTXSD/6j+bThF3OyDG91YXou?=
 =?us-ascii?Q?5NZ1xohCbVx1akLwfgGtORpHnM7JR5zJFjX5mSlPPXD9bu4v850II3TxAxzC?=
 =?us-ascii?Q?nL0ytcym12eqM+wMANO7nfdzuXQ4O5DKckXNP7aihbNYslmk2YuzIjs4M3JO?=
 =?us-ascii?Q?88/QxBd3mdh2RexVkKI4QP6B/OMec05QkJatOB0HrabIuRm2sb1tCNx2yL+8?=
 =?us-ascii?Q?r2fqEZWKMXLjVnq9Ppzq/MVCjQ1LS2WBfl+Wo/sFSHdlzRU2C0+WZqfobrbh?=
 =?us-ascii?Q?tbPMtodq6PnpRddYm0ndGPDsFt3VTH8NlRLHI7jT6153dLAu/8uU3ZElYyro?=
 =?us-ascii?Q?Cg2E3YsVARa7HxIBy6/YQR0QT6omqQzVHbZHe1yX0wKQwlLjo+KupZjr2+1g?=
 =?us-ascii?Q?sQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 360de0ba-3d5d-4eca-7565-08da79da6135
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 07:40:06.8320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IQ4JXmi9+xVI7DqaEgqg9hVjzsd722tffXVrSOVo3dvAaP3BHoYezV5gaFTuWgpcmgpARoAlUf2KS7LVt08dxzdX1I6nQdUx+EOkJqr/CK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3070
X-Proofpoint-GUID: 9gfKs8jr9Qi83Got5p34o4qF2v3TwUi2
X-Proofpoint-ORIG-GUID: 9gfKs8jr9Qi83Got5p34o4qF2v3TwUi2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_03,2022-08-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=927
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208090034
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit 294f2fc6da27620a506e6c050241655459ccd6bd upstream.

Currently, for all op verification we call __red_deduce_bounds() and
__red_bound_offset() but we only call __update_reg_bounds() in bitwise
ops. However, we could benefit from calling __update_reg_bounds() in
BPF_ADD, BPF_SUB, and BPF_MUL cases as well.

For example, a register with state 'R1_w=invP0' when we subtract from
it,

 w1 -= 2

Before coerce we will now have an smin_value=S64_MIN, smax_value=U64_MAX
and unsigned bounds umin_value=0, umax_value=U64_MAX. These will then
be clamped to S32_MIN, U32_MAX values by coerce in the case of alu32 op
as done in above example. However tnum will be a constant because the
ALU op is done on a constant.

Without update_reg_bounds() we have a scenario where tnum is a const
but our unsigned bounds do not reflect this. By calling update_reg_bounds
after coerce to 32bit we further refine the umin_value to U64_MAX in the
alu64 case or U32_MAX in the alu32 case above.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/158507151689.15666.566796274289413203.stgit@john-Precision-5820-Tower
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 30ac8ee8294c..694ee0b1fefe 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3496,6 +3496,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		coerce_reg_to_size(dst_reg, 4);
 	}
 
+	__update_reg_bounds(dst_reg);
 	__reg_deduce_bounds(dst_reg);
 	__reg_bound_offset(dst_reg);
 	return 0;
-- 
2.37.1

