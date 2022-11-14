Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6680628DCF
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 00:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiKNX5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 18:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237546AbiKNX5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 18:57:36 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5A810064;
        Mon, 14 Nov 2022 15:57:32 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AELDlQq011985;
        Mon, 14 Nov 2022 23:55:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=GjynOfmK1NGfPSqaN7twnNbL6ZbrLMDmUL3fGSYghrQ=;
 b=T6CtDUcISpoWS+qqgjcI/LgmNiFfHobr6+GY+AUAn9GLmOnfFb4zfSvj+CtnTKiZ/N9b
 59abhXt9gdN/RBN5e/PAv9/02ldA3tMXwSIlgL+iddRDF8QpaJZHBEQuwDfvOGuUIoB/
 W4/5Mvgf7TEcR79knPyYwJG0w6LjQzSrz4X23D1Iq2IPVO2CNhQMhP2s209BGYhUXKTo
 jkzYE81/D0ienmI1l5CwNxNSHENsitWoErtGRS86oIXMFE9BjIgevoOcmqZv5sHOTemM
 jxxsBYxpUN/l+98Sh9ix/9Y7qzgHmYapD6um7mSInTqWbIPvaPIJ6H2ow8qEqzh5+C3/ Gw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kut2dh2sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 23:55:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AEMTc7O004738;
        Mon, 14 Nov 2022 23:55:20 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2047.outbound.protection.outlook.com [104.47.51.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ku3k5prbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Nov 2022 23:55:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXgOEKULtG29bQpYvC0QrKLFuv7zGPtQcuRLaEaGda2YfbR7G9jgnjMxz1wT4ESwWjXvQc07q3d3lrcIs4y0EixCXloF5xRADpPl5AVEoOqJjT/cGA6HuxfPLo19ImAoICnMg6fhzND1IlKd3fVgF2O7+XXbeaKVHsgUF4qCz937yuSkIpQazpgAv53Shxe75ZvDf5n37HVp2iFyRWqsT37a02bD3vZRUGBA8nab1X1qEilASCgAzwj7KKLhL2611EIpEO1YHptffux7FrI4megGWs85nELa8L5kNHD1iH/K2FcGumwtom3UuzTWAC8n0FeV1Z8bmEMkR/yIE3lzsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GjynOfmK1NGfPSqaN7twnNbL6ZbrLMDmUL3fGSYghrQ=;
 b=cp9wbw0Pg4AaAO74Ob8+Z3mot2q7aJ8GRw8oefDfAX4l36owKl/NoDMwyn1jkC/4sI8Vkpp6CNAqQb/4mxwcAzW3fyTAElQCF3XKg+sLVYiwplH+0iDNdr/gUDkYT95Dnj9kQHcx++9j810B09rczwFXHxmI0kuQkr/GWXz0t26hmIWKuy8M9d0UFPnSGq394OZfhY5zh2LXL9wKoRWwtIUHC+YupFw8ow0w1YjJkZMcoxyZTDKxUGGzQn4MtfrM59sOiXxF1joctakMsEaZG+l1+AHlJJ1RuNMHN3Vnq7W9J+kDcPzLVVL6LLJGrzrFwEY16ffkGHhvaifDFaym9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjynOfmK1NGfPSqaN7twnNbL6ZbrLMDmUL3fGSYghrQ=;
 b=OrN4TMMq2UHenbzoowssQZqxko0W4T+7YRQTg1u1RLRKncKRj1ltnQIlXkBUnpuEc6kIgArsNO+faoCqSdbk89hHxDmxxaCq14QMZcQK7GdYT0Ryc2jLaB7LQ/oTxB24/u9ESRGnH85u6TjAZ23GMY5gl0SHit8p89IsvSa6Y9E=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BY5PR10MB4178.namprd10.prod.outlook.com (2603:10b6:a03:210::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 23:55:18 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 23:55:18 +0000
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
Subject: [PATCH v10 2/3] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing
Date:   Mon, 14 Nov 2022 15:55:06 -0800
Message-Id: <20221114235507.294320-3-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114235507.294320-1-mike.kravetz@oracle.com>
References: <20221114235507.294320-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0189.namprd04.prod.outlook.com
 (2603:10b6:303:86::14) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|BY5PR10MB4178:EE_
X-MS-Office365-Filtering-Correlation-Id: bb202879-9d96-495a-2af1-08dac69baeba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vtVNloxCvStDZwTgsh4a6QLFy97342I+WHpYvS1h9gXXeYpN/eEg2dxaHesUW8y2VIhYNtT8YN6I3e3NxdqJNEH9bN0zfJCmk76N5Wg6mGFeEPR52+/9EUaqk2S8U15pDCLmMRvlhWlJGPjUsget/KVuXJ3xWUpkk/aUlSWUE0ryg+UZwug4Wo09kVb24OmrlBLpth51KFu9TnNj6s9Hei7J5Nc1GWB3g6J7MZ/zUcJpozWQ2SgYQPfwGJ/pNuf+O7BYduFyzrOymg5GLKGigRiCWiJYcQ7njdPUP/ip0aLI+SAoUIbDXDLX6TAxfzHR7KKOf+gPxLwrpcXNrpHfH4MiIQU8hj/z12p6MYglzCQ+974OdknihMZO999G9FS7XipdKpDhjpotwwSJa85FftiwYjOz87hEo0gszxIsqXUnPTED5xmh7t6RBXmyeltlbQIunN9GjAL/jn8FnGF20+mgQhUPOR8etsZAE+2/U04izAI1SlEoKzvyYGF24EaMGiqt+SeMLcSxlhn4nXJoaknuRq4KTbg1iII4wfQld2ko1IF+Ab1u2IArEJvnzu76jVtP+VnLkEg4OxqXrE5+w5cbW6hd6HarOBOEyhlFH4QuetzhbhrNgpPz5LSNhk0Cw4ZxSmlLqEuLbQW4L0Z2yDBjgTcENV+QZ+Zmo0uMRK0jXGGK/yAkHDM+xT9+2zC2DB601DLBKmn8OeAMJriKMn7hrSt+4cvnHmgEgQ1Re5J8u2jumxHOCh3r+9KzAxG5eSbpx9Vy3dtNITDQezVExQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199015)(2906002)(4326008)(66556008)(2616005)(6512007)(66476007)(8676002)(66946007)(41300700001)(86362001)(36756003)(1076003)(38100700002)(316002)(6506007)(54906003)(83380400001)(8936002)(7416002)(186003)(5660300002)(478600001)(44832011)(966005)(26005)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Vq05+Ux7P/KISxQeu8sOtbsNuq69GUzYssEADZwWjArh71nl41aBv63vtSN?=
 =?us-ascii?Q?UqND0gQhn26Ky4CLIhDA2dXJ6no7Ec8bmH5Vyuy1SObhJSaQgQihBn1ebZAw?=
 =?us-ascii?Q?vbc/cWqgYV+NkAFePd0jgyHt0BmwKZW47u1oadDvasQpDkwQ8sUux220rQQW?=
 =?us-ascii?Q?dgKMlwJRUw23cZXDMddWxyJdANP2TBd6O3zCyDM1ad7JFadaHoDR5NYsETb9?=
 =?us-ascii?Q?InMtw7xwYfmFzr0RB4dwpfwe94xAoeLJ70gWkwgBrXTTcNfvexaA+XXIVbNn?=
 =?us-ascii?Q?Ywpz6Z8t/iWEwK4bsPcC3LGtw9K+9Df58GxA/+6Ow6JVdZLCj2zhI580d4rC?=
 =?us-ascii?Q?tWsBbm0xCxjqFGUYYCl5htpsxgZIQIZxw5HabHTQLm+r/9O/Qszwbwbuia1z?=
 =?us-ascii?Q?UDRxfLM1zeRzBS88qWyOmnvFL0Mx3AbOM3dfqSqDL7khcn+nSHUCisKGy+xt?=
 =?us-ascii?Q?u1T7la6CLr+pKWuusHICpt1SfuOuS5qJr8QHn6JetXrCRfllDECy695JwpSs?=
 =?us-ascii?Q?H4K5PuAvfL9vT+6JykztGU9/O8fwJWjeza5D9UGo1XvDyTj5RcaKyvujMdHD?=
 =?us-ascii?Q?EHmPx3fTmKCPTFWCHt1gz7cwrjgv2tfgPuPw1Ocr5H1UtXK3rj8bs7y89x5U?=
 =?us-ascii?Q?+26cUnW1ddYrG3ySNTAsX0dHVxLgLffysp5yrsYL36cqzD1zIxhLEEmLZi8K?=
 =?us-ascii?Q?2Ja2+XtiXn8nK44dhruP3ElYZGnxp+k6XDMudoWO26KpSqORyMnLWGmX3EbO?=
 =?us-ascii?Q?63njKHpC6MYgdyqi7cCF/seC/JKbpTq30el3iUFUGUncyzizaBkvAq7s66Ma?=
 =?us-ascii?Q?uq79DQtsLGjmWO80ufjg7T9dw33M4zILvRSg+qAZPxM5fmta4+OityDjJWTH?=
 =?us-ascii?Q?fI5siJ1wPyaFgdsvFCrFw+1hc70Yw2hXAJpF15yXJ2iZrYH6lZ/+p5VNMhtA?=
 =?us-ascii?Q?GzfPYGoJ0bRGvY/9YC6cWJuaXWHr4xeUCaOO9BEAfIfA4PXotCQ0iecq2Xyx?=
 =?us-ascii?Q?wSpmbX5e1WyAcM3fz7MbgCWfi3kDUvUyXyxdsowTH/CJwV5elGO8MocIqkPz?=
 =?us-ascii?Q?EBJoYx5X8+vOz0EB7y64fDf/iad/+pmghPyuywdHWcbkgf3U2qY1NNtbjQ2G?=
 =?us-ascii?Q?XCJG3MwpYEDDU5EahuS91qOL97cLTNYHS8HKOmViJ03hiX7sKle9wvoK3rRr?=
 =?us-ascii?Q?FIKagIq1wnaeHgwGHjWClzDX9NovUl62AL/2BsxpYLjQPsZjZb6zp/35s3hA?=
 =?us-ascii?Q?ahbUKTXI6PS2xRZMt4l4qHfZ3vLhq7zl3qCXEP3dy8eIY7u6fzFsBdCTm4NO?=
 =?us-ascii?Q?p+rayIYYJpSIRETK0oWhX3hQEDpf6wMcxRfIezOpb7iADI+YzSTRtIQBp0yy?=
 =?us-ascii?Q?lNOBT0+ymVRu38HQUBPn8YJTAWOWwbgf3eJH13Ctt5LK4BOlcOEmdobQpB7R?=
 =?us-ascii?Q?JJZDJcxP/S1rJ6DHKCCLihP9vg34Yr1pcjzSbRjqMCYTntbh7vyfi1qRib7m?=
 =?us-ascii?Q?9hFbhUY/UkPwnASvwR0kq3Rx/4khVJgHA6ZSgEc3DseJi05Unv/DDExhZR7X?=
 =?us-ascii?Q?7BjwyBsLXyboevo2uitFfxsUdBH1b9kpQ1ohMGJ+GfbMAeYqBJknealOjWQW?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?1sq2QSV4vYg6s0+huPTV/Ozr8O4F8mwqMJ7G92jtiydoaaMZXB0pe1q5sXIk?=
 =?us-ascii?Q?Za1xOhC40uQiJGuzjdMTE8KIW83GZoiU0L4wr8IEA223G92hcxIKIbBom+x5?=
 =?us-ascii?Q?Zpfq9zRYsEgfSYWtgWbterWQyP7XRDIZydFP2UTcAYIyYx/j9o6vhQ5UTAwV?=
 =?us-ascii?Q?/UgeMPZTZP3oE7wwpV5Rr0m+jXFd+LkSLvLAqtB7cJeEqyiSvzBzFKAhLgVE?=
 =?us-ascii?Q?tQECnWNjZHgEVLO50xJXJLO/1e8OMC+s/YZzsLK8zsLvIsuvNIYT4D9q/Pni?=
 =?us-ascii?Q?/febN2jxZMZyL+2Vsa7SCq1Wy4ILd91x/u4vldbmnGkLIJnS4VZHfw1K1qJ1?=
 =?us-ascii?Q?9b3rMRQn0fet5DofqUAQL7DI37GtkV32JaJQd7K2bGNF667z9iSUGHRXMX69?=
 =?us-ascii?Q?BKzADWzAxXkYhKAK7vY8W/EdcXagCyUWQNelqL4am056o2Tzv1cF3kqz7tvo?=
 =?us-ascii?Q?Mdg9XPf9jvTX3BkyOd4yAxNcnvb1kao61L09b5jPTuztKMI46dpB25dFaNKh?=
 =?us-ascii?Q?nycA78cI5DpI2ukWMw6tZOmB/T/+zyI7Vx6Ii53NDg9mLi0icBj/aMr8gd4t?=
 =?us-ascii?Q?AL4wBQ3Z+n6fR/bUZMvZ+6Ierd/kcSF01b6PsfczKbyIdgljc3hJveDMbxiz?=
 =?us-ascii?Q?1mQ2IdjuAm0Mi++z3yhjclutYO3Ixvr+sqNS8EJBUP0MTFGN3qHldWgn1d51?=
 =?us-ascii?Q?bCY01hGlWxstL/tAPhL0hyrQ2Kp+pW4VJPVQZfDaELQ6Ir4XfF+8Y2xbP9HF?=
 =?us-ascii?Q?43vF1v1qw5JC4cIrf1kok6WxWGKzZx9Dbpou0P7F3kiZWyr1QgBehNUw20eD?=
 =?us-ascii?Q?UzhC4wQVEYTvEsi/V35daPkN45dxgEAoyH/MPqn1wSEtwxuYct2tXn9lVIji?=
 =?us-ascii?Q?GFyZAVM5S/e+FRHGo29WbN293y7MN95gqJrPiFmiSdtCe50lulK1AynZgvr1?=
 =?us-ascii?Q?1efYq0tK2f/4dhLRPmDV+paQHErtzkOz67TFQACu/YbtbmTtCFqvTTKEj7Uq?=
 =?us-ascii?Q?v26V/7YAR9efAyQV6zVQa1rjBj5zYX+jdGQKIADOZmce7HovJCJ/2laegnP6?=
 =?us-ascii?Q?QL7magsUJvGGiZdfbT3RHNO7sP6T6Y80Y4LjawjdATJfabMEmag6PAUDApp0?=
 =?us-ascii?Q?CeeX+O08TZ6hRBLxlqcGYpLhLy6dcvtoMeHMO7rOrjZNA0V4SeqXwhM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb202879-9d96-495a-2af1-08dac69baeba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 23:55:18.1887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWHH/q7ln/cT7IcCR7jau9ZV9UUwugS03gJ2lWqMMSe3C2hE1QbixX7G+1qYXqA8Q3cPEuzR4HKGkd9OuuIIpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_15,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211140168
X-Proofpoint-GUID: p1ot0EePJy7bfoRG8wLWKkrN3ew2vgbc
X-Proofpoint-ORIG-GUID: p1ot0EePJy7bfoRG8wLWKkrN3ew2vgbc
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear page
tables associated with the address range.  For hugetlb vmas,
zap_page_range will call __unmap_hugepage_range_final.  However,
__unmap_hugepage_range_final assumes the passed vma is about to be removed
and deletes the vma_lock to prevent pmd sharing as the vma is on the way
out.  In the case of madvise(MADV_DONTNEED) the vma remains, but the
missing vma_lock prevents pmd sharing and could potentially lead to issues
with truncation/fault races.

This issue was originally reported here [1] as a BUG triggered in
page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag to
prevent pmd sharing.  Subsequent faults on this vma were confused as
VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping was
not set in new pages added to the page table.  This resulted in pages that
appeared anonymous in a VM_SHARED vma and triggered the BUG.

Address issue by adding a new zap flag ZAP_FLAG_UNMAP to indicate an unmap
call from unmap_vmas().  This is used to indicate the 'final' unmapping of
a hugetlb vma.  When called via MADV_DONTNEED, this flag is not set and the
vm_lock is not deleted.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/mm.h |  2 ++
 mm/hugetlb.c       | 27 ++++++++++++++++-----------
 mm/memory.c        |  2 +-
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd5a38682537..a4e24dd2d96e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1886,6 +1886,8 @@ struct zap_details {
  * default, the flag is not set.
  */
 #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
+/* Set in unmap_vmas() to indicate a final unmap call.  Only used by hugetlb */
+#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
 
 #ifdef CONFIG_MMU
 extern bool can_do_mlock(void);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9d765364231e..7559b9dfe782 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5210,17 +5210,22 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
-	/*
-	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
-	 * the vma_lock is freed, this makes the vma ineligible for pmd
-	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
-	 * This is important as page tables for this unmapped range will
-	 * be asynchrously deleted.  If the page tables are shared, there
-	 * will be issues when accessed by someone else.
-	 */
-	__hugetlb_vma_unlock_write_free(vma);
-
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
+	if (zap_flags & ZAP_FLAG_UNMAP) {	/* final unmap */
+		/*
+		 * Unlock and free the vma lock before releasing i_mmap_rwsem.
+		 * When the vma_lock is freed, this makes the vma ineligible
+		 * for pmd sharing.  And, i_mmap_rwsem is required to set up
+		 * pmd sharing.  This is important as page tables for this
+		 * unmapped range will be asynchrously deleted.  If the page
+		 * tables are shared, there will be issues when accessed by
+		 * someone else.
+		 */
+		__hugetlb_vma_unlock_write_free(vma);
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+	} else {
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+		hugetlb_vma_unlock_write(vma);
+	}
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
diff --git a/mm/memory.c b/mm/memory.c
index a177f6bbfafc..6d77bc00bca1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1673,7 +1673,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
-		.zap_flags = ZAP_FLAG_DROP_MARKER,
+		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};
-- 
2.38.1

