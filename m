Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40EFF626586
	for <lists+stable@lfdr.de>; Sat, 12 Nov 2022 00:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbiKKX3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 18:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbiKKX3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 18:29:03 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A571659FE2;
        Fri, 11 Nov 2022 15:29:01 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABNLnj8010286;
        Fri, 11 Nov 2022 23:26:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=pMXhVD3fTz8Sa2qDgNSakVPt/MNcI6pVDm9NsXh0kwc=;
 b=Yc14aha+slHvMn2QWtMMCJMv5MmvWKCZ/mlKE35mqUJmwp6yali16123M+AY92aZRMjB
 j1LP7WRV9p5ivxmJWSUHVKzAnzao6U0jhf9KxKRBQ2Fhsn+MRHwAqkNfCNWsRxWs4e6a
 sZ9Qsvc4m63+POw0qBNmLRExRnxoCd3+e9eGY00kyKVdssbMhYJ8e+tXifHY6KNRyn02
 qkoFtXcA8ImMK6uSYnNVrEV1GEEg9qyF9BAB7q2isv5XFaxHIhM4GFiJK9OJK7/AV6q+
 ZM6lE2TxFgBScUhzVywUwXEpL/OLuXJYyboj8HxZ2gyI2trFiFxOY64Dr1DVa55bc/tF YQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksyktg16s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 23:26:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABKle0n031606;
        Fri, 11 Nov 2022 23:26:48 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctrcccf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 23:26:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EsPMR3c8dhYXbf7LFcOjukvNfOVwWOQuLcRLBc10FvgpB9ZBABIcns43iwfQYhc53j1ZoAUiwklV8ZsYxu/a7XGZYUTVxV2kzK7p5l/F5Zw7AZwGJT7/boDYlaKYIhoZl+Ub6oFSH6QNpJ0TVlyMMMdNxyadfiZHndFBmz0BczUi9irt7CTWoVs2rjF9rpisw+h0VOD1qI7hRRNO0MgRpsB4h0nvjre02HbjGzTqYEOzPPsB5GVLQIZDSUJaPMYqxKdHyqkBXZh4OSVwJfitNT7cwGOarthYA7YDUjmTx0ijIP/mY87c9ZQANotefL5UXuKcAWiOmEy8NZbmWpUBVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pMXhVD3fTz8Sa2qDgNSakVPt/MNcI6pVDm9NsXh0kwc=;
 b=A/cUzppmnLWRPRev9+16GJdQxqsGaSds/e0twN97Xxm2qCkrzlUHAt1xXtsws2nPoVJaGnHJH5tHD59jmHpW1cwCVTNOk98ZLch8pyhseD1WwiIMxoO0GQgyGJG8REvmg8FyO2JD3Wjs79WU1IxPXpXILYrLEsC5iL8Fu9oLtqIV2rS+e5WZJ+0VGA1UxUSCTWYtUB+g0YMLOV0R1zl2C4wEFdIeRJfaYkj23zLJOGokazMscUhF6jW0St//1KOUQSTC/uyqcJbWD7c8w3bIIDjfqAPVhl7hPB3SrW6MRCgEhiSeBuFOfxrlIU8jGOs8rLfQGJqcp+RdQynt0ZEgJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMXhVD3fTz8Sa2qDgNSakVPt/MNcI6pVDm9NsXh0kwc=;
 b=YJUahfUqsY/EhzSiMED85oE0lOtZ2qJf2rC6ZDp2Cf6ZdfHi/y3joWUh2lRvAh/cHL3nH4PqUFnNn2d0zJDImkGDXuwBenKeMv/mLiHP2ZjJdYlc8XN9ON/fcu3uhCbbMtwRpz4HC+ZMP12wWJ18vmZytPAeVTDgfAvo9hlu4u0=
Received: from DM6PR10MB4201.namprd10.prod.outlook.com (2603:10b6:5:216::10)
 by DM6PR10MB4139.namprd10.prod.outlook.com (2603:10b6:5:21d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Fri, 11 Nov
 2022 23:26:45 +0000
Received: from DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::4786:1191:c631:99da]) by DM6PR10MB4201.namprd10.prod.outlook.com
 ([fe80::4786:1191:c631:99da%4]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 23:26:45 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v9 1/3] madvise: use zap_page_range_single for madvise dontneed
Date:   Fri, 11 Nov 2022 15:26:26 -0800
Message-Id: <20221111232628.290160-2-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221111232628.290160-1-mike.kravetz@oracle.com>
References: <20221111232628.290160-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0069.namprd04.prod.outlook.com
 (2603:10b6:303:6b::14) To DM6PR10MB4201.namprd10.prod.outlook.com
 (2603:10b6:5:216::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4201:EE_|DM6PR10MB4139:EE_
X-MS-Office365-Filtering-Correlation-Id: 2de7c00f-f50d-4b91-999c-08dac43c32e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +KcGULEqPhhAv3fQi3U6ag7W+FEKDevJ3+HXH2yCSab+vBGdNx5ftS2hQtlWizUKUbXp+0ksIasCDhQIC+kfErvLt/BUSFtee/j13MnlkYnmOKCZPDbXZQ7BEE5qYVBfJykZ+yNkv6HpW2hqIXLj6NndqnyPr9D/FAiV6VoybY8vaRrQRZfDo34TDHczcY3G035nxWp+xuzvEgGP0LNnCVsP0TbS+F4/sr8+rv5aUfhBvFQQMbx5KdZ2DrgFbezJBU2tPf9MtpqbVGHKhqnkn28T7P/+LRhqcZJ0xNfqK8YLTT/gsTxWzUvqrzvhbnryoHNKggWBQtOOtN//QTCwfaK/+MxUwZm1kZ+SRzBRctg7VGJsq55TbWK41p0wB5k8eDp6/bMv3op0TybuDTydlaoySkx/4J8BppxpuH+S6w11AFx0G2I3nrnIykztNtNpVc5SWz9xiBGVTR9DP5yASfQ1S6r7PDMkihETb5rhnKK5BuZz14TNXzEqZYJjbXerQtxK9S4CfJfTS/OFonATOl5Z/1tRTi/Shotgfh2SbjF+5bc3c0mFvX2yC+wnigzpTSYJFDyxWNpfJnCij/nHKzWrVAgLDlefdfkySmgNz939l/cffdaZlYOiICfH8T84c27Pno7qGlJ8uMnT9VHhZpORweiyyZPCIRZ4UQd905TweHFb6VfxEKIx5asNT6vxAiq3k7tHYtBzT0xIc02aTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4201.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(39860400002)(396003)(366004)(451199015)(66946007)(8676002)(66476007)(66556008)(316002)(44832011)(4326008)(38100700002)(83380400001)(2906002)(41300700001)(86362001)(26005)(6512007)(5660300002)(186003)(7416002)(1076003)(2616005)(8936002)(36756003)(6506007)(6486002)(478600001)(54906003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J6Wb4+8mnB4BiaE8WIVM2nV/jd4NpJ2rx0pu7rv3AejF/t0cA7N80kc8jCBJ?=
 =?us-ascii?Q?mE4gGGg94fo/9Ygw/X2TyJIkZwN6lQelLeZwy0R35fhiy4yOvkEaEKHu4YCA?=
 =?us-ascii?Q?urgV0TjSZa8rU9tnLLqr0IshnoJSdJx25zWoP8qoR+vVM0Cy17m5uT4fFVcp?=
 =?us-ascii?Q?lEBMWfPsf5O2BlyaAItW9xmc1tUN+fTxQgGh99WzyUChIkPMc7C14zN6nj07?=
 =?us-ascii?Q?gLmdesMBi1cF3AZ9adJGoBlkB/ZDBGhhaoiDhZwvwHSyxVo8F3roFWFTt0j6?=
 =?us-ascii?Q?+2xv54XX4e1KTeNB93TrjpXNIDfuJwvxSJz2+j3hI9TYNFztycJzGReAzB8S?=
 =?us-ascii?Q?fTEffhLPaANSITpHXp9pRWdPxZxZ/9Ljg6sk16z9/l1jQf76dzq7gJgMmDhb?=
 =?us-ascii?Q?AIeLCIE2PIU3x9VRq+RuPsgHIdGOgN4rAmwYip/aVZW3rZ8WxiGK9G2S5uhp?=
 =?us-ascii?Q?eSDZdRfnf9nzB3RlGEk86djMg8uHK+TUDBINJg9Ox4gXRa2V2WgNyASfC9JP?=
 =?us-ascii?Q?z3cQCkFFgMCQSN6Qp2zT/7d2aH/acAUbm8rKlvXYaFJJ9cxQDxLP5/uX/Evk?=
 =?us-ascii?Q?RipsF9pw+hbDqBexMIKTIVv7rM8iX9f0W2h4V6vdieN7UCKRAnkWGf557lje?=
 =?us-ascii?Q?J40M6TUnkQhdM7YsTt2b5IspbO7rurhWgncsEOEPzleJTWwwHCHkzf43cR2R?=
 =?us-ascii?Q?4B4Dywn19n6CTpw/54CtvH9AldKoom/QiGxNq7tNpHpGKL/GmoFkASxN/pOS?=
 =?us-ascii?Q?ET0BUFDTA9bjpPFjBUG7eHw8h3HyLLPPocpQIFHda/OVeKy4+F7O+9fTJTrJ?=
 =?us-ascii?Q?G+28yrHX3dqfl+eWg1kGzQ7SNZRbk0droeaNhuW6n2j4IMK7L06YRwebt4Z9?=
 =?us-ascii?Q?QOHMiceeoeNkjQLSdXya2I270HDZ3qSEpWbwyzjbWKbkUeRVUClCY1OmTzpb?=
 =?us-ascii?Q?SjYtHJubt5pXWfq8toHSbN5l8mfGLSmiUQE5nOvEk9G8vMw+uaLVTAQMYuSd?=
 =?us-ascii?Q?KRimzFJhWS9REwnPBFGn4pJ0mNAsRSO9RMcOcsduRtFtCbhwzmq9FWM0wTIO?=
 =?us-ascii?Q?0ayT+clZJ56i22Ay6pApqXGHZ1Be3LfYozmR1/ig+KoYqsxjcJIpj2XKFZY2?=
 =?us-ascii?Q?QYiEWFoG+VGDJXyrHil9/9ubKnnts9EF1lVquxGl7W1arXYdZioO9M8rfk5k?=
 =?us-ascii?Q?1xIZlwGK+NwX0i+1bYe4Kt1C7iueJRMc5oYoNP5Uok6rx9agc0YlgTLa0JLs?=
 =?us-ascii?Q?0Zd8mqXBN8qALFjRxitUA1mTLs1CCLzYO/3FSjzFWwsU4PqjtOcDc09bjk6F?=
 =?us-ascii?Q?0jC4jaW+THQKoRfVGQfqw92PC0ocm/9B4Kzl4vi0/nKQy8f3anAO+AKmlY0x?=
 =?us-ascii?Q?qYaDQmDUdFFMoHQMe+lLLTaLN2vUUsbK11YqC42MyL4ihEqozc65sTFYTtXp?=
 =?us-ascii?Q?nafuhV/+eqDcsjEns1uDf2oCOD/mgZGvebaitUdnGfmGtLJKbfG+ht0hFJGA?=
 =?us-ascii?Q?Pi7cVUOptoyCO97ZaLqKpC803ZWNycsGLQrMbVP4zpY7JVK7Dvbxjib19I0v?=
 =?us-ascii?Q?Wnbf0LVxH1mMm6YcEDEZQgMt8dJ/piED8ZH2KDqZi9415OxXCnFl2Hl/PZww?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?x5DASo4NEHMaItg4gibizPgpi7yU2T9zzWx/kRHLVZxeVYL8ygklX1ylG2v2?=
 =?us-ascii?Q?fIoGBcLolGaDL4nzakzXdwB6CKpz2g1m7+YXNfZUObD/R7iGw127MmL2RTZl?=
 =?us-ascii?Q?/chSYN8bqn+48zrYq3uaI7kzFrBBpJ11FdxqR20Tw8IYTEecR+6GBPUuL7gg?=
 =?us-ascii?Q?Dg+VThwbEgvF/lwsF7iLJUeKikJtgANdq4I0RipGN0QCnuZOzSZONf/QPQT0?=
 =?us-ascii?Q?0EX5V7xekOzK+D99CYBfTBlWar/P8cztpxJLq2gO/JI4L+BQqlU9rUBTBbxX?=
 =?us-ascii?Q?SHrOVA1EcnCy+0A8sjZyzfOeAsQIQowDyBpgznIJRQ9RKG8+UI4fCkFMYg5l?=
 =?us-ascii?Q?UA2IzmduJTqgDqoCEjae58axwVGJHloKE7b/kSJCB64Zp66rTKSnZNfKdzGK?=
 =?us-ascii?Q?AHMKcc45tQvUvPG4FxRYN1/I0TF+68NJOJn8E3+vBgt0YGC8ckNNkcZ1f5mg?=
 =?us-ascii?Q?ae2ErxG5ALrTqMkHzUBnM/xBqc4GoMG/NlqjkrITiDM55HJZoF0TgY85anMv?=
 =?us-ascii?Q?VJQ5iapViGpu5Z6pk/tnYoVUzyTXlMV/+19GdJwxg81fa99Eni2Kw+vfIvMj?=
 =?us-ascii?Q?R1SiVFO+/gwjXsOFXh9FvlQA2zptyjoaySabHr4kb5T1Cs76YYed6hhRXVCI?=
 =?us-ascii?Q?akfRwkyhpqzJBqPWeUUDNojdPQoYlZHxh6hXajEU5fDgVQh9dqdobED5qi7i?=
 =?us-ascii?Q?Q7VSs/bwijzW5krlgSeoqhu9Ho9tbgxuKD8uZ/EfZu9qk0YNQZ0hE+NVkJq8?=
 =?us-ascii?Q?kjtmyu7RltKRF4+nE7m5X8wiYbIUqWTW9D6DUQ9zRandKM+cX9XYB8JXBVG8?=
 =?us-ascii?Q?uhCpgE0t7nDqgiwC7Udg5YI67MdkTF5m8dZbefxN60aAVHh26fReqUQ7sxUu?=
 =?us-ascii?Q?LZwYX1vUgBq+Dh9HK/lwGloY2x2Y6rcYsSeNQcvl5+kcrVYJi/r+tThUCV8r?=
 =?us-ascii?Q?ZZXdWkjrJWkUqC9b/J4RaBnWFxYw09s4ngD7oGU0cF4JLAFxTcYEnP3/kZHn?=
 =?us-ascii?Q?43cSlGA6NJZdeuYlHFFO66Itcxwpd6ejTUqemDcdwCztSJH2dwM3RgtBVsjf?=
 =?us-ascii?Q?kk/yey9h/80x/V9SWvT2h1Biv0YnYMLu2QQqii9SoKXdFa4oz0HuKHoHsSG5?=
 =?us-ascii?Q?SsnetdlMgN/auak7Qkz3phTXRLyJTaM06d14txqsodi4Ks5+l3pAvpk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2de7c00f-f50d-4b91-999c-08dac43c32e2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4201.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 23:26:45.8233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MKhS30aUwK08Hn6G2ZlkyrlZrAlaN/BGKSpzr0mrV79uzpQEBbqR2LGdvWzN9ONXaEosqC7TQ/wsBq1iowmvxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_11,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110159
X-Proofpoint-ORIG-GUID: acLj3til2iUgZUEp2aP7XRApArtmgo9Z
X-Proofpoint-GUID: acLj3til2iUgZUEp2aP7XRApArtmgo9Z
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Expose the routine zap_page_range_single to zap a range within a single
vma.  The madvise routine madvise_dontneed_single_vma can use this
routine as it explicitly operates on a single vma.  Also, update the mmu
notification range in zap_page_range_single to take hugetlb pmd sharing
into account.  This is required as MADV_DONTNEED supports hugetlb vmas.

Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/mm.h | 27 +++++++++++++++++++--------
 mm/madvise.c       |  6 +++---
 mm/memory.c        | 23 +++++++++++------------
 3 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e8fc35edaee0..9e7cad65dfde 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1881,6 +1881,23 @@ static void __maybe_unused show_free_areas(unsigned int flags, nodemask_t *nodem
 	__show_free_areas(flags, nodemask, MAX_NR_ZONES - 1);
 }
 
+/*
+ * Parameter block passed down to zap_pte_range in exceptional cases.
+ */
+struct zap_details {
+	struct folio *single_folio;	/* Locked folio to be unmapped */
+	bool even_cows;			/* Zap COWed private pages too? */
+	zap_flags_t zap_flags;		/* Extra flags for zapping */
+};
+
+/*
+ * Whether to drop the pte markers, for example, the uffd-wp information for
+ * file-backed memory.  This should only be specified when we will completely
+ * drop the page in the mm, either by truncation or unmapping of the vma.  By
+ * default, the flag is not set.
+ */
+#define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
+
 #ifdef CONFIG_MMU
 extern bool can_do_mlock(void);
 #else
@@ -1898,6 +1915,8 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
 void zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		    unsigned long size);
+void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+			   unsigned long size, struct zap_details *details);
 void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 		struct vm_area_struct *start_vma, unsigned long start,
 		unsigned long end);
@@ -3529,12 +3548,4 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
 }
 #endif
 
-/*
- * Whether to drop the pte markers, for example, the uffd-wp information for
- * file-backed memory.  This should only be specified when we will completely
- * drop the page in the mm, either by truncation or unmapping of the vma.  By
- * default, the flag is not set.
- */
-#define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
-
 #endif /* _LINUX_MM_H */
diff --git a/mm/madvise.c b/mm/madvise.c
index 68a23104687f..b2f1860a353e 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -785,8 +785,8 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
  * data it wants to keep.  Be sure to free swap resources too.  The
- * zap_page_range call sets things up for shrink_active_list to actually free
- * these pages later if no one else has touched them in the meantime,
+ * zap_page_range_single call sets things up for shrink_active_list to actually
+ * free these pages later if no one else has touched them in the meantime,
  * although we could add these pages to a global reuse list for
  * shrink_active_list to pick up before reclaiming other pages.
  *
@@ -803,7 +803,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
 static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
-	zap_page_range(vma, start, end - start);
+	zap_page_range_single(vma, start, end - start, NULL);
 	return 0;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index 98ddb91df9a7..ebdbd395cfad 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1294,15 +1294,6 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 	return ret;
 }
 
-/*
- * Parameter block passed down to zap_pte_range in exceptional cases.
- */
-struct zap_details {
-	struct folio *single_folio;	/* Locked folio to be unmapped */
-	bool even_cows;			/* Zap COWed private pages too? */
-	zap_flags_t zap_flags;		/* Extra flags for zapping */
-};
-
 /* Whether we should zap all COWed (private) pages too */
 static inline bool should_zap_cows(struct zap_details *details)
 {
@@ -1736,19 +1727,27 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
  *
  * The range must fit into one VMA.
  */
-static void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *details)
 {
+	unsigned long end = address + size;
 	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
 
 	lru_add_drain();
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				address, address + size);
+				address, end);
+	if (is_vm_hugetlb_page(vma))
+		adjust_range_if_pmd_sharing_possible(vma, &range.start,
+						     &range.end);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 	update_hiwater_rss(vma->vm_mm);
 	mmu_notifier_invalidate_range_start(&range);
-	unmap_single_vma(&tlb, vma, address, range.end, details);
+	/*
+	 * unmap 'address-end' not 'range.start-range.end' as range
+	 * could have been expanded for hugetlb pmd sharing.
+	 */
+	unmap_single_vma(&tlb, vma, address, end, details);
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 }
-- 
2.37.3

