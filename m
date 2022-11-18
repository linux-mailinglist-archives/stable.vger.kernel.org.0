Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38AE462FF7D
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 22:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiKRVok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 16:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiKRVoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 16:44:39 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A8565E4A
        for <stable@vger.kernel.org>; Fri, 18 Nov 2022 13:44:36 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AILNpLA028196;
        Fri, 18 Nov 2022 21:44:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=ZI7jrtNufRCrmQP4UjwK6apNVzf+KzL2ANhASaZJy+8=;
 b=MVNoz7kiJfdYjz2aAWjFFtoi9izle//39jDAZdDNP0kTAArOQr32Hix7BHzx9b3KmVKF
 ZUvsWaErI+hiWmc8jZGMcAzXT7i/Qq3+WqRO2vfxSc0UngndpOiZVPCq0/B2ScpXYJO1
 emKMjN/KiUynUxuMizYhiur0AlMbZSDj6ScF6+jYb5+Q8deUJ5jKCC8f23eDwI2Lj775
 xnjqe5JMDNv2D8Q2amH5lojKTS4fT6PzaD2sSP+u0UAMgsSfVuGU2WeOJr0ftIji/c+I
 OVcOhvg88vzdR3NCrxGWFZXEDTwa/eZXN2UK9NDLNbQiaRI4RUy4PLJadvXl9XgPDogL 5Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxh4585r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Nov 2022 21:44:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AIKeQCl023292;
        Fri, 18 Nov 2022 21:44:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xb3j5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Nov 2022 21:44:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsUSzfdlWTP+rsezt8yGIVYQ0sVusQAiQ2KT4EqFGqkZUFiM8AU0xOxVWtWzxJ5A5k5i2q6GW+b+GcJRBjNdnOLKtrGfW5a7HWmOSteVE/B3vb+lJ9oWPa22QwAw2r+tX/O/SXyG2LBYd80WUuey29ML8fSCMTPCTRikMgDc0PAuPUTXRZ09iCvuEmtmo0VNFJLDWKQh39qAV99rTKZE+3zBMjeivWNawXUAyZt0VQJ8Yzsv5wTRCw84VAzUbtOJae8D+vB6bZJj6ICJxrFt8QrihrIYi01OuDI4c34ly3DyMMxZo5UVe4KkNEmkLDi07PZ+ho1955qi3u6g2lz2Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZI7jrtNufRCrmQP4UjwK6apNVzf+KzL2ANhASaZJy+8=;
 b=Ovn+TTybz/t+NFRzAW71ayvHvyrZNx5Ojb8bXUx/UV86o8n8iZ8XJf7Waj9tX2lPVb0TMlgDLgIoJhMrn+tuhLdguMkzodQxKEVzm8ELSPqD6e6Roz9F7WCy/bKqrtkqK7vPBb8Edu+AsfAhGRHLx8SqJqu4LA6TLRgs9kuUsIT5PpLy3Nodg5f3WG2WSQRn0X3RBs3lnRugvPKM+LwPLTlX0Ij48zU5WccI94ww22Tov3DEHFlsHgWoh8+kC5ATB3A0bncZ+RwLqlJruvMBWdL7d0bvcjKhL5jPvwrg89foBD9WEqyNzsQdDvv3POp9x9rKRRLM7wZqyW3mcM+q7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZI7jrtNufRCrmQP4UjwK6apNVzf+KzL2ANhASaZJy+8=;
 b=uoWLlKO4ODSxCB8uIDS9S13g/Gov3PgEg9S/9lM6xpzwWKgFgPvp7rPN9wFpVcnBOdhQqF0G29rmjvKtybZt8lWsyrQaKHFZTQ6+crQxobSBmhWkFvXoPS+3xBQisXJbo2EuzpEohDUYtfgq5+P0x7smcM/2QrJx22qIE/QjIK0=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by DM6PR10MB4393.namprd10.prod.outlook.com (2603:10b6:5:223::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Fri, 18 Nov
 2022 21:44:21 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5813.020; Fri, 18 Nov 2022
 21:44:21 +0000
Date:   Fri, 18 Nov 2022 13:44:18 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     jthoughton@google.com, akpm@linux-foundation.org,
        axelrasmussen@google.com, linmiaohe@huawei.com,
        naoya.horiguchi@nec.com, shy828301@gmail.com,
        songmuchun@bytedance.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] hugetlbfs: don't delete error page from
 pagecache" failed to apply to 6.0-stable tree
Message-ID: <Y3f8spPtwzNCFyte@monkey>
References: <166842203040114@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166842203040114@kroah.com>
X-ClientProxiedBy: MW4PR04CA0077.namprd04.prod.outlook.com
 (2603:10b6:303:6b::22) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|DM6PR10MB4393:EE_
X-MS-Office365-Filtering-Correlation-Id: b5e4081d-9754-4b34-f32e-08dac9ae0d53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: URIvvzgdni8KU35cXBIlWfm4HOy9L38m2Er+1saaL2XhZ10GtrvCI7PmN0UPQytMmmZN6lbOsgEkB1y1cg2V1CEs01If6fdIUkShWJk8MkusmnWNxZAjm8Z/mYyeXcW6PJs429iQqcFX4PzqLfKaha/bCLhHPm0RcF8Bn43YLTxfbVOH5ZFni2VvNjOmjsETDuOXaYLkCPa3R+pktPtEc47cqcPgWcVp31Bx8NT3vJYlWK4hkaTLc73ho2eEpGL8Opjf4gLhUiNCgQcjIMtlVzaQLlTl8cdWapIry1bS69L5zWzT2pQVfzFJTr6Wq5btUqiXupGBLZGr1GC0Jvfy4MmDMedMWlTv0RHIc4uK90/sNJ/oZptCrst4DWNOXExw/RIMaG2/XABtr43AaZ9/Sro9OaiC7CYZ+s2ixV1KihKgDxOTg8vHQ8BNyXRaR01MlYnXknASEtbY7WcltlLe9cAwII7xGxz+HdtSEALv5b1u3qfUjE2XdKJjONbI21jy1quPbsBFjdhaj3R8SVdhuqrYpptVsqGW0MCHpGxsF6hXcsRaCs1LR1XClbsbaHYYKba8MYWqQFpdyGJNnsZoKGTMoZNVD/r+MzvryLspNBsJxAJgQ2sI5KNNx5qe0WAQUs4rzwWCKqRJw+Sp88jcRL5pF79oxlNEstmb9GatduQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199015)(83380400001)(66946007)(6916009)(38100700002)(86362001)(4326008)(8936002)(2906002)(5660300002)(33716001)(8676002)(66476007)(41300700001)(6512007)(44832011)(6666004)(26005)(9686003)(53546011)(6506007)(316002)(186003)(66556008)(6486002)(478600001)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Nqn/YgyArA3snSrS1ICRfs/CRR2NgEc+eYC9h/ieU/SIrmrZnKSDFjqxd04?=
 =?us-ascii?Q?mv85IVJ3WTSbpC8UmmgUjtDe5o4tnMPn0yrsHfpZVy+apWMstIx5I27I2RAk?=
 =?us-ascii?Q?jioSwEazo0XBRqGzV2HBAi20AR2YuDuOc14IF88Nb+SltaFkEOvn0uSvJGF2?=
 =?us-ascii?Q?GL9FfztqKdt4V+JIm6bxUxKl965qSYJ0PNam3SvghtAYLXhKmvu0Xlhnr9fo?=
 =?us-ascii?Q?cFP6txVafewOLpKzwf+LCU5Z0YrPbJ/iP8hO/AiE88L64wIxFHVlKfgoeHKL?=
 =?us-ascii?Q?sbFwpw8KRIUvMXD2+nuWeIp3elOG3RgBJs+tDugaXgZ9DGtd5nLOMXH0+kWr?=
 =?us-ascii?Q?I0NY21X4HZlLMubvbm+4hqJP2xxRyTgJgO+B1wMLfrXbqFfiybrkQ7Le9UIg?=
 =?us-ascii?Q?V+lWLKqFVHS3xbUEpSL1BxCWmVM06JPAxiavvOYUFjCfA5mtpBpKzejRTRQo?=
 =?us-ascii?Q?MkmDEWSsOcRIj96lZ7BLotTSAg77Vq0PLZPeJHEYhaJgrRQh9U4g3g/ZHR9l?=
 =?us-ascii?Q?eL0xd9TeLrJXEwa3t5SrfVzHO5erPGaiGd86h0gvaqDXI5Oe1ra+lJlq92u+?=
 =?us-ascii?Q?im27TEG9aUdz/YvlLJe37DZ45xK6nBPniZ6VrLHGDB0FfuhoY3DWxC/A4QaJ?=
 =?us-ascii?Q?jA+vOQYIwHZXoz9JGyAhJdoakDWtHg6hIs2otBgy08bmHnC0tMiNyyEJUkCH?=
 =?us-ascii?Q?PVN31KynDWtjOhHO7spVxuAuYqwG8p0Uv/5pOxqFGtgzJFSyl6dKBGXHLp+J?=
 =?us-ascii?Q?JvqAVGaMCBM8uJZVESEaWGjln8ERS3tLqYclAJJ/DjJ6huCEooAEp2c/yLpr?=
 =?us-ascii?Q?4eIiralv5vGlTx5UMk1IvRh06vxziEIgaPcb0rpZLsFZByh+5IlQVx7VswZX?=
 =?us-ascii?Q?BBxLxajYCRZjLfDUX/D9Tyz+9UUXiYQnCrK2FhRKXjmJOolpito8+NFI+9n3?=
 =?us-ascii?Q?icIS3bgffxG5NLb4MXHf3CskLSJJi0wV3J3Gsf6jeGC1HWAEYdkKEhAUtQfe?=
 =?us-ascii?Q?6xgh3Zfu8KyKAS5RRYFHfajBhtVTOLbQMm7RhaNGlPT3i4lUZSmbdCp++BCQ?=
 =?us-ascii?Q?kGPUY9Mq+tweBqs/SBsPKd6HIQR+WzUU0BCA9ArXmgd1qiOJqYJNj3xcgDBL?=
 =?us-ascii?Q?V0TfOBKMgt+D1dWUW96q0Gg7YYCSN9s3i0X9x8QCdhowEFrLsJHnbdQm7B0K?=
 =?us-ascii?Q?NVt+j4IJcGfUmi4USSfJMSckLyFpdarD4OBApYmj3pemIPVksf06kmDB0dek?=
 =?us-ascii?Q?PmOhfji9iunopnIMo2hVNxeWsVTOSE3FnE9K2kQIlOBIa0N/cvXSQDgK975V?=
 =?us-ascii?Q?ERYtxIo9eiEIUscEO95orA3cEKwDHTzjJ0qmPd5NPRb2aOhsL9LtAGahUprt?=
 =?us-ascii?Q?Nw+nHal5hLDXOMiEbXRVxvJxjHF9ROp0d8AkQlQ+h/dwKOKrnklxpB9YxdFy?=
 =?us-ascii?Q?C2P9VYm3ApWf8xGVQO0RP4YoQq5JX11ISjKREoEmr1/0efM0XbWuuqn6In/v?=
 =?us-ascii?Q?81DGxz3uA90MNEczIpfzqiylrS+rHJP1HwtCrrA+jfbl3NN7ZO8Bi483wdEB?=
 =?us-ascii?Q?sKW/DvbWQevn9C+YbbN9/S2NBFhu7/JzD4DY+rZ7wGJ2cswuujMtvy5aAThp?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?jR5E+PbnRH5KhBU85rzA0MQ4p/rkxHIPM2huNJl2s5Hg3uRuB++D0ixbc492?=
 =?us-ascii?Q?mkbenMgvEZcPhbgdCHxd7+6rUxf7ffwpZe5IfJxyDPTQzqcE+LfQ6YWNYQsB?=
 =?us-ascii?Q?HDPy9P+C0LtL9IsIWf7PI3M/zGXBAW3jv/9slmOlQEiUA/sIlavGxHaD9TW5?=
 =?us-ascii?Q?zFB/pAx1wP2XmxoCzFEzji7VP51s2E152AMCeoUwRKe9IsmRKbHxo8cW7fPo?=
 =?us-ascii?Q?5eoXKh9ZcWOSJTaXyFzTDOVOnXgd28jPgvriWCJtbt7xNWVtGqfq7BeKzhmI?=
 =?us-ascii?Q?/AGNwqPDCmmJG6xhkDTTo4/sUZ9Jt9o+EUcYeHQVJGo/WDcHB5GqIXPL3SWZ?=
 =?us-ascii?Q?4kBX6MfxZw91kCQaTL5LA2Uib6oOE0lUZJgKU5q9IfE0naqVv9VEdlsVWkoN?=
 =?us-ascii?Q?58F3i35JpO/vxMZfj/qvas1+GUnAN0D6E3OgY6WLtI0fwacfueztalGfu/Mh?=
 =?us-ascii?Q?abMO5+ngu5RGTYBh20Ogfhx0/2Nw1KcTYjzHuDKMiVkY7ic73qPA5TT3XmSm?=
 =?us-ascii?Q?S9INiEIgtn+81QEJSov7tsu1WJ9YlwuE9NqmGk07gzNlOm2s0TS6NwjUpvrm?=
 =?us-ascii?Q?8mAAPGgwTNKJLNetc7M0iatzNLsQwWU7RWZZJR5ioQ2GcFSYrkrqUmpBVR4U?=
 =?us-ascii?Q?A1a1K6VUxENSE/nkJdrdlCVnyJYOfqVi13gHvdh9IdNL5PmQvHqvwql1XEcG?=
 =?us-ascii?Q?sNYJC/9kgsQUBb4FEl83dHHERFo2ssQs02kOMrb9Bq68uNSH3SDzmfm+NTTM?=
 =?us-ascii?Q?D+yvBeaviE0Ib34wgEeqp/zONho0dMRBIVYMioG25+z3E7VT3P1Cys0CefGK?=
 =?us-ascii?Q?aRSiNsHfvqUYsxb8Jefp40IpWpVC4kbEg/4B3OKU/4DDeFGtqao7aFvrsBTY?=
 =?us-ascii?Q?93A1i2IhLYwbh9DA8udEIULOX18vwHVtqBhaBIkvqX5WVWcekCPR4A5Ac/46?=
 =?us-ascii?Q?e6xNZ6hSXXisfctrJuskUhNkoOEd1+L4V++HsRBbQi3+Gf8EgbBh970ez40H?=
 =?us-ascii?Q?iXGN6VQ+kGTiR3FE3fTbZzcyMw886tjzsQLgKsRyilKh3xk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e4081d-9754-4b34-f32e-08dac9ae0d53
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 21:44:21.4100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2pOXgjdPaWxnzbR39bi0adSzxlwUSsaSMB0kFXTyz3KRbtof6i8k8gf9m3/WR6c5qKzz3EqzK2V5eysfUJy1NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4393
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-18_08,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211180129
X-Proofpoint-ORIG-GUID: VOqJbQinoOwDlCVxRkx1JGpIpkxVXfdw
X-Proofpoint-GUID: VOqJbQinoOwDlCVxRkx1JGpIpkxVXfdw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/14/22 11:33, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.0-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Below is backport for 6.0-stable.  Only minor conflicts in code that is being
removed by this patch.  Tested with simple program to access hugetlb pagecache
page after poisoning.

From 5dcd97ae1a0848c1b9a1ec5f4ab623b1ab478892 Mon Sep 17 00:00:00 2001
From: James Houghton <jthoughton@google.com>
Date: Tue, 18 Oct 2022 20:01:25 +0000
Subject: [PATCH] hugetlbfs: don't delete error page from pagecache

commit 8625147cafaa9ba74713d682f5185eb62cb2aedb upstream.

This change is very similar to the change that was made for shmem [1], and
it solves the same problem but for HugeTLBFS instead.

Currently, when poison is found in a HugeTLB page, the page is removed
from the page cache.  That means that attempting to map or read that
hugepage in the future will result in a new hugepage being allocated
instead of notifying the user that the page was poisoned.  As [1] states,
this is effectively memory corruption.

The fix is to leave the page in the page cache.  If the user attempts to
use a poisoned HugeTLB page with a syscall, the syscall will fail with
EIO, the same error code that shmem uses.  For attempts to map the page,
the thread will get a BUS_MCEERR_AR SIGBUS.

[1]: commit a76054266661 ("mm: shmem: don't truncate page if memory failure happens")

Link: https://lkml.kernel.org/r/20221018200125.848471-1-jthoughton@google.com
Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Tested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 fs/hugetlbfs/inode.c | 13 ++++++-------
 mm/hugetlb.c         |  4 ++++
 mm/memory-failure.c  |  5 ++++-
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index f7a5b5124d8a..398f8702c34f 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -328,6 +328,12 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		} else {
 			unlock_page(page);
 
+			if (PageHWPoison(page)) {
+				put_page(page);
+				retval = -EIO;
+				break;
+			}
+
 			/*
 			 * We have the page, copy it to user space buffer.
 			 */
@@ -991,13 +997,6 @@ static int hugetlbfs_migrate_folio(struct address_space *mapping,
 static int hugetlbfs_error_remove_page(struct address_space *mapping,
 				struct page *page)
 {
-	struct inode *inode = mapping->host;
-	pgoff_t index = page->index;
-
-	remove_huge_page(page);
-	if (unlikely(hugetlb_unreserve_pages(inode, index, index + 1, 1)))
-		hugetlb_fix_reserve_counts(inode);
-
 	return 0;
 }
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ecc197d24efb..590ba2bf033d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6021,6 +6021,10 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
 	spin_lock(ptl);
 
+	ret = -EIO;
+	if (PageHWPoison(page))
+		goto out_release_unlock;
+
 	/*
 	 * Recheck the i_size after holding PT lock to make sure not
 	 * to leave any page mapped (as page_mapped()) beyond the end
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e7ac570dda75..4d302f6b02fc 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1079,6 +1079,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 	int res;
 	struct page *hpage = compound_head(p);
 	struct address_space *mapping;
+	bool extra_pins = false;
 
 	if (!PageHuge(hpage))
 		return MF_DELAYED;
@@ -1086,6 +1087,8 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 	mapping = page_mapping(hpage);
 	if (mapping) {
 		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
+		/* The page is kept in page cache. */
+		extra_pins = true;
 		unlock_page(hpage);
 	} else {
 		unlock_page(hpage);
@@ -1103,7 +1106,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		}
 	}
 
-	if (has_extra_refcount(ps, p, false))
+	if (has_extra_refcount(ps, p, extra_pins))
 		res = MF_FAILED;
 
 	return res;
-- 
2.38.1


