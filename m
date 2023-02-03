Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0700368A373
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 21:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbjBCUQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 15:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjBCUQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 15:16:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709E99D5AD;
        Fri,  3 Feb 2023 12:16:57 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313K3p1O022407;
        Fri, 3 Feb 2023 20:16:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=0nEoPgz6DmIQKLTgIBVN9LOgfxvZStekuUg55dtT7Fw=;
 b=C6Hknl2A4ZNubmztRMYJeabiYuSmC4/dDz0GBlwnrPtuDQ3zDpzxA8cQU3jY74tD49da
 ImmMMF+eICQgzvPvitJIloFYlR5/2cT8U7vlx8ztSOh6EMuvMcyOTWQZzbrTMeIl9bHv
 wAUj4BYub5bPa3BhUQi10f8AijF2IUg4O8EvFYGtR3qW4pimVqMtMXXMy2ENkBukFQCy
 /ewFllZt0JOLU8P3lNbX/1DZdV/+EjM1bxzib9+uFprsBvhC39u0gAR8dljrt0LPbmR5
 6Xy+fV/ikQOP45upA4+NLJaDtXUqw/R2Ec1eyxE7r805WmdiCBMeCwW+FhWgcNzkU9X+ 9A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nfn9yptxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Feb 2023 20:16:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 313J2xOE034242;
        Fri, 3 Feb 2023 20:16:10 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5hnhyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Feb 2023 20:16:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFP30hmbD7oqnqYWa5Qz2jmxNPAqTUnubeAh92kHzQoo0FYND+MeJF1ci8hTXBTG3CE7onOdmf9rdskDBH+jb0KriZg0xEb3tJPiuDU2sZZS4Krf1Rz96MxFDqqBT2R9yfRMVU+E/YdyqTGr6tV6SibAq0/aNyZlWjfZATec5Hdnbw3A7OFi7GOeDnVLF9F8w9jQUTSKMZLTcTJ1mngYEpprA/pHJL0m3UzwbixhuXQ7pKmW1uNC9ZJ3SR6/NAlO3ifb7htX3NX2d3d2T57IR+1y1lzEPJF+3/Q5VG/stReOGx8JT6pgqWb2u0KIjfYTkDEqgtMxg73bktBD5A9V2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0nEoPgz6DmIQKLTgIBVN9LOgfxvZStekuUg55dtT7Fw=;
 b=UkC7xpu9lbLjUtBRvgn/fBZ/mvs/0ZTP/Hg56hObCQxUVkiJWcEGuCR+vHBHwKOvgYxKY9xXc73NMYg8diT0tPk0/5HOBAFeALlROpwNqxEm+IHqZswBSkTzk9OasLayHx8k3zM1Sy+hfXIliuJFudRZoz4BeTMWwElHYBdafRE1n5GFXkiakK03C4hPoaiMULTfs0j28K7mqabZ5nV6zVTLOGsbKs0FWOTDT7kZ+cypoBJbgSYbxIPjvrZcYQONBk6y/XoUbON3wB3jgQC81hW22jUozVYlW8Q0R8JkIJJCXCINU/2zSc3B60VUcYKXRpGsVv9rrRS0SQ4DCZDNOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0nEoPgz6DmIQKLTgIBVN9LOgfxvZStekuUg55dtT7Fw=;
 b=Ce8YH6BFe99C7ETpr4rn0SZPxNWNuicC8wELtMuAgN54C4gSe281GYVyqYHQmNDENG0JN+9vPZanJWfT9f03Ambp27p4K2gqPdaxpS90WxR7HlkeAiZ7OfHGYdm+e5ZAhjWepAygUJ6Aqx/oEPwaPqxuzwAEx7OXQ6iXrg4dQls=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by MN2PR10MB4383.namprd10.prod.outlook.com (2603:10b6:208:1d4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Fri, 3 Feb
 2023 20:16:07 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%8]) with mapi id 15.20.6086.007; Fri, 3 Feb 2023
 20:16:07 +0000
Date:   Fri, 3 Feb 2023 12:16:04 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Peter Xu <peterx@redhat.com>, Yang Shi <shy828301@gmail.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hugetlb: proc: check for hugetlb shared PMD in
 /proc/PID/smaps
Message-ID: <Y91rhP+gT6me67M8@monkey>
References: <20230126222721.222195-1-mike.kravetz@oracle.com>
 <20230126222721.222195-2-mike.kravetz@oracle.com>
 <4ad5163f-5368-0bd8-de9b-1400a7a653ed@redhat.com>
 <20230127150411.7c3b7b99fa4884a6af0b9351@linux-foundation.org>
 <Y9R2ZXMxeF6Lpw4g@monkey>
 <Y9e56ofZ+E4buuam@dhcp22.suse.cz>
 <Y9g/70m15SwxkLfc@monkey>
 <Y9oY9850e/8LQ78i@dhcp22.suse.cz>
 <Y9rUHw2kuSwg2ntI@monkey>
 <Y90O5+UVYaaN1U3y@dhcp22.suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y90O5+UVYaaN1U3y@dhcp22.suse.cz>
X-ClientProxiedBy: MW4PR04CA0280.namprd04.prod.outlook.com
 (2603:10b6:303:89::15) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|MN2PR10MB4383:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e9cda5f-be12-4a89-88b2-08db06237bd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3CpCUYuR4Xc0iSJoESg0RaqfcGIVp9PwnqsL+rmyeA+6gSwQoxtnQuuWAkuA/Pyy+jlWIO3nPk2qPESQsBH8CoOeJfzM40MuSejVjL0rhF7gadlHAi+GDZaTE0o7VeHOBOhmoliLOBVqN/sddATw7BSHdH1Ly597wWNfdH+Nhrlw7YvsAmuUaeG4urz8Gl2zgrtDjO5kDhu2Zd4S0Dv+cSX7NwhkdcH6/Sez7Cslc28oWuazLyFoTZq9gfHk6tbgafWa6N/VHf7Cekq5l+Ia+Mq61M3Gp7pLymsxDF569oOhtgcAOhy0PRpljwPBOl4fz2FPIeZlYSMEtavinn5umtWhvIhdFuFy+CT7GPlUNcdVVcZgWDoSDZ9S8wfD6HXUi/u9YbQsT9a3d+0fjoPnHqP0V+dtGa8mHDHRFko2Ei5UbnXn8uKUMZqfaMbLvTplO8s7MYF3zsbpq2Z/Zey1NRrNmE9gJqsEcKxN6jxWmbNpD64bjW/h9os1QWik/CaAnwFh9q2Vq6Qbu9RuYYmxPRfHbBjEsOFbtvDxEuE9XxzfeDrIP1vsxIgPPIQ9DW4xzK6rrdwVfKP6EF3uTJPL/XTPdGvOeBnDVj04PfhS0M3ijZytsaVFXudCM6yqCbyIIJpPsD8bGO9RWb98yCOg/lGDgF8dTtJmYCLGnVkdIbqjJVVe7Nh0o5YMSur+pNeVMckm3q8z2Spy4LvD3CfHpBFN2lwE8/qaZRFdDiGBYb8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199018)(478600001)(66476007)(966005)(6506007)(6666004)(26005)(6486002)(6512007)(41300700001)(9686003)(186003)(53546011)(54906003)(316002)(83380400001)(6916009)(38100700002)(66556008)(66946007)(8676002)(2906002)(44832011)(86362001)(5660300002)(33716001)(7416002)(8936002)(4326008)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RmqUShN2ZbzHdfyM06Q0Rs4jPGNFyPlqOQ5j/ckWYYr6w04vOiSLBS3uMnbd?=
 =?us-ascii?Q?tUie4jtc09YWN8Y5EVSe31vhxVbq2nyb5zfju3m+kjssw03P03efHO3BXcEx?=
 =?us-ascii?Q?akkLLFx5hrETv//Cpj+nKC5c/NlVUoedykh+cb1kQGO6+fz11PauGswvRE8Y?=
 =?us-ascii?Q?IKcnZzyKSz/qvAkDvz9pErpE1wsQK+lfp6TRrTv++CRBh8kaVBgFKA7UYsLw?=
 =?us-ascii?Q?K0eeijC/eC57rrYK0qGsQBi3VFOPwDcgc4bEt4Qx7HMt2erTP2khiboHk/De?=
 =?us-ascii?Q?Y9fLyEsZWsjnzFx0ZdNKUgeoLVEYf2EMIsDK7h+fP6uzEeC14uBO20sz+heM?=
 =?us-ascii?Q?OUiLxQwqJu9GG1tF3AjqvkE2uLtc4fWNrR8CIUwTA9hHfOdygc8fMxG/6uFs?=
 =?us-ascii?Q?V4ADPxHEobPaCpLXQT1bOsHKCcDt71Gj80nOj4ppQfKr3H5/Cn7WXlmAkBY9?=
 =?us-ascii?Q?NanjREJ9nQocTAu+scaUTymp5FY6iZza++/AoN/1grbHnL4hPO72LHXiaptl?=
 =?us-ascii?Q?ocp5y3GehQz5sidOoFYX5mACgoWTcAThKn8jX+vTzhaUGvx79SbzqzlcFVbG?=
 =?us-ascii?Q?lCBp6nSPYajaJohxtxU9s8mP90tS/wBpFnIIZOkQIAnLYUuN0fq+sE2Ir1v4?=
 =?us-ascii?Q?MVRGhcDYBxgD7wUShBIEBz8R5eRIAa1YoT4ZIBxC+kzYINt2mOh8r2tjNSkP?=
 =?us-ascii?Q?FtKW0O+xHEUR4fHGYLhFcPm7Zy08BGcDu6OlsDcTxnXqIOVj4S8ms1UW/aF9?=
 =?us-ascii?Q?KoJXHmM9icMWh1Q/iJhMtSFA9rw6I9y1I/Skeaz7jOMQ5STBiM6taj6Me1wN?=
 =?us-ascii?Q?7I/0rvWB7DEGgbcbZPV0+JpP/D+/xLuXv7/JqukIEzdhNq8/OUrrhH/fPkf7?=
 =?us-ascii?Q?IEwpYXkmdAg/GnBCAW3Dp4lNk2y9GleZBP3nJViFU+EjDJTKFA6blzSOsLAp?=
 =?us-ascii?Q?K0cUohdCYLmkRUCMVshSmnW/quRgRXQoNkJBZii5b27rqlvYEaEYcV7rUKP3?=
 =?us-ascii?Q?X7YoJMV1qJXu5JTqf3C69ezLn3WpOqz5p9Xp7+vIrdwkb1xiV1YSKYz6J8zk?=
 =?us-ascii?Q?3AW8/9n1a1Y+IOZzWK4hnj+6i+mQIUuwAcRR3oAVSBdFKfbYg5oLAv50uxKn?=
 =?us-ascii?Q?EkaqLvdA/gzwO+QhB5TOnnDlJTGTur9O32dDDOG90MFwZBXkL10N2iVFzHNV?=
 =?us-ascii?Q?YFCfvGmGVjkj55E82X7K49aAtHwB5y7pqUWtzO/SB0U6LVFK4unvdgiE2V7H?=
 =?us-ascii?Q?8lyn50HAhbLG0P94B6nL8t9vnVhommYuxf1/jlgx0Ue/P2sx34G5yDBlh9gg?=
 =?us-ascii?Q?FQferRzI67cjeh9BKIOtnLTZg2rjLpGKjsv/WvUrqhsKDTe7RRa3kye8Rziw?=
 =?us-ascii?Q?GtmEtdkoOGSiQT0sztvaQ/MaHyEu8NaSyq3S7TjIUSFKA4DMGnoabguMUiii?=
 =?us-ascii?Q?G6Y/XseShuvZIadGOUAmbttmR1bv15jD9DXw1LDHFmHzKmrWTmrxTa1LUAtz?=
 =?us-ascii?Q?ywopYLJB9LQd0m3c0JZ6j4nFL3r5QmIW0onnG/EBCR/4mTPj4cKcf1xPvnpK?=
 =?us-ascii?Q?cTvrmhePT0WSIDoGVSwGp2RZ4SD+YiGoGt4ovJmB8Frgx3MJWi0Q5jvtMvna?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?QCuhS9DHo+s5iDIpzJKOYvcbAEX4zC4rvHtYpYM/5xn+bYQbQ4fswncgARta?=
 =?us-ascii?Q?kcj7xC9rFoJMxGJ10juVGaGQrxSWZueWyMDISdUVfX1zAoqh8P3wRXzeXMgZ?=
 =?us-ascii?Q?RnxpGqVFZYw8tflwGU3E13f6VtzyGiNnPG+lifGxvI2L8dyukt85cBOUEU+q?=
 =?us-ascii?Q?uD0dLGRn7sC14QpV+8XNk4KyjMTGoXXd+lme/h7xPtVSIpBdkUnGccmRyhxR?=
 =?us-ascii?Q?lIXEBErxSaW/P0NknwuHsqmgjQKw2sKH1x4kBp14Ig9AmvBYgAcn8+Bx5deA?=
 =?us-ascii?Q?jdOxEHKvDZ+ROuQ8KSoUP4XfGj+X7f36KkCdOe4PMIUkzgwimK6ocqCiu948?=
 =?us-ascii?Q?XUESrLKgQApgwj3Q+eULoTpgNFGG+7/DmFau/0O9IrV2kDBPZNJ8zUjIJmM1?=
 =?us-ascii?Q?NJ33hQn/ENpDuMuFyLgS59qe92z6U7LmyrWFU/vEVEtevkmPi3aDSiBRRZ7C?=
 =?us-ascii?Q?OaC+W+H2Z8IwhoLm93DlDv3qrnphavJ4Pu3s4OzX5OnS05jFp4fls25A73c+?=
 =?us-ascii?Q?u7hCTwDO9PX/cf4d7BsR8zKk45eZgaSJLc9RK2o6PtIRZ/M5JLFkIl/WriFy?=
 =?us-ascii?Q?3/z5V9dZ2UTYzAZcFeePXTXj7xJg4/pYHDDZ/IIwYaLFbAnAyYTZy/kEYP5a?=
 =?us-ascii?Q?IrJbdIafTBNdQOelQa6OyY3PhuM30L+yYjoKFpSTZPM3xtKOw8/N9QHEoeA3?=
 =?us-ascii?Q?wmgMeEdEdylvJAT3p6Istwsld6nWX4IiYGFyCf1m34s4OfdgPbi9UKCyBgde?=
 =?us-ascii?Q?xLBIBu2Sw87MKaf+NpFtLr2PpU6z5wDlrhhxIixW4LYsjOX19hbBwfJi7pfI?=
 =?us-ascii?Q?u0zLiG1y5mUtiSl/2OvmrCQtZ0211VtL3n9xsRN9WzxaLbrbnB06dlktuYy0?=
 =?us-ascii?Q?ALY20PsBg1UQdUGkc3vjP7sopBO/hUsNkVcMjC/2ZTMk3Oy133ASpjQhnk5+?=
 =?us-ascii?Q?FkpSy4ggZMK00a43UcV4ieTXwudOY3on2U2Wm5YJfYAp5R3S0O7Y5jdWS7aQ?=
 =?us-ascii?Q?ZgdZLFlZZGxuj8GN9rs7P85rPCHGTrty/VZcFbGc/G4lEBM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e9cda5f-be12-4a89-88b2-08db06237bd9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 20:16:07.6720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CVPENK4rA9e1a65Q6WFIEHmZlaOHIjnYzFLL/PVN3ry7ooQO6fPHmlDjsSLFwUuJfGELH4HCwvbJjkN/yqow7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4383
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_19,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302030182
X-Proofpoint-ORIG-GUID: To3Vf6sakElsxdWP8tCvzpq5uYmLXu71
X-Proofpoint-GUID: To3Vf6sakElsxdWP8tCvzpq5uYmLXu71
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/03/23 14:40, Michal Hocko wrote:
> On Wed 01-02-23 13:05:35, Mike Kravetz wrote:
> > On 02/01/23 08:47, Michal Hocko wrote:
> > > >   process.
> > > > - At page fault time, check if we are adding a new entry to a shared PMD.
> > > >   If yes, add 'num_of_sharing__processes - 1' to the ref and map count.
> > > > 
> > > > In each of the above operations, we are holding the PTL lock (which is
> > > > really the split/PMD lock) so synchronization should not be an issue.
> > > > 
> > > > Although I mention processes sharing the PMD above, it is really mappings/vmas
> > > > sharing the PMD.  You could have two mappings of the same object in the same
> > > > process sharing PMDs.
> > > > 
> > > > I'll code this up and see how it looks.
> > > 
> > > Thanks!
> > >  
> > > > However, unless you have an objection I would prefer the simple patches
> > > > move forward, especially for stable backports.
> > > 
> > > Yes, the current patch is much simpler and more suitable for stable
> > > backports. If the explicit map count modifications are not all that
> > > terrible then this would sound like a more appropriate long term plan
> > > though.
> > 
> > The approach mentioned above seems to be simple enough.  Patch is below.
> > 
> > I 'tested' with the same method and tests used to measure fault scalabilty
> > when developing vma based locking [1].  I figured this would be a good stress
> > of the share, unshare and fault paths.  With the patch, we are doing more
> > with the page table lock held, so I expected to see a little difference
> > in scalability, but not as much as actually measured:
> > 
> > 				next-20230131
> > test		instances	unmodified	patched
> > --------------------------------------------------------------------------
> > Combined faults 24		61888.4		58314.8
> > Combined forks  24		  157.3		  130.1
> 
> So faults are 6 % slower while forks are hit by 18%. This is quite a
> lot and more than I expected. pmd sharing shouldn't really be a common
> operation AFAICS. It should only happen with the first mapping in the
> pud (so once every 1GB/2MB faults for fully populated mappings).

Just want to be perfectly clear on what in being measured in these tests:
- faults program does the following in a loop
  . mmap 250GB hugetlb file PUD_SIZE aligned
  . read fault each hugetlb page (so all on shared PMDs)
  . unmap file
  measurement is how many times this map/read/unmap loop is completed
- fork program does the following
  . mmap 250GB hugetlb file PUD_SIZE aligned
  . read fault 3 pages on different PUDs
  . fork
    . child write faults 3 pages on different PUDs
    . child exits
  measurement is how many children can be created sequentially
For the results above, 24 instances of the fault program are being run
in parallel with 24 instances of the fork program.

> 
> It would be good to know whether this is purely lock contention based
> or the additional work in each #pf and unmapping makes a big impact as
> well.

I did not do a deep dive into the exact cause of the slowdown.  Do note
how much we are executing the PMD sharing paths in these tests.  I did
not really plan it that way, but was trying to simulate what might
be happening in a customer environment.

> > These tests could seem a bit like a micro-benchmark targeting these code
> > paths.  However, I put them together based on the description of a
> > customer workload that prompted the vma based locking work.  And, performance
> > of these tests seems to reflect performance of their workloads.
> > 
> > This extra overhead is the cost needed to make shared PMD map counts be
> > accurate and in line with what is normal and expected.  I think it is
> > worth the cost.  Other opinions?  Of course, the patch below may have
> > issues so please take a look.
> 
> If 18% slowdown really reflects a real workload then this might just be
> too expensive I am afraid.

On second thought, I tend to agree.  The fixes already done cover all known
exposures from inaccurate counts due to PMD sharing.  If we want to move
forward with the approach here, I would like to:
- Do more analysis in order to explain exactly why this is happening.
- Try to run the proposed patch is a more accurate customer environment
  simulation to determine if slowdown is actually visible.  I do not
  have access to such an environment, so will require cooperation from
  external vendor/customer.

Unless someone thinks we should move forward, I will not push the code
for this approach now.  It will also be interesting to see if this is
impacted at all by the outcome of discussions to perhaps redesign
mapcount.
-- 
Mike Kravetz

> 
> > [1] https://lore.kernel.org/linux-mm/20220914221810.95771-1-mike.kravetz@oracle.com/
> > 
> > 
> > >From bff5a717521f96b0e5075ac4b5a1ef84a3589b7e Mon Sep 17 00:00:00 2001
> > From: Mike Kravetz <mike.kravetz@oracle.com>
> > Date: Mon, 30 Jan 2023 20:14:14 -0800
> > Subject: [PATCH] hugetlb: Adjust hugetlbp page ref/map counts for PMD sharing
> > 
> > When hugetlb PMDS are shared, the sharing code simply adds the shared
> > PMD to another processes page table.  It will not update the ref/map
> > counts of pages referenced by the shared PMD.  As a result, the ref/map
> > count will only reflect when the page was added to the shared PMD.  Even
> > though the shared PMD may be in MANY process page tables, ref/map counts
> > on the pages will only appear to be that of a single process.
> > 
> > Update ref/map counts to take PMD sharing into account.  This is done in
> > three distinct places:
> > 1) At PMD share time in huge_pmd_share(),
> >    Go through all entries in the PMD, and increment map and ref count for
> >    all referenced pages.  huge_pmd_share is just adding another use and
> >    mapping of each page.
> > 2) At PMD unshare time in huge_pmd_unshare(),
> >    Go through all entries in the PMD, and decrement map and ref count for
> >    all referenced pages.  huge_pmd_unshare is just removing one use and
> >    mapping of each page.
> > 3) When faulting in a new hugetlb page,
> >    Check if we are adding a new entry to a shared PMD.  If yes, add
> >    'num_of_sharing__processes - 1' to the ref and map count.
> 
> Honestly, I didn't really have much time to think about this very deeply
> so I might be missing something here. The patch seems correct to me.
> adjust_shared_pmd_page_counts's delta parameter is confusing because it
> implies a delta adjustments while it justs want to be "bool increase"
> instead.
> 
> Thanks for looking into this Mike!
> [...]
> > +static void adjust_shared_pmd_page_counts(pmd_t *pmd_start, int delta)
> > +{
> > +	struct folio *folio;
> > +	struct page *page;
> > +	pte_t *ptep, pte;
> > +	int i;
> > +
> > +	for (i= 0; i < PTRS_PER_PMD; i++) {
> > +		ptep = (pte_t *)(pmd_start + i);
> > +
> > +		pte = huge_ptep_get(ptep);
> > +		if (huge_pte_none(pte) || !pte_present(pte))
> > +			continue;
> > +
> > +		page = pte_page(pte);
> > +		folio = (struct folio *)page;
> > +		if (delta > 0) {
> > +			folio_get(folio);
> > +			atomic_inc(&folio->_entire_mapcount);
> > +		} else {
> > +			folio_put(folio);
> > +			atomic_dec(&folio->_entire_mapcount);
> > +		}
> > +	}
> > +}
> [...]
> 
> -- 
> Michal Hocko
> SUSE Labs
