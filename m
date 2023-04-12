Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269B36DEACA
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjDLExU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjDLExM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:53:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F985BBD
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 21:52:43 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLQh9U018017;
        Wed, 12 Apr 2023 04:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=+34qnlpbIzuz8I6YzJSWiJYXUW6+N2xTKKTxfy30PK0=;
 b=tNnCZdZHSFcgY4bTv4lIXjuzgb965sYp3G6Oy+nDHsVvfRWvA3+tTjXD/nNYiK6PqT0+
 GMfl0MpCRl057Hxh1Utn3Tk8qQJh5Z6SH79wuj579pcYsSrWpM6WSY1ZwStRw5KzgKCB
 LZfwMYRnll8ieMC9exQ/8uqt2lfaZYRrQTUxumn3dzrCfL2XGgbdLLrXuAbR0WKmjU6g
 /0ItsEYFByStfzVL8KVqO7jm6e4dgi/iPCNfWBv21sB5AXHxZgrTE8uW7lTK6QJ68T8G
 3Mwd+n7vBWSK6cUsT2YmZ+wbFjy5KbWrbRXf2YTjxqSsUtAb7g1UBgpTXVX9Ioo8loWT 3w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0etq1nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:52:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2eO7H009959;
        Wed, 12 Apr 2023 04:52:27 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw881adm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:52:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITH7/Deq0Vtxufup7kS6Zsc8Ijz+TSMX/5+LnRHvZzJhOy4xjDGi5oOATtTBd2Ft1PExY8loxdW1ooACV3Vf8KdpK6pL/12RFK487yvtTxV4duH5i3a1x2i0gRs5VYv7u8URNDPdNMzMe2mfhIu5JBVH3fCrM+bgwUNn7dYuWZCikY4ceKTdr8zL0GrP7H/h1JZKiHsq0O8Do3+TTtGHXeE2OjutnfI2g+/x6P7nxScAfIuCZDkEpB+rHIpyZUgNO4JxsyqfW3jKfysIFkOybssMYYkcZd3BvN4ZFpy3uEEG8oGC88lWPc14o2bmNiEaYZeSk7Mmzd8HCXsjXpFvOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+34qnlpbIzuz8I6YzJSWiJYXUW6+N2xTKKTxfy30PK0=;
 b=adz8vrO7F6AV5bf9ANl5aPqFyXTNN5kNzsffcrjgnjbakGQu+5ux2MjviAfuhBmPoTG/1AZeVUmSY4C8UYTnc1rE0c1KZCq8Z9yZPxZ0Osa4klWPSY0NY0RrXXbC3i0Gr3RjhT7z+caP/RZwUwZVjjhK5aprvNpLqC9lMzJprJ4DX8dAFI8rS4LK5731CV4cAx3Yej8zxf2JmIw/bL5LNsl+KZl1yye4pYZjM+DCy3EBsDgFRO67iqrlniEtRzkrG7RDeMeneFu+6io5/qmENVxkgPNGxQyaBlDefjfK+JIcgxdBaeZRltP/kiVdHnKmBFZ6yJgZdpnLJbeudso9UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+34qnlpbIzuz8I6YzJSWiJYXUW6+N2xTKKTxfy30PK0=;
 b=BmbI53NBkq9c8KsxK8Yq4UgmhjwgcjKCwkemr5wnSDAK5vuAk5yXeE/YIW9kRDWmXuKA93QKAlwpeYnG93pXBXECVA5+/YupkSzlI8zycTZDn2/RAC5q0iTYoYhuVoQ57AsYNhVxxrVTtIkD4pees1PpUkzvg/6S/ScutnDETvo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO6PR10MB5620.namprd10.prod.outlook.com (2603:10b6:303:14b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 04:52:24 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:52:24 +0000
References: <20230412042624.600511-10-chandan.babu@oracle.com>
 <ZDYzp9l2Ku6cbtQC@ec83ac1404bb>
 <87cz49lnjz.fsf@debian-BULLSEYE-live-builder-AMD64>
 <ZDY31JiLR2k0M2dP@rli9-mobl>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Philip Li <philip.li@intel.com>
Cc:     kernel test robot <lkp@intel.com>, stable@vger.kernel.org,
        oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.4 09/17] xfs: simplify a check in
 xfs_ioctl_setattr_check_cowextsize
Date:   Wed, 12 Apr 2023 10:20:41 +0530
In-reply-to: <ZDY31JiLR2k0M2dP@rli9-mobl>
Message-ID: <878rexln29.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:3:17::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO6PR10MB5620:EE_
X-MS-Office365-Filtering-Correlation-Id: d55741a1-be3e-4137-7391-08db3b11b515
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e2cXB/HjLDa4oOzn1HBop3976TIHb+8LinheygoC2I/dpbiVgADmojV4WT/db6jWprUS0O178qzb4yFrYbTKv2fZ1pfYHd/DP2unw/A/9x6YpWZyUGcZSCP2+F/HcxunQIg1xRozRnu4aVQ/eMjj/DwjFT6QeNBcWlrkCsDje/bUx5Z6yEbbuCGIqZtCnfBEH6h/OObRsuGGQKJI9A1F2G5cvhW+BMif7lSsMX0MAC+jjDoT5RGPZ4aK+I3dzMwRwVNbTfqueNiilqJyUtSGmabTYrSOVsU7wSFEew6FRouDbIRlMrqE5pER4MgWeHklz1KCn2jUYBVQxHtNJXb6ZtsEFfK9mF9O8oCSCQbLAgMV9lh06wRDcyPNpf1OG+YFSycBlQlJPSYuHTvmSWIE9YPnuKtE3Z7ixRwemTwObz85lgutpT0+VRP5BYZbca5bBQTFASe312i9A7FtRV/WyebCa5inO5D8DMfGOLXK5PXbPelLEZflNjNdQHiU+LmWQzTJ0Puta28XA1GQaY21A6rQEM4wXmCIWoB4pDe/FEbTF526l2ximcD9HMODh2Kd33HHAEMan6NJEY2Z7iMYAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199021)(86362001)(316002)(41300700001)(66946007)(8676002)(4326008)(966005)(478600001)(6486002)(6916009)(66476007)(66556008)(5660300002)(33716001)(2906002)(8936002)(4744005)(38100700002)(186003)(53546011)(83380400001)(6512007)(26005)(6506007)(6666004)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cCouThR6R1ujkRo7rwwdARiJChfn5Ch6qM52zAtpETTXAMUyHdvzqPJUNixa?=
 =?us-ascii?Q?/e2BMpKZ1SHymkzVeBitk558IlhMLIfAyVRS0NIPThyPNla7zt0sY24kGnlA?=
 =?us-ascii?Q?sFe8yKEOMkf7tn9Bj1b+xtvJv/d4z93LC0AGuV+VZ1evsw6GzJYYTT7eecMm?=
 =?us-ascii?Q?7Meqq/jaaDASFxtIe0LungNX2F8/tPDXy6NwPJN1XjsTYC+otOEnvK3pjRKd?=
 =?us-ascii?Q?8xYlu+28UumRySsVqiaR5z8i8CMYrrR4423GUgLUg+B9bxPt9kqLWycmt+PY?=
 =?us-ascii?Q?IPqf5oRiI7SSeEqhwdIwxFVrvV8HomYsJlaoN63AVT+Gvs0Lkzt9s0HuENOM?=
 =?us-ascii?Q?75PQKDrtTx5C/1Sn7q1Ds62wJvLRkcp6v2MvCGdqwHgZhbtgRkSEKR3fMvV/?=
 =?us-ascii?Q?kZDfiStMmk6aPiDNW3wLA2V1jzizrNoR/OhWesritkc9nbqmLW7KySDLQAzh?=
 =?us-ascii?Q?um1eQ3cFZtkt5qay3GSlIjfSwV2NN5zTW+zaHYRhvNf4QVx1eiZTC8V9tweo?=
 =?us-ascii?Q?YNVq70/k87YMFTM0y3v7f0cGD2y3iiweR92YuwxAn9TStX6+Ug/vv8lNpKuK?=
 =?us-ascii?Q?uTeCpbyxSTEykdEk13xHasEF5UPvy9RMAvb55K8C/sWD5IapnOqcy3+wzyTz?=
 =?us-ascii?Q?ZTfCe3GbNGepoSpinnk2lJhKqH4X6Da9mJUbPpWrBl0akf+mUtvnXgkda1OU?=
 =?us-ascii?Q?LfS8kKoOGhfX05GYHdtjDyHTccQ+9J0JChnAbpznrkmU4YltDBt2oauEKjB2?=
 =?us-ascii?Q?ywGYRtofvTEooUmo7lwjnqACp9jse8c8l51fgQQkr/w637ZiEXJBsD62p3SI?=
 =?us-ascii?Q?uFGCiA+wWJkEN7cDjwqE7kL+0gWUtrbYKf/DxRJy9TfeQ8JS2eexhGg0Hhdk?=
 =?us-ascii?Q?jqDeIzKa9wBZBVpVNfWW08dtAFCvC7VsVlV1usJ2COuJIiYwpa3a0MN33U0T?=
 =?us-ascii?Q?2YBqjJEAg0UJm9F8cTRunmTIamyLepWD2DWN+EhKwtOYbw9UbhQEyaJKbulQ?=
 =?us-ascii?Q?BFFafxaMc+M/bhCz1UHy4a+n9I4oUUfl6r1xkajnlFA7WtcfQPbcOi2dViJu?=
 =?us-ascii?Q?Vl6wdigu+SjreEr6eU+1yQdLIAr3zbiOoJU+oFcrFPytbT/ACamToadHS8d1?=
 =?us-ascii?Q?wAWvhvx/dBqGVlYqhZROSsnEhh8c2WuVVLg48Es+iLDl7CMSJRmuRAsLXiUG?=
 =?us-ascii?Q?EemP3c6Tcun2QGi1dOSY4TTHHbNtiahLDcJg2pBjdL7AeK96STWhVKxjCwGM?=
 =?us-ascii?Q?LBxweVvrs5QYyofCDTcMpwHSylsn2GeQAB4ZkwSs9ua+tTWyhooHP1n3TWK3?=
 =?us-ascii?Q?autZ+i/mz9CSlzGFFn3bJg9RHbnVec991AmMYZz7CtegHzFSpcjc9PFE9mGr?=
 =?us-ascii?Q?nR4T8mjaZrb4RXoE6ywKoCYMlTZAROUzu25pbSrU6c9Ch8bmNT3JPji1XNr+?=
 =?us-ascii?Q?B6nHqdhz4S+mWNBlOObdSM77pEQaS2CEk98QI5nHCgwP1OLiFDxJChliguOp?=
 =?us-ascii?Q?njmkOr0oQaQed8n6MuW9tRunEAUqIzIJtLuVYZQlR4NYnsvCRDzF4FgoAOd1?=
 =?us-ascii?Q?d9o+U9cnYzpwV6TZxGY3K1LCPVQQMtXB8nA95vpnd6H+h0nXqda72FJgnxrL?=
 =?us-ascii?Q?kQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XFbgJrRH3LqeQkT9cPJiUhkBfbSRxwYk0eckadkA/wbOlYlxhuWI1VZ8OcMbFd07CojWZoNiTOffNCTcco5SUvM1ivSR6VkyF0u/BsKCR/UzlQBKiPCsoXhzel1V9FvY7mMCgzjMrzlxjsfzRwGdXo+QJB3mcWih1Y3NToZYDA/zaTr/JBPpOEC9StaQVvg2g99Q9DRFN+sHyR6/FGFuxaqvRRJtlN5pkyjbpOpJ8BUzFjmCMkKSxNJTleQ3WjuEg7uIeA7QB+h0Vl7+PzfBSvMl0ozuM3yh0cqHQresROvF0CZtHQQdB8SvVncF8wJUF18eYWkdtbUCgT/oZAxIPPqfXysJtjKl+GMIYxMiI21C9n+2DzrWglAgx6MmTffXDuU4BqHFMtEyCBAKKP1E8ZR8l4H2yHu9CoMRZnjtmDCd+pcrkj7x+1ySn6YSqGCcX3UEM8Rf8FDg2ryL7BjgxlW+96mz2GxwOA1Q562ioD3fAQ8Tt4MBt4XjnA3tflV7G8H7Zr0blDEygu3A8CglBRDSjKTeCmsaMPCkePWt0zMhj9t4wln7MBDoeXXv9cPqtpfHrzTM1cMxOh/hPeFI/XqvbXpChBVBiy/dktumTNcbYoI4xLFkQPjpdHdJG7UgqS/ROpIW88khEyoUCJtCaA4VrYDJc97CxiGOJuJesFPNSBEtclHDD5SObWnJ3j6Klgx/IkH7ztsW7YeEK4dZst0XFXbMDNymMQQmDNLWoYC/gtnjNfH2RAvAdX52cHcSTPfHXtp0HfHwIfXWnfESsQytiho2msrIKK3Zxj3f2I4IWp2DmYsKjVELh+nMgsmCasNXgTRiPY6WRWuM1ZVXxA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d55741a1-be3e-4137-7391-08db3b11b515
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:52:24.2778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0UycyNvq6o97Ek26qN/wJYO6QHZzKGXYaUdiClTdq2KAgaCK+KWXib29dxs0+1VEmD9BAy7GUvyDlOnA8LvQTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5620
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=823
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120042
X-Proofpoint-GUID: u9NVMPoWA51xeKAMTaWlIt5TzR5Kg4Kd
X-Proofpoint-ORIG-GUID: u9NVMPoWA51xeKAMTaWlIt5TzR5Kg4Kd
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12, 2023 at 12:47:16 PM +0800, Philip Li wrote:
> On Wed, Apr 12, 2023 at 10:06:59AM +0530, Chandan Babu R wrote:
>> On Wed, Apr 12, 2023 at 12:29:27 PM +0800, kernel test robot wrote:
>> > Hi,
>> >
>> > Thanks for your patch.
>> >
>> > FYI: kernel test robot notices the stable kernel rule is not satisfied.
>> >
>> > Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
>> 
>> I have CCed stable@vger.kernel.org and also mentioned the upstream commit ID
>> in the commit message.
>
> Hi Chandan, this looks to be a typo of "uptream" in your changelog
>
> commit 5e28aafe708ba3e388f92a7148093319d3521c2f uptream.

Ah! I am sorry. Thanks for pointing that out. 

>
> Thanks
>
>> 
>> > Subject: [PATCH 5.4 09/17] xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
>> > Link: https://lore.kernel.org/stable/20230412042624.600511-10-chandan.babu%40oracle.com
>> >
>> > The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>> 

-- 
chandan
