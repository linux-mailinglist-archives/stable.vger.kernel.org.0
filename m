Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A4E3E06AB
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 19:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhHDRUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 13:20:30 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:46224 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229873AbhHDRUa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 13:20:30 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 174HGmCO012138
        for <stable@vger.kernel.org>; Wed, 4 Aug 2021 10:20:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=DkPMxZNlP48PGo/xmxeyciLhwr91gvdbzjRuqgGmIuc=;
 b=jElFRfp7U9JHW+mzuRH06iKVSiw3BNFiD2ejkutaD+B8DiPpwJmPfQti/zM4zSr77TIN
 qtmay6WdsypRNL+97PU4QGcbO1fI4+ewJj4x0UyD2o6eC0ZD+AZCH2rKnVzBv8dxgtVx
 Gmsyrd3ARJOI/JSdTEdNj3jwV5+6T/22bK/RpuQ5E8cjsdvXYXezk4Fm/Hi0p3e/e51Z
 6AhK86a82zC3BT5s6fvqavw/VlPR9tRA1bSfUHzc5zmH8EMyIgCk+YhQSNC77hC4VTxd
 IoGliCoGhY1QGy4mbYoIR1fKfovlX3rV6ygHixeMAnAuaWRQ2nerC4LGiRGEH/3lguoC xw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a7vt6r4a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 10:20:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=me1ksNHUeLWKMoC6IDfV9XBet7HayQ9ahWZNdEprJERinNRm8t6Ei6ZW78ZALPK9VvB2b2NB/Jfv8sSxIIgZGR3sQAC9BPtEd64tmVB5ECHFO+OWH1NsMhAd5RTlVilzeS+uaYcNttypPdTKRXv6hdy3TIys1aSnw7ZiEsDPfB1Bk5eTBmEQ68pkmxcUpcQiL2Uzbnu7HwUH1QNv1iL0bR/ANJQlY2xO6uCtHvEoXAi/kRScaZlQEdP/4zYiqqMSVsNAiQ15ZOIx+l5M/x/MOqHiLybvG7dXy8e4Ph1eF9czwsST2rna0mgstXZG9De+Df+OgGEKENNGYQ6WT3+syg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DkPMxZNlP48PGo/xmxeyciLhwr91gvdbzjRuqgGmIuc=;
 b=GjhUL1v2qvVvm+bUWHladDU3Of/aHtNJ/FGf23stZx7mAmKE5kbSlWazH8g95B34JNfvp5fNfAkBf4eqQa/EbB6lTUIo/DyPte4144R9CBRGsZMkRcZ7zk+kanfI6rNP1gZk1VrFUH5ohTXzg67tPgdOaMgQg8dokVgLjp+sxJ2H7b+hFzQREeBBAt3NOHibld2o4tYiQ/e04V2MEJbYdAagAp3KeiwLvxrjZhXxodzbO3JYiYabid/ShFMNbNhclpoPRph80/r6VpDB4mattXw07YRnrLaKL3+k8BcTK/mb8b7Y4rM8ZEMsfNgXZ5bmRS2yoZNuxOeU8mxoxKmwZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4169.namprd11.prod.outlook.com (2603:10b6:5:19b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Wed, 4 Aug
 2021 17:20:16 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Wed, 4 Aug 2021
 17:20:15 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 0/1] bpf: selftests: fix verifier selftests
Date:   Wed,  4 Aug 2021 20:20:00 +0300
Message-Id: <20210804172001.3909228-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0156.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::34) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 17:20:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 015eddbf-91fb-42d3-67a9-08d9576c2021
X-MS-TrafficTypeDiagnostic: DM6PR11MB4169:
X-Microsoft-Antispam-PRVS: <DM6PR11MB4169B7A54C3652CAA3D9291CFEF19@DM6PR11MB4169.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yna/jFkTTdIR9Q+IdBS6mQ9rxN1UcxhHjWd1OLNcguJICexecSc4R4zuozbzuFtjLFwxwyZ8mNrs2tqnXRLADyeccvBd6TlILLzHhh7qKZQhxdK5u0hedVZ5stMpHRUUESylAa+OXjvHdenHRk2qHub5Im07Dka58Tl7I27J4ieyCmeTIqENZ4pQ7KhB9XGu0Aq2ekELXgHuWzeNG2PfQqad731uFJlnGV/2ZpYiZX8qIo8LatdxLv3qx4aEox1EWh6+GMWFP8sxDeD5UmMITTNJzrdqRV+YRVohTEJWnim0sNcpmmQOMpBqkjXaU6WxJRSLl5ftf1lpfa7oBNOBlh3Z7giNJqj1HUMJ50jEuJtbCYqvfmkAbsD6e1oygs8MrxkXwNK3PyHDY0mZtv4NJwTuaqcV+Uivd+xNAhAJzk3PaTSxTinFEKdzMhfy920Njq+HBfA7qMVqY1GtRcL+fFWK7LCVJxyDAAQkeru4fNPveNvZNCkwf5GK3XTYFmB3/5r9eUm6y54DLCKNzR1EitN3h9u0UVTzWfCB1f1jJqcrhXgG2gIQbq5+1FAtNAouRQ9L6hk3grpRsvs0mIchPDabNefLexuOmlN0W9rk5mn5kRinVp9hLX7hKgRCUzcRy58mH6WmuUEWnRbuEj56ovc1zDaKtxDjcizGynHz65sLW+h6OgYY8cblYpNwOpMHNrkTNJYo8asDYj5ipdK4cA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(2616005)(38350700002)(66556008)(66476007)(44832011)(66946007)(8676002)(38100700002)(52116002)(26005)(36756003)(8936002)(316002)(86362001)(956004)(186003)(6506007)(6512007)(508600001)(6486002)(6916009)(5660300002)(4744005)(1076003)(6666004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ygjeAbJo1zwlrDtSSCYI4jDuB4795uvZnUG+pMDL8s0o3JmBxFyrmbwPLocc?=
 =?us-ascii?Q?g3zuqorMmcZbsQI0nB1nVSysHGO6AqUSgE1ecRYrH4nBmDgvXpeBAbXU9x7Z?=
 =?us-ascii?Q?TMUkce36U7Gczbz4kDzKVzvN2BijbAFY0FtuYIrxNsBIyi00HTLPUId/LuDa?=
 =?us-ascii?Q?5b78drKwkooPj1I+omt7zdr+KfwQ0TIW2KGsf5emRev06ESU/f1AQBebWjIt?=
 =?us-ascii?Q?YrTCAjGU2mlNb7UnJigZVynfVBMNRWoXVQo4/ep4lEYNNWDnN1JxiE2JKVl5?=
 =?us-ascii?Q?qnRhbQBL/znjRj5ecQ3w6tioZDHVDVhadaSZCqA/UbdBPDW7Lhs6jJjHGGjq?=
 =?us-ascii?Q?+ts7bBXrrR4GMTT645SAQxB70sbKaOyv/6+cgL/3MCA8ajWOQNTdjbKpNcag?=
 =?us-ascii?Q?ck+xOA51wiGxGqDZwGpaY7flQtWhzudXcNT8zYiifN8rSwqPTcx4Lil88w1J?=
 =?us-ascii?Q?B/ZALFJM6KZXQfSsuebbVcfko94Vk6+Qyl5tz2lT2WF2gaXIT37zKtH56E7v?=
 =?us-ascii?Q?oydXF/q7QeBGktThayOpo3EZH6+b5/K2Gun1LlBhLmTpE54f8kxVxyeyJ0e/?=
 =?us-ascii?Q?oaajWMc404q/SZxrMoelpspxGYzr8ad/5c2Yrz7Q1ottuFEQp6rMf6Dnlv6l?=
 =?us-ascii?Q?gcJ3ZIA+ssCNYkYYs/DSaa2nQ7KleRALZwUu6QfLpnUivmSnpKe7F6U99TdA?=
 =?us-ascii?Q?kT2gsRu54o8p28VhJSswL0KCJE6IIkH4khEEMtKqEY2Z6HUwS7fLoH9omLuF?=
 =?us-ascii?Q?Ly5aXgaWDhrRRN7ZygLrjLHR5TusaKkvUu6K6mu0lBp4NBrVCltZ05YxffZ5?=
 =?us-ascii?Q?OP00yPPRSYW70+N42JoU09oJJI/h0D9Y9gCHSJveOrD+77l3xARMqlbZLPiq?=
 =?us-ascii?Q?nzXN48Dv9nbKND1iy9URO2iNzlsXwSgI15u6fPtLOM91p4DZUsIS2TIoyJs4?=
 =?us-ascii?Q?116zVtRnTOmxHVvt7JAehxJJIxslFQPSoO2jhgN+W9j+zyUGfwjJecou0UfT?=
 =?us-ascii?Q?bocMS9PKJS43JIvn2+f8RCEt5hcGNfx6uYpBd0hicCJ75nJcmWSVoK/5nUnP?=
 =?us-ascii?Q?sOTNYFnW1K0BKx12rtBk6oUSRAxDUHHGRg7mf+eBkWB6QBdAypPL9gpb2ekn?=
 =?us-ascii?Q?hzubwfAI/Lvn/5xmxKPVBqsnuty6Ojh6wGzryH2In+p2kVAi5RYqVnhiW/NY?=
 =?us-ascii?Q?j6azn5+2kvQsMasoBc1au2LoXXnzmrPle5m7FBdVsLUA36tedB2E2aSddyFZ?=
 =?us-ascii?Q?N+XDdKzNXK4q/XtxYkHsYSMLTHVrHw7rfeKqAP9bBTNt8KjA9A9a1sk1YXNW?=
 =?us-ascii?Q?bpHFJbQP0xHCwbK8OY/6r3Xz?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 015eddbf-91fb-42d3-67a9-08d9576c2021
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 17:20:15.9209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dmt0Mlj62FXNurdObaNWoOTg8J27hK7X3Ip2yteL0h7Y2ZgS3/z/YAt1S8l7fS4o6bVEAr/VxwlHXX2ju9svRqOwTB3boI62nNYKUVk+LlU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4169
X-Proofpoint-GUID: kDHLIPuhEPdnCI7u7KcooiUuQP9wu5XS
X-Proofpoint-ORIG-GUID: kDHLIPuhEPdnCI7u7KcooiUuQP9wu5XS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-04_05,2021-08-04_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=610 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040099
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patchseries fixes all failing bpf verifier selftests:

root@intel-x86-64:~# ./test_verifier
...
#1054/p XDP pkt read, pkt_meta' <= pkt_data, bad access 1 OK
#1055/p XDP pkt read, pkt_meta' <= pkt_data, bad access 2 OK
#1056/p XDP pkt read, pkt_data <= pkt_meta', good access OK
#1057/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 OK
#1058/p XDP pkt read, pkt_data <= pkt_meta', bad access 2 OK
Summary: 1566 PASSED, 0 SKIPPED, 0 FAILED

Daniel Borkmann (1):
  bpf, selftests: Adjust few selftest result_unpriv outcomes

 tools/testing/selftests/bpf/verifier/stack_ptr.c       | 2 --
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 8 --------
 2 files changed, 10 deletions(-)

-- 
2.25.1

