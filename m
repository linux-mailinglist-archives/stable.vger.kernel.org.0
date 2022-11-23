Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB39636A3A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 20:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbiKWTzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 14:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiKWTzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 14:55:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845BA260D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 11:54:34 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANIhhLs015621;
        Wed, 23 Nov 2022 19:54:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=pVtfB2cwHEzBeKcBPzU1VOg9DZild1IftBR2Y8xWutM=;
 b=rgtDgwlqJuiDeGiVfhmg7su3lXY8n2xrS+LKC9yRpzje2F9cJ5wubM1tMfOlVlyHP7YB
 bkUoZfFPSus6NW8d66tIMuYdljZaMrr7D2zguAagl/aPRvtGqtReR3745jrQUm1CEXJT
 poHc1YdLqA0q/nk/qXoCwfiE5K38KC+PYFePkkpv294ZgA0cMNEUoNZkLjw+mH3JoYZM
 0qOzgwHnjvoPvugfeCwSZYTPmR6JeBOvMfr7cem1uCBn18aweYMJeqOkkTro+S2RjxPF
 hBk8eFOzi3TSXvlpZyHTmse6yug1oy/kWLRnOxnjle35puXg+H1nfLLVQpbMtj2U7sih Ag== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m169535x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ANJQ8kM015585;
        Wed, 23 Nov 2022 19:54:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk78qdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRCsBhP6cdTyCe/AJoLdut9B1cGhb4F4KsjRP2yZ3xy3WnHD/H3jTPHIFO6wViEE3eZYP3pyTRiH3uLYzjW+gyotnlUSLBNyvAqncOW3oxmbvG1GvdEfIaBKIh5h8RiwWWRgFmwziiugJAntAeouMet3r6yNhWglMSVdxdOoKRc1arh0DtuqoT1Uf07CsQs1AgFGvxN9JvNJVOD2n6hozwUaUtK8xEorDjx/+0hwnsYdLfPunAeZk09m9QaGSI6ESrBJ0w3f36KHIw5fSOwRKnCc1rbsBUTIr9R9zLCvZYo/ZQWmCJNk+u24WWh5i/LmzEHW9e3KWF+wDRlGtqpkCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pVtfB2cwHEzBeKcBPzU1VOg9DZild1IftBR2Y8xWutM=;
 b=gCm69XHItvVivqzzphyK0a3KJhmS55cikuqzus/qRTBJ8JBoS7g7X0hPOE+wQWKg2DWjdsJoexu3sUzzL1WKyfk/6QOZ8mXyaUtaCG4ZvN2IG+oMf+c3DC+p+DwbVnppsS7hWsU4O7irhfkgjvxSZoOxNp4Q4o5V3Rew/8jbTw80k24XXptvjT8PM+yM5Qg10dhDVO76/Yj8bq+8TEdKEXi2tGNSX1xaSFnHkQolXu6nBxFgTJHKszcKXss4SDnqWwdDQIsbrqEJ3gBqCnVVCu5Wtjj1+sQMXJOQDkOzF88kVMTXPvn+q2w0h2EoJrrJrurUazIIp9v/YMc7ECKUEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVtfB2cwHEzBeKcBPzU1VOg9DZild1IftBR2Y8xWutM=;
 b=LKsKEXYOthItOdtW1x7FwtmfKNRwzo4iYfK9xuN//8Nam8K6d1TUmxb5krILur3n5vD0fojD+4s84hvsJ6HmjKiVk10vQitB4w3k/kqeYnogaSpIZHO428b9MMNw59LeR98ILs1Rz/VNhxdRsOQZtYRXIyYHaSAhOAgtN9Sdabc=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by MW4PR10MB6300.namprd10.prod.outlook.com (2603:10b6:303:1ee::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 19:54:16 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 19:54:16 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     stable@vger.kernel.org, linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Oscar Salvador <osalvador@suse.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/6] mm: hwpoison: handle non-anonymous THP correctly
Date:   Wed, 23 Nov 2022 11:54:06 -0800
Message-Id: <20221123195408.135161-5-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123195408.135161-1-mike.kravetz@oracle.com>
References: <20221123195408.135161-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0055.namprd04.prod.outlook.com
 (2603:10b6:303:6a::30) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|MW4PR10MB6300:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bd5e6bd-b500-4a23-0bc1-08dacd8c8068
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8lesDBPSAFtYwHlFCoV9GNk19GlPEGct7ZJ2gv8D7qOv7sRgHltgWDDppX4IXD56k0Zw2SSsUe6Jb9S6XKhVHT/jniWG4Y9LCw7g4H4pVWpnvvA5koVAkQXoXi93phB4ElHG64p1r5i2O2G5qcfIhLRQJkXglAAZq/iHZ6OKYXQZeutNKci7gCeL5zSu7Fxc3ZO/Th/p0dFA8h4NewG65/oTkrgBvAh04yaVi1s12z8vpVY9eOiZgkZQiDwQB3zMDWeFfD4qf7H02yAU7W0HxpVbyz/WenxY31K66/eER983WApmvcWuFo1BqKyvc/9NBaStS7meSnGK+3dAovHFHC5uTly3LVdFyR2bbpjHglM0S/Z35L/gGijVQKviDuzF1HNq7jKv6qwqLG4iqBDbK+a3Pw2ne6/ExsCAEJZNwDf61mfOxOXCpW5NWVhrO0O6WLVwfsXZy0jLMOsoz18iiF8iBYPbYevXHqSvXMlcKG2Jclso/kooVT0/ypijbPTxp2T3DyWd4rYG54ByKDo/1xZXusi3GvukUuDg/Djm2pHwZJBEIN7qev732OX9mOZ1sKlLepLZixIciem+DDpw1zZOFEJnRwqL4jyzTOlcrH2+ZGsYscXAMlmIcHd8YOAyt2Qbgzw8kP3kveTAT5FVNrA+QZzRMM6cauePi5lgxYs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199015)(36756003)(316002)(54906003)(6506007)(186003)(1076003)(83380400001)(2616005)(966005)(6666004)(6486002)(26005)(478600001)(6512007)(41300700001)(44832011)(8936002)(5660300002)(86362001)(38100700002)(2906002)(4326008)(66476007)(66946007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DpWtcAia0oK4Jb3csNMRdWnbCqR4GN8eHXwwA0QL04TBAeF6pl5nGMcqL6Kl?=
 =?us-ascii?Q?d6T5oOzD7+aRX9g4+qE7XbmUa6xhGJ6UZKgKLtv1kbk1zCsH8zUFkITA66gA?=
 =?us-ascii?Q?4ZbAZrzR16V0/KxjtBiiC9Y47fqA3ja8n1vmF9+4+macQ3bxYLgbIu4+xB22?=
 =?us-ascii?Q?6h9DQq5IG1vzL/OSUNBIAWznOcZsXWurro6lYhgjIQObjvu296ezHiZyFM7S?=
 =?us-ascii?Q?bvME+GxBY2/jtnPK9tPWIxTjLOB5qzX4U03bVz6Wkoxv5JGqITNClv4tffJL?=
 =?us-ascii?Q?LQat4jJk/71VlQuYPyThM6jzzsWSMS20T7LpUCc844PRR/nZ4m5dNrY5l6Uj?=
 =?us-ascii?Q?DJV9Rjqt30SaLQqJWOQtZ8b3yiN3/g8HJ55CVtonFLw/g0NsGOvIbgI1nJI5?=
 =?us-ascii?Q?kNVIYWG4hHJRgqJLWjqpWfes/YEi4UpePon7Rs+at8FHwWXe9FDVU5xdIDM7?=
 =?us-ascii?Q?DNRkbewaINzKkM3ARLkUpDcykDWloO3WRyrpZbVzNqj1PGYk/nF8c3175Mq0?=
 =?us-ascii?Q?iyXj+QoRfeDk6R6bgZwEks69NoaZusLldbnh0E0rDKLu7cTpEkcAQM2E9XHL?=
 =?us-ascii?Q?CcpaJUON7Az2g3HBxZR8vno9Uys0kXHcGGAAf3hUfT+RU52FK9M6EKOyqc4Y?=
 =?us-ascii?Q?6BfYCVvAu+6L3/GjV0OmuJAyDyfkEFFsuPqAe2YgKqYvugLw7f6maodKomh1?=
 =?us-ascii?Q?+30UKR+CyNr37e+NuApWLg2FBsSg4eft6Be6vC648DVjQQ0y0MaZPsps3wm9?=
 =?us-ascii?Q?3436jIPHTRPsyLyygd+Pg2Tf79Yhx8s+dpnO0iWvEGUScn2RuX3Nh9oTaWUj?=
 =?us-ascii?Q?axV7BSEPi1cGEmhTL63V7DHR9fW7jxA6/d/k/DKbLRV0sSjp1VAVrbcbYKTg?=
 =?us-ascii?Q?bPE8hFH2vc3PtaotZ3q6Zd/VphmD6crXlR9czRLV9d1m8QZFGwykJLlm2Jea?=
 =?us-ascii?Q?pjvcz788mb3nzpcchbhxAXJoudjjhy5dVo9rRY0EQ5Q/HVHG/pnC53i19vvt?=
 =?us-ascii?Q?c6+fvnkQIfslUXG7gfG9/ARCK0uUukiMRY0+Qhn+GrE8i/uhSFUTFIZYEheO?=
 =?us-ascii?Q?ypBqSGfYQ2GPT+/EhCuCGqsFfkHL6aIut0tDCuazACpf67bSmPjSkm5zpp7W?=
 =?us-ascii?Q?3qflmwQF1DzoMkyS6o5+zHia16sUWJffYXxSvl8c9nx1oK1pOCmBxUshHFnt?=
 =?us-ascii?Q?RXVPZiYMyfiVOGMy8h4d6mgM7Wf8EurUbv1AkHVEDA8HZMserNF2M2Kaqte2?=
 =?us-ascii?Q?uTCSCMcTuH7ViDBPPyGWOx7Fj3zugkfLfqAqeKtvmDK+Ct4dSFiivrhSadYW?=
 =?us-ascii?Q?CL61D2TdCE14lb55mYGfMen2oTkaVw6eCsrCjK3cPqhtYdcM1Szt227OMxBx?=
 =?us-ascii?Q?XxS19QR/1wIKayhD+esjOQK5Q7o0Wr73J1wNe38jNaK7rbANO7Wb64JJjnS9?=
 =?us-ascii?Q?fF5jsu1wLh9jDOP2JF0lDC8ELAVB1mnbIhH5WMjgePTYk9L2ZQ7ve3ac0bOn?=
 =?us-ascii?Q?r/SrgQOg8v1K6YwGLo6AQWQy8agQj/ouskIhdn22EliO4neahmKlLiKnYqME?=
 =?us-ascii?Q?ltc+IJhHMXxtF9c7HVoRbCDxidu5Wb5TQSpeCJJ2RGo32QG/IjBvt6pQm8KU?=
 =?us-ascii?Q?KA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?736KN4UEe3eWLUCe/4l/+8sYdwHTzUXaHMQMmCdJDFcC+7z12KaTav/eQJJ1?=
 =?us-ascii?Q?peR7Z/dGeyNSQ9xVRDrxOu9AAbbIx3X2/pTgRv1p1dhEK/UNjAtkbxrre1Lq?=
 =?us-ascii?Q?5mfC7o96igL6zI4XocUpOvtqioSRjwda1nVJj3gKtaIc+bw24p9ez9pUEnph?=
 =?us-ascii?Q?ToXmQDs3xxXyN0ix7fjb7VgnKaoJzwNrxDdJHm8tAqiIKcuEy9ZYot+JbbiY?=
 =?us-ascii?Q?Co5Uh0AHfZcumrNy0qPrJroGfdWgn6LiaDTDxzTr90ruKWLxhnvxGuJlRMHV?=
 =?us-ascii?Q?A0DADLx/IbKinCcLMQsgk9O1L2zywSHiZAzMzP0ubzk5jOQAgKYBhyblFWzQ?=
 =?us-ascii?Q?vV6YHkjPaBAlVqjEdilTrHslQlsxpjk82qxKv67H7ECh/l9oNRhQ0zxukhO3?=
 =?us-ascii?Q?dj7shYUHR8fGZlY07GasvpuZym3RN3QrK7u+TZIuDMp1oBhQvLwPefoJbizj?=
 =?us-ascii?Q?bmrNN1Qt/pmNNukkJyYgoTu3P99+dEsxCOTPv2ORUJp2i7+sszj2/2iH0Hew?=
 =?us-ascii?Q?QAhurBmkwO1nm7UkyZcYgvCYxznqhW/HL3+vUjX0jOJQCwxorHQidSFqfs91?=
 =?us-ascii?Q?0NEh10AjazmT+T7ETEsIUmrRbFCMm4fpq4DCbeNuwPXbV9qxEdKFq0diZnnQ?=
 =?us-ascii?Q?o2vO1wxOa5niGZ4OvB1k65PMfkw6zhloddqdUfput6pvSEtxCMLbH0cKWPj9?=
 =?us-ascii?Q?O52AD2C2at6wIFhFTR3sRQ2eFf5J4a2Ax4494fFkQxootxpBCsGSx4B9gFjb?=
 =?us-ascii?Q?CSsh+p3z7K3uWlj4U963KaFbAJHLM1gVa5quQ3p3yLo9SAYjMgcakRd8TlUG?=
 =?us-ascii?Q?V+bNJTozecXXdiyxEuwZj9FZnJh+AICCoYoT8j7VtV6L7YI6BjY0xc46ukGU?=
 =?us-ascii?Q?/XwlUlwhWKIHTx/1f+QIxC0+6MPwRgs84KRY3I6qjTy1IIbbdbvAOOr4xNzp?=
 =?us-ascii?Q?9CTFPurH00py4p//txKl2aeUNJbtKQpT9THs5kP4nmPYuVb1oy5fADtbmA2Q?=
 =?us-ascii?Q?JooLqg04SWTOtfNYBWBm4RcYpw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bd5e6bd-b500-4a23-0bc1-08dacd8c8068
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 19:54:16.1182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0vkKjEqWIVO/fwdbt3RReK5BpNpjQmMIdr72FtT+dY7JidxWQ0d3bvqQLhoDEbe5jT32otC2vA30BNbx8Zg57g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6300
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_11,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211230147
X-Proofpoint-GUID: yOzyaioO4GvBuckF64dTkjCHXxmYYQIK
X-Proofpoint-ORIG-GUID: yOzyaioO4GvBuckF64dTkjCHXxmYYQIK
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>

commit 4966455d9100236fd6dd72b0cd00818435fdb25d upstream.

Currently hwpoison doesn't handle non-anonymous THP, but since v4.8 THP
support for tmpfs and read-only file cache has been added.  They could
be offlined by split THP, just like anonymous THP.

Link: https://lkml.kernel.org/r/20211020210755.23964-7-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/memory-failure.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 0f77ec1985dc..1d37de089008 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1154,14 +1154,11 @@ static int identify_page_state(unsigned long pfn, struct page *p,
 static int try_to_split_thp_page(struct page *page, const char *msg)
 {
 	lock_page(page);
-	if (!PageAnon(page) || unlikely(split_huge_page(page))) {
+	if (unlikely(split_huge_page(page))) {
 		unsigned long pfn = page_to_pfn(page);
 
 		unlock_page(page);
-		if (!PageAnon(page))
-			pr_info("%s: %#lx: non anonymous thp\n", msg, pfn);
-		else
-			pr_info("%s: %#lx: thp split failed\n", msg, pfn);
+		pr_info("%s: %#lx: thp split failed\n", msg, pfn);
 		put_page(page);
 		return -EBUSY;
 	}
-- 
2.38.1

