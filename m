Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00D1628DCD
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 00:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbiKNX5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 18:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbiKNX5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 18:57:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9DA10044;
        Mon, 14 Nov 2022 15:57:32 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AELDnql025708;
        Mon, 14 Nov 2022 23:55:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=uRKbYWuEt3rFdhI7IzRGeWhbUjlPV3fd2I2QkSG75kg=;
 b=rTZ4+sgmhOErph0bqldZnYn1QLT547M9CFi1bb7XShQO9PqVxf4HCEXID+RikL1PkZyW
 zQs9tSw5X2wH3bKTXQ9cSXtrTp2XZocvVEr7QZAEbYakC0MoWnT+yHSL0oDgrmHILIkI
 H6WeLqSB3oYx8uiLP9Ccf8W/16B98T5GyEM1tFFe8gEH4RMaWgdRBbSL74plnoiIAz/j
 ok8CWTSk3zu+KikeYbzI+LE2wvrwTH2TgEuGw4g+kwLPH3zo2uhw0ed5mzsFOk7CXC5q
 ydQTGqHudv5jR0xTqbt+wpPO1K1r0YBAWGGC2AwYlJjX2MlgdqDzkjrW9kihlFV1AUJ3 ig== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kut2eh2r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 23:55:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AENADra019263;
        Mon, 14 Nov 2022 23:55:17 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1x4vvax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 23:55:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CyqHKAWdA0FzBtbbmIiHOOP2PO5VBH3RD/hZY2fbF5xJ3meKCtoauRCI0MeNs5YRCLinAGFAadzZS1grUnuhxrJFf5oO3izGV2zAh/2a94lNI7Q1rFdcFPCehW4zV/PQE0WqYfVHxkTiHjwGclFnhq2+ZURGJuBGjOSktU9ALwHftHq4lu+jbKKqeO+FlLS69yopXDdHNill/Z54QUUF9RqqIR7W23UE0puBGj7+WC/HOce3GZ3wNMHfbHNMwatwXUwt4wL7D1SQQfsskTFTVUUIZZymjfKxFqTkwean4jwNk1SI0C+1/qgDj/TT2AfzYY+nc3L+nxQgI1d/u7fq/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRKbYWuEt3rFdhI7IzRGeWhbUjlPV3fd2I2QkSG75kg=;
 b=Ey6qKotx0dpcpy48oxqkwVn8GqZnoJxwL/WvuLUpIVlaO836jovLUfjP3dbALippfiaUU/pgPh2SIpiLFro8zTmmn9dx2CNIW/BcaRoIFGxYVYvS54QyYBKxLA9vkr5BCqfLIGXcVVMNyyNnDC0oVI2Ome/JQnRI9pwT/t507Z/HRET3ugSIvlFt/t4JIFnZJ/5tucjFaB1YYLUVL0MUVespcqPup8bSiYvDsED1NVOxYHzFAPsQHqRygL8oF2P21yZaCD1zF+No50FXgl9rAjomHnDmuH3TLsfelb+JrPVJ889LX9PmduHY5PtV3sZxck+doByueFX3GfiGDuU2CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRKbYWuEt3rFdhI7IzRGeWhbUjlPV3fd2I2QkSG75kg=;
 b=WxKjaz7gglHEuWWl2dgxLUzXKZ+saS5MZ6F468F68uLNCVy2akMsO1mRstn6mXNYf25cZp1oxLPLZHSh4jcm+0LgR62vY0GaiJ5XL5HbfwAPSeviKSlJbGPovJzh7qai1fUhKZCUPNlMOzPPdCwH3hKWR9Wdl+7pvgO+LLJPF5k=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BY5PR10MB4178.namprd10.prod.outlook.com (2603:10b6:a03:210::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 23:55:15 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 23:55:15 +0000
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
Subject: [PATCH v10 1/3] madvise: use zap_page_range_single for madvise dontneed
Date:   Mon, 14 Nov 2022 15:55:05 -0800
Message-Id: <20221114235507.294320-2-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114235507.294320-1-mike.kravetz@oracle.com>
References: <20221114235507.294320-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0027.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::32) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|BY5PR10MB4178:EE_
X-MS-Office365-Filtering-Correlation-Id: 777c31e5-5db5-48e7-90ef-08dac69bad16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lMj0EqvFR9sHzoFaGnLaazAQ3qkef9C0N9Q/UguxfC9PG3MaQsYIMZZb9EM8ROIhLmZImNCJFr51bpQp0ut8f1RqWIisV7Wobvaa1gDgFdBoB1SFU6TK/lKI05cpBMi2E+5/gcYgdCCZx8/b/+rT4J4UnkQ1lLWnoPkBx9i+ONulfbmY/bkDx/Ld1Me13XbFn3V5cvqcgHusNMh03ad047mPZPpIRMAiR7/Et+SiiHEU+l2Rbtd6k0uEFePSik/Gjl5GWXS2fZq//yHhj4Alv2uPyLVio7XJEbJEFwJXoJGk11tHhRZpjI6ScTWjYaTqoW0gTJayQcF4uOQmwic45Dz1ySCSWt4FmvIvD/RErd+C1KzjnUGA1FaF8qXGhQod7d9yVJYR0xM/8QxyZHHcnaHT3LnDFUrPZswEdK3a/GGHJFU5lTaHcueDOF5jthzwfLBdPem5v458RiYcHCy1yTDumAyzcKpbkknFfNc7V9xnS5ulPA4gcIGeefPGrvcsEpFvvB1W+zdhV+qYkYpczb3QfZ2C3z9lrketiZwUt/gGEUljA7EeQ2R1qunS0wsDQn/7UsjAoDxOxdJlgaIJZL0KdMV+Wt/JvlIXEFggJTSSJjzwEUtVmO3n0GsYEpCGgggqXDmeJjBbQM5jRg/m+ewoymrq3+Uq9/SuY94kf4+zF28CqcqeTlU8VKk6nXNDmsiKb9a+PN2JUuUoCTbCzHt6ai7Vygw70GzskZP0pg07dY5rnQ6CRNRCwJsXaaSJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199015)(2906002)(4326008)(66556008)(2616005)(6512007)(66476007)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(38100700002)(316002)(6506007)(54906003)(83380400001)(8936002)(7416002)(186003)(5660300002)(478600001)(44832011)(26005)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B7U4UjyUH7hX6Slz8SGSpf6Q9rYs3pRugONEe9rql+fuy/bXi4GKOCFODLA9?=
 =?us-ascii?Q?J9OHKAs5tk1U/n4b5NBWykjF6Xppk/kbX45ANM6HAC6YdKE4ofNi6SFsTPUy?=
 =?us-ascii?Q?BoZh8BfPimWovVgJxYRiqyzhQ7MWUG8gYa5ciC+L1rPZ4DePpG1SgcVLdhz2?=
 =?us-ascii?Q?ImC9kD8p5oT3C9BT5DuxpH1o1E7LhoE07zCXDX5dvQqFXB3YtEp4U+fiYkvl?=
 =?us-ascii?Q?H3iXZb8n+WcX+rNM3NndDa7TiY+drIYEn7cOEBR887CrLYcWlzoHWH3qe/Qt?=
 =?us-ascii?Q?ZK3hSAI17eCk2p4MWedEhdSFlFLooBLDYfJFnXFNE2N2fkdleXMsFuhi6aSb?=
 =?us-ascii?Q?8779Kgpd0dAfkIUVJG8pyZgB4SblrCnEKNyq/3Ndcq6n8SNMIbr50Pu8p9hj?=
 =?us-ascii?Q?+LNtVw0XDz7hNclddHjyAMRSaKrIU2VJzDamU/0wRxVPEvUvuOUfxXiQJIN7?=
 =?us-ascii?Q?SXtTDkwXcXFEqN0Wn7hcRLR9qI+bn58Qh0nus2MBkD2U8YAYL/25jp33Tmt5?=
 =?us-ascii?Q?i9Ignizh38ciWWhjY+xvtPynQvDdhDNR6n7aSAJosSxZV32srLbsmDTO6gXh?=
 =?us-ascii?Q?Bp/O9f/jBgVn9+QkBopVlKzo/3uL0KAyTDBahwHkjeFBJbtTnK6UxMCdmIiF?=
 =?us-ascii?Q?b4+kWRLIOMWcKHXDmQNA1wS0k9PIlEv5GDC5gMBStQLAYpNFGVB9DSccPpQ/?=
 =?us-ascii?Q?lcUoW2qOdZMVJZHD9e+BZ50XLVrYBcWYnM7RqF6bkx6ceBp1yD163wgJBoVV?=
 =?us-ascii?Q?6FHHp/0XHOKCQYF9x3DjyXhUT4nsOArLVV1Gkp9uzMH+5I30dtrL61uPW9hu?=
 =?us-ascii?Q?UNqQWswY1IEFMqKojY2mQXnaX+s2RW78jnGgGvTsF72Xl9QYz+FQCLufzP19?=
 =?us-ascii?Q?Tk9bnLtme5+BRMcjR6ye5QUQFTajijyj3iKwHpMDxMJn8MGX21AGW8e1bIn5?=
 =?us-ascii?Q?4y87kpiYBoM7DKD9dW+XhlgV8wQRDaOKRLEB7+rDduffyG56xI9YAtgVugjA?=
 =?us-ascii?Q?xbfGFotIHwh9C8BZNXW7ph22hRs2mStt8zk7is4j4RCF/HFY9vcxUNgCjk+m?=
 =?us-ascii?Q?+QX279uhFcCHSijSRa0M+xybPa+nxAFNvjajWyRmRgqpy59AL/QcLLo1bw1k?=
 =?us-ascii?Q?G0HaH1zV/0sE9VA+nquFDtXvOky7+g+2rE5YxLebI0lwFt8aQ/HZhOv/3nJz?=
 =?us-ascii?Q?Fa6FKooudZV22KmeXXsjWDJG1UEcg3r2LadGtMOeM/9yAdXXEmMqwMtLAroV?=
 =?us-ascii?Q?OP7Rbt2eXzUZZAyS1aO+2VzL2Dsxgkjv/gZ+2WVeJkeD5ntlAnNcGoqKnxbG?=
 =?us-ascii?Q?ojTO6Iau5WctEi34qlP83JdfyTaKreJdtTL6T9bMR/63Yo2pEbXwP+utIU8D?=
 =?us-ascii?Q?6oUZdlGDsxaru48JSIwf/lxcIoHuHPU9BYSXNyHNNG2OsNzqR20aJ1KR+z0u?=
 =?us-ascii?Q?HJgQtGN5PQh+ptZycWA7z0WVU6XRRqz8LvqaXJOsiul0s3EmPTSAQ/ry+NQn?=
 =?us-ascii?Q?UxZnP2OH3sZyp3jqWw4J7wt6IiBY/uisZWEdaH2jBRWRWZjBw9+vEb8gtL5y?=
 =?us-ascii?Q?O4r0ixa6etMcuJo9tjHtDdAxVBxQcuB4xJPWdrmDcadu+UYy2xS+4X+JOW+Q?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?12RD4dNHqLrmA5hdicC8SHdAsUtDvy7TdcoHYZ6N2OM4a/u+fXA06cu6YifA?=
 =?us-ascii?Q?MDUpJojHqW0KFIZHHZXKmfHXXdJ/lHMVgqen+LtwHrTflA7MXqI1fciyApkw?=
 =?us-ascii?Q?o2M3zI9fT7jPA1h86ObsSpFXy+8qjCR3SDk4VW6H8hKgJpmPoxYur/ASZigg?=
 =?us-ascii?Q?X0EymKDSipTmWH8E4wRMSfyCys5XDJ4Fbfqun+WJPXqyUrrHS0Ri5QQVW8SG?=
 =?us-ascii?Q?C+s4dU28ggClGSHDFlCRKIwub7Sn7FOHfuq15p58rvAnDRo1di3mgPllmwhV?=
 =?us-ascii?Q?Gew1e0kE+2pKLwzWtbNwkq61b+MZ1kKgOFWeGTaPTYHzmaZpfsX8f/TjGiGQ?=
 =?us-ascii?Q?kFCMtH8JTOaDD3hanuA81XYV0ERF8YO+wGB0eAHS5orA7gZohOhKTva0WAKN?=
 =?us-ascii?Q?N9nIQiIELFRpz1JbK8khL53rxkNciq4RkITYLm2A0UaAuLYCvGIFS7AtbpxO?=
 =?us-ascii?Q?hYm7pmTM2QJtHXCA3wazYgxHBzdTLfs/cKYZWz0QwbBmm8tlxaGHUJwCuPS7?=
 =?us-ascii?Q?nj1vS67KDgkhvdxKhDB9TDWuqg+D1zTIYeU3Q+Jp1Fi5sl+v5Su4PbHcV5Jy?=
 =?us-ascii?Q?bb/U2UEYUWYTqFmIviFvwaC6tZpmTsqd9q/fopJ929HfTl7t8bnPh5t1KBRO?=
 =?us-ascii?Q?v4enTwP/JukDB1pWGR5GOX02ZIu0apleGONvnktgZHiMHCLb4gj7RoXfQyKL?=
 =?us-ascii?Q?HcByZ9FbPEOqt5UyB8SkkrRgE3O0QNi/Cyq/HPr6D8v53b0FD13nMiwjVUR7?=
 =?us-ascii?Q?LoVavi2Gm7hJK/fdo5gfF1UOJtO+gRHKsrV/Mxwt7VifJjuQ5IK3RibHBJwB?=
 =?us-ascii?Q?SKws/lfHPOMdgsZr9FvYWTWxHLr97lir5orKGe1bKW4Q9SDdatm7cHgG0gcz?=
 =?us-ascii?Q?hjydK3MMW6FBH/IdGQtx7klFHfxopk4DVzJXLYUYlFKLA3LRs5JyZK7Jly/R?=
 =?us-ascii?Q?jgigPppxq5dn9Us7dAeqnkbZmWx0cwMRd0oKaTKMLbnkoA70t8YHojCpZNFq?=
 =?us-ascii?Q?9+a9Z/BHJeS5Czs7vsTJn1/92nOGzcpxYa1g7XZrlsRSQH5y6UT+yefGSwEs?=
 =?us-ascii?Q?9pu4ivokSDph6rvvz6F44xU3XuEsXEglwrpu+pBFH5EWCPJKcovTdw8RlJxB?=
 =?us-ascii?Q?mOnx3U51T9LOuWT7GnAAppCFZ8u8wtHI/qQS2BmvxBk9lBFfX8IN6rI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 777c31e5-5db5-48e7-90ef-08dac69bad16
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 23:55:15.4076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yWH0ovwAYflEiG6lavARwV5u+j+mQqViH5CKVgvxkJcZO/GmA7NYrqcBGxAqNPN0BFpug3YWQW3STG2cxGpj9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_15,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211140168
X-Proofpoint-ORIG-GUID: YCQX9bB0aOLOwIUT_Oi0vXUzwMXUiKz9
X-Proofpoint-GUID: YCQX9bB0aOLOwIUT_Oi0vXUzwMXUiKz9
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
index 9838b535fa21..dd5a38682537 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1870,6 +1870,23 @@ static void __maybe_unused show_free_areas(unsigned int flags, nodemask_t *nodem
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
@@ -1887,6 +1904,8 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
 void zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		    unsigned long size);
+void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+			   unsigned long size, struct zap_details *details);
 void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 		struct vm_area_struct *start_vma, unsigned long start,
 		unsigned long end);
@@ -3518,12 +3537,4 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
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
index df62d9e1035a..a21b186eb7a0 100644
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
index 98ddb91df9a7..a177f6bbfafc 100644
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
+	const unsigned long end = address + size;
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
2.38.1

