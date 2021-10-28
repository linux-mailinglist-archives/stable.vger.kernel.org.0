Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E815B43E78B
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 19:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhJ1R7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 13:59:20 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:14604 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230192AbhJ1R7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Oct 2021 13:59:19 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SCbOUU009266
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 17:56:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=9WA/hbqpCT//XDLkxOoTQeVP2CzD80s5uIsQ+5jocE8=;
 b=V/pw/4WpUZrOXqqk2FgachPjLn8kuMfln/DzDjzKy5iL9D6qETRdLO6W4eCw012Qc0+m
 XKYOe5ENJCOb0tUkrqcVOCLGwWm9ztZbfiWrtt8Hm7iLCKi4XAPWhlHDt3ra37alxkc4
 SFE0U23SbWFBhSdLQ8iVr1N1vyG8HZ3J0SkwzYZvupNN6MV/eoSRZ+3rEsaO0caU0jD2
 Ibhr+5E/BGAxiIxvuYLGsLCyhk3nsosebA9d8aPsJItn5domrndMsJm9Ql251MO7QvFT
 4aKUQIWxbqw8LW+EAHIRgeLFx+tK9I6OTSy8VOceZjXMSvbitpFWkIM/Riv56mMmBgAe dg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0a-0064b401.pphosted.com with ESMTP id 3by93x15mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 17:56:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pi/8fZ5EwRm63ptQ7P4Clkib5v4fIEa6Pwq53k7IIai4cS+kk1rspTqsTwQRBntTMk6umviYjgDYiTBsyrpQs6jQwkdaH8DN72jQVrQsKsxPsYt6qhpIbNhGMbcEazCgvBqCan0zWqXhYxRq25SyS/T/tRF6JB93MQYIJRI3aYkdxgnnaHcPEVkMiymmQuNKH3x3sEv/LfwFycSPgXCNzBfYC7Sw+D0aj61pF1VOhh3/nTO4WFe32G6pe+2HVQMwncSj0smvFrFfEo31SFR7fkmAEiHWLWWttsqRDhvuwTk694o6ze9ZDps/ZuMBLJtecU2qylbKu6UJCA2OzOhT6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9WA/hbqpCT//XDLkxOoTQeVP2CzD80s5uIsQ+5jocE8=;
 b=Cc8vUwG0C4fx56om66bRaiBrV3QJ92v4Cb+Pleurr6E1WDoNGU+uMuxE7UBNeBpvtQKfkwUytzlwQ9DkDITNCRJ9anTJvpSf9qS9Jis2HWwjO4meIbvs1j0JVDD/lP0TtqzJ0qTUKBxuUNuw31XaN6bB83q2Zj7t4pIjXgEAipNYjOamgs0bmtu1F481Lg1YciJFHSL/31Ph2uGLNcvDAa1M/vGNRlnP6uJ7tU5R5Z3QWYnFmaqYueFvxHf9fJ339UY0zDhBJByyXaGDEyC5yxhhwiagtquoJhTuywuhNBdt3PLhgk5wtwRjR53nFCk1QdOJ6ziq5fGA41DMg0r7Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2874.namprd11.prod.outlook.com (2603:10b6:5:c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 17:56:50 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%6]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 17:56:49 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 0/2] ipv4/ipv6: backport fixes for CVE-2021-20322
Date:   Thu, 28 Oct 2021 20:56:29 +0300
Message-Id: <20211028175631.1803277-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0067.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::35) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0101CA0067.eurprd01.prod.exchangelabs.com (2603:10a6:800:1f::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Thu, 28 Oct 2021 17:56:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36296217-4170-4336-085e-08d99a3c50c8
X-MS-TrafficTypeDiagnostic: DM6PR11MB2874:
X-Microsoft-Antispam-PRVS: <DM6PR11MB28740929776877C50F283A5FFE869@DM6PR11MB2874.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:473;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m82A/rjJFYWhXnZKt8aR+KQ1d2a0cNclURyF6R87pacuuy9k5ySNKzZ4TsBI+QiUp0TZvmd7EFAU+adWEnQ0jEI6HL1jZR03RSQMWylvFmPfpLqiMyYF13KBi3cPUDpG0A8QGGXcEgNPab7kJoV+BM095dLMAcFj1rjkaP7mOO9P7xXxmT2IJ/zzArBflR3W2MoRd6A87h6J3QwiHJU3zbwc64npoN/AgMVmW3o/OvxwKXO9zyCiqShkyWezaxYkIaJS6RIbCQqhJh9NnxyrMhksugxZUszrBD+AUnLMrJOBKhouZ4fRmSIAsglJ/Z44Q0t3+EE0+WAIEgAORWr7x3COuwZWL1MPiCdtjFZF6Hi/A+Qo+TbNBwEuIo8LPPckRSV2K/0s+uLEAWq0kA1QDJ+0bQYBSoREvFRQjRoL0W513V09IAtb745gy2w1dPXbdFF38CmANj8I3tIk3elQ/TFDafldQOh+ToYWLArMua+jPKKV9+l0JsaVkFJzA2ufE4ZodiGVfv8aJnJVy+pbUdee3IcWKt3gkjCulwo4bZVOT5/He2aFM0Wb0eVqswZDsR6TPvQ07QsvBYXk+MqxJx/d4e/Sf0voLpv6LGLZOdAvTS9ZFh1c02i5LMyaYr4DEPdhlnmGWOT8eKLHCt1keRrHlqp28v77hAFQvqq1Tyw51587pOH4NhD/3FqasJra2UhCa/sHmKGipcH0rQ6dFWYb43ivDjGbC4Wf0b2QqhKGj+JoKcAg+VIpFkh0xDqOkhmqnIVpP3w2pRw1lej8WyemxlEKpcSV2TYSIOBsbcT0Id0XfFNUCYrVQR/5fsBi0fkClqBgOvKw2qfF4aN8oQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(966005)(8936002)(36756003)(66946007)(186003)(86362001)(6506007)(6916009)(44832011)(956004)(8676002)(1076003)(508600001)(66476007)(6666004)(6512007)(6486002)(316002)(38100700002)(26005)(2616005)(83380400001)(38350700002)(66556008)(52116002)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?inCfc3gDQVMWPUR44bp4Dc8xiNpVc+DTtCg/8M8gC4BqlgW+46DWziDKBwle?=
 =?us-ascii?Q?mekN4Q+V/q2I9MRZofkfokgSM7hDyskx+++UZiRPYRnEpsxgk+9M3CzLXBgk?=
 =?us-ascii?Q?9R31tYDW6EVxydMtp/Qfw4ZelKjeWsTG3UbM1dbr3R66Bxm1TPeSc/75a4Gy?=
 =?us-ascii?Q?czRUisYcsRAv04hVNtWtEdDQmqF2KCJB+OoY0wgBuFfydI3u3pbrk9AzA+cv?=
 =?us-ascii?Q?dtX8TzaIal9WBjXcBqVCB7DfBJdhVaj/muBZoGhAO0GPeimsiwneWhYiSU/3?=
 =?us-ascii?Q?WKL+58BJ7Zb0SzZzALdJG5T0ZqEHbQo5YZYExNykQx8sMWl8if6HqmVjie+O?=
 =?us-ascii?Q?hScPnJKKP3tLln56jH98hWx1GTAl+stK5tgNbQG2uAFyCejDfy4A+Z1W94KT?=
 =?us-ascii?Q?3R97ByXInOmrL8Iiei4/ncgoESFKglX8kc0HBGuCHZ3NiJT8xzh0OG3QPZI5?=
 =?us-ascii?Q?nd2kHYFqY18b+uDOtnchQTlC7gDXU8T5kEqXTysf9iQ4x630qS4kUHZSvoVN?=
 =?us-ascii?Q?WFc5TUUyBRSJnW02PmtG+YEGzxVW/mfKuH/tqnhxmMp38hC/Qwlql86uznyi?=
 =?us-ascii?Q?MJvlztJ0Mgl6wbayA9lL/UPgS2SL5Lswx9Mx3RWwNYuDytbkcN/cVUplPPCP?=
 =?us-ascii?Q?4oyx6ThTZE5IOf4OD5ZX9msHz3pIVSaB9hV2HtPmepXJFMp58tPGhTKyGbCZ?=
 =?us-ascii?Q?lJsw/r3P6VJ6/I6KjdV7MbLEz9WJx6bCsdwGi7uFN89skdiab+DZ/SWNbzEn?=
 =?us-ascii?Q?A2ZiKFKgqlvGiIlKCossAirf6O8VLqHpOWUOyW2LzGMf6k2rftu2+t8FnwHi?=
 =?us-ascii?Q?JYSYLxo4r5UkFo+4RPt/76KabmYVoQ6mMfvrle8MCRnLGVvX3Mm+4boVow4d?=
 =?us-ascii?Q?9mGrUuzdHiK/dxbkeZ/DqcZfZW7mwrA+94NqLkdFCMYnuuoYeZ2S//91MRxv?=
 =?us-ascii?Q?ROIWAH3/z7PzpbNfpvHBqMD1ueR0LHr/Mm7GPYWmCtQvsYmPaK29/CxS11NK?=
 =?us-ascii?Q?athE9vzPgrFJKP+9dgbnDAhtStns89byzEZvuKBQNAuDjL+bha9/9oKcy4Tt?=
 =?us-ascii?Q?mU8DQ1FPXxT3YdgtRSZd7QX42fchkbyJsi0llRuQU5JqAd7xbrqbIeNSusrn?=
 =?us-ascii?Q?8HXfAytDpucj3AEW5M+1blhpux/22SsNPnMKeVcgDSmo6Yi0fKcacEapITJP?=
 =?us-ascii?Q?J1CyAIs54L7OYhSddbjSGGMFDmW1Vnr+tiXbhBOtDbQL8nuklgzB6DUYnlvq?=
 =?us-ascii?Q?+F8BEBUnzKnRsoQYn9hOwpKzYSsweYwyRkrlPTICg11qvCjcXDtqXZRK/XlC?=
 =?us-ascii?Q?fqzirhsd5M2P5BzRaR32lutBA7Kvki4JGY9t994YpYHExn/kljf/0B49bgn9?=
 =?us-ascii?Q?rrjw1HLpdp02Grp1bPcWkesbyBjVlkDDEpVMDpIU4Arzl0BN7AMGV4eFn02I?=
 =?us-ascii?Q?wIVQV36Hg4xYuifSuGcrxTSCfU2OoFs3u/Xry6MljJZ5twpwey+fppqiw33/?=
 =?us-ascii?Q?STZkDkAbMlc7JFkLHhlAJf0DABfhAMDFN1xV0V5+8FSFRnlMnq/6nFEo5qbR?=
 =?us-ascii?Q?8ph1X3ouWROky4rNBr2PnQyo6fRhNwqsd5C2TTAP0CUK2uZ0G/q9IcfQgwy8?=
 =?us-ascii?Q?23TSM8fz61k/HTkSLRBqTVf9vI/vzuJdYa9SXdWhZmZ8+O/xwcOUgvzdl2XN?=
 =?us-ascii?Q?xmhwGw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36296217-4170-4336-085e-08d99a3c50c8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 17:56:49.7988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GLtvo2QtIGnjkU/dgYkiMH+XyTDZVTYfv6Jw4mwpPU7jhRHO/xJTyGYfp9M1MMdhmvnhWtT8wph8N0v97jellOU7lc8Atl31EVYh57jGI6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2874
X-Proofpoint-GUID: GFnObQ2iY_sVFxX_uWQDcWiIYVGmBwuF
X-Proofpoint-ORIG-GUID: GFnObQ2iY_sVFxX_uWQDcWiIYVGmBwuF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_04,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 impostorscore=0
 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=497 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280095
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commits are needed to fix CVE-2021-20322:
ipv4:
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6457378fe796815c973f631a1904e147d6ee33b1
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=67d6d681e15b578c1725bad8ad079e05d1c48a8e

ipv6:
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4785305c05b25a242e5314cc821f54ade4c18810
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a00df2caffed3883c341d5685f830434312e4a43

Commits [2] and [4] are already present in 5.4 stable, so backport the
remaining two fixes with minor context adjustments.

Eric Dumazet (2):
  ipv6: use siphash in rt6_exception_hash()
  ipv4: use siphash instead of Jenkins in fnhe_hashfun()

 net/ipv4/route.c | 12 ++++++------
 net/ipv6/route.c | 20 ++++++++++++++------
 2 files changed, 20 insertions(+), 12 deletions(-)

-- 
2.25.1

