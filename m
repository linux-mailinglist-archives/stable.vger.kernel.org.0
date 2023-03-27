Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57086CAE2C
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 21:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbjC0TIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 15:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjC0TH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 15:07:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2475810E5;
        Mon, 27 Mar 2023 12:07:56 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RIoabU029000;
        Mon, 27 Mar 2023 19:07:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=l3Ziv234beX3yrE/vWwNH+Dl8Ov2kzWoTk1v5fbxVIo=;
 b=2xgMlF6BeKoCsGZ4HHVY0uQuH6NH8P/iDadJmx4ndaBkUpBgiZANp1K5HucfnCJbCKVK
 MZZYeX0hmnsRgS/Aes5ZtL+S18S17AQ1mzVGZsGy/PSE+446xvPkLdzaEuXHhiqbKXeg
 mgtyiYf6OKu3D3LvTRxdlFY9om/acUS6inVIoYxuuozUEqkXa7WBkLNKREn1l783AD5B
 XU9clpk2ldzhuuwMS1q82Y3n3AdKr3ypO/SJ+KW37v8JSlurkved2lPcjiRr8dNCr1Uv
 dKG7JMb84jKxpriWc3oucmBYXnKm7BHNwh/WzjHvOhDceIXbjY5pn31KEWoWpxvuQFj/ NQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pkgsa02kh-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 19:07:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32RIcRVu026831;
        Mon, 27 Mar 2023 18:55:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdbvywk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 18:55:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5IX2K/uj2hgmwu1r64Lp95LOefm9qsy1UJf4QnGe+rnZNciHL45dRpXFYGNbKWcEbQM/quYJtGM19wTYbyGfdqxs3mNijRVK0WbiTSCuqfkh2Zh9bS8ARuYyux1DsTo0qX6kdY/wn4mOx86+Oiz1i+/0ivPd4AmIZCdslfFP/qQJ6Lkh/FkSfMJD181/vZrbgM5qJD4SD5wnVR18DhKWd/yyeTZo9vkOehafBRZmzQxzH1Gw+g5KdJvlxrSy2Amu+09BUPTe1NB+/qQ/iIuHHYgItsIs2bCvSNTi3VOYxI2zF+g8jWW95gvAhcrLb0BaaZ3o8VaqQMmUUsiYmxScw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3Ziv234beX3yrE/vWwNH+Dl8Ov2kzWoTk1v5fbxVIo=;
 b=a4QCyFrNhEDLSc/khWbD6m95HQNQlHVASmfOhWUaA6enA58m6+EskTrKqFT7Qd75kM2l1hjox8X4w7dsXlmfisiYMGVQbUOWXXoS6NqGKugon5DnZpV7Hgo13W5qlqlWI52SXN38wcG1uFp4wsgHOLjSeouzs1/V3D6GdVzs9OOoqNE6VFnNXCvy9fWMJYuwXnBS5Bet/0ymeTxLoo9M671jzzUcHxEWDeFo6/g5hNr6r8DNULpxKISw7AfxB0TCnmWQHzPO2xYEXICuV3FGSps3bdO7sI3qKpvHXI+mKKj4LLfqlMxz8y5uD9V1TJ9RjQOMcC6lycUf3lpMci8ECg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3Ziv234beX3yrE/vWwNH+Dl8Ov2kzWoTk1v5fbxVIo=;
 b=EIgRMH6u98ARMQyS66Zaf+0jEtHJAONcA7MnN/dXM6RH6lgIDpwBPEc/9/AcBWMXdE4y5nVHJq3fO6A7keZRodKkj7Q8cg4EixUNYgnTqfMsW+YNZvpY/gNm2GkR6Z1NPkXS8r4J4AFckKnYAtkOvWpjB1V+YBL3g3Ux+4qbyXI=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH7PR10MB5722.namprd10.prod.outlook.com (2603:10b6:510:126::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 18:55:55 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060%5]) with mapi id 15.20.6222.029; Mon, 27 Mar 2023
 18:55:52 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>
Cc:     "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        stable@vger.kernel.org,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 7/8] maple_tree: add RCU lock checking to rcu callback functions
Date:   Mon, 27 Mar 2023 14:55:31 -0400
Message-Id: <20230327185532.2354250-8-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
References: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0075.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::15) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|PH7PR10MB5722:EE_
X-MS-Office365-Filtering-Correlation-Id: 4385e9c9-7ae2-4c77-d15f-08db2ef4e36b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DP/885f5mr3PCI/Vfylyg868Uegs/I5QID/YiXpqsRdsGPhKdQlJtZQw9OTlVNLu5H4eqzGnS+HBEiAkXc+abqi9asiMrEJwPfsRC3CWiHCpr5XmGMPRx6qWEvTA9TmoEiuhZluZPEwNRG9MmOSw4RUshuFACS4qsC5mLD6zMu7tQ6iWPwnqYDEaasL2vIX3OX7+6VpGNnbqI0/oxqUVSvnaej2i1I+3WUEX6ubjVIcFvaYcJvqfORcW7emh91erkwRBzzlL1tLOBtYCucxUJvcwoFklIesF1FPj679Mp5zMjuUVrQ4DlK0weu38E6ecHJkYbB2ECilEmWDjL6fbPFuMcz9DYvb/knRKW7w7Kz25Xbg25zw4N7pGUenZ0VGQ9IChhZnOIk8D6EUezK3H1Yyi3G9VSYO6UoPlDVJlQP4De8AHN6S46D5ltgrbQopq2uLh52u+J0tA/HPoWTVED4BDO1VJnXgKGpNdrkpKT0HJLRMDIkLZAU1M9XL2uIpuX2Mj1wmz+VP8cQcyi2oPwRv7mufeAZVCfifBA7Rza2Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199021)(2906002)(38100700002)(30864003)(83380400001)(36756003)(5660300002)(41300700001)(8936002)(86362001)(2616005)(6666004)(107886003)(110136005)(54906003)(6506007)(1076003)(6512007)(26005)(316002)(6486002)(966005)(478600001)(186003)(4326008)(8676002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M586xTfujb5E6xE/r93dV/eWFOUPPDNdSenu4Hm9UXBGqJnEwOpVF/mNbiXj?=
 =?us-ascii?Q?5MxF6dpwZBcX25kBSgUu3VkEwOv3Xs3VnTdXYedqyFYh2oXL52S7R92KeVkd?=
 =?us-ascii?Q?p77jUf0fBQ6MSOC4R6OPzfrp45gyGD7QWBk57PyutL7k8QgKU25g2VVKq4Jz?=
 =?us-ascii?Q?MxFGs+d5PuI/XIjgnut5j/35pEwNPfsKqn9ALXucMiepw5H8OdxrRqg2QV7g?=
 =?us-ascii?Q?8AMhDl9eT1hqqvLp2VyY84PGWJl7I2bWkZ6XgBBV444JRViiYfav/aAPodZE?=
 =?us-ascii?Q?lcbCs6oPF1IMh1lKeGTBX7Bz0Lbk7G8uLfsPrJFB+ZNIvhf5HMK7NNxKqynU?=
 =?us-ascii?Q?u43CRAf3Rrckpzrbqcd/J3SsmnG4fQK7/wT7bSP8PYdCpbTwK5hxFtpb6coP?=
 =?us-ascii?Q?re62Ref2UBvy7jmBrt0U6uGo4ZFw7vRD+KCaNvn7g56basig0HYdaMWKAG0/?=
 =?us-ascii?Q?FX+1R9kDyCUUvlO5ptZVV0xxWEtS+o506pajWDQs4+jUV8D2yJVzOTCb7bZA?=
 =?us-ascii?Q?eJCiWESO3p/PrVtVp+73nDg1kXBhts23OcnTygJybbr9lFJy++HikRVBCa7l?=
 =?us-ascii?Q?TJRYrEQNL+KXxaYLrqo3ASrWa7Voj6JVzr9QpIOI9f4wnipq+oAiU7rLE1fJ?=
 =?us-ascii?Q?4NjcKmhaljaXhpHxpiXlBg/zdOMrshE5mz10uFMoCCZ5kMl+B3HXnFOQIy9o?=
 =?us-ascii?Q?niK8APYH8vT5EPIqZiCDFpWTJ9teuqr1+VRroTCjX9gSCfvPJryZR1+7gi8m?=
 =?us-ascii?Q?y0UE6QrHuURknAF+3FX+jEJ6SQApOX7kZ2fYiHfLaSaUStcNn6likkmqC4zO?=
 =?us-ascii?Q?T/NO39Fb9WvqkLjgzSgXXWpYZRFJ5GMR3Af/8KYluFhCF76u0KA1I2kKg0Ix?=
 =?us-ascii?Q?ZnEP/Iv/R4ab1l5UMR6/P+ELZao8/mjgmCngUOSpxFRshqJoE4ySgmh/w8s5?=
 =?us-ascii?Q?mpgbvTYNLJOIKGj5rTiO5BWR5eug66tsucmitLlZ6Tgud/z3eTLXL2F+5lAJ?=
 =?us-ascii?Q?S1pDdl8lY41lDBzyY/kg7Xw6Agd+O4u4N2ODB27w4Ezmw1eLw11Dh8lhMV/b?=
 =?us-ascii?Q?jNpc62ieCQJ3R+i9jq2noMz8RdIhSY74w1JKznmPg7gvs/tH5hQAtajVTQPc?=
 =?us-ascii?Q?3i/9NoUNt2Gz6DPrNOoqu7SSNcQaCRRoOnNUy4O0aek07tjGtUuGD/lcl2kF?=
 =?us-ascii?Q?vL/Yw3SgWQJCPoXj1dIFYCSr7p1EF+tpL1hBmqOEcdKIJewEQDe6qLx3eWK9?=
 =?us-ascii?Q?V6IfZq4LPVMLChcnKZenksNiuHTwNFf1DUPT/YFkypHcOuru/OprH5olnrDY?=
 =?us-ascii?Q?SU5u6lBKAIbE5NpV6R1jM1dw4h4hJsmwaNCb31iZPJQb2DjVrZaZeUhyuRUl?=
 =?us-ascii?Q?5E3wGRC528iZExODKnj7KwbGwtezQ4h0qR/HXe4ZsS9BrKnlTMzRJ1TwjN15?=
 =?us-ascii?Q?jBqwFp4J22wT1OrEV48yOSZSGGP09u6sSq8SrgyRgNegVKCS8iJwy2z27pBH?=
 =?us-ascii?Q?0kAR+N2m5Sj2kWRwalhI9ZcypULFCJNakb290cm0+aHE7koAtVm9qpnD1CHZ?=
 =?us-ascii?Q?p1R6BturkpZ/EGIndvS1FdhVwOKq44W5YLOTAMUb0XoqlgImDXohUB+lI08U?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?K9P5Xs8WYfz7I3aAbqPsM3hFHeHWXz1DC/Q6Jftwb0u295vXS093iGTfWuGp?=
 =?us-ascii?Q?bBaNbTHKjUWtQzooOOSMwdEyOCgnOGRxGSGHdx0WPQIoio4NSsCuMUvwZEKI?=
 =?us-ascii?Q?gsvqScTHyP5UcUZxHJ9a3Ljw6PuPHYkKRaZ6iBvSjVEAIhOAWR9prd/RoDIj?=
 =?us-ascii?Q?Vcz9iy0Xt1vwVJWozdIozBLvQGajBho9Y99a+86BA4UPFmsLhVAddJMRiB7P?=
 =?us-ascii?Q?aPu1tNUVfq2NzeTahvd8pxMH1zSZnJ3L0M1NJYSbf6ih4EXQVC2jPviwWzEu?=
 =?us-ascii?Q?ws5upmcG+06A2CjKslmzjkwLPIK+MGGG8GchgYIg0vAM6Tfuoe3/PeeQk1h/?=
 =?us-ascii?Q?RLZLyIY7UNNsHpACBofFCfyx8Bv86GILaXt4Fpm/1/i1egu77DS9/Pv3McDu?=
 =?us-ascii?Q?J4v+O70RAEWT7Yvcwk/5UclzVUwMkz8dQaUw1BjlhSUuLV3QgtaSd4VKlzld?=
 =?us-ascii?Q?2JAxVSbIcWyC1ErMtKzwXmg6s06NqPofSa+XE2ceLZauiE+/f3vPgoVmeZb7?=
 =?us-ascii?Q?OXau6lKKJJzp/azdky7X2/wEAcvm7qhAl8zrXUjFwRSceiy7xblablm7uFGO?=
 =?us-ascii?Q?jeldTzibOZE0yrZxHLPJZ4JQV15XSq5qbircw4kvuv9W+KtFjY5cv9poFLxu?=
 =?us-ascii?Q?IXuVBUuGi2EuXZmKnkmDV1mKf0ZwBg7xlsr4oJ6CQde4jRczekIOljOBpXXr?=
 =?us-ascii?Q?2mRoY9wJZLgn/FabB8fVHXICS7oKgGt2DaZJhYAFSqro/DMAUpO35yujkVmz?=
 =?us-ascii?Q?xW7TRyFSMVdRBuEw1zSoZQnpX6g93JANFioNOhMlKpblaBxMr4ud898EDTgA?=
 =?us-ascii?Q?2wmdfR6ZxyxPwvM4FSWLp/FF75xOJ5kI1E9mZUhhJXteu0uuCluwU7MN9uVY?=
 =?us-ascii?Q?iBLj1UnZ6pSXOqlO90P4/VhtZQ5DdGw7jOLlsGptDl8b9vTnVW16AdxNi965?=
 =?us-ascii?Q?d0988mChJbtQflrrctxVuw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4385e9c9-7ae2-4c77-d15f-08db2ef4e36b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 18:55:52.6978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WlG2fRksC7GkhKfD/BKfNyh+yZkXBUoEbsHK8iChUlkfyKtr1eB2gFVQiIeyiPfHHLKUVj2w2ViB8O0rhEm17A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5722
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270155
X-Proofpoint-GUID: jA7JcKBCk6vESVCfXYsYXtSGCeCqW7BR
X-Proofpoint-ORIG-GUID: jA7JcKBCk6vESVCfXYsYXtSGCeCqW7BR
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

Dereferencing RCU objects within the RCU callback without the RCU check
has caused lockdep to complain.  Fix the RCU dereferencing by using the
RCU callback lock to ensure the operation is safe.

Also stop creating a new lock to use for dereferencing during destruction
of the tree or subtree.  Instead, pass through a pointer to the tree that
has the lock that is held for RCU dereferencing checking.  It also does
not make sense to use the maple state in the freeing scenario as the tree
walk is a special case where the tree no longer has the normal encodings
and parent pointers.

Link: https://lkml.kernel.org/r/20230227173632.3292573-8-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: stable@vger.kernel.org
Reported-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 188 ++++++++++++++++++++++++-----------------------
 1 file changed, 96 insertions(+), 92 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 8ad2d1669fad..2be86368237d 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -824,6 +824,11 @@ static inline void *mt_slot(const struct maple_tree *mt,
 	return rcu_dereference_check(slots[offset], mt_locked(mt));
 }
 
+static inline void *mt_slot_locked(struct maple_tree *mt, void __rcu **slots,
+				   unsigned char offset)
+{
+	return rcu_dereference_protected(slots[offset], mt_locked(mt));
+}
 /*
  * mas_slot_locked() - Get the slot value when holding the maple tree lock.
  * @mas: The maple state
@@ -835,7 +840,7 @@ static inline void *mt_slot(const struct maple_tree *mt,
 static inline void *mas_slot_locked(struct ma_state *mas, void __rcu **slots,
 				       unsigned char offset)
 {
-	return rcu_dereference_protected(slots[offset], mt_locked(mas->tree));
+	return mt_slot_locked(mas->tree, slots, offset);
 }
 
 /*
@@ -907,34 +912,35 @@ static inline void ma_set_meta(struct maple_node *mn, enum maple_type mt,
 }
 
 /*
- * mas_clear_meta() - clear the metadata information of a node, if it exists
- * @mas: The maple state
+ * mt_clear_meta() - clear the metadata information of a node, if it exists
+ * @mt: The maple tree
  * @mn: The maple node
- * @mt: The maple node type
+ * @type: The maple node type
  * @offset: The offset of the highest sub-gap in this node.
  * @end: The end of the data in this node.
  */
-static inline void mas_clear_meta(struct ma_state *mas, struct maple_node *mn,
-				  enum maple_type mt)
+static inline void mt_clear_meta(struct maple_tree *mt, struct maple_node *mn,
+				  enum maple_type type)
 {
 	struct maple_metadata *meta;
 	unsigned long *pivots;
 	void __rcu **slots;
 	void *next;
 
-	switch (mt) {
+	switch (type) {
 	case maple_range_64:
 		pivots = mn->mr64.pivot;
 		if (unlikely(pivots[MAPLE_RANGE64_SLOTS - 2])) {
 			slots = mn->mr64.slot;
-			next = mas_slot_locked(mas, slots,
-					       MAPLE_RANGE64_SLOTS - 1);
-			if (unlikely((mte_to_node(next) && mte_node_type(next))))
-				return; /* The last slot is a node, no metadata */
+			next = mt_slot_locked(mt, slots,
+					      MAPLE_RANGE64_SLOTS - 1);
+			if (unlikely((mte_to_node(next) &&
+				      mte_node_type(next))))
+				return; /* no metadata, could be node */
 		}
 		fallthrough;
 	case maple_arange_64:
-		meta = ma_meta(mn, mt);
+		meta = ma_meta(mn, type);
 		break;
 	default:
 		return;
@@ -5497,7 +5503,7 @@ static inline int mas_rev_alloc(struct ma_state *mas, unsigned long min,
 }
 
 /*
- * mas_dead_leaves() - Mark all leaves of a node as dead.
+ * mte_dead_leaves() - Mark all leaves of a node as dead.
  * @mas: The maple state
  * @slots: Pointer to the slot array
  * @type: The maple node type
@@ -5507,16 +5513,16 @@ static inline int mas_rev_alloc(struct ma_state *mas, unsigned long min,
  * Return: The number of leaves marked as dead.
  */
 static inline
-unsigned char mas_dead_leaves(struct ma_state *mas, void __rcu **slots,
-			      enum maple_type mt)
+unsigned char mte_dead_leaves(struct maple_enode *enode, struct maple_tree *mt,
+			      void __rcu **slots)
 {
 	struct maple_node *node;
 	enum maple_type type;
 	void *entry;
 	int offset;
 
-	for (offset = 0; offset < mt_slots[mt]; offset++) {
-		entry = mas_slot_locked(mas, slots, offset);
+	for (offset = 0; offset < mt_slot_count(enode); offset++) {
+		entry = mt_slot(mt, slots, offset);
 		type = mte_node_type(entry);
 		node = mte_to_node(entry);
 		/* Use both node and type to catch LE & BE metadata */
@@ -5531,162 +5537,160 @@ unsigned char mas_dead_leaves(struct ma_state *mas, void __rcu **slots,
 	return offset;
 }
 
-static void __rcu **mas_dead_walk(struct ma_state *mas, unsigned char offset)
+/**
+ * mte_dead_walk() - Walk down a dead tree to just before the leaves
+ * @enode: The maple encoded node
+ * @offset: The starting offset
+ *
+ * Note: This can only be used from the RCU callback context.
+ */
+static void __rcu **mte_dead_walk(struct maple_enode **enode, unsigned char offset)
 {
-	struct maple_node *next;
+	struct maple_node *node, *next;
 	void __rcu **slots = NULL;
 
-	next = mas_mn(mas);
+	next = mte_to_node(*enode);
 	do {
-		mas->node = mt_mk_node(next, next->type);
-		slots = ma_slots(next, next->type);
-		next = mas_slot_locked(mas, slots, offset);
+		*enode = ma_enode_ptr(next);
+		node = mte_to_node(*enode);
+		slots = ma_slots(node, node->type);
+		next = rcu_dereference_protected(slots[offset],
+					lock_is_held(&rcu_callback_map));
 		offset = 0;
 	} while (!ma_is_leaf(next->type));
 
 	return slots;
 }
 
+/**
+ * mt_free_walk() - Walk & free a tree in the RCU callback context
+ * @head: The RCU head that's within the node.
+ *
+ * Note: This can only be used from the RCU callback context.
+ */
 static void mt_free_walk(struct rcu_head *head)
 {
 	void __rcu **slots;
 	struct maple_node *node, *start;
-	struct maple_tree mt;
+	struct maple_enode *enode;
 	unsigned char offset;
 	enum maple_type type;
-	MA_STATE(mas, &mt, 0, 0);
 
 	node = container_of(head, struct maple_node, rcu);
 
 	if (ma_is_leaf(node->type))
 		goto free_leaf;
 
-	mt_init_flags(&mt, node->ma_flags);
-	mas_lock(&mas);
 	start = node;
-	mas.node = mt_mk_node(node, node->type);
-	slots = mas_dead_walk(&mas, 0);
-	node = mas_mn(&mas);
+	enode = mt_mk_node(node, node->type);
+	slots = mte_dead_walk(&enode, 0);
+	node = mte_to_node(enode);
 	do {
 		mt_free_bulk(node->slot_len, slots);
 		offset = node->parent_slot + 1;
-		mas.node = node->piv_parent;
-		if (mas_mn(&mas) == node)
-			goto start_slots_free;
-
-		type = mte_node_type(mas.node);
-		slots = ma_slots(mte_to_node(mas.node), type);
-		if ((offset < mt_slots[type]) && (slots[offset]))
-			slots = mas_dead_walk(&mas, offset);
-
-		node = mas_mn(&mas);
+		enode = node->piv_parent;
+		if (mte_to_node(enode) == node)
+			goto free_leaf;
+
+		type = mte_node_type(enode);
+		slots = ma_slots(mte_to_node(enode), type);
+		if ((offset < mt_slots[type]) &&
+		    rcu_dereference_protected(slots[offset],
+					      lock_is_held(&rcu_callback_map)))
+			slots = mte_dead_walk(&enode, offset);
+		node = mte_to_node(enode);
 	} while ((node != start) || (node->slot_len < offset));
 
 	slots = ma_slots(node, node->type);
 	mt_free_bulk(node->slot_len, slots);
 
-start_slots_free:
-	mas_unlock(&mas);
 free_leaf:
 	mt_free_rcu(&node->rcu);
 }
 
-static inline void __rcu **mas_destroy_descend(struct ma_state *mas,
-			struct maple_enode *prev, unsigned char offset)
+static inline void __rcu **mte_destroy_descend(struct maple_enode **enode,
+	struct maple_tree *mt, struct maple_enode *prev, unsigned char offset)
 {
 	struct maple_node *node;
-	struct maple_enode *next = mas->node;
+	struct maple_enode *next = *enode;
 	void __rcu **slots = NULL;
+	enum maple_type type;
+	unsigned char next_offset = 0;
 
 	do {
-		mas->node = next;
-		node = mas_mn(mas);
-		slots = ma_slots(node, mte_node_type(mas->node));
-		next = mas_slot_locked(mas, slots, 0);
-		if ((mte_dead_node(next))) {
-			mte_to_node(next)->type = mte_node_type(next);
-			next = mas_slot_locked(mas, slots, 1);
-		}
+		*enode = next;
+		node = mte_to_node(*enode);
+		type = mte_node_type(*enode);
+		slots = ma_slots(node, type);
+		next = mt_slot_locked(mt, slots, next_offset);
+		if ((mte_dead_node(next)))
+			next = mt_slot_locked(mt, slots, ++next_offset);
 
-		mte_set_node_dead(mas->node);
-		node->type = mte_node_type(mas->node);
-		mas_clear_meta(mas, node, node->type);
+		mte_set_node_dead(*enode);
+		node->type = type;
 		node->piv_parent = prev;
 		node->parent_slot = offset;
-		offset = 0;
-		prev = mas->node;
+		offset = next_offset;
+		next_offset = 0;
+		prev = *enode;
 	} while (!mte_is_leaf(next));
 
 	return slots;
 }
 
-static void mt_destroy_walk(struct maple_enode *enode, unsigned char ma_flags,
+static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 			    bool free)
 {
 	void __rcu **slots;
 	struct maple_node *node = mte_to_node(enode);
 	struct maple_enode *start;
-	struct maple_tree mt;
-
-	MA_STATE(mas, &mt, 0, 0);
 
-	mas.node = enode;
 	if (mte_is_leaf(enode)) {
 		node->type = mte_node_type(enode);
 		goto free_leaf;
 	}
 
-	ma_flags &= ~MT_FLAGS_LOCK_MASK;
-	mt_init_flags(&mt, ma_flags);
-	mas_lock(&mas);
-
-	mte_to_node(enode)->ma_flags = ma_flags;
 	start = enode;
-	slots = mas_destroy_descend(&mas, start, 0);
-	node = mas_mn(&mas);
+	slots = mte_destroy_descend(&enode, mt, start, 0);
+	node = mte_to_node(enode); // Updated in the above call.
 	do {
 		enum maple_type type;
 		unsigned char offset;
 		struct maple_enode *parent, *tmp;
 
-		node->type = mte_node_type(mas.node);
-		node->slot_len = mas_dead_leaves(&mas, slots, node->type);
+		node->slot_len = mte_dead_leaves(enode, mt, slots);
 		if (free)
 			mt_free_bulk(node->slot_len, slots);
 		offset = node->parent_slot + 1;
-		mas.node = node->piv_parent;
-		if (mas_mn(&mas) == node)
-			goto start_slots_free;
+		enode = node->piv_parent;
+		if (mte_to_node(enode) == node)
+			goto free_leaf;
 
-		type = mte_node_type(mas.node);
-		slots = ma_slots(mte_to_node(mas.node), type);
+		type = mte_node_type(enode);
+		slots = ma_slots(mte_to_node(enode), type);
 		if (offset >= mt_slots[type])
 			goto next;
 
-		tmp = mas_slot_locked(&mas, slots, offset);
+		tmp = mt_slot_locked(mt, slots, offset);
 		if (mte_node_type(tmp) && mte_to_node(tmp)) {
-			parent = mas.node;
-			mas.node = tmp;
-			slots = mas_destroy_descend(&mas, parent, offset);
+			parent = enode;
+			enode = tmp;
+			slots = mte_destroy_descend(&enode, mt, parent, offset);
 		}
 next:
-		node = mas_mn(&mas);
-	} while (start != mas.node);
+		node = mte_to_node(enode);
+	} while (start != enode);
 
-	node = mas_mn(&mas);
-	node->type = mte_node_type(mas.node);
-	node->slot_len = mas_dead_leaves(&mas, slots, node->type);
+	node = mte_to_node(enode);
+	node->slot_len = mte_dead_leaves(enode, mt, slots);
 	if (free)
 		mt_free_bulk(node->slot_len, slots);
 
-start_slots_free:
-	mas_unlock(&mas);
-
 free_leaf:
 	if (free)
 		mt_free_rcu(&node->rcu);
 	else
-		mas_clear_meta(&mas, node, node->type);
+		mt_clear_meta(mt, node, node->type);
 }
 
 /*
@@ -5702,10 +5706,10 @@ static inline void mte_destroy_walk(struct maple_enode *enode,
 	struct maple_node *node = mte_to_node(enode);
 
 	if (mt_in_rcu(mt)) {
-		mt_destroy_walk(enode, mt->ma_flags, false);
+		mt_destroy_walk(enode, mt, false);
 		call_rcu(&node->rcu, mt_free_walk);
 	} else {
-		mt_destroy_walk(enode, mt->ma_flags, true);
+		mt_destroy_walk(enode, mt, true);
 	}
 }
 
-- 
2.39.2

