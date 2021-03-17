Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B32833FAD3
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 23:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhCQWLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 18:11:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36618 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhCQWL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 18:11:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HMADfe089737;
        Wed, 17 Mar 2021 22:10:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=g+C4PpMAyVQ7oN2PcDz/C5Bjww6w/dQDP1v816BvyMI=;
 b=v0RFd/W0SBcY8XERJ8JoU6gNBbuIXyAUsUjEV6WPwTKPo2RezsrQw3SofJSae7zB4/64
 3ePO3Tq/uodKyL8Z3Bp4ixXxj4hos3hK6/3qReQExyEKmlr2MLbyn2iguj5tBwHdIsIJ
 f9P9BWAdno5mqW4uCp23UYUTfO1PtRbuIXo0ERYJ2gcvvhC2IaQ29Lo3OeofvCmQBcb9
 wOZeoLv2hJzLOr3HNW++GB4QdEeXBg+uuS4jny/vDgqtAKJIzgesG9NaifoXTvmsuyaZ
 UmVPI9ca5tp4rIw/Y/+MUxKdo7xAXoSZ3uuQe8xXkCZKIm4wfOne7GGMoE2Yhw1Ih/t5 KA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 378p1nwn8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 22:10:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HM9rQR001885;
        Wed, 17 Mar 2021 22:10:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3020.oracle.com with ESMTP id 3797a34um1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 22:10:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIhJrIcqq+rc3XwjBIIfgbWBrPSecZEBPRAu90NS/g3WxziMAn3cJYHxzjqaxn7wCPn61E6kBH2YcEBVdgatC4DhERC6fDc/f2YjO5rsR8+u+1L1BGzfnP9g+exxZi+6IdU41Uqu/M7EN7850I1xBXiU3ZRPCni5HD+Pu7g0/9ShWpx+BRa4VBGtPiVdnVoRkgdDb6UadG0Hh8kx27YUB9QCYiMTy9l7g0uX3nXOpXbwihipMq0KKdacpp8sxpgw0yJBd10kJXCaNic7zsHReMSeTj4DA7dlUZ7cfLlCKfYOePz4tdW/iDg+g0P+r/4vHGV5XC69caXKPhBFCW/9Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+C4PpMAyVQ7oN2PcDz/C5Bjww6w/dQDP1v816BvyMI=;
 b=XR4qs69KcG83HTJiqBPnEVDe0d16qPVm1LViYbVkK5FoKhQ2tfvQIteABK20giupcOJp0dqOaVgCA+uZ/dnfHlIJWx0ahPQu9qK0OaaE2scUjqaKbqobXsMkt/IlgVZxUXSrDDztm1GxU9pYL8QVaQzOUv+7HQyyW+fk6ru0K2kEqAQD9YiIiJ1u9pA//spv9HV5DlNdOoserdzGMlfm/s1eKk9lUA5JkbHtMsFNL4wI265QQBn6/ZvvshT90UIrCTxoK7NVK5H/Apo+f33tQ5mRZ5Akdp1Rzh9rMQrZB7XIA/g0bykcg/rBfm7LlMdFl9Z0/wQIoda/kKxuYLyJqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+C4PpMAyVQ7oN2PcDz/C5Bjww6w/dQDP1v816BvyMI=;
 b=cXENOr7E4P5zQhrwhex0NA7QYnTge1T7uF/ZxSFslEORCfjEVn3TL5wIPyRT1a6I/Ad7Fa74YkJR6aX+mJ2Xk4Ca1mturRVzxH5g/vDvkOzkuv0h7dpouzvdm6C2Qzk8O6BFzq31O8rVQzj+849XOp6C7Z5doAt5j0M7tFb08Ts=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by MWHPR10MB1360.namprd10.prod.outlook.com (2603:10b6:300:22::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 17 Mar
 2021 22:10:10 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 22:10:10 +0000
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
Subject: Re: [PATCH 1/4] cputime,cpuacct: Include guest time in user time in
 cpuacct.stat
In-Reply-To: <20210217120004.7984-1-arbn@yandex-team.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
Date:   Wed, 17 Mar 2021 18:09:53 -0400
Message-ID: <87wnu5l9e6.fsf@oracle.com>
Content-Type: text/plain
X-Originating-IP: [98.229.125.203]
X-ClientProxiedBy: MN2PR15CA0033.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::46) To MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from parnassus (98.229.125.203) by MN2PR15CA0033.namprd15.prod.outlook.com (2603:10b6:208:1b4::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 22:10:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1a42ed7-2ef8-4bb6-9d66-08d8e9916de9
X-MS-TrafficTypeDiagnostic: MWHPR10MB1360:
X-Microsoft-Antispam-PRVS: <MWHPR10MB13608EFB7C5641C75D7EB096D96A9@MWHPR10MB1360.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cffrZ9R7D/gPv8Zug5FU4rJ8Nl2iK/XQxiob5HifzEO5ym9QF9ktkJam89Nw7UQ/ynF800uID6T5K7qfhKZXOAEITBdL6Zl9QSmFIIpqKv/fDrr/UZpl+5keYUWaDoeoX61KeKbUGh9NgxpvZgGD9gw5Rf3yUkMhtDyQDDBjPldpMAtKk0HRRDfEoaWO+Ur2bQTgVdNeFMrEU/U8VXPleA4JLjRnKVO7lIKSxdb9Uvw/gJiXdRUt0iRXCKLbagwBHBcRvFZ8S7H33bTtt1YBE+MIebKky270GqVjGqh8GE7gNya9CYfNAMbQV+E2d1jvQGXEApsQ5ipTYnnf7sjNs6ezfAgFBYIVjQtyMHbVc4TSSwcCwjYuAtvbr5EzzktFQXNq5Wr3Dn2Bog7kR6+O+Lw06UXkftdr77CCgk7RWiw+5eqRHVnObxwwqzfdMvuVm4Ptbvku65ExJI4IYW/qh9i4uammgsXfGK9EzO0tGkaCXRgmbMa9YrlXh3shOMsTTwQDUUYmcvL4qowylKR67BUTMVHwMKvQJANeRou5LL9AJgZIJgJd6+K4n3qR3oX0uQTMwIREoQSQDkxGiqJjhpeo3d4HMuFAA8PUtRI21Vc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(39860400002)(136003)(16526019)(26005)(186003)(66556008)(7416002)(66946007)(478600001)(66476007)(52116002)(5660300002)(6496006)(6486002)(6666004)(2906002)(110136005)(54906003)(316002)(4326008)(36756003)(2616005)(956004)(921005)(8936002)(86362001)(83380400001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?N00FTjR+c4Aqrq10YCXgPtDh1PeMgT8wwT8KX/v1pKogsO2YKnOTxchIwYK5?=
 =?us-ascii?Q?z79j5zgjoZ1jIKhgu0M2Z4GwFmykZW+sN55uyrYIAYPhTb4JWjt83u47/jz7?=
 =?us-ascii?Q?op0mtv59RPAg7YQ/zyO9r6kJ4GRwKMKJAFd30iBig/OVfPKDntJoJcsvCtGU?=
 =?us-ascii?Q?Ah8irLFBiv2PjrppJyAqcWif7sTVgPzXv8cnkz1T7wUutCpk5hlu1iXwUT5t?=
 =?us-ascii?Q?Ppy74hkAOzrxp1fnEFFOZ+dfmcyDA9d2QhGkSdIzNUy5CMQddYidNZJJYFj8?=
 =?us-ascii?Q?wwkY6/h2NPbp8SUoBJeqPsZhownP/rVjL0wXZKb4HJVmSDLvPA6dUdh0hEFy?=
 =?us-ascii?Q?YWeGES7GofxGqXjmnxVgQO2oU+lbj24jjjI8NsjtQTQBsw4CP4OgoUbqHIxL?=
 =?us-ascii?Q?7DQ/uXoDkRgAmZ+gePORU3glXXsEZlIbCzAkPgy6KdsOAxbewfyaKOEhyw+G?=
 =?us-ascii?Q?fin78CdlIeqKJILGqiCHnxpwhRfQ2usLoioQIK52CI2EH1vZkdqB38Q0zXc5?=
 =?us-ascii?Q?jxJLBplQvvZTXr3XFSw5TejxIdQtYI/il7q/vWACBtL9LVqVHBT2St0f32An?=
 =?us-ascii?Q?9GHUjiiSqprsfenbmKq7Y5hcbbYb6xq5/djkUV04bFD4DFMXtoOz1Zrc16zT?=
 =?us-ascii?Q?g2iloBdvmmK+ATzeJgQO3AXCrY6r41uHGrkrKZ1xdS7nIva4w7Rv2WimoxyV?=
 =?us-ascii?Q?NmI96E+NgpfehAGD5VyFwNULGBCia984D96vxdn+qwBsf7tWpLYcoRRjRPWE?=
 =?us-ascii?Q?vmHhdVEH08sEtxzKDaptfP1HbgIw1KUs0vOWkhVuH2Iq/6tw0VH1a4JHgT3g?=
 =?us-ascii?Q?qH5iI/5mYjeQnFQedieLUTX0rlXncc2r0Bjo2yahQ0HJjF8mYN3eRyMs29qy?=
 =?us-ascii?Q?x0pQGT7U5XAV/mvNCNTK6sfiuJugglKySsaKbXRr9k867+anDArhp3EMKUZ2?=
 =?us-ascii?Q?C8Pd4btJstR5vkxb0M3KWkeUpaB5KYUuo+5DfjPXPn4KQYWOYux9Mb9WJJCu?=
 =?us-ascii?Q?Skh3aiiQvHyCffNJvVqCMOwBVTTcdFmMUuvTIpo/9AlEE5Gvpq7uVx6wcHvG?=
 =?us-ascii?Q?GRQUE+wR3V1LEbqwKv2JUtDwuucRPNTK3UCHn7qOOROIpUvuNM/2wM4rYUde?=
 =?us-ascii?Q?Rt8yMIYzQ0yjOESaDExCHVAuxqVtZJO26vYG5zwxnj4gHLFNZCPrAEgFS65H?=
 =?us-ascii?Q?pnNW9ZP6qiRpS1bA67CpmCe3iO4XrAOErLrQCp2c9ZK5/NclAGPVgEqK2iYp?=
 =?us-ascii?Q?aUcFd/0nZFwfSymNB9a1dVl4OcixelPs4RRqpoyCStQM6mBvMj6Sz0P51mZI?=
 =?us-ascii?Q?NajHUjIAKXwwllrioJrvw/vr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a42ed7-2ef8-4bb6-9d66-08d8e9916de9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 22:10:10.1549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ks92tSKEbe9ByvbGZrV1WZ/MNszUyqiQhBeLZIHWSfprkWCYyZrdZ4b1G75GgV7HDsl47ofDgikYFdesRyHz0GrxTLRPjQxu2t3h/SEaeSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1360
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170155
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170155
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andrey Ryabinin <arbn@yandex-team.com> writes:

> cpuacct.stat in no-root cgroups shows user time without guest time
> included int it. This doesn't match with user time shown in root
> cpuacct.stat and /proc/<pid>/stat.

Yeah, that's inconsistent.

> Make account_guest_time() to add user time to cgroup's cpustat to
> fix this.

Yep.

cgroup2's cpu.stat is broken the same way for child cgroups, and this
happily fixes it.  Probably deserves a mention in the changelog.

The problem with cgroup2 was, if the workload was mostly guest time,
cpu.stat's user and system together reflected it, but it was split
unevenly across the two.  I think guest time wasn't actually included in
either bucket, it was just that the little user and system time there
was got scaled up in cgroup_base_stat_cputime_show -> cputime_adjust to
match sum_exec_runtime, which did have it.

The stats look ok now for both cgroup1 and 2.  Just slightly unsure
whether we want to change the way both interfaces expose the accounting
in case something out there depends on it.  Seems like we should, but
it'd be good to hear more opinions.

> @@ -148,11 +146,11 @@ void account_guest_time(struct task_struct *p, u64 cputime)
>  
>  	/* Add guest time to cpustat. */
>  	if (task_nice(p) > 0) {
> -		cpustat[CPUTIME_NICE] += cputime;
> -		cpustat[CPUTIME_GUEST_NICE] += cputime;
> +		task_group_account_field(p, CPUTIME_NICE, cputime);
> +		task_group_account_field(p, CPUTIME_GUEST_NICE, cputime);
>  	} else {
> -		cpustat[CPUTIME_USER] += cputime;
> -		cpustat[CPUTIME_GUEST] += cputime;
> +		task_group_account_field(p, CPUTIME_USER, cputime);
> +		task_group_account_field(p, CPUTIME_GUEST, cputime);
>  	}

Makes sense for _USER and _NICE, but it doesn't seem cgroup1 or 2
actually use _GUEST and _GUEST_NICE.

Could go either way.  Consistency is nice, but I probably wouldn't
change the GUEST ones so people aren't confused about why they're
accounted.  It's also extra cycles for nothing, even though most of the
data is probably in the cache.
