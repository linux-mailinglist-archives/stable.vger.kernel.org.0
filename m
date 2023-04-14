Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2036E2C6B
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 00:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjDNWUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 18:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjDNWUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 18:20:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8657440F1;
        Fri, 14 Apr 2023 15:20:00 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33EGuljv009264;
        Fri, 14 Apr 2023 22:19:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=9pn59BZEB65jSgwyUBOb4lYASBn5tO/e63yPQxa48Ac=;
 b=hwIe1MfEYFkbz1Udz8tpWciXV9/3MyD1udiXKTcTnMbjoF1GhggwAMPdmNZgYvcUykFr
 BzepDlwXS7HEi7Iisjy8QlyvjcNS8aEBROH7wk+S/2+WqzUP3YvQc86QHpvezCTqNUbF
 uOH5Su2z/VecUpeyXZRcIst76OvTqLL8iQNS5oBo6Dd22MWd6GcGajH7YmRUlzM8/DUh
 VQ+aCDLWY41m+Hd1JCY57FZM8lDOySXcpg1JgLuEEZFu8gtZLTXXkQQJeI/6L4hlx8wr
 HaSPsP0XMR0t7b4LhUrnElSRfnuJHViftNMdKByclFrtk2STfdjJYvFTW06mwyYxo9tV NQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0eqf3nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 22:19:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33EKXLZn040378;
        Fri, 14 Apr 2023 22:19:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw8cdtjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 22:19:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+zA85L8FPKpwrwSie8KQ/wIopmBWtmZKe5ODfMacqQplnwU92Xvxkr5zH3Q9KSUKmt21Gjmgr7xhpCmqAgZykzeovgT24hbro3CPrDoIIp7QNNIt3F2Mqc6rbCgreSj6erT08sGcCOJn3dM9Q42opLFwCWfjzyGaC2z6Co7eq3oA7tT9/MTm5SCgG5jY7WGVKzOeo/IfPUBliiuHAdr+DJskorYP9atJQniLNBvsMzQTf6iu0neDi0rKJS3Cuv47wXSNpCzoLGj2VvDESO1TVzmeC245XwG9Oy5ZbcZ7J+RNp8YawUUvqiZtXy+Hdrzxs0Vkpy+mKb4/MJw5LfqcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9pn59BZEB65jSgwyUBOb4lYASBn5tO/e63yPQxa48Ac=;
 b=NuAgsuOdJxJTmnlfPhd+JsJTtUdY4DOcgWB9Js5nXUUF+OKJOr6KGKOIZMkdAnp7+9ZyjP28s34LLpK/avkH9OJ4TOVcsV+q1jHaqJQisoCc4dhqJRPf23sDuR4WcyciJ4a6ob52WZ9vV3e3fhZPN+79mH5Z8SOsCXU3gVHO/8AsFDW0hLAQWeVAjwh3iEZ+T6ayj9oq1x5I/2lBjV0aU2u9wuFxvYPWxa4I3NiDEif04qIS8+kc/XQvI24vehSHotA6skrFU4PEpQYE7u00eOCPFHX+xJNQhuDayGPWMDH0xgGSRSmUwf9uvtuomXkAnB2prGgDjK9v8rWWhDdtAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9pn59BZEB65jSgwyUBOb4lYASBn5tO/e63yPQxa48Ac=;
 b=roeg/FGNGQt2tKY9QygwdPBXNk8MvySSRtS70fjPZLe9VyiOMpUYWNTgI7/iv8+5tXnZnU5OW+OGI6DQaMsmdk05NhhGPyh0E7DKfglJez7n5eqbwCs24US3xNAo+atd9j/lzB7z1R8hYr6Lh6YEZV2dBvnOKjOgkUi2szq4GG4=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CH3PR10MB7330.namprd10.prod.outlook.com (2603:10b6:610:12f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 22:19:49 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::ffb:de39:b76b:52eb]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::ffb:de39:b76b:52eb%3]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 22:19:48 +0000
Date:   Fri, 14 Apr 2023 15:19:45 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/6] mm/hugetlb: Fix uffd-wp bit lost when unsharing
 happens
Message-ID: <20230414221945.GB54118@monkey>
References: <20230413231120.544685-1-peterx@redhat.com>
 <20230413231120.544685-3-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413231120.544685-3-peterx@redhat.com>
X-ClientProxiedBy: MW4P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::19) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CH3PR10MB7330:EE_
X-MS-Office365-Filtering-Correlation-Id: e718a53f-efd7-4e9c-5df4-08db3d365c2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5yzgvxaMpGEFMHxM9ie/H2FmiE2TIgFKdaDv5AcAnN7oZxZ5JXh//uCphMw6H91p0JVrHPY7Q6H7FWyTt1zhbS2pn4ha4Ou67UXEzS6VABZGbb9+ao22h7JnaIRJVegmGVnAp6SHw01TxEUMzcoZiMKBddwZYXmFQrvcFWKCeeG6YZ9PWzhdVBx2u/e5fwO0yyHhbsqEiqRsVHxiiClWVIceyEtDu0YlW9i3jEZraPCCmpVoF5tDgI6ekttMHkorVHGClN5Bkc/vfm5bnQfrs7QxQLuXP/IOsde29SElTcVXCIsV6yrxMg+9y606WcRAXk7L4u8/Jga7ncQaESkKnWs0ZCIxcsBtvkwegNNzRTGDfEGbpuj/QIaKWKC4czvoyYWTpSRj8zczs37w9JmZ0vdeNQKTmNaSJ/hzBo7b/tC4cylfVd8RAfM0JgFIuWQye/A4lII/SMIkYqLCLoBRkti1xA3MuH5KQnH38a4oJYBttpZd06o6lygtabY/WqIH9ssW6KVdetGpil1ad6zRsrl+3DRI7lA61SvDwE7XQz67lFG7u1QGTMtlmYNWuM2i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(39860400002)(366004)(346002)(376002)(396003)(451199021)(5660300002)(8936002)(478600001)(54906003)(6666004)(6916009)(41300700001)(83380400001)(8676002)(44832011)(4326008)(66556008)(6486002)(66946007)(66476007)(316002)(9686003)(6506007)(6512007)(1076003)(186003)(53546011)(26005)(2906002)(38100700002)(33716001)(33656002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KJVVSxXJvWpWJcAi2ulrYnPmhWy5uhym85oaAv6sx25/TNvL6cyiqwtcwg90?=
 =?us-ascii?Q?IMCtAhQYSSAjkyT7HfYW+BtsgjOCPjb4pV5ZrgtqiP2pGNojZM/7Oo46nY9R?=
 =?us-ascii?Q?BcV4SWEhs6fGUeD9dl9ZeyB81GFVBwjn0jl1B0u6REOOSR7gmojSJccUzCX4?=
 =?us-ascii?Q?mRKCE6ZT1RSzFZliJHyH5aUs3wDDte0YwJgD9Dgz9eeDxnXHxCVEyx92DFRK?=
 =?us-ascii?Q?bleDMSjP0WaebhyvDNGOGYF/w0alry0QMan8nb1QfU1L9SiQRGWfqQuXaWm3?=
 =?us-ascii?Q?0nlRjTo8+2+7NsM5P8jEzYbaFSGPo7FCSHZ4z5Fja8gteaTboU+5jjmvwb48?=
 =?us-ascii?Q?r46FXHlRmJLm0zn4qgzlAOD/Ko4byCai+mbiMF2c4RJIhnY+l12BeK06pJcS?=
 =?us-ascii?Q?Mt7aYNfntJYWUzqgNhB9ptcNB/MNXBpu3prv8jBFsozUYt1+QBRxl/uSuVRS?=
 =?us-ascii?Q?t4UhDS2Xdsu+w1gfckWF35At/dow8y9lOaMtsz0okTDX9KKT8LRX/AXNf059?=
 =?us-ascii?Q?S5uzrtpOVqe6BJjEIC8E2PE3stmA6qHB5fi73sytFngZH1uVibAh2nBDsrp1?=
 =?us-ascii?Q?wXS8dZzDW6MgUr67Ui0OwoPSU84K/EQth1g0UyPm9pIaithwlkcQ0E9yfCXb?=
 =?us-ascii?Q?aBj7REt7LfXQ4/6j553TE5BgXLh0nO1tiiHxEpAYEOsETleIHr+unzuoEWPP?=
 =?us-ascii?Q?QgNCyswEK+vG4mpYJPFJHQNaIfkxfdfRJyP229T6JTLmRLuov58eSIh4zBOM?=
 =?us-ascii?Q?qWxHV8HPzFZhjlAa3WbOc4h+WI6qK1fBj5x7IO0S7DtiyWEGUMGTftC8LIfz?=
 =?us-ascii?Q?cz8pjAFUhF0PiiBLBcyTUbGX/K2wjoZUyqXLsfstwEDP/Mt6Mhbz4Bwm8G9e?=
 =?us-ascii?Q?Q7HA6FqJB+cBulqFbbPn2TO5/rhlL13X67jXzbQJSzilMom0vz5Ah6p6LNH9?=
 =?us-ascii?Q?mDAgcwq/XVPB/ojZTaLv+35HwQZSwW5MNMLUqR3TNmgwcVB7N/KHeJobmIuf?=
 =?us-ascii?Q?1XsgWmXnuBgpfLEX0sVVdrgqHDTLnclGM962JUO6zcvjvKa04GQ8sDk15GrX?=
 =?us-ascii?Q?dqL1Sjw06bsVjZfXPFhQ0A61byRcrWNmvAVDXItnlDVOTWdmLiQb5xjX6Lm8?=
 =?us-ascii?Q?CqQsdwbT6uHhx/VBg/nInVfPnsGQrGye5sYgaV1tKxOf+ExuaDqSQVFdXLpj?=
 =?us-ascii?Q?TbMZHK9UNZYaCc0bo95kVxQz4MDUtX1WNVHWpreTRqgkWbsNHxQbztf1iLzh?=
 =?us-ascii?Q?Syk6iQMGV6fWlQp4uLaO95fZ+aoUGIUaraNtq4hOmT34KyXO1Cmx1vUNntd4?=
 =?us-ascii?Q?SN4ZyoVWfHZmAO93K0TdhXGK0wJuhzKp4KoihWtooW3I3Hjj9EeA2QX8yxhl?=
 =?us-ascii?Q?fFHZUUSoej+DT0ER9lGsg5B1aFG/T8szNNmmMdo4igJ+aPYHLfns0Pwscw5H?=
 =?us-ascii?Q?HxoKVZ/hzLpp37clOM7gn9I/2j4YKjknbZWVzMrKxkRbH3LQSkZKseQ141dP?=
 =?us-ascii?Q?aOfJA0/FBWr7r+ALhyO/FVLIfIrgWLjq6ZflsJ73q+nI+pxguADCxOQRx+6B?=
 =?us-ascii?Q?ocY5AnwAR/Bq4nMSrbzXmijGeBy19FKl5zFUP6iq?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?y66G+BxwC5VeASAlCVJfxKPF4RUgOwNUI6TfY08662ATRKUMHc7wBYERYE4h?=
 =?us-ascii?Q?n9VKyWPPRpH3O84W5Lsf7hGneowmnSyNuVN/B3RaGPMOfJ7f71Dzjm5J/w3D?=
 =?us-ascii?Q?6I8LCcoyfherduZ4tVaKrtQ+IyGgzcT9WrARwk3Rat7R6lq9E7GiKwch3wMQ?=
 =?us-ascii?Q?j3TMMFbPzvRV50e0MnVSyXZvhpqGDGLvpg/B0fFHWgl1KIBmHr/x/H6lv+7Y?=
 =?us-ascii?Q?RdcVYl0v8VC+q754SsTH6DJbHUWSMwMkHVNAsgqKPwtxfQWNz9zCG/NvxneJ?=
 =?us-ascii?Q?4uvgoe9x4avDWywcG1lO+XAi/BdTMYcySk4b9aO5TNTYIZheu0WfVP76XEfO?=
 =?us-ascii?Q?RQnQAp4QwbuJoXCupMmSZ/SfRsR6wus1UNOiSOQlHUQI4ccv1K5AgAAjox+2?=
 =?us-ascii?Q?dVAk0IaxhPH4B334Hoc4E++/DGxFVVTAqSp1vAnQtmegS9MbHlFj8I5E8P+A?=
 =?us-ascii?Q?eP5C0v0w7UDOmW22DSBxeQFvLoS+Jq6qoVTvZwMF2M6oashc9W2CECRpVDg/?=
 =?us-ascii?Q?TFQ+FMc+iP8VBcQ8168JxmVrlv4J1Px6eUQb/isbawzgZyuGP1KNAsSWQrDJ?=
 =?us-ascii?Q?/9yZpTH/zUIxSbsqLsdCnbjR6XWseqr/Z5y7NBBKKhU99UP5k/Yf7njEiZyy?=
 =?us-ascii?Q?AwbKCuE+f/+O1JTs4Pp+mI3Rs/3iNMwcQZUIMHs6gt3xb4uafab57Sh5wycN?=
 =?us-ascii?Q?sMawCaRynpOfYyBE66m1+k0vRF/sYCOzpgLiDFKddJIjq4rXAzV/tC/hFGyl?=
 =?us-ascii?Q?rR6wazLl+C8WS1xMmieJJVlisS64XAlY7C+6sXeuDIu18oL26ITqsTgv1rCz?=
 =?us-ascii?Q?HZYbTCUxU1HKzogKZoQi3bJhsp38AR+roCyvtY2f1Il40b+I0OkuEcYb54Eq?=
 =?us-ascii?Q?oyjBB4y6ykShEkrdiZVAogSNS3Z9ZqhQzsP8LehX2ScFdhI8jWmBi8r+s+Ur?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e718a53f-efd7-4e9c-5df4-08db3d365c2f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 22:19:48.9192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iCqOJyRazbC07ElFA+fJZymdOQiDcaDvvJ+Wkt8D+5OkXCaxU+XhFhxPJqYJnIYw0s9C5zDdOYTECzkGWLwF5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7330
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_14,2023-04-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140196
X-Proofpoint-GUID: lqSnT7wL8etpvd4kRAyZS0o_lfByGyGd
X-Proofpoint-ORIG-GUID: lqSnT7wL8etpvd4kRAyZS0o_lfByGyGd
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/13/23 19:11, Peter Xu wrote:
> When we try to unshare a pinned page for a private hugetlb, uffd-wp bit can
> get lost during unsharing.  Fix it by carrying it over.
> 
> This should be very rare, only if an unsharing happened on a private
> hugetlb page with uffd-wp protected (e.g. in a child which shares the same
> page with parent with UFFD_FEATURE_EVENT_FORK enabled).
> 
> Cc: linux-stable <stable@vger.kernel.org>
> Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
> Reported-by: Mike Kravetz <mike.kravetz@oracle.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/hugetlb.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 7320e64aacc6..083aae35bff8 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5637,13 +5637,16 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>  	spin_lock(ptl);
>  	ptep = hugetlb_walk(vma, haddr, huge_page_size(h));
>  	if (likely(ptep && pte_same(huge_ptep_get(ptep), pte))) {
> +		pte_t newpte = make_huge_pte(vma, &new_folio->page, !unshare);
> +
>  		/* Break COW or unshare */
>  		huge_ptep_clear_flush(vma, haddr, ptep);
>  		mmu_notifier_invalidate_range(mm, range.start, range.end);
>  		page_remove_rmap(old_page, vma, true);
>  		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
> -		set_huge_pte_at(mm, haddr, ptep,
> -				make_huge_pte(vma, &new_folio->page, !unshare));
> +		if (huge_pte_uffd_wp(pte))
> +			newpte = huge_pte_mkuffd_wp(newpte);
> +		set_huge_pte_at(mm, haddr, ptep, newpte);
>  		folio_set_hugetlb_migratable(new_folio);
>  		/* Make the old page be freed below */
>  		new_folio = page_folio(old_page);
> -- 
> 2.39.1
> 

Thanks!  Looks good,

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

-- 
Mike Kravetz
