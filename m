Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D00653108E
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 15:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbiEWLkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 07:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbiEWLkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 07:40:42 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1517506CA
        for <stable@vger.kernel.org>; Mon, 23 May 2022 04:40:40 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NAf45L006369;
        Mon, 23 May 2022 11:40:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=PPS06212021;
 bh=mtdqhOSL7y+LbsCgrULhTRG1EJHrmZVa/r3zCTRu3I0=;
 b=mn5y7TmliFDtpbZm2NHZ7Xq7zc8JcfAHzYHBafHtPTRCtIj052TkhNSA5CjB6uN3I11/
 QHvMsfiqO5aWkZoSyJzxc6nfOS3UYT7RamNj2QugYgGIBanE2YxgTUPWNG+Y2D1t+iab
 yTV6KldXVZTt6SyhS/1gkx1K0tClanF/braGrTpVO+MPX0i21kdhP9XwmVsjiM9BUvhl
 WiLEHeFamMOV7lYgJTpN1ORP+tyoQuMc+TjPQFg3ATYtorA1c/i3FqlPZITW5svZXg2G
 YStvjMaPuxGzZ8sq8fYwMnkiwOp9/rirk/p+zeCgF/SL76PJBrm3Hsw2qBQBJv2hPd0v pQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g6s4119wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 11:40:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpPtpSsgM/CuoSv+EBjXT4rv54BGHJar2laFJX5Uu6BrzCQIszZLYw4JuoIRoXCoS3vHpzxF4DkPnpD25BUAjaQvBj46yRezcNzYpXcan6XH9ZzFco1IZ3w2/U03cj/M53facGlzsmDIQpZ8LzcuqNAIBLph+/3HSi8JaIK2uwvipCN1TjGpSb/a1rk/QSUyMUVhNb9y/+wiio5LWnR3BCVXz6EcKsqA44k+26Anx1fV/6nqHWlyV4Y61ofd0E6Kpne/5hJ3ruZRnTe5RnuVGBENUNn3Yd56+CON1/gXSbSV5PyeF+m3eDGYD2o1iGefSlU3MdMg5eI2nUBYewgQkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtdqhOSL7y+LbsCgrULhTRG1EJHrmZVa/r3zCTRu3I0=;
 b=kGqQ6S+rkW0mNzi07EpZovXGrdBw62C9962Ntllv7AUj4kJTgVOcPrarUjuXngX1Mji25hBY4U+a/LO7hOcBuKRjZVCctHQwjRcqRIfw/jM2OgHgbwq0tIVXg7Gtqk+3qTf3/mbnNVTzCfOZLvdkTsbCyMXRNVFJtJF7LrL34VfLqjhV9C+RbDkou2AQlEmRPWfMNbSqsHfSRs01VyJnW71R26xk+bc0hPSpWotH3zrBGzTiw0GG8cY1dVI9J40qQwGh5NoPd+YioGE2n5ptDholU5ePctwalfr4hFO7USJu7D/1fbY0qCxbMyu9aGmd38QnPhdOvY+72TTt3HH1lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MW5PR11MB5761.namprd11.prod.outlook.com (2603:10b6:303:195::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Mon, 23 May
 2022 11:40:25 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 11:40:25 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 1/1] Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""
Date:   Mon, 23 May 2022 14:40:08 +0300
Message-Id: <20220523114008.297420-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM5PR0601CA0038.eurprd06.prod.outlook.com
 (2603:10a6:203:68::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2ff3c41-20e5-463a-6fc7-08da3cb106ec
X-MS-TrafficTypeDiagnostic: MW5PR11MB5761:EE_
X-Microsoft-Antispam-PRVS: <MW5PR11MB576146061C56FD9899A0E28AFED49@MW5PR11MB5761.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XV+h1kFjsQDQ6VR2Sa6Bwdok0O0aKMldrtf7hr6qLmVTYSKriMg/06e73yjlGlWhaM95Zhe5wyCGIioSl5wg1AEYZlwE+zrlmDgqHImM1UwBnTBb3Qwg4OfTf84uQfRCyO8Rs7T359Z0Qp1iHxAuMmfFEIo7CGHhVV96vRvdDpUf96Ie4h/q3JpC2f5TiJ8bOzYJsWhdbNo/VpK4JutWnVlP/B1k7L8uLS6hQm1an2Yafg7CEbkjoV0S0FTcGD5p4hza2gqz8mYX7eIcpUvRLWF3lwxxM/Yawejkp1Nco+5HZErnavu4+RZOMLB5rOdFWUcHSti5ZOL8ek/C5p6Y68JdEK/Dq80GRV2BVFi43MCuq4AC1GquhDj8Y49LvxZXdYUR3K/Rqs/73x2Nf9eAerjzgiayM+U/InY1vMpRY751G/ykIfDFHXWA8khNwipCTKK1TTNzH8bTVtXwX4z0aFR4JNm7H8hjtNaDJzKsy1/3P+haxWQMKZIipcCf6Up4xHFrSFKwUxH02PdNjEwTkPeYOQo9GxwqHitupcfTDHJVeU55wjwCcgdhZdhJMPbweZMahoEFgPNz5KZL3tXagR8q/hAa5xUzFpIK2aBEBSPYI5qS+bWUfxRAYfbT5UX20Af+KW440CLWUMWNSj9R0dPEjUTmRYrDOB+i8HVSNbLY7BFPN+LgHGWfe8VQSgzJ67OrVCITFpfXUV2Kd2Fuk5vAq1CERbok4Wzh/y711mMLITy/k2/IElmRH9O8GVXB7buoA9t9PMBemciqa8tyePNpQ+umGKia8KGLv0qltr8aKxT3Cma8JPNTdj+brui94r+OWaW6H/1UddRMRdnCyJcMF/jw5lpxjdCh2WHdgWkNXZA/Madz9npeHP/1nV67
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(66476007)(66946007)(66556008)(44832011)(36756003)(6916009)(54906003)(316002)(2906002)(52116002)(966005)(6486002)(6666004)(5660300002)(8676002)(4326008)(6506007)(508600001)(38100700002)(38350700002)(1076003)(26005)(83380400001)(6512007)(86362001)(107886003)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akp5LzEvKzAxd1pzTFk1Skh4amNvRXNXYzZRQ0V1SnBFdVU4RXZPUERheUdV?=
 =?utf-8?B?YUJWcGd1eHFXN3g2a0dTWkdsQVMwYXVVRnd5dmtQbzkvcTNpSnFNQVFheDdW?=
 =?utf-8?B?cFpmRzZxcVN1S0dXSDAvOElwbEE3V0paR2tmWHZQZTE0Tm1sMFlhNlhBVmxZ?=
 =?utf-8?B?L3hRNVd4MXpMaWM1Uy9yb0tGMEltbHhoQko2S1pmZkxrTlhSSHhFVlBYUWF2?=
 =?utf-8?B?WlFuN0lpZGFQSDdBYkNKVEJMd1dxaVBlQk9aWTN6blMvaG1STno0Q2lwMDNB?=
 =?utf-8?B?MnBncnNFSmZTeVltUk95eWh3L2RwYVVXZTJxK0xwdWY3aGdkTG9BWnN2ZWRv?=
 =?utf-8?B?cTJaZHJpMVE0YkpUZVBmODRQeVpaN3ZsWnlWZ2xiSE11Z2hrSklLQzhNZVRu?=
 =?utf-8?B?SXNvckoxS25hbm1mL01yK1B1b0VEQ2lCeEdMaVFuYUpmMEFySEp3QWNjd1BU?=
 =?utf-8?B?Nk9kWktTTm01ZnlLNzJJWnJ2TGhzdmpoVFJ6L3VjOXkvKzFHSUNYMXVXVGxh?=
 =?utf-8?B?cVR2U1FTVzJCWXQ0Z3JDYjh0djJhMUdnZFcwTklEYm05MTM1YW5jaGxNMWtz?=
 =?utf-8?B?SzBRMThGVFp0MlZ6N3h4OGVoMCtjdTRmejZadGUrN21YWXpMRXJNZzlKbm1D?=
 =?utf-8?B?WWI2bUlwKzNHZm1vdDBVSldDYzMxekdPOTBUbVhweDlTMDFhSzhNaVRPQXB1?=
 =?utf-8?B?dExQQWordWY2MEcrR2FaRkVVYm9VR1hVZDhha2dTbGJsK2Nra0Jwck9ldmpQ?=
 =?utf-8?B?d2d5Zi8xUWNpMWJTTlNVcCtkcnJNc0JXSlN5SnVWQjNFTWhMcWIvcTZ4NHhB?=
 =?utf-8?B?T3l6cUNnekl2UXBTZ2krUzhycHZGQzI4WVg3emd1aVR1RHM5d09iZ0J6WGIz?=
 =?utf-8?B?WHFGSjIwL2FISEJIQ2NZSFcwK3JhYTAxQTBaNDFiNzlRckRWVHRIOHpXOUho?=
 =?utf-8?B?cDNPUWloN2RMQjl1dmRiN0tzWFM2blIvd08yeEZacHU4TzF4M1MrV3dTTXBl?=
 =?utf-8?B?b01Eb2ltMXRDVHRzTUVRN2RXay9tU29janhzNWtaY1FrbkxxUTY0WDhiVUdW?=
 =?utf-8?B?QlZCeEtEeEl6RGw3aWFSYkIvU091OVcyanBZb3YyUk1PMUVTbnNXQU9wNFBW?=
 =?utf-8?B?RnZVTm9FNWIrKzE4SmwrL1JNUWwxWWRuZmhSRlpHWGZVTjFVVlkxeWl1ZU1i?=
 =?utf-8?B?SExSTWtIK0c0eEdJellvUjdEbk5ETlhLV0xrd05nYktFdTNQcTFYTFUxQlc2?=
 =?utf-8?B?azA2RDVOMFpmemtSNFJicUhucHNjc05nQkNFSFRuVFM2SlBmS2R3bzk5NHh6?=
 =?utf-8?B?VmlwQXNvV292cWRBb0d1SDFHSWFRWlVXV2NFblZkUEFTYmhFNlA1M0pWcTdX?=
 =?utf-8?B?MGx4ZXdMYVpseUxDL3IrMTBhdHFGa1BibldiYzI5dFRtVW8zeXl2NHdxWUVw?=
 =?utf-8?B?VG8veEx6emdpZzFZdTg2amdWTWhWR0gya3JjTXBZSFdNWGxJdU1MUUFNTEJZ?=
 =?utf-8?B?c0NDdDBJcUpFZ3N5a1VGaHFObS9LT3AzenJOd05sY2dPZjNRb1kzTnNpR1NH?=
 =?utf-8?B?L0FRY3JtRTU4NmdDMGxrVDBWU0VBMEVmcHlkMmNmVm9BY3NKUTkzMWhiQnB1?=
 =?utf-8?B?YXlvM0JNMkpzakxRaUlhZWxZK1RyZnEwTkpiT01NUkIxaVdlRHJWcGZVemd4?=
 =?utf-8?B?SzYraXhEK3d0eEo0S2g5STAzZ1NKeStPVmswbXhFaVNuK0RRTnhFZXE0cHdQ?=
 =?utf-8?B?YmZuRHpoS09UdUx5RE1zb2JQM216Q2xWUnFuRURyMGU2U0hiaEdKb21JdVpm?=
 =?utf-8?B?c2VQUlFBdXQya3lQdW5qd0hqaGs2V3MzZlJBQWxTNUV4ZFlGaG1Wa2U5UTVn?=
 =?utf-8?B?Y05INStKUTJGV2JzdGVxbDV6YnByL0UzV0NpZ3RrMU5KM0kzWFBPdlJBQm5q?=
 =?utf-8?B?RmVkS1QzTXkzeWxoemdQVk90MXFpbE90V1N5VkVGbFd0NDY4WUh5UU8xVFd1?=
 =?utf-8?B?R3dZejhUNUxhQ2FSamZxaHBTQk9JTnNKTE1TMjBkNUFBUXlwQmRCOUNYYVA1?=
 =?utf-8?B?ZTY4eVBaUDRpc2xkZ2oySUwrUmlPNGxQeTA5QWZlMENzMUt1c2ZLVHNtYkgw?=
 =?utf-8?B?SnpybWx2Wk1KbDhLL2lwTHhaYXVTQ081NWVuWlV4MlNKcE5kVjhYZW1LUWJR?=
 =?utf-8?B?cGxqTGhGWUx0T3hKTENncmpHZ2FWbkRTKzk3eFQvVFdLN2E0TGFTaGFUd0dt?=
 =?utf-8?B?eVAxN3gxbUowZkdQL2F0eWFUMVczaXlFSVBLdC9hYng5TDFjUVkxbmZHN1dC?=
 =?utf-8?B?SGJaVU5hZDFBVFpreTNveU1yalk0dHlLdlk5MXV4WXpvL3hZUDlDS3d0Q0w2?=
 =?utf-8?Q?taw51YklO+YfMxlI=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2ff3c41-20e5-463a-6fc7-08da3cb106ec
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 11:40:25.1102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewX1Lf9NK8vVnQxl0mZxKktWBbVrZBcQ8i0KaF0g7nXWhDUTIchsg5bFj9jXRHr44Z9RO2S6dgJp6XLoQb6lLNjmBsHp1SWbgXC6N2aVNhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5761
X-Proofpoint-GUID: 4hsXbKu0CyqKSxiXGAynVCOqfQ_YXr-9
X-Proofpoint-ORIG-GUID: 4hsXbKu0CyqKSxiXGAynVCOqfQ_YXr-9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_04,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 malwarescore=0 impostorscore=0 spamscore=0
 adultscore=0 clxscore=1011 suspectscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205230064
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 901c7280ca0d5e2b4a8929fbe0bfb007ac2a6544 upstream.

Halil Pasic points out [1] that the full revert of that commit (revert
in bddac7c1e02b), and that a partial revert that only reverts the
problematic case, but still keeps some of the cleanups is probably
better.  ￼

And that partial revert [2] had already been verified by Oleksandr
Natalenko to also fix the issue, I had just missed that in the long
discussion.

So let's reinstate the cleanups from commit aa6f8dcbab47 ("swiotlb:
rework "fix info leak with DMA_FROM_DEVICE""), and effectively only
revert the part that caused problems.

Link: https://lore.kernel.org/all/20220328013731.017ae3e3.pasic@linux.ibm.com/ [1]
Link: https://lore.kernel.org/all/20220324055732.GB12078@lst.de/ [2]
Link: https://lore.kernel.org/all/4386660.LvFx2qVVIh@natalenko.name/ [3]
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[OP: backport to 5.10: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
This is part of CVE-2022-0854 patchset:
[1] ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE")
[2] 901c7280ca0d ("Reinstate some of "swiotlb: rework "fix info leak with DMA_FROM_DEVICE""")

[1] is already present in 5.10-stable.
[2] is present in 5.17/5.16/5.15, but not in 5.10 and 5.4 branches;

 Documentation/core-api/dma-attributes.rst |  8 --------
 include/linux/dma-mapping.h               |  8 --------
 kernel/dma/swiotlb.c                      | 12 ++++++++----
 3 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 17706dc91ec9..1887d92e8e92 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -130,11 +130,3 @@ accesses to DMA buffers in both privileged "supervisor" and unprivileged
 subsystem that the buffer is fully accessible at the elevated privilege
 level (and ideally inaccessible or at least read-only at the
 lesser-privileged levels).
-
-DMA_ATTR_OVERWRITE
-------------------
-
-This is a hint to the DMA-mapping subsystem that the device is expected to
-overwrite the entire mapped size, thus the caller does not require any of the
-previous buffer contents to be preserved. This allows bounce-buffering
-implementations to optimise DMA_FROM_DEVICE transfers.
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index a9361178c5db..a7d70cdee25e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -61,14 +61,6 @@
  */
 #define DMA_ATTR_PRIVILEGED		(1UL << 9)
 
-/*
- * This is a hint to the DMA-mapping subsystem that the device is expected
- * to overwrite the entire mapped size, thus the caller does not require any
- * of the previous buffer contents to be preserved. This allows
- * bounce-buffering implementations to optimise DMA_FROM_DEVICE transfers.
- */
-#define DMA_ATTR_OVERWRITE		(1UL << 10)
-
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.  It can
  * be given to a device to use as a DMA source or target.  It is specific to a
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 62b1e5fa8673..0882ebf9fcd3 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -597,10 +597,14 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 		io_tlb_orig_addr[index + i] = slot_addr(orig_addr, i);
 
 	tlb_addr = slot_addr(io_tlb_start, index) + offset;
-	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (!(attrs & DMA_ATTR_OVERWRITE) || dir == DMA_TO_DEVICE ||
-	    dir == DMA_BIDIRECTIONAL))
-		swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
+	/*
+	 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
+	 * to the tlb buffer, if we knew for sure the device will
+	 * overwirte the entire current content. But we don't. Thus
+	 * unconditional bounce may prevent leaking swiotlb content (i.e.
+	 * kernel memory) to user-space.
+	 */
+	swiotlb_bounce(orig_addr, tlb_addr, mapping_size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 
-- 
2.36.1

