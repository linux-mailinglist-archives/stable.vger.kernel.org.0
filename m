Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C850609068
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 01:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJVXZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 19:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJVXZc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 19:25:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983285F23A;
        Sat, 22 Oct 2022 16:25:31 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MK1v9l020290;
        Sat, 22 Oct 2022 23:20:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=JKxkD6kKz5XGAbb87b/Tl5JzkK3P41662kDLuC2e2kI=;
 b=HDgQB6DWDySotGnjUQV3fqhRUok3FHU2J6Y5wqqpuuaf0uN7xk7MkBZZu4/WtV/6GToo
 ZUQdVR6/yTsrmypP07Fe94WMvNJwG+BhtuGgjJpy7id77uPMmcfxU8TvCddUlhSSpy+H
 HMLOtv3z2N9VP3t8x9SJqTOOUAb00I7q/77OxEzphv4whZi/h80Uns7QUxU9dirKLkiU
 8AtnLQWUj3227e7E+gUT53Hbxe6MhiAIZCRBCRGa6RMcW5Lr1OKmj2gQo/G8kpiWBwl5
 5wKw/frP08nmO2ItMSDhRmlC03/ei9MLyM/djJMeG4iBuOfeBhihIGCpTjtlg8EoWL3N FQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84srwm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 23:20:04 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29ML6emm015353;
        Sat, 22 Oct 2022 23:20:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y2dyxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 23:20:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGo0oyfVXa0b3P7CEnUu98eOlhpNQysfelbAVk7ZyHZAff6FfJqrnNEaXUHxjZhlc7S1PYQksF11CCfDbbQ12sokROxrK7/GcxkTzdRjUJM7RgCrAhm2jWYKZlNoOPwNFVyNFV78P79IDwF4iS/NSbwEGvFuArQFzzZ5ZaXjN9wPoabgrebNpFsWAaAEm3kW39p5u2v4uRKwB1O1z89/zCszhJQGYT6J9EEOJ3mSfmlzBpZJVKjs9H5H6aus2Wm3LJJJEGF1nmNbUCwJraxQScoczyTEz7YwdXeaRCZFc0WMl9N6pMuNThHvi7vkfl1YXi80By13jqOWP8e05mWFxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKxkD6kKz5XGAbb87b/Tl5JzkK3P41662kDLuC2e2kI=;
 b=d1ZCE6f/QR9xzzlKLXhc1F2LcXSx6eNmMTBmv3eTmTYroCYvPvk7jv3ZPgZCvqL9/Cd/T+OeKcXs2IHXN8b3ydmm8VSrfu7IN5t8HNri2klTvq+kdMo/YE+10hWq4odc0BPbbPdQTY8miPvRJ3XJDNeq5YMMlFYaUFZwCRyw3cJAYGbimoJlWTu0Ka7XCLKjS5rBj1buB0unXTydOF6H3zXyK5r5GRox45njntRnYYdNFueXSa+Dg33DGSPSl6oRjIREOdQzRPEj8fzAVTIfZhizDUPmYaDVzokveFLYp8sLKF7wVCIVqe07lf6gcaSQxEYhv0sty6/R66UiGyDSLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKxkD6kKz5XGAbb87b/Tl5JzkK3P41662kDLuC2e2kI=;
 b=p1zKd+jPdn/GHI9W8fBOFVzlNjSXz5gqyGcmXF1WXAbZILE8ir4Y/Q1gpPT5POazTG8VVsRYa0wRQsi1hyswCvwM9n5wqWCNP69wQAJs7gzvVF5xS541BJQdpcalxdCyYX8NGIvJ+M0XcuezQv+THgsCK1NDw1I/+f8A6QZ/wuM=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BN0PR10MB5319.namprd10.prod.outlook.com (2603:10b6:408:129::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Sat, 22 Oct
 2022 23:20:00 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::5f85:c22e:b7fa:21bd]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::5f85:c22e:b7fa:21bd%5]) with mapi id 15.20.5746.021; Sat, 22 Oct 2022
 23:19:59 +0000
Date:   Sat, 22 Oct 2022 16:19:56 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     kernel test robot <lkp@intel.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kbuild-all@lists.01.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED
 processing
Message-ID: <Y1R6nKdWb4hNA/sA@monkey>
References: <20221021230722.370587-1-mike.kravetz@oracle.com>
 <202210221005.gYJlzVHS-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202210221005.gYJlzVHS-lkp@intel.com>
X-ClientProxiedBy: MW4PR04CA0319.namprd04.prod.outlook.com
 (2603:10b6:303:82::24) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|BN0PR10MB5319:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b1e74b2-c6aa-49df-182f-08dab483f08c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FzY2Ovqr9iTArLXq1FkgvMs8paoies3QyHt9EmAk/nHn5RIsnCouAJQExWOHXmMvxmvOkiNOLb7uSiuB/imkUyJUD0nDLaPEFd2UJCzSzEXDL19dwqrXfFg2+Mzit5XBmcPMhiRLGUOrgRkjZxXvMTntSyM8VBw4U5r2HXlVsJZ7GOkKdaHK41c9Qi/K9pEotmWR5UIdgzw6VFc/Df6z748cmEtdcx+bJ9NGKpW2BPA0LVv4OORz+776fLQzfUs/PKXVE0yIywItuC0YmeaSCm1tAFXxyf6rCuubwROOsRaDzLqhYcj+T8OHQdD7DKh+xCWtsxTNHZ3VldNY7vsugBVg0XM+SCcdcfLUSiC/f53geleGK9XSLjpBn/sV7xnAIoTr9MvTtJyirI1hS2cqZn2tccNpY4PMwf4jeJYt475hwqFOfpn49crPvQRc75bmyY9nHCf6BsYJIHMZsdmbqioid3l9/aDysM1eqo6IjFgXaWsSwb3dMEcRo1Ux5eHEbqTe+5jwAOyx0h7jYm6irJnxeW5NWO1hiLnrVBgmwWgV+k1M8p3oj4ZBpAWRby0QpEn0xebl2vrw0BvKgm221mSX2TZGHRXWxWQI3FNRlQrLXXQpi/bqGuw+Bn40uZmu6kVlBQ3VmwDUKF33FiPGzD5KmzIYe2S66/XwgTg67iutRmAyIJDgdgopTlqKWfciRVHkx+isHpW89l5gHjYtU6wTKKd76LV1hivwY2hIb8CXG5unQdqt5ZQy1IeOYYweS+3wzoP1vE2ZhlzxeKNsfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199015)(6506007)(83380400001)(38100700002)(53546011)(8936002)(9686003)(66946007)(4326008)(66476007)(66556008)(41300700001)(86362001)(26005)(6512007)(54906003)(44832011)(316002)(7416002)(33716001)(5660300002)(6666004)(8676002)(2906002)(6916009)(6486002)(966005)(186003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+2lbae60RNlEWsZO7kADoTtRGOjawmXUH29qyOL4tiMg7m94pzfW2kmpGFl6?=
 =?us-ascii?Q?hymXDnpPNXyaNuQCEf0avHOS2NUJT7nE/ifi5Fu8MjXKXKenhJwCtmhsSwMl?=
 =?us-ascii?Q?RDYC6DVbQmis5VU8ChBH5ragUBD1LGNO6WOEhrWG7DUTBGbobXMYryKsDhZK?=
 =?us-ascii?Q?4Q+HuXIbgwdE6g9FjkKraX1MXtyyq6d6hJblRd76f0oWawKKz9QjO3VElLQJ?=
 =?us-ascii?Q?J3v03pWaiCKccgGXH3+yhk5bwmqSN2s6iXB33FkHEzGinvS2iowD/f11TPyu?=
 =?us-ascii?Q?ODZ1WiG4BXYPIrrt1al1EHn6qj9UrOh13lD8fB7jOQwW31i/FblKBMQ3OHGt?=
 =?us-ascii?Q?wd1WMvorOf7Fx1OQ6MFxzg2fEs830FNl/lr/Ypb3WfrJSLVZuO+nUQgtifGS?=
 =?us-ascii?Q?5PnHIDHlB+hXfMthYrEZmmP2UdR013cfOoJ8BPHVTRqWCxkP+npDzQOWi/GU?=
 =?us-ascii?Q?C8Bmgt4NmjFZqLb5donH3rzH0kj75ZSwr+voYIYimB9oCK2vWDprTZYJg5Fi?=
 =?us-ascii?Q?gSwsgU9t4jwrNGawrkCHc5net4j1EjjlN+FMwsVzh0M1CNjZwKpxmh/GjC1m?=
 =?us-ascii?Q?5m7P3PvJg+cn5iizorvn1fidXsDAJjJ4qc/0W18Ci6pSUrotYfDMDsliAtkZ?=
 =?us-ascii?Q?Dix81nV9NWVitWhx/qMkxmJQWOGoZ+FgkFKDerdMLQTkrE1wskGTcAaL7C+5?=
 =?us-ascii?Q?A8G2IZzayPyipRK2YQ/fFmCa9CY1K1W7KFsJNmSYp+D2ziF4hBSBnmUTLDHH?=
 =?us-ascii?Q?Vb/a1SRA+Kl9q30rr+cvqyYBuqMqmLrPbF0T50brM4C8vwJnX3x9NDwuvpwi?=
 =?us-ascii?Q?gVtsvxBW8vqCm9VfzZKF7kcQ5EDW2pEjfGtOgKXgb28NhyyCYDgAKTcR4OIW?=
 =?us-ascii?Q?LICx80extSzUwtk+metEUF7IuGIG2baa64HaUK9vrzNL80NvZ99PAwjCMdsK?=
 =?us-ascii?Q?1XMlkq4+QzX9Q1cEImLdtMrFEVVLjHtbk/+zJV6G35WMnlCwUeRp+2FZKVAW?=
 =?us-ascii?Q?60b53nmUoSurdxosBZmRcihOmjOkXRn3DWl2T14sFSM8BZ+W5iSXL/JnAGE3?=
 =?us-ascii?Q?itLXEW6wjEotXuuFXsyFGLDM5vlrNzlLBtZAdeGSTZ+WffAcxFax1cICPs6s?=
 =?us-ascii?Q?6H3gwIr/aWmzCvx2L5NZeoab93a8Dn+1Nsd50Ac6iWmSR9xlGF8hXqBGtos/?=
 =?us-ascii?Q?Jrn2vOp+EuImqDY3ZW7FcMXeHLUOBijFH9OnJqdj3yX+EjGLCsgzmDpVIV/f?=
 =?us-ascii?Q?edq/SR9BgXgladRNUzNRf0hfCYEEnMkuDLz+iuLImTfpX/ZupE8l61wvUFQ2?=
 =?us-ascii?Q?8SWYj+Wr8TDuPMJW9NucOi+HBnEnrgso/BewaOQYxTFJJ26MQ9U7FBK8Xb+x?=
 =?us-ascii?Q?MkCjhBSubM0501+xVm2sw0qenzMl/to4Vg0S77BlD+Hztq7UXpE+hYVZ20mu?=
 =?us-ascii?Q?R1vHlbiJ+jy+DKV3rh59jMQgKcJE2qTL6fu/o6mKKccp6IdDjtpyomk44F/C?=
 =?us-ascii?Q?idfMMt/+AFjc/m0WarcCM0O5GML3W8SjDLqta6D6ucYLeNqxm9Ac3PiJhcNJ?=
 =?us-ascii?Q?prdOwFxt9YLeykKkTup6LMseH3qbg9R5uIdVIWa++bkHA7Ac0i08QfGWnGPr?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b1e74b2-c6aa-49df-182f-08dab483f08c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2022 23:19:59.8118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMKRqz/K0IOa/FJJ5Oi/oKBjabbP/iE7nL+rZ1mHNrUv7n+f9hXXmAbSOhBT8G7mif/tP5tSF/E56u8GZTOD+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210220146
X-Proofpoint-ORIG-GUID: -grTO9U68b_A-1A_S1Z5VhX7ZUd7eeeP
X-Proofpoint-GUID: -grTO9U68b_A-1A_S1Z5VhX7ZUd7eeeP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/22/22 10:45, kernel test robot wrote:
> Hi Mike,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on akpm-mm/mm-everything]
> [also build test ERROR on linus/master v6.1-rc1 next-20221021]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Kravetz/hugetlb-don-t-delete-vma_lock-in-hugetlb-MADV_DONTNEED-processing/20221022-070934
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20221021230722.370587-1-mike.kravetz%40oracle.com
> patch subject: [PATCH] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing
> config: powerpc-allnoconfig
> compiler: powerpc-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/b52333ec636c58b31a006e7b4a0e6e9f1280ceaa
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Mike-Kravetz/hugetlb-don-t-delete-vma_lock-in-hugetlb-MADV_DONTNEED-processing/20221022-070934
>         git checkout b52333ec636c58b31a006e7b4a0e6e9f1280ceaa
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash arch/powerpc/kernel/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from arch/powerpc/kernel/setup-common.c:37:
> >> include/linux/hugetlb.h:431:13: error: 'clear_hugetlb_page_range' defined but not used [-Werror=unused-function]
>      431 | static void clear_hugetlb_page_range(struct vm_area_struct *vma,
>          |             ^~~~~~~~~~~~~~~~~~~~~~~~
>    cc1: all warnings being treated as errors

Wow!  I was unaware that madvise could be removed via a config option.

I will soon send a v2 with changes as follows:

- Use __maybe_unused on the static stub in the !CONFIG_HUGETLB_PAGE case
  in hugetlb.h.
- Wrap clear_hugetlb_page_range in hugetlb.c with #ifdef CONFIG_ADVISE_SYSCALLS
  so that it is not included if !CONFIG_ADVISE_SYSCALLS.
-- 
Mike Kravetz
