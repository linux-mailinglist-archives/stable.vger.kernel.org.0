Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08E93C790B
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 23:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbhGMVkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 17:40:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47240 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230376AbhGMVkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 17:40:49 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DLUpsL020608;
        Tue, 13 Jul 2021 21:37:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=hsMM+xue26ryAcUpHiUy1q1WH3H67W8YksugV5y4bGY=;
 b=JNuNTb+Tuax4p8q2Bj6eBvRRro/BUpUNq+mI+uOPBazLhrsolkFpnh1NX4u8cvlFrbdn
 h4jJaKVZt4ldXRWIKD86CE5e5XcSjAmxkT8b8dhKWlwrwwb+GLVd0kzJRYxpQU1MHltc
 1UEc8+yB90R0cCyttFU5xmXgGWa6A01FOEg4qLwwFgVZ8pFVfZN7hUIyZOVKJepK7K1U
 WcDYXHSGDQuvzFrlbOETci0B85JeTyRX1tdfMV+nu0eAu81haMBHNKAfvvDLU29ErfxX
 rF/3AkoUVBnIcXqOMgU/8F+cupREfA0CslmgjH3sZmYu3Ox9waKVb2ZDrNdr+AEW+wqO kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rpd8umjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 21:37:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16DLUvrp023708;
        Tue, 13 Jul 2021 21:37:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 39qnb0q60m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 21:37:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TT97m1VGqPMLcehsyhAXPVU005rlW1xwVsRGWjAb1fzGlLoTtMgfyHbvbfnNJZYQ8QW8CpPn2C3PePLg6P8im8N29cskG7XXYqy3n40wSd2ZWVUOF1afWAZnHg0nuVisay7CDDw3IPkQUIVrSuE4yCPPjvJzOGzn3PMjrZl59RXsKQU/Xt0hH1DSRzd1aV5N/HGxt2/dhTxKGjl1bSL+gb19L/QXpwWD8Z8VxrKvDwlBqtEq5/lfPEQa3FAnIzeHprQ7s9gw5/F2XHOeQhLsiuyhIMiOBhK/SWuen5SdrAKET0VjjMaeoim1A7fbLAkaKiBhzahQdaY5xQeZcNKCMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsMM+xue26ryAcUpHiUy1q1WH3H67W8YksugV5y4bGY=;
 b=TnEUInJCnOMYPKN7EToj0Yz7R394Yz+snqoScnXxC4RXiwZEDkHuVuEwxAsuehrabk0it0CWE+1P5qsmao9zWbtop9K5eXGeZd3J3hjBZ1hGVBRFbR/myoiD7+yD29C0VTyKXhGR2x3SmtJE/uPsr8SQIcBJxV/opKjPIxPwb8fKkWDinANPHZY71wJXCghryP6ckJaKW30218jtCuuXfEMQF7Ej0ymqXWU8ZTGEkM45kKAmqgJk1OJQs5fJqTROZ9qPgGzbbSDCs9Eb7U5T3NK4P3IbJNR9Usto/rJSMTBKrg7BL0WekHKzTFibvt5Qpxoq+Gr/vMfc4TiaRhjo4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsMM+xue26ryAcUpHiUy1q1WH3H67W8YksugV5y4bGY=;
 b=PHuJcdlzQ1O2GFQHERTzrD2p7EM6zvavR8bCqaqOxZab/znH/K5IP8EmqXccnd2S3aEKyR86UjAnKB884gvmnMIhMvMNEDczmi554rheeEyYgin3BWTZS8TKZ8/aE1NktHAebOp5+zk4zY1tWdJSTToo9pzMOBjcxb16okLyYNo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB4415.namprd10.prod.outlook.com (2603:10b6:a03:2dc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Tue, 13 Jul
 2021 21:37:31 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a%5]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 21:37:31 +0000
Subject: Re: [PATCH 5.12 669/700] hugetlb: address ref count racing in
 prep_compound_gigantic_page
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Youquan Song <youquan.song@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, John Hubbard <jhubbard@nvidia.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
References: <20210712060924.797321836@linuxfoundation.org>
 <20210712061047.079512160@linuxfoundation.org>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <c393870b-1f17-7980-36fb-a13deedfafd7@oracle.com>
Date:   Tue, 13 Jul 2021 14:37:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <20210712061047.079512160@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0370.namprd04.prod.outlook.com
 (2603:10b6:303:81::15) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MW4PR04CA0370.namprd04.prod.outlook.com (2603:10b6:303:81::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21 via Frontend Transport; Tue, 13 Jul 2021 21:37:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bc23d21-c2be-4d09-7af7-08d946466b6c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4415:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4415EB2CB5816B19AE7E18DEE2149@SJ0PR10MB4415.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: snXsWslSk0qzKEtSxpZjsXcOwSGxHWdrb37WEcczWV4vefzHQGBGErWRt7vcNaimm4jXc68T9iBirJki4UvGGgC/k+FCtuZMDkWoEwkjQG2JEQ3il65pimFe915uk8wsLr2Tr+W2wcaWOE+eEZD1iAX3HlQt9hVT9vGR7ASmH1w/AWpazUJ4o1TLGIHbgEODQ/x0O0IFle9sEGN+2045HMfJ4GUfbx2Bz1W9QR7jvyWxlxDmNFwbDDI2vHpNGCP2C5P4zW+doa17UGF3xb/6v7TbKSbBlhapfO6ZEwsq5OvIbMIM63Bd0tJZ/7xqFZ+YXmkarmlyFvGjAwVzSeVt/v4V75OTDKcxuNG10G2Kk6EjIJ9+zdEgj7uOI/4WxltEumiDuNIwS4kesGd+D8Ucs7ES1kK5T1MER0lBGcPg3TPcuJEF+z151h9+CmFPgzlTpyhaQLUu9Jyq4k8c2cLyJWGaRo9Uk2pPi3TAXdZfw63mBEgGvnXlKOg40J2DruXT9dOapQqb5jANI+7wlzxjkQpH7NkTS610zigDjpWV/e8PoVr5uAYcF8LFEYNvaL/51vQGeEmvlx+G5ViTVWh8KmI0kr+W4TwBosvMGDbuZUiyfN8xQvhm8dSKni7So166qX8KI9l9vUTBS7WHylfxszMiMGJaxAsadHecuddaczmYUqkkUv1DZ5diucwpan2aaSNi9VXKJmcL31cQJcDxf9wCnM0VHufUrSRdAGU2QyzLoH4GbRyNLwVsEe8Mrs/vsNhoaH3MPgN567afJ1BQZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(346002)(396003)(366004)(186003)(5660300002)(26005)(16576012)(31696002)(44832011)(83380400001)(53546011)(316002)(7416002)(8936002)(54906003)(31686004)(2616005)(956004)(52116002)(38350700002)(86362001)(38100700002)(4326008)(2906002)(6486002)(66946007)(66556008)(36756003)(66476007)(8676002)(478600001)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXJ0T2NQSnRqYXJnOVo1bUx3R1lVNVBOblp2S3dlMHFjM0tpQ28yTkNZMlFQ?=
 =?utf-8?B?ZDNQNW5zdzdLMlE5OVhsWXZLMEprb0MyOVVTZDN2bkFUWlhlanlGL2ljd0NZ?=
 =?utf-8?B?WXhTcVErN3BjbDM1VStTTVF1U1pSbEUvWkNGa3VxSGdmN3JSUnFqTHBITklC?=
 =?utf-8?B?SjRZWEttZXZTQW5CRWpTa2lxWXhJNGhubUl4YkZxZEQvaFdma1NxbnhJNGlH?=
 =?utf-8?B?bnFtNVFPbU42QUJVd3VkQ2UzRVNRZE5Yc0xjcy9FVStaOTlCU3h4TjNyU05Q?=
 =?utf-8?B?WHNJRm4zKzlLc21sbnc5RUtKN3M0aXErb1dwWW5ncGlrRFRPWldyWk1GaHVK?=
 =?utf-8?B?SHNYWWlvbE42Nlg2SU9XSUJsUHFIdWVhdHp5b1l3MnF4ZTYxMnc3c01Cemlx?=
 =?utf-8?B?Zy92YUN4UWVETXFXa2FZZFVVU1BFNVBpeHR5NnhqZDB0UjU4cTJHZjlYcXZR?=
 =?utf-8?B?RExJYmlaOTNROFJtSnBVNzZaejlFNEsxeFlkOHZTNFNyeGZtbU5xcm1uRk5L?=
 =?utf-8?B?c3czOVZXQklPMG95cnZYZEk2VEU3K1lqTDBKVndVaFVnekU1RFZmaFMxWkVY?=
 =?utf-8?B?MThJMnQyUjdCallKWml1dTRORVcrbkNhOVVwQzIvTkNLQnI1cDJXdzYwcTJw?=
 =?utf-8?B?d2ZGcVRLTmV0UVgrQ1R1ZzRROWlaYnFHZ3E4VU1Mdnd1RnFab2I5LytTNWFU?=
 =?utf-8?B?Rm5NU0hJMzZRWElhRDUvaVp0YmZxTWlmZzRoaFBibGppU1NublRHWWQzcXVI?=
 =?utf-8?B?YVVwcmlrVEdvaTNqaEFqWFRIM2IyUmpQTE9YNVpZRW9LTWRsZTlaM04yQ3Zp?=
 =?utf-8?B?TFN3WUVUeVdBQzVFQndmVXJHVWp6dVJCcmxTZ0VHdm05VjFtcTFYVFd1aS84?=
 =?utf-8?B?VncrU3JWRmZibG1ZMEtOUm5QTTAxU3laY3dVZG45M1YrUW9VZWExeWdFY3RW?=
 =?utf-8?B?c2tueXpabC8wWFZGSXd6Rjc3MVA3dzRRU0ZpSTVleFp2VmFtUGZEUUw3V0lP?=
 =?utf-8?B?c2xpRHZkT1NGWW5MOUd2cVZ6SUZHeUZYc3VTZ04wNkdJbWMrRFppditSZ1Z3?=
 =?utf-8?B?dGpILzA3dFJWVFFEY2pHWlp2VmEyc0V5VndEOFpOQng5K1pFd2sxdUYyWGJl?=
 =?utf-8?B?T25wbFlDT3UxYm1EcGhCaUFvaFgyUkd3R0V2d2M3UzJSVEd1bDUycWk3THVP?=
 =?utf-8?B?VUZjaDltcDlxZlN1Z2MvQzg2OGJjeVJrVzA0L2V0aHdSbXV0b3dYeTlkZ0Z4?=
 =?utf-8?B?VlV2ZGQwdzkySXljOHl5QXZtNzliZkEzY2ptNmtRZ1ZZUk1seXNHaEpjS3B2?=
 =?utf-8?B?cjFmVFBVZWN0SXpqWmVUMVRocmJaeTJZbHJuK050dUdQM2lpU0dRa1VPZlEy?=
 =?utf-8?B?UUh3Z2dpcDRRaFAxc1p2b29jVnJCZXEvbGo1NHJleTU3b1lhc29zL0RNWjY2?=
 =?utf-8?B?MTRqZWt4QitFelEweHIrbDF1eHJBWS9uTGEvbG04bVhZM2dJTWNkOEU1cDli?=
 =?utf-8?B?Qnd3LzRNYWtwaHVWWHVScllYdFlucVNKRkhkOTFEOC9Cck5WSmsxTU1LaVZK?=
 =?utf-8?B?enNrRFZVb0psVm5jcHl0RXJodjdicFdYRk1jZU1pRjd5aE9XM3hZN2pCeUFU?=
 =?utf-8?B?UFdQTm1kUUZPem5sZnMvRmlqZ2pMd3dUVHZ6WjhFLzZISWhNcFJsbUVtQTJw?=
 =?utf-8?B?NjJBUW5WdXZJNVZBdStqUk1BYVd2L1dNa2JtOWtvYks2SFBiaEIyNXA5Nkpt?=
 =?utf-8?Q?Ta3uGcpmpk940GHgr9EA8Rw8cOc73LLI3Kw4GSa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc23d21-c2be-4d09-7af7-08d946466b6c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 21:37:31.5792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4nLJMvhysE8Iwdv0eZCf8HXCI3S6eJFSOn4A3XixE5ESMzj+cLkTB77DMjoXorV7HaxbZRLglkfv33r7l3lsxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4415
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107130132
X-Proofpoint-GUID: Rkn9_DgWjqHBbsnxst59TVwodWq0kvom
X-Proofpoint-ORIG-GUID: Rkn9_DgWjqHBbsnxst59TVwodWq0kvom
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/21 11:12 PM, Greg Kroah-Hartman wrote:
> From: Mike Kravetz <mike.kravetz@oracle.com>
> 
> [ Upstream commit 7118fc2906e2925d7edb5ed9c8a57f2a5f23b849 ]
> 

Please do not add or the requisite patch to stable tree.

Although this is a real potential issue, it was only found during code
inspection.  It has existed for more than 10 years and I am unaware of
anyone hitting this in actual use.  In addition, this proposed fix will
likely be updated/simplified based on more discussions.
-- 
Mike Kravetz
