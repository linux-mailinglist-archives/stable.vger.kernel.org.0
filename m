Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA1F3EA8F7
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhHLRBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:01:23 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:24986 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234029AbhHLRBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:01:22 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17CDv2UR030865;
        Thu, 12 Aug 2021 10:00:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=fIw5jIrrn1qOQfJT9j+UmRHLeluxHUEz+yPF/XxI9WI=;
 b=Y1b+ySgNB7HxXQXLJGWz9NBns9bgnQWjGqf+zaYYEewY5kxdTRFrS4exs6JaW9AJN3Yi
 YYo9mAUoXEJGAVv8Q6Z5gndW7c38be2PvpbfVGMKpwHZKuHkkIWGmDzPQXefxd+6CXtF
 9TwP+6FW8BdtPjxQcNinvS6KdqIGvxiLr7WCeexCHVSTh08JIFgvInnCOc0zwxr9Lreh
 5aDPwBwYQPMQRJRZki10k8Onp30PDWhMqdheDcIQWmkH6E3vfaYdGgpifzJ+t5YO+3VP
 cwVojA0qdzqJTnl0Qs+dKiZ834zYUxw2XO/yCT7lVG9Taq94lvFTPq/xNvaFRpVfU1Hw RA== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by mx0a-0064b401.pphosted.com with ESMTP id 3ad4wug5b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 10:00:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVZW9wiDW1UR/Z30Gi2fhCouX2MO3TZkUeTna7iOzx3xyflxqOuKMJ/jvtfuSlOFK6iyUdrbKdU6/1fCpzQ0PyTgwWHSXT7m5K0HdmCYw1UeUhawHStoCPZKUjczW8VHlr/56XQdhguVNYqqEx89Vy/ST80VKjCTvvBZ26nm4Td74F1Wbux4ySY6dV1I+lIYQ8ls7lEW0sbs+crN5F9NyVIuDH7RX+JShmOJnAXXqL1g4FsSRSgHXfQKb01HayYc7WRfv/YZrPQWBiRHemRGZLgp/y9JLSb2Sr0Wi5ZD4Ou7uMh4RthmQzd/KhRxudSgOCUXCH3bsX9pCzEKKdeZCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIw5jIrrn1qOQfJT9j+UmRHLeluxHUEz+yPF/XxI9WI=;
 b=DRPdjNycPW49VhmHn/a690wIO0KG3s0+OwgsLaRIWdV/RzOT3J5HEPJ05AbJhT8GNrZ3r3hFGOTzUYzWjAHY1pPv54uN1yNjdbuTSUKI2L9g3QfPFI87Oo5TXbsHBSpXt6g8fwHsfDpcJnYREsoilpYnX/J/Ueji1M1q4S4/OqMIL6rA+69voR5c1bGVnNIzium42ceyu4NE95wAN7Q5OgnF7xz1oxucmsFM0DUXGS7z/MCfnNQU4FDn6feIfouEMh+BVeoSmmlTnOrRIdtZtcsImu5l8+vtsFbFDRHd7TMPL3oOcIZsvkiSKIPUGhzisD71xnbvtSlXu8SrZ8rM8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Thu, 12 Aug
 2021 17:00:55 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%9]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 17:00:55 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org
Subject: [PATCH 4.19 0/4] bpf: backport fixes for CVE-2021-33624
Date:   Thu, 12 Aug 2021 20:00:33 +0300
Message-Id: <20210812170037.2370387-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0251.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0251.eurprd07.prod.outlook.com (2603:10a6:803:b4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Thu, 12 Aug 2021 17:00:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 431de9fc-4c4b-43a3-f98c-08d95db2bfb2
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:
X-Microsoft-Antispam-PRVS: <DM4PR11MB554974DDD540D70144891180FEF99@DM4PR11MB5549.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mZrMqjkF1/T+zulvi7ea04TLm6vfE5cp89PT5UwTrFHpAs0bVZGlVyQ8sxgQj/d3uDmrTBUr0tqwXMdfTjJAmYtR49wDV9CRXwZNFPsMq2da3J98tXYO2sz3EvR3dvmrNhDwV8ePxPOMmJuBc5avLSytjOUE1S5ob42OyXlnADFLcbQ872UAiDi9Esc6G9a770EO1akLh7sbGxmpD0DBXqyM4z+Deut6R68hkkLI/QwpBBuVi2dXADh4j8Qgwe9FxYkn6qRrKLe5EA6M9v+b/WDlnINeOCpNZk6nLLNobmCJGomUGBPNcQQ8GOFmwfD2g45Vpo7ke2Y62DAgT9vM/ggvZJ9zu0kCiNM5eMv17VfSZ5uyyoU+9wGzhWiaDcsLB/gUhhvyQ3Ws/Nsq7AgAqe4bHLA+yse/m4Q4KUmXM+V5LVHTfD7sKCWuUHdcLFMZWtRwoqZsyf4JAgb3WqhXgKrJnek+NL+RQJl8hsvyl78JHrC5ZtITzx9c89S/+/69IGk3Gm0KMuFqyy9g0Cyz+SUPuuRxX9AlkWJxYeBW0C8HvynAITJCaXXlhlwWB6PuqIB+izHXKx0RHjigA1sprK6nr35Hqn1uUYU+vSJ/EbASa3asPMrf94ebGejRW3pUqqLg+tIArBSRklYWSvl1VFKcten7pY+2JmnhukCzcA0zuHU2xK09/0Hi+vW7ZAdQd5zYLkL3yCWqc55OjIjemw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(346002)(366004)(136003)(6666004)(478600001)(66476007)(186003)(52116002)(66556008)(26005)(5660300002)(2906002)(2616005)(44832011)(956004)(4744005)(6486002)(66946007)(6512007)(36756003)(450100002)(8936002)(6916009)(4326008)(38100700002)(38350700002)(86362001)(1076003)(6506007)(8676002)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n8EPKd66eLrCDepfDbZo041M6+8Jj2233dypyVktqWCONSkt/F68vCd/EXrw?=
 =?us-ascii?Q?v/xFGlh7nN1u1pr8ZuM2I8J7884q53RR77d9qemQ1UulLtRZEmyD1ek+pXb5?=
 =?us-ascii?Q?NkfpJAib0muiBv+NolAq0DuUHK/lnqA86cl+/3GUsuOZrO9jKxKaeqWFdbhl?=
 =?us-ascii?Q?W+jmLOCdM/B1kkbdu815swx1vRcRXU3rih7lVvLAMPnyL2CwlSSZ/+yTS+ru?=
 =?us-ascii?Q?CWEv5ZBJGqqaxbNNp3if21l2FVz0hi1AlYBVoW2BX3B5IAFTub32ib8BI30l?=
 =?us-ascii?Q?r+8oMulQqC2kXivMoqgTmT+h+3x/SCEzjhIM3mxfmEJ3Kx057XtcViEBrCY3?=
 =?us-ascii?Q?JhNtCsne4iH+v8x2ZYXK1KnEK8j1JMPLVrbcAb+9P+08bLXgQv6+ZpnhFn9Z?=
 =?us-ascii?Q?QjhsZoMgFokWCDvnGhzZfYuHKv7bqqsrdhe0bixTACIuqszbwB1N35XAs4B4?=
 =?us-ascii?Q?6Onz2mjJiPBDMx1s0A2Ch1lKHLVCyIPwF9hj5R/1Bs4r+0ftw8stPxzBQn3x?=
 =?us-ascii?Q?YivHRT0B6k+B4OYL48zQ5XwyyEGs0Be7uSvETqUmPLM7Vj36v92582qA7klU?=
 =?us-ascii?Q?G8RaD+q9kDnnb/K89WLiBVtWotWpeGNglpLaZKrkjSAv2TcbgMB4Mo+iwazP?=
 =?us-ascii?Q?HnrWdTAAVSHNu2HbzQTHUf/Cfc+UBUZb/lDqSnvVf/NGiTXGeg88QjwvgZkm?=
 =?us-ascii?Q?PayAUvTWGlvcIRFsVqzDPoYdJ5If62eSt7i5ReIDHYBHO5UkDkKE2WoqJGHP?=
 =?us-ascii?Q?kAJV4SgqJiiWTaoZGOrqTMWtj2TKpKilhuYs6S49dH5Xjy/Ed+RtXSjq6wPy?=
 =?us-ascii?Q?v5YYHxbfXvX4aGO8Ug62rV360oAPbRHd2Hx5ku9XPl8LoH9ZrqzPqz91lGtl?=
 =?us-ascii?Q?LVpYZTlPC+KD6VPj2tsIM2Gf3zro+ENhzJNKnZCRRnfexXjz98ZHVlTjh9oe?=
 =?us-ascii?Q?LoSx+6H1LdAaEEbjGcwIyYRYn5Waq1xUSNKZ6tphjI0X5cD7O5LNEZwkOfHl?=
 =?us-ascii?Q?4uXUf0N2Bww6YLjPfC9Jt6il+/3NjpUplYS8+kjVJ0TZKFmsKv80XX9H3ZT7?=
 =?us-ascii?Q?3ItiPY3tFuMRRYtuC4kMuD5B4lDWaoXiYI2Y9TLsbf5MjmHHNNO+nxzIFhWW?=
 =?us-ascii?Q?Y6J8osWAvRrBf1eyIiafh85nPYw13Se4/xwWz5m14146OckfG1X6/ftMQy3d?=
 =?us-ascii?Q?W8jEyXRruKe+MVLr2KiZrrausQFtCFUYa/p4CxZJLD8QDy396oA1w3gXFTm8?=
 =?us-ascii?Q?MK03EoZPZjjJ5XBOBBt3dorO/S8n2hQ3q4QzFnnS+O68h6p5h/PM1t5lufwN?=
 =?us-ascii?Q?gqgqwqkq1Gnl95m+I39nRlip?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 431de9fc-4c4b-43a3-f98c-08d95db2bfb2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 17:00:55.5497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: poPVtkra1E7NJdqtbxuquONlrbsqvDpJXJwOniRpVq7NZg97/BRTPLsC3V9ihSMWwjBqdypCHvvN6/Bvxm1qzgovtQuQabAPadzlxR47VLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5549
X-Proofpoint-ORIG-GUID: gJnprrb3vgBT9bHU1ftKfX0_dW5L6Wj8
X-Proofpoint-GUID: gJnprrb3vgBT9bHU1ftKfX0_dW5L6Wj8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-12_05,2021-08-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=734 suspectscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120111
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

NOTE: the fixes were manually adjusted to apply to 4.19, so copying bpf@ to see
if there are any concerns.

With this patchseries all bpf verifier selftests pass:
root@intel-x86-64:~# ./test_verifier
...
#657/u pass modified ctx pointer to helper, 2 OK
#657/p pass modified ctx pointer to helper, 2 OK
#658/p pass modified ctx pointer to helper, 3 OK
#659/p mov64 src == dst OK
#660/p mov64 src != dst OK
#661/u calls: ctx read at start of subprog OK
#661/p calls: ctx read at start of subprog OK
Summary: 925 PASSED, 0 SKIPPED, 0 FAILED

Daniel Borkmann (4):
  bpf: Inherit expanded/patched seen count from old aux data
  bpf: Do not mark insn as seen under speculative path verification
  bpf: Fix leakage under speculation on mispredicted branches
  bpf, selftests: Adjust few selftest outcomes wrt unreachable code

 kernel/bpf/verifier.c                       | 68 ++++++++++++++++++---
 tools/testing/selftests/bpf/test_verifier.c |  2 +
 2 files changed, 62 insertions(+), 8 deletions(-)

-- 
2.25.1

