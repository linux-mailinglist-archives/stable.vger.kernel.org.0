Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7974B445640
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 16:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhKDP0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 11:26:23 -0400
Received: from mail-mw2nam10on2091.outbound.protection.outlook.com ([40.107.94.91]:51841
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231265AbhKDP0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 11:26:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGbALl/zSwlSBSn6RhYV8GiU6aoDchdBbBoqkDQpPQxUzfRDa1Z5daP6rY5LI77N5Mp7wrBYdk1KvOQeT/GxIi0vUaHB7cGLIIxqYxiKiqeDDSOn/PSUWuWcnsA/6dJ/UoJvdCLNzDPbyQJ2mpSBV7aIErdiekxO39rMhkrYiA8vGnbaxXotdIcvFxynOpRsYSCiONnlkwDh31zGwW8AhLCRWshkEjAwav90UfGOIe1DAYUXdiglRHAyNslKPf7g/49/0s7VXHWnsIOdfbJlp9iWzg1J9eK9cJDeUXSyZ1asa7PIGhCGi8ecEN3WKjZNYp1OUZ26JIst6MyMuvd2UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VTt1VGmZgD5VmX97rvwr/ilt4UtzRMDUVJp6mTFVA5k=;
 b=Lf5OYAq1lySi1BinSFiryIx/5q5vD6Yv8vYNP20GqKVcbGRDGKWpWuew+QJdYFLlK11gt7ALV47jArV0tSOdxmARR4RdocUcy0zcADstRkisugDA87qCjhosDJFG9VdStKScySPPXpWZhAyuFjwxQGhzWkuzCyILK+2lVEPHbOBa19Jb+aNAbx89h58Pa8keeSdLeEuNadAdPtoNTFXf2w447tZpmyTf4kDGM3krdjPsutHxb5m4zTL1b+E6pz5v7yOjFN/U8wcMzRUIp79c+k2c1d1g8KdvfIgQjPuRtjzAcgNMeYk/7KrZX/o3oPvS9QPZ15iNYHWWefTZUVm+QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VTt1VGmZgD5VmX97rvwr/ilt4UtzRMDUVJp6mTFVA5k=;
 b=Nv9/U0qSiGaW3/rcUs5Dau5nMxWor90pOadtoilX+sJA8vNYvRNiMI/yLwcAK36L0V72iJqntkrmC+/u/hq6cNU12lFrXfrubW2Ji/CRPj2FwvPI48nKOMhsjF1Zm15OqBHwVa5mXJGjSz37DyCcu91INO7wC6dax2WxxrHzMzGCOsHyHrsZpZspELv+9AtvVzKK+Rj3Rb2aKlQQQH45QPraLAJwYXC1G0a2slCcqwKRN4gLFKbGUMKGU5x6fpSZneTS/ooXDgew83itoEVavoU4AhpfB/Cvo1XLLqEIKzT9QYq7Tus/cF7SQBP7J3VoWFSGwvg0XTXu5i3/ESCuRA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH0PR01MB7139.prod.exchangelabs.com (2603:10b6:610:f6::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.11; Thu, 4 Nov 2021 15:23:40 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 15:23:40 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     stable@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Subject: [PATCH 4.9-stable v2 0/2] Port upstream patch v2 to 4.9.x
Date:   Thu,  4 Nov 2021 11:23:34 -0400
Message-Id: <1636039416-138753-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0011.prod.exchangelabs.com (2603:10b6:208:71::24)
 To CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7)
MIME-Version: 1.0
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by BL0PR01CA0011.prod.exchangelabs.com (2603:10b6:208:71::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 15:23:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d35d7fab-8514-4fb6-a86d-08d99fa7145f
X-MS-TrafficTypeDiagnostic: CH0PR01MB7139:
X-Microsoft-Antispam-PRVS: <CH0PR01MB71394E4534D87E17BA72BDA5F28D9@CH0PR01MB7139.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:130;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fhoqlg5Z6bRb4evMvdVSBlKHRON7zLBMaaBTXiAvWKTYNXf3beRVqB+oNARkSHKo2hj5/DSEFwB3+L9AWvjQWnG371DeahTtU/78Wx25ZWyvy362fi5ZFFt29X7ik+zaIfSmc2s+isHSqi/1zlkoXHNW+5zzXFCR8YNIkjOZr1t/ShngSY58szH/428ZQHsHw1qpQ9xWRkIkDf/7TnmrsNQD/KZ8FzJiiS0iNqUceA0n+EkTB8us106O3JaqtFWV+bm3oSHIjeeIxgmK5Cd7oXbzGn9CDHidqJP+OLMptAkIUTQBABvvSBKzXBEReVGuOH4ciLlrC7XT1DNv5/gEELsJskQmUrSXtqvpI1NiB1Xw/b5/960qZclqZ9Zz8PlskEhqp8YQufwhJG6NKivYxy2vZsYsMYYDs2+S4uzyH5Hims+yELMtgUA8wqOCqPShT9qhjUrvFjWfOEP5ZzSAvTyaJHiDvlFRxCBL/Zk9EKMHc3oOUalivo4RoCD4LGrOvdlIYqdCSB7tBZ4yyeVcBb0HzcvrdaWm7d2Vh0dQrJOR650jZRpRkF4wgFA6xbmMEfh9PNTYVEPe9/nidHcjn7nOd8wYpMZM6IOoust6w+rbKSCsciZJ85opVZdF0GoUQg0oHe1kYqW08GZgmmdMKVPZSylwD3EAjOqWJqHOV4WCZcDpEhFlditDwC/LdvVVQNTj6YFP5bR4p1BW2YGGXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(39840400004)(376002)(86362001)(450100002)(83380400001)(5660300002)(6916009)(38100700002)(9686003)(38350700002)(186003)(6666004)(508600001)(4326008)(8676002)(52116002)(7696005)(107886003)(26005)(6486002)(8936002)(36756003)(4744005)(316002)(66476007)(956004)(66946007)(2616005)(66556008)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rvq6QqWln1VGKim/0dalv1In+w0akzwtO7jZW3DH94CLsrVSsBv7dLufag9S?=
 =?us-ascii?Q?UFK/8ehJ2rRwK8wGEuwruk/asLAvklytenMTLaHnFfkTHeEdjXuplxnQYMrO?=
 =?us-ascii?Q?P/oMXhp7DVo2liC12jwXQQ6A86d5OnUZMZv4OOKrnfamj/7AEThzCyDBfsEv?=
 =?us-ascii?Q?7MMGW2bJq7KkkFtZbVtr7GiifH4XyrFlFPNto8t9C60Dr8tntIc/WRHyYAuP?=
 =?us-ascii?Q?CNPhsuzgxDGPu+K3mosauiFjF2nSlTomup0cLFgNEALNuhRlO50BVDAm72C8?=
 =?us-ascii?Q?/8nJzee9wNfpOBiGNT9g5WG421p6kgvDdS5owFoK78JsZ9Pzyg4zEZyY9w0B?=
 =?us-ascii?Q?k8vLkY8u86KIwOTLWp/XKQ8iGLlQXCvalDL3e4h1trd//O8CIW4RjsbT8Kkn?=
 =?us-ascii?Q?J1uBsFKRa08hb6EE5pWH94k1DVUrmpy7IChBuiiQk+2CPhNJENERAQlf1yjB?=
 =?us-ascii?Q?DOqjaG1w4ZwPOToP3GIOCU35sdbUW8BTektdPf8fZ2874wVqbU59aez1ihGg?=
 =?us-ascii?Q?HJLmm2YZrhWWoGAkuS85L3Q1IycfbkccpTOD+vjAPgDyxTqedA8HCX2pFiJR?=
 =?us-ascii?Q?Ob4uHX6Ku7fagNoJQrN5rnl1oWslG5JkFnZ8mJbC7ZFEufPg4LUQsXs7V8xn?=
 =?us-ascii?Q?O3oQTfrNOYe6bHNoO22SS2Dovtkr5FWQZqQCxMi24DAZkAzcghaeK8BjhLvg?=
 =?us-ascii?Q?IBR178aB/i43bHScDbsnIT/BmDw3rSYAlGv5Xn8iqXl8f3c8E4j7hxcu/1vX?=
 =?us-ascii?Q?Bv2fF2uEsC21m4iauc71AnXgSD9g4V9iKEy11lOwAJ6uKXy4e8Vaa46gb5gH?=
 =?us-ascii?Q?OanUKFEVYDEwXcjJUYTUVM4sRS95KMUFIqH09ZgEjguDGgHW29bI2v5rtFE0?=
 =?us-ascii?Q?q65bg0dJL4boA8fNsaD3bhew0fKUoXBceXVSANrQTTncOXCfRyufJjjAPc6k?=
 =?us-ascii?Q?DN0AMlPPcpbEy7SE76hUamosnJc31aHwxrm0Gr1SQ1Mg7x0OmHI0c13GOFsf?=
 =?us-ascii?Q?dNqE3Hrtc5a76JJ0MCwIMZDxlndTJjHPVdvZqo021WtR2Q8KCCEle56UmD4n?=
 =?us-ascii?Q?Yq0Gaw36gEpeyz4vSMfCiyT2YUYRHremnyd72MLOV/3Av/gynUs5TvpLlZr4?=
 =?us-ascii?Q?4MgVL2FLfv+0ObGSZA/ZDK4vG9iVkWBnX8DwTJPyO+Wb6w4IXUbLf6ug+xCw?=
 =?us-ascii?Q?8KRZLisspR54bYbqzemnkLyn2OON09ebGEkyurf7ueCbUPaUocOeMEqKGUum?=
 =?us-ascii?Q?nIiRxUNOcg1CtNtpGjPBIbTTi666pKTTjXk1y3wujEqxfTRCwVskdXdSo4mS?=
 =?us-ascii?Q?6eQRP3d6Rxo0m9LuZlUstEYLzYT+vGdqrWsUCmS8Sar9BXYptEijCs25dcjQ?=
 =?us-ascii?Q?2tcXlmq2qz6m0jJpkULqu0o/wU3CSFRmlX4bYlhu1LPOIrlJgFwng1h5dQV0?=
 =?us-ascii?Q?e7P91uceIDHleVqdpgELYaH8FxA3WgFoUtSs5cHmWNZZUzdiVAogokgP5N+2?=
 =?us-ascii?Q?BRLdcajnnsCoD+BTRivs0Dv7lRIUFIbdCvIx4y2yfyEjhz65HG02bCUYcmAt?=
 =?us-ascii?Q?GAJIzzmEkpOHGlv7LeVAuANA4bHfmE9fM6QdPvrJTi77NZ0X95wy3uKW/Tq4?=
 =?us-ascii?Q?XK3jqZ5W+UUpbYaGvrA+keo0zX6YGn/k9K3oyk6FwbeGpme80C2J1cTOqDvn?=
 =?us-ascii?Q?yQj0oh4UScHqDvVbTtkmdoYKuAOaY/YyQCbGfiRgHS6Wl4NAmPvMRyljYI/i?=
 =?us-ascii?Q?xsswc6lVmA=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d35d7fab-8514-4fb6-a86d-08d99fa7145f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 15:23:40.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Pmp+pGpelEOZL4HumD8IGGwRQUAhrwMXZ+JoOiTlnlVzSUKuWSoR/DgF6n4BIfk17h/r+Q4JkcbGEpbH1XHoX43X5lud4BIufdUfKEzql0NkJGuC8yg4Dnxm1cKu7aD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB7139
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

This series ports upstream commit:

d39bf40e55e6 ("IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields")

Gustavo A. R. Silva (1):
  IB/qib: Use struct_size() helper

Mike Marciniszyn (1):
  IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt
    fields

 drivers/infiniband/hw/qib/qib_user_sdma.c | 35 ++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 10 deletions(-)

-- 
Changes from v1:
Correct signed off for Mike Marciniszyn
