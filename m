Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFC460FBF7
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 17:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbiJ0Pat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 11:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235493AbiJ0Par (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 11:30:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A912019E;
        Thu, 27 Oct 2022 08:30:43 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RDx67i016615;
        Thu, 27 Oct 2022 15:30:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=jfYh24JdxEawcfbNxO74t9Mk8AcqARpo/bxCLwIyyac=;
 b=q0E5aUlYnC8FIm8shTIpaUdi9ipWtWWLHIAnFbuAThoBc3KOCFsA0248tROr8fYqpk7W
 YkoThqKtPMQpQqBLLqSCFTSOvKUZdbwB+VBfhnd+vqsd8svWB42TmHvxBraVMt9pk1Kq
 0V2smJI4dOdHVgpbBvm4na+2Pj+bk5tpz9gXv7NWj2yP4++AIoMquRRZmO1Ydt7wdFgY
 dVfC8kAHr9o6ZS0tMsagTFhmt/7Y2FYnmvxKsb8KvizXV6/T5AipwJiCFnxyq7zW288c
 xMMd9wepH00OQ6/hNk/7uhosfYNzubQyKtiiEJd1NiEnMBFf1gDva82IPnWnCniKnlqM Rw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfays2j1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 15:30:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29RDSp1e017455;
        Thu, 27 Oct 2022 15:29:35 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaggk71w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 15:29:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kj5U7UDdb7ngLLvyI71Qp9ayNy6dOixM93hF0BxUsk5b+vKmHcPuP2W5VYMuRgtJiYwV46iimA8v6RpsIH8xew+2/4daM/niJ67aQT8yerC+CEg3EUibPDK0DaKVJWuU0EKHX5/EdSgywIIpF8AJC3z7gXrhGV2B1CYgvp0jvyE5YEkrCGABH7QW/ptl6OQa/2OFtae2rI6jOD4+DUv3oeOfO3T8MBPhYwelrZ94JWYwVcDjNxoo2JJp0djq42U1WIk1WLVvsOkSFfMg1pGkt4v81ZRPADuftaxB1GNUyLmg0VtIvQq+U7CHO3qFe560aNNbKhEC76WmtjdnSS1w8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jfYh24JdxEawcfbNxO74t9Mk8AcqARpo/bxCLwIyyac=;
 b=YEdzVOhaZreZFot4j4JYinGC+SoCsdhrmvnjq5HQfDIwN47Gagpoij0NOWc2kR+u0L85X9lpi8DqbfcB6Rhqa3Vn+bDhSqlmsNsSK8gZvtQ/LwpRh9q5MKk5PUVT3uhmXMyOwt74U1b0HlovmlAN6p8BFO3vWFqoY20TF8PfcY+LbXKqsji9LyTQjZZELg2Te/kekehVFiU0rNPQOA/Ly3QigrcllhHx8tHpopcNcq1QE6oV+nWRup8ONHFV8KR5x5VockqRJ8mkogReNTyvMLO6vJMWDs6s1Tu75EMwgyCxDC6Gx7k3ZFIWp20GKwydLGC5Rk4b8tZzXCsnJKThfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfYh24JdxEawcfbNxO74t9Mk8AcqARpo/bxCLwIyyac=;
 b=VaxTbMPzUigt6/Drdh1bl3xlR926RM50CNyCbeu1NJLgL0yXh1jgYvoFuAYyFEja7H3V9qOR1qktvy7XS8tQx/BVIrFGKjuR7qe8kLdoQ68B/29lOHrC1M7vdaFirI2TjvxKyh/7PzhAAU8rE0Cpi/fgaNAaJN/Fsl4I5nG0pKQ=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by BLAPR10MB5217.namprd10.prod.outlook.com (2603:10b6:208:327::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 15:29:33 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::4848:b2ee:4a44:16a]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::4848:b2ee:4a44:16a%6]) with mapi id 15.20.5723.033; Thu, 27 Oct 2022
 15:29:33 +0000
References: <20221026062843.927600-1-chandan.babu@oracle.com>
 <Y1lJqHOSKuAMrSTS@kroah.com> <Y1qclR0k6r386vl3@kroah.com>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 00/26] xfs stable candidate patches for 5.4.y (from
 v5.7)
Date:   Thu, 27 Oct 2022 20:58:47 +0530
In-reply-to: <Y1qclR0k6r386vl3@kroah.com>
Message-ID: <878rl1709z.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR04CA0022.apcprd04.prod.outlook.com
 (2603:1096:404:15::34) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|BLAPR10MB5217:EE_
X-MS-Office365-Filtering-Correlation-Id: 70fb32ac-b9f7-4058-1e7f-08dab8300ca0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o4kK0o0nMezC3Vm8WBK1qxbxsQda86PAsd0KmboP8hl30ceZv4GVMdgwNg0e12vYJnOpXjzvIPO545VRuiOLdEWT7eB2TcwSaDFhCO8LwyM/6xyU1yRzbB4yGnub1XRFntvpBo6Ifq4ATvtRsJXS6h1h+kq+Y3PTdiix1d4cC2IoPlveaG+kpu9uoBJlJ+MWRa3DwV7c3jD2ax72JY3uPuQAZ0Xg/FtLEUtQ+WjaivEjypXfQOB21P4ZnIbZQ/5SawnbYkQBFS+vL2GA0ToCnYrZA+OBfeJX8ittHCoLhHlFnAYlTtJDjBq+KOWtHGDvlnlqSVXpktAmBhzu92n4wwpwrr6sDfJrzziXQ8EE9/KpFfuGGfEufvq4Sp6ZPtbHKgVnPSWOq/yblrjEu1npl7j+EVVA/fuo6K77khhDFndqdDxatheqWiMTQwzk+Et/HCmi0uKRjirIJVJALYue8ghfgQak7YsM1RiHkCo4rPU8QXXvKiHnPUE9Xxuq5bc1eVfmE3o1J8dPGCiUGvRuGs+2ZjgsPEn7hLb61H1o9QJtAd8K1Ni+gVZl1DXbvmgX/TgjgJSGoybNby2ckx73lJEWrh/1iZn+SBqsQEOwB5oxDy4082LT4Kc9hY1Pxk5lI8GgchTInwpRV4gzJ+JopmWEDhMqB9/mZ4PolhDEQlXgU/qKNMHBFsF0bEVJoalBBMfCPJgLQXU5Pei6OGj/Mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(346002)(366004)(136003)(39860400002)(376002)(451199015)(186003)(478600001)(66556008)(41300700001)(66946007)(6512007)(66476007)(316002)(6486002)(5660300002)(8676002)(4326008)(2906002)(83380400001)(38100700002)(6506007)(6666004)(8936002)(26005)(53546011)(86362001)(6916009)(4744005)(9686003)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pd1eHMQRVdWYKbLQuYMUYQVNQSLEmd7woBNpJzzHcl2X7ObA2pNQTLplokeh?=
 =?us-ascii?Q?dIwlfviTkjpWZVEBxJWymacWd/hX8DZslxM8uDyK3FkgkC/gN9ZKuYDsYEOg?=
 =?us-ascii?Q?E03APGqNjhzinjpFo5cta/VbyGurcLl6XAPaZFD3oLObCGZetFJY74SD/32u?=
 =?us-ascii?Q?9sy1OIIrjUBs9B3cuVWzyN1Lzce/mHvE+8qSDhvUmf0iEBityGv5zq5UwSkl?=
 =?us-ascii?Q?WlM+wKTLCjiNgPxyB8nmnO8c9Omcqgy7Qi8hcNdT0KUpdzBIJE/Wg55WlOnU?=
 =?us-ascii?Q?YxGgGvRvCrk6O/vMM41P6gxBgt5Jhvatyj2ndkXgNdZFdhKjVPlet53n+UJU?=
 =?us-ascii?Q?sSgZsTmCZVIY3iHoJDYAXx/0U7zOvOU2XSOpFz5L7rjmwoxp3uAAyJCf3i7K?=
 =?us-ascii?Q?YskcdME5M38KChO323rUkQqQtjmaGcLWbTVCyp8CEL4X8mftCU9WZbuXK1x9?=
 =?us-ascii?Q?FAb4t8xKhrorHLLcMM8vKBTVTICfGU8jGk7u2jDNmvM1a2QlQK8gDUayLu0U?=
 =?us-ascii?Q?xFbu9D5t/WqfhHH4R7QIemmH3rQ8ml07GhTpJdX0wgAo8fQL+Tx5HuWBpvL6?=
 =?us-ascii?Q?oO0/geSizAoAxmurCiN1JO1SQiW/rTYoHy/mXY2rDAK0B/QGRh/G4Ktx8FSi?=
 =?us-ascii?Q?XrbEvSr0/hQ46PIBzJJKOh1fGIlsHDZhlgckBNooNu95XN4BQiF/V2c1DyTb?=
 =?us-ascii?Q?iFoFpN6B1fVC0Z8U4hJMIKjZ6YGYxBivhPT5pkQhiI+F8hyV3WqRaEr266NJ?=
 =?us-ascii?Q?6NBNg3C8p93L0/xZL+OTTuUgeLPcLCFGuxLE1BQIgr4qBPmJ8bb4jPt0Xozj?=
 =?us-ascii?Q?wLutJ58JdmQiCsqn/os/DuIJYbM6/3AFzBTuIBa7lnXikLfvboVrlarJ6DfB?=
 =?us-ascii?Q?a5fhSmI7fHVuAOOCKJ0ievrc1ObksGbnw64cr0Mjn1hqTOzv3jgiX8G21DBe?=
 =?us-ascii?Q?EYV4vfJJgfx78qDHquCGQCsgmIJSLcxehykYY2tvybMhwai5mnCb3VqP7cyK?=
 =?us-ascii?Q?OdRwr6dCDM+4UBKguqPRoJOJApLySkaqbal7KkT5k4N9sRVwFfGE5XwBkREr?=
 =?us-ascii?Q?bCDSMy/qqTnS30cjqVlpC7uZzCHyb/a/R5MA8hpPDYbopGcOOXJgt9v9m8HK?=
 =?us-ascii?Q?R6i8TqB8Xr65YRhPBvuBq/j7OCUnvpo83htPU25T2Yb+E3NjK3Xfupd7AzXz?=
 =?us-ascii?Q?02mTVi5kEeWhfX/7rxOcRrGPSkxlxKi30r+oQ7/Q5TkIvKRggQNgrutA63H6?=
 =?us-ascii?Q?+qkH4eYr6sEBetlMYlwKwEv7iFkPtGmtjkN3OReU1dis3nI0J22QRSGjV35Q?=
 =?us-ascii?Q?SFjZhKLqh8G1r4UNd7wIHRcsY0OjJZDYtvfZejBKr3H8ObO7TeOp5nQFu8Cw?=
 =?us-ascii?Q?vEdM6wgSnlSIFIFmNRpUydP/hbN+rHjGZfz3E7jMBZciddz0RfohsR2r1Upe?=
 =?us-ascii?Q?Baop258iwGE7GAzWdahFgqmU14qC9NT4WPK4j/t0jw1/k79V5SwhPvUbKHJ4?=
 =?us-ascii?Q?XnxI9sS+T8hDnM5SpSgrzn7H7RHIkXEpd1nRMQPJ55kZO3dM+aMu1GrScPih?=
 =?us-ascii?Q?WyXEW9101CTaF/ll0qveBBJPJ78s4vkMRXhalsie?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70fb32ac-b9f7-4058-1e7f-08dab8300ca0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 15:29:33.7669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0gnqpQhqfI8NZMpKB0zmB39NXhyxlSChXAi/XWM0vykMCSdxcxOfJ6RjePg32rLukwc09qUOB6j/JL+R/PQaLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5217
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210270085
X-Proofpoint-ORIG-GUID: qeTp7sdjT25mVRMQ2wBIJ-7Z_q3pBma3
X-Proofpoint-GUID: qeTp7sdjT25mVRMQ2wBIJ-7Z_q3pBma3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 04:58:29 PM +0200, Greg KH wrote:
> On Wed, Oct 26, 2022 at 04:52:24PM +0200, Greg KH wrote:
>> On Wed, Oct 26, 2022 at 11:58:17AM +0530, Chandan Babu R wrote:
>> > Hi Greg,
>> > 
>> > This 5.4.y backport series contains XFS fixes from v5.7. The patchset
>> > has been acked by Darrick.
>> 
>> All now queued up, thanks.
>
> You forgot to look at fixes for these fixes :(
>
> I count the following commits as also needed here, right:
> 	9c516e0e4554 ("xfs: finish dfops on every insert range shift iteration")
> 	c97738a960a8 ("xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush")
> 	5ffce3cc22a0 ("xfs: force the log after remapping a synchronous-writes file")
>
> Hopefully you send these later...
>

I am sorry. I will backport these fixes and send them to the mailing list
soon.

-- 
chandan
