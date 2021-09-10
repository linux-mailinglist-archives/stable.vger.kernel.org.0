Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318C94071A4
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 21:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhIJTFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 15:05:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:5252 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233038AbhIJTFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 15:05:30 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18AHO83I023952;
        Fri, 10 Sep 2021 19:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=DNkfUGSbpjIuVqk5Z5ogMBzidSNn4HDkXcWuWjMkuPY=;
 b=GKMfc2YWGGuQuDLPnozvRVPsrVq+tPttAsxLptDLOmNpqNVPYFB9fbHqYV8o0FchU1VJ
 zk7ZfW9EMNHvYQBXdstrsGLW0kwwat2JyA3cKhf/b5Kht1MD0S1VsVjtRJ2PSdB7zkk4
 NTZPK/K0KLOOeVFQgQsVyVDJxKNvzUQpgxvzsV9vRbDWewrpgZMQDYw6UJNp7dGTWNLA
 gj+/x0J9qtV5DmpDPONOT78iNloB5VHt3MA6yrzAasSVhGtnOK8fKAMmmnzYZ8elscwJ
 V7QHM9ISpqu+FXw64y5z1LZf+pho1GLSDAg/91ZOOpJ8ybserI0rArNhFNy646rySlsY rA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=DNkfUGSbpjIuVqk5Z5ogMBzidSNn4HDkXcWuWjMkuPY=;
 b=tuCILJlVLTdDZMWHAdlxwZMY+8UQxqEwAe+o7kj2CJabHtjVW+5mTxcMG/Bk+9KGSWGz
 YMfqzma63AjJSZvJRRjZDmsDkX0YCWsmwLSWBrubp6JB9cccudbWj4a1tLra3y/Gh8XC
 Z2YMBXEhIkR+l5rNOV912chiX6143Jg3silEcjr+I0MSCR7WYQxvFjkRIj1aaMvkbq9J
 Jo7zrB5Akr3EvXyfwYAIAWL6XiHllBEheis45zCN7VeP/8EMIoD8weim1psqzoi1bS3A
 evyuXUezedKFu1AaoOKT2eanQZ8/8CEe31xqYTYUXN/ySpszXdIT8tjsDD69+oubGJmw Xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aytfkasdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 19:03:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18AJ11V8110116;
        Fri, 10 Sep 2021 19:03:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3020.oracle.com with ESMTP id 3aytfdsjvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 19:03:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtTGhCLhY7oDRdqNFVVXYVnroudxJO0ampMSU/izGEJp9i0XfNeFndyo8GpoEeCn2Pi65Q4veFDXKfaJ+cWpVqDS29/kzNPAXeL64yhzpxxrxqOfFg8UEnX+K822bFsI7h5LyTyPSZxN3/SalSCyBP0fMgKoZ51qW7iOB88lVv78g3eM+Tr+yGcqLM0xbaaVN88hoW1rNbCVhvLOvpuPaaxneeKQsMjiCMUvXUSV4y8CE3k+HXZsHJPB/+rvfxbyYCIPsbrErp2b57+z10FEXmsewdTPYAKssU2AAcFuzDoX2UjgBG/RIzxvJwLUblknIsjiT8NEuqZZHyDiKvXC2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=DNkfUGSbpjIuVqk5Z5ogMBzidSNn4HDkXcWuWjMkuPY=;
 b=oYh/WWdSbcEFV9XY8hF7+AnneUapHYHlS0aPZ3faVMXOW9y0SqNOS5tbBjaBjlyVXCO7WjyxM8hBScYVjZzUoL2NDHSqAmw218bIhMHpxXhTcPNXWmklr5hxI+nEC15ka1IUMkuBYMJRiumd6fNOQrVwOWTjfVObk+udhOPmFFA56tfK/nr3jqVrEBxel66lKELVJKkqxjHqHNCx85cYzvsT5MNWIqgjPpcaOAk1PfVQj6g4SQXcwBka+KCiao6uF83/h8jquHMnAe0nW5BO8UMh7W51g9zCckBBcYZH/4d3mgYdUGGp3CoYVG382KFQLJGLmPfnOBYZbclTEDdAvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNkfUGSbpjIuVqk5Z5ogMBzidSNn4HDkXcWuWjMkuPY=;
 b=LybJcw7cvr8ltYeqzu+y4m7VFX/qpLyeugDjiPHwxNtEHpqAhxlzkXCB1A8yFJGuz2faIIQSX2sWh/+RBgGnaDTLwFZiw5/l1lMf4RX1QM7CRrSXRQ48KNgJNwHIf2jOI7/YDafmUuLCoOO6DiL0kfI3CqGcs+jQUuTl6Ybb2Zs=
Authentication-Results: yandex-team.com; dkim=none (message not signed)
 header.d=none;yandex-team.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27)
 by BY5PR10MB4386.namprd10.prod.outlook.com (2603:10b6:a03:20d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15; Fri, 10 Sep
 2021 19:03:31 +0000
Received: from BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::a01b:c218:566a:d810]) by BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::a01b:c218:566a:d810%7]) with mapi id 15.20.4500.016; Fri, 10 Sep 2021
 19:03:31 +0000
Date:   Fri, 10 Sep 2021 15:03:26 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Andrey Ryabinin <arbn@yandex-team.com>
Cc:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        bharata@linux.vnet.ibm.com, boris@bur.io, stable@vger.kernel.org
Subject: Re: [PATCH v2 4/5] sched/cpuacct: fix user/system in shown
 cpuacct.usage*
Message-ID: <20210910190326.nwv7kktt42nucoit@oracle.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210820094005.20596-1-arbn@yandex-team.com>
 <20210820094005.20596-4-arbn@yandex-team.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820094005.20596-4-arbn@yandex-team.com>
X-ClientProxiedBy: BLAPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:208:32d::10) To BYAPR10MB2966.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::27)
MIME-Version: 1.0
Received: from oracle.com (98.229.125.203) by BLAPR03CA0035.namprd03.prod.outlook.com (2603:10b6:208:32d::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 19:03:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 736f820e-e5ec-4468-f863-08d9748dae20
X-MS-TrafficTypeDiagnostic: BY5PR10MB4386:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4386788C862842007D00BC30D9D69@BY5PR10MB4386.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rr3WRUbKloQRaKWoxA86tD4pC97eCIVRo7TVDCvv2FeeCuwzshe9V7ZYTUVfX0hp6gkKtq60zQT3Go8f+5d9rJ0FzmvC8IJluy3/9CrAHoKS4ymxKajc8b0Hv28G8+Wa3vm86T50t2EmarfjPhx6oM1zxotFxE++cnlYKBEek/tG2WhU/+nxjA16aZOeqeikwLTLe8QZwVuhcMoCUSreT9HyuPXOfEupYKk1rC3ycF+VkP7F6mscouVZ9y0wMtUCm0MMrTJoo9dFF+SCqyywSQ0RTb59XfjbC8pZjtl2jpRF5IQYTQkSTEy8ZfpID5U4NmJwA/LTz1RQo/pmmfAh8BZdGdmlsKVzj7yTBiwvK+nJQkzbydUqrQM3TojzBHIBRlaOM3UUGhaM6OXeOAw3SQAvfPv9TaH6JVE14jc7Q7SsjfXWpQk4j4ffYmQCNjXyzst4WoEwq+NYmiEmeO7LlDp6fC6G2h7vE8xfBDAlKgMxAa7mowI278sLA0sPe9KPpmEgc8gzyByWidu4KcyxsrKXQf6zEMvZcRRV7HpZnKIfq6fKFDuZbu/nLkPLrfKYeUpy2k4eF1guoUn0TUZGUyglXBX5s5RG1peVjLjTaid7bb7eGYqHj3Tqjy17AwQRZFcMMljyRFENUAooBB90tXggmLiOXEdpuQOAKyMPVvFHkqUzjcK5yi8PhOWi2Q7ddYXklKJYhPGmXWsoi7FYkjeRFXVMys0YxHunFYPB80KNlTFaEeY+KUly9fHtH4OXQidCHhOm6ZTfGk9OrSFavo6E4mtXpL1KWpuDT2j3Z+c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2966.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(136003)(366004)(396003)(6916009)(966005)(66946007)(38350700002)(38100700002)(478600001)(54906003)(55016002)(86362001)(316002)(1076003)(2616005)(956004)(66556008)(66476007)(83380400001)(4326008)(8936002)(6666004)(186003)(52116002)(8676002)(7416002)(5660300002)(7696005)(36756003)(2906002)(8886007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bbV+WYwdsh94VqmgXnYDQFIj5nbulC0ARDD2yC5piMDa4Jb5stCm/c59cKrO?=
 =?us-ascii?Q?yI8Ii31oPoNuXF1sG4w+Qj3FLy6uYk7xdhaG9X6EVvShhi04BDT3PIokMA43?=
 =?us-ascii?Q?FI8eSld1UkBIrb/7cnQHw+k2UDRgLJYeCsC0crMG4JHxB4RGekx1PwauURA7?=
 =?us-ascii?Q?3FapPdCEiFMQLvXW9B30dJXq4lbJNsiaDmLzPqnqu5SSPmt6lmEFUQSa08l/?=
 =?us-ascii?Q?rgNM2g0ONBGe5EYjiimOV9uS+v2WPO7aZycAL5oNEibv/TgiQIr2j6zU9liU?=
 =?us-ascii?Q?Rki+8y1oilbyubJ9PXIqpaIyjRupY9hFS3zsm2vIbkkBnKSwCWU+sq+lEkvi?=
 =?us-ascii?Q?baX8d3dg1labY8i6vDRlw981Bkl2/qbPUs3/mCQQg+fqu6Xwt2ly9CE83fgk?=
 =?us-ascii?Q?nHbAU+Plq7MX/PdJnsRVi9oDi61/5icRHaPyxcqatxyYYcqTFSvxqCUHP/ci?=
 =?us-ascii?Q?2OjxyIU2n5B068sIXTkd2pYKoI2RuflAL36jAPpP4S8Dwjjujd3vxTX5nPaS?=
 =?us-ascii?Q?u4lMZCYZ2vmi6xS8CsQjbh8KMEVsWpAT8rFjUwHKTLoEnJ5FIsELvSzRwUTq?=
 =?us-ascii?Q?KV6A8yRZt43Ax7QKtyWMDppgrg0yH8M7PQUo+qwYe6QOPkzjp8poypvBh0Ul?=
 =?us-ascii?Q?QiF8xhXcZAUzwcxx9aHP4Z+RZf9N67FFKX94Of8CHV4h/5QaECVuq4T3283L?=
 =?us-ascii?Q?h5WFzEU85afnWvkqhtld51OHbxwV34kM7r53lpgfx5siVCyCveH1Qcr/L8P0?=
 =?us-ascii?Q?3Z0ROHXJxEN1Zn8lCnntliuluSo4UcJXmbHv6EOEUGgODEnwG4QRVm1yO5+q?=
 =?us-ascii?Q?k4Sfh5I5ginUbkLbId87mT9HoHc8iGIzgs8DlmKuwhO5HbIrXAGatkABR7s2?=
 =?us-ascii?Q?ichtIeojbyAj/HjS5hWobWzUDxKj43Kl+5aPByjng5sFKnKQPlnFwtzyadek?=
 =?us-ascii?Q?ydWi883mDv84tH2rgRPB8I4FY3F315C4+5rNqEX9hfc6rl9FhzaRZmkWcHo5?=
 =?us-ascii?Q?HRmhwFEqNfWdIZcPEcVhBGj6nbIqmZZOFidbYKsdGhbyFQetizkQNLsCNJiT?=
 =?us-ascii?Q?pSv3bQ6PrtPEx5VykcSs1ssGlFnTauA9ZZau2ebCs8duqplIpkEyRtXPZbmH?=
 =?us-ascii?Q?eUV3jM47BrNHV8HFuKY3WYlNjHQOtYUzP1aU/cYa9TkSb04WMc0ByOvIVm3B?=
 =?us-ascii?Q?PKGzZ8pzly0z8xG9XW1MEEjKgHvoZM9GGzp1uZ7A43i1YEwgXbj03SNlQN/c?=
 =?us-ascii?Q?qudKygy0MSX+XuD31JHq/S93HNalboTqxN19CIpBk7zHSgclYsmiI6RMJXJz?=
 =?us-ascii?Q?kcdqcDYn34Xo73ZhZqGoBjMP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 736f820e-e5ec-4468-f863-08d9748dae20
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2966.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 19:03:31.1822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UaL02+ckm2CYAQ42fVgX5VgX6oTFRtzgDiJscEsg6uCqk/9dAF8cX18ihVhgUvRY5kgbC/36Dcx5Jzi62qlNmWlD2QVv8YDpUSQRWL9cRdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4386
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10103 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109100110
X-Proofpoint-GUID: x1pMJYLwp1wlDtPqn5XpY_6eoolRfD2Y
X-Proofpoint-ORIG-GUID: x1pMJYLwp1wlDtPqn5XpY_6eoolRfD2Y
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 12:40:04PM +0300, Andrey Ryabinin wrote:
> cpuacct has 2 different ways of accounting and showing user
> and system times.
> 
> The first one uses cpuacct_account_field() to account times
> and cpuacct.stat file to expose them. And this one seems to work ok.
> 
> The second one is uses cpuacct_charge() function for accounting and
> set of cpuacct.usage* files to show times. Despite some attempts to
> fix it in the past it still doesn't work. Sometimes while running KVM
> guest the cpuacct_charge() accounts most of the guest time as
> system time. This doesn't match with user&system times shown in
> cpuacct.stat or proc/<pid>/stat.
> 
> Demonstration:
>  # git clone https://github.com/aryabinin/kvmsample
>  # make
>  # mkdir /sys/fs/cgroup/cpuacct/test
>  # echo $$ > /sys/fs/cgroup/cpuacct/test/tasks
>  # ./kvmsample &
>  # for i in {1..5}; do cat /sys/fs/cgroup/cpuacct/test/cpuacct.usage_sys; sleep 1; done
>  1976535645
>  2979839428
>  3979832704
>  4983603153
>  5983604157

Thanks for expanding on this, and fixing broken cpuacct_charge.

For the series,
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
