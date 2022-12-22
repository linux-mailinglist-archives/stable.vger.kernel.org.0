Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28011654936
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 00:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbiLVXVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 18:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiLVXVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 18:21:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F796365;
        Thu, 22 Dec 2022 15:21:15 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BMLx7E0001690;
        Thu, 22 Dec 2022 23:21:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=ioANjbj0UIyExF88hL+vFhvIVpYUiIAgext/1nTbM5Y=;
 b=t3l3piSqXfF3CtH9cGsC91g79YNRjsTNjNBsDxG1WwxTTjf2B0Kvb4pGMiO4kBtbOt4A
 MfX3f1tgQ2LG0j3Y46RXcqM2rwTWSLXua+hOtzDeaJxNoPGPYfSejBeByuM6GyOfXLQu
 ZoBOTmdNV7PLazO7t7pX+8lL969vsEFRh01SA2Oz9+TM7O19VID8Z5oB2b9sskONaRMy
 Fdxzm54GZGqGMplk8fNlZMTazeClj34YFG4/dwRDBIOSHbzKyDyTb195dbexZH8OqTBX
 EpEGzgb3SHbyhRg7j9+X3HGk3KCMmZFNu2aRkddaiSeXV/GtqBaKWkL7dsoLSapIL4rn yQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tnmvm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Dec 2022 23:21:01 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BMLWHYk030257;
        Thu, 22 Dec 2022 23:21:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478t0tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Dec 2022 23:21:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RpUEV3XJrZLxfJvS/CORw4vF6UF7ek7JZpmU2DNsyw+Y2LDNCxO1Nb9vRkX4n9KVGnvlQ88JqFlI12NrlJOXpwT3+WYXv9kX8T+rQMdGowzJFbU97GZelwq5IO52HCO8D07obcuselSqeiAnMdBPCQA+vL58XM0RG07zbxTLHtL7djkkYoi35Ub99TA4BC9Y1ZuWY+i1wjK/DJRxgkiFqOhTRP+xrOKnygWima8qUHSKtd4nZ/7Co/GpCQZxoN3ZGtk0ROKAUUJNONn5UKFbkZ93fbn1Fc0aijmMs9/El3tGdu/oQG6f7Jf7wU/rOECn/IhUoV0Fh+F68WjZxvjc1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioANjbj0UIyExF88hL+vFhvIVpYUiIAgext/1nTbM5Y=;
 b=NwA0qW9XmjXwFkFAiJGp8nTnglopxq3IQRkVhmMXVN4Ne3RcnWhG55LwWsWLDnrdVpDQ8/JoU6Dl3mXANiLGNYk9WUrB1I2h2kiwI7wA0GaV1Ajfez9gd1p2FPFo7seoRwwGrG3Rf/WH8JfKIWL2KqzgW4oeGYyyOJiA26eyLaxQ2N5V+FzXfEpsKFaFCuWEYKEwTV3Gd8aZKENOmFOaUCBB49xsFqEtfeXlbJ0s3PFGIITJSEOVvK3to6rBAmufSEPD5weseeDljfodLRNX3Me9/4oeAFT5xb8QIzLXODFUQV+3OwAEGQWrfS4xqAqyLKrFrDEwtVnr65xJGgxExg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioANjbj0UIyExF88hL+vFhvIVpYUiIAgext/1nTbM5Y=;
 b=bdU5asDvBhNkUpTQAv11x+lOtrd9mGnfk4PM8szdkmoq0AY+eUfe2dEhC1yQpvD1nX/PZzv7Y22snoOPxCWhF/1d+feY526TwY89L6AfCPvPz4bRvq7+d7/9MmE04wj/YzoXzzUudd/uORABNCFaySN08b9KIaetFriHD/gufCU=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CH0PR10MB5210.namprd10.prod.outlook.com (2603:10b6:610:ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.12; Thu, 22 Dec
 2022 23:20:57 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%7]) with mapi id 15.20.5944.012; Thu, 22 Dec 2022
 23:20:57 +0000
Date:   Thu, 22 Dec 2022 15:20:54 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Muchun Song <muchun.song@linux.dev>,
        Miaohe Lin <linmiaohe@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/hugetlb: fix uffd-wp handling for migration
 entries in hugetlb_change_protection()
Message-ID: <Y6TmVtE0gYqWStez@monkey>
References: <20221222205511.675832-1-david@redhat.com>
 <20221222205511.675832-3-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222205511.675832-3-david@redhat.com>
X-ClientProxiedBy: MW4PR03CA0102.namprd03.prod.outlook.com
 (2603:10b6:303:b7::17) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CH0PR10MB5210:EE_
X-MS-Office365-Filtering-Correlation-Id: c568290c-7262-402d-019a-08dae4732e12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: APP5p6Wn/wNKOb6cJnMHdA+bgKOTU1moPuBwJEkMDWzBE5ywkZGeCozLJYewrp0HQ18Bt7/8+az7jPReGxrnon7txetV7QRNcDoqprJ3QpyA/44VgZ2alpw1gxzcfBFRjqgHKLMHS8oN8/f3bV4vJNOuQeS7ZV3JKf7cKBoF9b+kDze6CMBamFy7Dum09+7CiCxheglL3WVl0YPuLcCMEFeyf5h96YDbaBvPQCSnnLzPKHAWovvKgvJrPLdG/V7UyE0JHg1h4VYr8JH+YGiknNijiCtkRppuh79NiRiOAGPYWWAxJD9saXq5UzPH5rBq90Cp4lAPC9NJn9gHBQJIvo5apP/WZiv6o3IE5frADJoB7EmuTkM19WHtnFwvpsVsoZyx243Yih3LDAtcR4yERA85KFLSoi4YgjrMcoBFp3vQYT3+DRkmzW2nrPDRVol0BQ5RTcCGmlFDxVT2TP32BsptjuH/W302jIQeZIa7pyros6rVdCC782n2GzYIjUpzST7iwLBMJ5LsvmWTjEGBQo1Et/mIVUMI9VXUZBjYBSNWdPGN1qy1xhbn3WiCEtOctlAjXL9OB4JDJ2pGSKQEn9hq0x2OegMMCgOTY78ngohMvwVzLs9h3RZG2O2SO/+jjZI4RyYtKwe5IxU8w+AkbLf/r4BMfY1KCesiqA0/8EI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(366004)(136003)(376002)(396003)(346002)(451199015)(6506007)(53546011)(6486002)(966005)(66476007)(478600001)(9686003)(6512007)(186003)(26005)(6666004)(54906003)(6916009)(66946007)(66556008)(4326008)(8676002)(316002)(86362001)(33716001)(38100700002)(41300700001)(8936002)(83380400001)(5660300002)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JggGe55zZNbSOrvY0ziRkXhLr5rcSNzTmJLhw/Rc4d8+wtHE/gFk9jBGsP0h?=
 =?us-ascii?Q?plW/LajKsBaOYY/HcwAW6KyfMz5BtdFloxf2qo3kHT4005LK/rhpcbOCu3Yo?=
 =?us-ascii?Q?UWzi5cpcxuuZ5zBnSeYGO36/hgrQraZbszS/W5mmpATpUcZlqQ1j3oYFd+th?=
 =?us-ascii?Q?JERJtv2JUKso4q4rPNbPznjw7Izcm/iRM0xUq1OdOXCV8n+WTYtX5fdv+uWU?=
 =?us-ascii?Q?4YVMQu6lnEVFQGuua+AAom+7Yp2KmT75fERiL7m7R36iNV30pXI0zMogdZgJ?=
 =?us-ascii?Q?MDuBFRb50yrl7Va45U8M8XkYz5CyKWUJnAvcq3zQqw/mZn0u2A6GU3WyQStE?=
 =?us-ascii?Q?Pkn9a7RlQQhBUZPXrhnhX52gsqf2jp3x0YVbB7W26IS6Qs34/L1hf7uKaT4Z?=
 =?us-ascii?Q?tcmnIhBuPS7ZI4mIrH0cf3nouWCryIbRfKJF4ECp7KMWLJeFaIbCwsQBbEHO?=
 =?us-ascii?Q?rumVH1J/HL44geL+aNxoe/3yZC74gyAhAJcBFeErRBxdSwHqBy1xtlpQWYl6?=
 =?us-ascii?Q?o/2UiILvGH+vSr/bmqnzGOFdLRwfOHD2+4WjWml689FL2OEwlmpxEbt//QpK?=
 =?us-ascii?Q?9xLAI3OFTEX0hk5DQ66LjcSVu+9mnht6BShYI6LHUKjf0i/txyCNEZPTY0nq?=
 =?us-ascii?Q?1yXnb4f539yxC6m/Oup1PX+QTpFaBAgE45Aa0H80m86CR9QpiHTq4yW1+M3n?=
 =?us-ascii?Q?H8CegtXFP7ZKNqKZO3T3vFP9mBTX/eqaz+Cz2lwXpGAhzvHjsfNXOPpgEce1?=
 =?us-ascii?Q?q55Q8Wcwy71pZP/YOpzGQHa1av8v6t05U0RQuVYBBmW3luO2ParvmSutwPQ7?=
 =?us-ascii?Q?u19EPgRXmVyDojSfeaQALeLK9NiFMZPwal7LEYhZAFWSk+vXVVFYPwIl3yDW?=
 =?us-ascii?Q?HNL6VoWPd8k2laA+0gDRrDDSOMGyhAr/PZMA8NmDxeV3vhE3V+k40fuNuSQ8?=
 =?us-ascii?Q?hSPwCdJHjXk3EBOLdPiOc9bUWM61x4IKnL3YU3/zTW/lNt1JRS/KzRN1kyLd?=
 =?us-ascii?Q?wMlRYjVt70etG6XiUNB3Z4+TLOyp0zTMNFRIrfQPtWFiejyJUcl9Cjc50jfu?=
 =?us-ascii?Q?vdyMmJC+4cODSv38z+e3W19X+8jIoBxs2R5RhXumxuJNvX94iQqx9Yegoc5T?=
 =?us-ascii?Q?dtXhkCTYMIxYkXeF+6HFcjFYA89Ek1Tb0dF3yZHLIGQF0eK8lKUHefEQUyxW?=
 =?us-ascii?Q?tHYIPa+ulLBPwRF7oC2FUgp0EEmcSzB4UXqlqJL7Z0/nN3h2nbHx3a4VWXeM?=
 =?us-ascii?Q?NvgBZGvUZ2xsFtEOB0tEzXbthkl86hzFt/xME8xXrGq8uTktuy0MiIGrwrsp?=
 =?us-ascii?Q?fqtVawnhj7tAbUXW0BTA9Ywy+DgrzrSUCQ4SuXPb0TOYJ/BsmWQEvDvzKMEC?=
 =?us-ascii?Q?gLEyq1xCjUZFBY17fCHdWvOh44IgNs8rxZxTikqkWV/qSkzBpd8xhILns8ty?=
 =?us-ascii?Q?xOU8KGUxZ6P3XTO+SkjvdF6ZXRiVEeUrbLgKyHgWOUxIuKqo6Ty20kEznILt?=
 =?us-ascii?Q?D1keOAZ28p2pYXhBfO+g0qIOkGQY1x5YVzLTU5nN0h38GKtpJE8fXr2nmPXq?=
 =?us-ascii?Q?vKYLk+EaE6cHeNrDfkFBTcL79xiFrxsPN34ocCo6ccSq0LphgXe1+L4Zu93Z?=
 =?us-ascii?Q?og=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c568290c-7262-402d-019a-08dae4732e12
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2022 23:20:57.3212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ma1JtNkmM8kIGV2fWVdaeXkdPFISNcUbfvCg/BQyLy1Gbt/oUQ1BkoLqKxeIvkIMCOytAhvd65trki8t8IPUng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5210
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_10,2022-12-22_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212220196
X-Proofpoint-ORIG-GUID: 8Z7sOiV_TqGvl2Wlz8gUZ8hKCaKrdLoP
X-Proofpoint-GUID: 8Z7sOiV_TqGvl2Wlz8gUZ8hKCaKrdLoP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/22/22 21:55, David Hildenbrand wrote:
> We have to update the uffd-wp SWP PTE bit independent of the type of
> migration entry. Currently, if we're unlucky and we want to install/clear
> the uffd-wp bit just while we're migrating a read-only mapped hugetlb page,
> we would miss to set/clear the uffd-wp bit.
> 
> Further, if we're processing a readable-exclusive
> migration entry and neither want to set or clear the uffd-wp bit, we
> could currently end up losing the uffd-wp bit. Note that the same would
> hold for writable migrating entries, however, having a writable
> migration entry with the uffd-wp bit set would already mean that
> something went wrong.
> 
> Note that the change from !is_readable_migration_entry ->
> writable_migration_entry is harmless and actually cleaner, as raised by
> Miaohe Lin and discussed in [1].
> 
> [1] https://lkml.kernel.org/r/90dd6a93-4500-e0de-2bf0-bf522c311b0c@huawei.com
> 
> Fixes: 60dfaad65aa9 ("mm/hugetlb: allow uffd wr-protect none ptes")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/hugetlb.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)

Thanks,

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
-- 
Mike Kravetz
