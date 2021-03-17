Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5741E33FB0D
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 23:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhCQWYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 18:24:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhCQWYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 18:24:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HMKgI5106921;
        Wed, 17 Mar 2021 22:23:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=LA5ZAQhYLUaED6CdchMqR50MvS+2+CLaZ4yN89QwO5Y=;
 b=PItloUqEikd9la4gfSg3nDRFUk2fvjs9jt29zNUbROCUHmJ2VtPygsEYO3Xv9Gba4yb0
 2gyGdBLE0wwWY3Su9/jqPGWjr2QB8mF3uhuiQgNp3218bHAiaHaHn2v6Ol+y1BnLAb4q
 2xIgWJtoD5PJ8IwIJWZ/OuZdoC7OgKPhX2aRPoj/dngy6ZejUUy0+dKaDZ/ZYEfeVp+6
 uj9uvttAOgAQ7Dnt26TUVM5NcTV5+kkpeDyZudemZgC+bAU+3q6Vlw8qco5VbGsD6/Uq
 MytuI/QT3r621nE6Lrmu0wy4lQkeaxTo0GZzQP7/fvFyHX2GJrEcHoOjIbM57pXbIUA3 ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 378p1nwny3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 22:23:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HMFTkR171083;
        Wed, 17 Mar 2021 22:23:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by userp3020.oracle.com with ESMTP id 37a4euyapw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 22:23:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CubsyRVnG4ziny2+xdD6HJHSZQAWqLrqPlz6uDjbbqyT2CFHjZje7QS4Mh1rfprVcLAG0MM5UZcP4QG8Ipx39LiwhYPoH1mGwqn/kgAfENnguKpbR86tRu8J31o0peKLMZ1ymRYzznVx/b3eUB4TUE5tvaPzBlCn7TV8CVs3BnKKgddpwiVSzfomA0ZY7sKRA/QxNFFurTaQilIswUd59lxR8mHZlGQ1C2LCW+4/2nwLbBAM/YU3cqaanUj2hMi/2TJlm8TO0eMZKOsobB9UDAG2RbaeYj2/15xN5MkJ0NKHQymjc+zDO8EnaGDmqiR6VxJDa7mfWKs7uegsTkHhlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LA5ZAQhYLUaED6CdchMqR50MvS+2+CLaZ4yN89QwO5Y=;
 b=V6g2q4YClS7qrFo1z304uWKQ+G8O9n5XxWo+TiuDCUoarL6RbHO5jCzBbhMuulhOGM2wYqahMnZbDFGp9PEC+OtxaYVtaiIJgqq4p0T95Rzgt7uhqaueXGE/UXJ5ncT8e0NAM4dzbVKsQtgiFaPowRA6Ef/HybeIVZu6tj5CDNl4SP/dsfnLrbU78Zt0K6NL5M/7zOnIcR0w803cVk4uofTOlnIbfNVD4KvSeuwX7vAUvErnfNRAq/lmSH9+Y2aC6smbiPa1dgnI/ZjnXaj69gW6fz8w3cPhaB8SlWgkEp12t+yPFC0qi8C0+FwePY3E2TW0GfEjYaIlTcwjejAOFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LA5ZAQhYLUaED6CdchMqR50MvS+2+CLaZ4yN89QwO5Y=;
 b=NWofWmnJCIIU36S436WsIIdhhvj2UjxVqR2C8v8DXYmZ4/uEvyRJvY6S44xE5sKOo3ggPvxNGf+Tj7mgfeFuq0pNtiIFsT6RaxNasTrFoYh6PW44N+515x/o1nIjnATHXwiLobxkQ7lDqN2BfeTN4SNDEjlxYF+Ek4lrrwu2dLU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by MWHPR1001MB2158.namprd10.prod.outlook.com (2603:10b6:301:2d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 22:23:01 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 22:23:01 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Andrey Ryabinin <arbn@yandex-team.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Cc:     Boris Burkov <boris@bur.io>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <arbn@yandex-team.com>, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] sched/cpuacct: fix user/system in shown cpuacct.usage*
In-Reply-To: <20210217120004.7984-3-arbn@yandex-team.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210217120004.7984-3-arbn@yandex-team.com>
Date:   Wed, 17 Mar 2021 18:22:57 -0400
Message-ID: <87r1kdl8se.fsf@oracle.com>
Content-Type: text/plain
X-Originating-IP: [98.229.125.203]
X-ClientProxiedBy: MN2PR14CA0025.namprd14.prod.outlook.com
 (2603:10b6:208:23e::30) To MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from parnassus (98.229.125.203) by MN2PR14CA0025.namprd14.prod.outlook.com (2603:10b6:208:23e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 22:22:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d5a702c-f9e7-4bed-f585-08d8e99339a3
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2158:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB215841F95DEAF3DABF087AD6D96A9@MWHPR1001MB2158.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xNqbbNtn4RyD6S5MmkHk7hon8DBIErvoI9oLwB3Nmb6HIuvDDaqiicVRorEtVcCi+VV09cb+NPNW5arDQiPNwj2lnABO4ueeAMoq7k2R5RCto5Kk8+ul1R8tLqBokgi8rBD8+cPcia54bi1miSOCb5espTxEuPiYIGkLPPAMRoLdRot1HJfN9DcKASaTbzv7f02f7V/yAgAsg5zzwoLdXojaW4c6y/eaSlwxmrsPyln0YBC9wqFK81f8WgW10V/H6M9o++Sgx9du0y8AlPjgReG732obvmWY6rr3W/oHgQFYr/bVXf/NVy2bJGjO+h8Jnlf2zEdBMZT2ji99fMGi190LXdTKb6l2lUCs/RxU2USjF99Po0vqh32IU2Aw1yYj+hJwqwdKVk9A4zer/53Ci1ju/JptH+dFV5WPpf6XbvIYT0WsQgWRIDgXu3ff0hMYwdwdG2f2tRPazEYT1oCB1XR19b/H5y4z9LH3hZW+iyofgf/d5DcE/owzPk+vt6p6ucUUKwTB1LxA19PhaFEbO1igayVZDzqKge7CDY3w2LuQeIGfJ+0DTR3asvCNvi8kHDAibyddpSRrlRoOJknCuPzm34F+0ZR+zJE0q2SLNCI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(39860400002)(376002)(396003)(54906003)(8936002)(8676002)(83380400001)(16526019)(186003)(110136005)(921005)(2616005)(956004)(86362001)(26005)(6486002)(52116002)(66946007)(66476007)(478600001)(36756003)(6496006)(2906002)(4326008)(316002)(7416002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JBfFGn0NBaokKMlG1afG7raG0fdfZIyU5ssXCgn2Iu6U7wUHq0KwuTaz+ufm?=
 =?us-ascii?Q?yZ/+tD9kaFfxkRHBOpEtG5qVsqb191ecs8gVqVaroGiQ0+247MPJSOSurJSI?=
 =?us-ascii?Q?7UchwiSaAocuGmPqxlIbdu/20nfjBoRUJBkNT/FGhpepU/DP2jALOH05d7ce?=
 =?us-ascii?Q?fTK+4z1gRjepaR6YLs03jY6kHIiMZAgbfXEPFARNnMMMZacVfGw/HCs/Gwyw?=
 =?us-ascii?Q?ScWurHHYpsNJ16IuKm/8dmQdebCAezSuR3yMrxfglFeMqq8MfayYJrAumUw8?=
 =?us-ascii?Q?Ul+yI6J8ZMOh+9kBiQsWsbFsGZsasiK/AauZzFMqj8oI684JRoZ3jgstG4QZ?=
 =?us-ascii?Q?Y6LimAmzCL3kJFvWSwDYSQSOHl7Xi3wgGsuM3ILSaEHDV3qOZaLpjPehvH79?=
 =?us-ascii?Q?iSaHzWodXVVGSrxxXJIz5hrl5gnHkJPQSrePpArCfNx6Sx9N7erTBaEm9OiL?=
 =?us-ascii?Q?HKbCNaeSlC3w8JFguOyW6yXUPXBVtot5x6dF0ytPT3HR7feIpYD+jVo3qTub?=
 =?us-ascii?Q?Sw3WAGVvUOycUYMBqd99JRaqC3FKQ/vuF3BQjGNsQDnNc8d1z2f4nLopEpRX?=
 =?us-ascii?Q?QrgmGEUBnlqrOyYr3qO5Ly4UMtXPTmpWbGwarDnhS1PD5R84ph2wm0iJ8aZP?=
 =?us-ascii?Q?I2Ig3fLugry36n2muvDdFMtTNYV9amkxczbCrIeI59ETmqommC+FQ9XlS/Rj?=
 =?us-ascii?Q?1A8nKyHxHLek2F3ix3THindEIpwX1GnjpJnXEcLLT0SyoOI2RxpZ976CH3d2?=
 =?us-ascii?Q?AyPg6tFFLJFPIiVwegNrp9HzJgAs1Fxr18zlDhfXpu7aZ7mcQ6bkiWyAU2+6?=
 =?us-ascii?Q?CuhPgg3ileveb5Mz/g7T8W3HlgRc6yCs3YicHnfV/GdN8uQxxbIuH96pDQv9?=
 =?us-ascii?Q?vs5T0yZr6G1XVBFXzKc5TCKvkA4+qlc3Zjz4nmDqvXABgxNUxlXUmhuWzy4T?=
 =?us-ascii?Q?4bH+htBjQT194FwNT4O/1LvTUTxQVb8hA1KXQowlXeS1NNNzOW75jzHj1E7n?=
 =?us-ascii?Q?bM1FLtNqb8fdEr4im3aBKiVxnsOZzNWU3T9OmsjtWLCyKA4Bep/wRPO/d5t7?=
 =?us-ascii?Q?2/yOO6tMrjFEQSs3dL2Z2s8H3o9r6Sz5i1GYYp9d1RPb20W6BzXX/6G2pEJJ?=
 =?us-ascii?Q?BOyIxCuwqcmuh4Zu8HUO8VQyqkp70UajK1MUlRylZiNNvCqQasI2fK4f4IIn?=
 =?us-ascii?Q?Harq9IlEq2xISFrSMog7o5IqJYMiXoM4ki2T9frNQdpDoOz2MVugFDpiSSiP?=
 =?us-ascii?Q?4syA60hGMIG5Nne1DUmBqnBDrJRzkZqtU3kdaTXPOOyLKnC3CNkbu6r+XRl7?=
 =?us-ascii?Q?ms/buTL1ES9ysoxq+KJkqogb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d5a702c-f9e7-4bed-f585-08d8e99339a3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 22:23:01.2764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dRVkHb9+6CF992agMIlYbPTqTSb10EJahNNghTYSKvfgawWEZP7qyioWW3Ml0w1LOyO4fD4pkCYG+ctX9mM1m7PXZwroa6PAbKKbaTkxIes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2158
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103170156
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170156
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andrey Ryabinin <arbn@yandex-team.com> writes:

> cpuacct has 2 different ways of accounting and showing user
> and system times.
>
> The first one uses cpuacct_account_field() to account times
> and cpuacct.stat file to expose them. And this one seems to work ok.
>
> The second one is uses cpuacct_charge() function for accounting and
> set of cpuacct.usage* files to show times. Despite some attempts to
> fix it in the past it still doesn't work. E.g. while running KVM
> guest the cpuacct_charge() accounts most of the guest time as
> system time. This doesn't match with user&system times shown in
> cpuacct.stat or proc/<pid>/stat.

I couldn't reproduce this running a cpu bound load in a kvm guest on a
nohz_full cpu on 5.11.  The time is almost entirely in cpuacct.usage and
_user, while _sys stays low.

Could you say more about how you're seeing this?  Don't really doubt
there's a problem, just wondering what you're doing.

> diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
> index 941c28cf9738..7eff79faab0d 100644
> --- a/kernel/sched/cpuacct.c
> +++ b/kernel/sched/cpuacct.c
> @@ -29,7 +29,7 @@ struct cpuacct_usage {
>  struct cpuacct {
>  	struct cgroup_subsys_state	css;
>  	/* cpuusage holds pointer to a u64-type object on every CPU */
> -	struct cpuacct_usage __percpu	*cpuusage;

Definition of struct cpuacct_usage can go away now.

> @@ -99,7 +99,8 @@ static void cpuacct_css_free(struct cgroup_subsys_state *css)
>  static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
>  				 enum cpuacct_stat_index index)
>  {
> -	struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
> +	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
> +	u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
>  	u64 data;

There's a BUG_ON below this that could probably be WARN_ON_ONCE while
you're here

> @@ -278,8 +274,8 @@ static int cpuacct_stats_show(struct seq_file *sf, void *v)
>  	for_each_possible_cpu(cpu) {
>  		u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
>  
> -		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_USER];
> -		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_NICE];
> +		val[CPUACCT_STAT_USER] += cpustat[CPUTIME_USER];
> +		val[CPUACCT_STAT_USER] += cpustat[CPUTIME_NICE];

unnecessary whitespace change?
