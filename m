Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DBC33FAD9
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 23:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCQWOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 18:14:18 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48614 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhCQWOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 18:14:10 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HMC9dk174273;
        Wed, 17 Mar 2021 22:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zGYuXZfD+zniSD/XaAZxvizQ5334X7661tTFtRc0g54=;
 b=RFlEBHmRZnhoj4yDk/PYccsESg4qawsvfwsEPpg5wVQWLtLPzWoYiKz+4q7bfDm6WrBz
 kO41shph65s3p/pK6nTLN2UBImSalbZ9G2vLVji+drbUfyjyzLBXD9TeW8+oljnYTlOW
 3ag2N5fzItNGlIblycWO1/XS2y41MnMxtrA+3vS54xXuWFVylUZiZJkUo2qbCV4tLhl8
 w58LBAZBPRjUVjL99XJ2vKr/bHZQH4ajamnLEDUkBB+hqmcbkN0JfJnU23KjW/hqb9vP
 Tn3/MfJQHwrHSvpxkjsyB04/IfUgxPnIQXHMfp4K0Fliq6NiaUBQ5ZSm2k1YM8kDcXEC 8w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 378jwbnrx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 22:13:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HMAmmu166051;
        Wed, 17 Mar 2021 22:13:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 3796yvcw12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 22:13:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jefzeGBAD/4bTX2QdlPHwn1ePVQV3UMquDH6ITQz1OtH3wZvethzkF3mYWumZex6QScOd0qQIcufWgmiH4VBuOtRnbrqUJ+z1eNr/bDOt0CDH88kHAVPJBX3Zxe0c7C+qsa6qt4WAVAYLcyv1OgMm5TAeNseT+9deqcLsi6hVfQKj/ak9bzMkADyQw1bG3XQ3ftEHsVkFLULvDZM9rcNfDGAajf9jKZh7VgtTC+rb2Lt6uVSB44xyvxWePZbH+LHP405mBrOSMHG6xJc46ApPs9buN9rARVNsXrDpw2tA26oHX71hd/yR2FdS7JeqhHIMhH2KpWFk2m6L851WGK60Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGYuXZfD+zniSD/XaAZxvizQ5334X7661tTFtRc0g54=;
 b=AWNiqWsL72g4LJEZvGmIBBITOiLzECRleQazs9hMz3UkO7ii38afBj8SUhYRdjsBWs3IM0Sy8rDT/y2Xv3oSbNnubTlBlD5C6AbXJ+4t/K6CsmZ7SuGYrX8tpCNoR97q9FAcOceA14DPdTf44GWKyhDF3Hwui8OReX85ecwbi9O5iDczodIVg6cVB/h5m/glt2ProA+jRRn/11/EGv31BISodDeZ98fE5QPbYrT3RiHqkB0Dhy3GQSM9HHPd/4S+RZ0EHywU6fssGwu39zUm0PWOWUMY1H1iztHCMdh0IlAcgU4Jhrq60XuG+E+VWQQhHB5WkYTgLBGCMJZNiuJB3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGYuXZfD+zniSD/XaAZxvizQ5334X7661tTFtRc0g54=;
 b=odnBb62aq8fyrOBrKwq2Wi6/UGSbFZA66iASyR5j4IZeHpuFcOdzPMk88MQQhNU8IHOsh35e/Wf//jIBgp2GlV9yprumbfnCLJJjligoy2Vzel93ppBDQMCl+isA+I+8ps7YXmch84RHtNHViUcq9AZpS8yaV5cLufQ31gmQgm8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by MWHPR10MB1551.namprd10.prod.outlook.com (2603:10b6:300:27::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 22:13:07 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 22:13:06 +0000
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
Subject: Re: [PATCH 2/4] cgroup: Fix 'usage_usec' time in root's cpu.stat
In-Reply-To: <20210217120004.7984-2-arbn@yandex-team.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210217120004.7984-2-arbn@yandex-team.com>
Date:   Wed, 17 Mar 2021 18:13:02 -0400
Message-ID: <87tup9l98x.fsf@oracle.com>
Content-Type: text/plain
X-Originating-IP: [98.229.125.203]
X-ClientProxiedBy: MN2PR11CA0024.namprd11.prod.outlook.com
 (2603:10b6:208:23b::29) To MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from parnassus (98.229.125.203) by MN2PR11CA0024.namprd11.prod.outlook.com (2603:10b6:208:23b::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 22:13:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1b4e3c1-f06c-42e8-252b-08d8e991d752
X-MS-TrafficTypeDiagnostic: MWHPR10MB1551:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1551EED4192EB01C9106A1E8D96A9@MWHPR10MB1551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQUYZ6YXeUb6k49kf+LHL5nKl+Y2wTD/B2f21oKnqPbZJp5CYpH2qycSI2P6zDhkVSc0B1PHpICVYSfdkAJh/Y9iP/zrcWWqgSuyblCiE+VTkwS7Re9PjIm09SV14JMLvqvfNYbJhAbZt+JWn5H0IKHe0TMHjOl01RPsEEerzGo2cCeRscSHN9TYByb/BzFQCqiZbR3YRJnvwW6I7yAUe1mHD1eq9/LUM8xSWZm5N0WfXajqfNCGoGXNE/u79val0KZw0fzrNunD5pMjIsSjch5TSzlTPbldWeRvZU8J/YXevEOzhGkOs8p5KGmTx+5pZAyFy21x59dKyGCpORAZmN7Ql7Eq5Tt8LC3oFGrtX31hUAbx+l/rz64iLB9TqcXWbbkFg7cOPeRKTrJhrBUErmHyZTZvERtzPVHOh/4kKh9NGKVEgoq36hsoQ91qaD23sFHIDWRgaK5nRAH53P69Om0yJTQ6RCdoqacfK8xgXqylXU1HItceEvA9WycsEXrOAth8icdOyNJbFFpexspNL/jQJQ09R/m520EUHeumYjWpKcRcpppNkvtlWL3LqLNgvpk0UJl88Fv/gSJlKb9fv/xBJGDX0DWSkFy18TAne+Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(346002)(366004)(921005)(86362001)(26005)(8676002)(16526019)(4326008)(2906002)(83380400001)(956004)(7416002)(66556008)(36756003)(478600001)(8936002)(66946007)(4744005)(316002)(6486002)(52116002)(6496006)(186003)(2616005)(110136005)(54906003)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?h0Y1WqB2+zDudwahBAP28G4yLCsQpH3u/fq9mjq+BTFmUds7MCmUm5Z6VPcu?=
 =?us-ascii?Q?V2JyoO3ctHDFwmY79wibsDfT1N3GsZe428wV6ubpZ389BNGLm9u0tHaeDDum?=
 =?us-ascii?Q?npIu7bSIzHQW1ipQkEJogHctonlk38XA+a4G2U5vERYsVbD7E3qQD8Dg8SzF?=
 =?us-ascii?Q?KOTte1Q1RVT58OpM9VdxAxmyexCuse2ND5FfXfGkionKI6e5ixsxTaEvW7QD?=
 =?us-ascii?Q?n9nlNc6H7Tkzqm0ixIpCwlrtAJRnAQL4kmSCvexARienZrB3OFP6RuXCgwFu?=
 =?us-ascii?Q?rIdC8NbjwN+rWNqBMhlpMw6OB7CkohF/0VFHvMwaKOagawmndoxLZVQxS6Cj?=
 =?us-ascii?Q?RpFA2nBxos9weiB5EYP6uyed+proOY0yQ1eXMRbdXQ7jTTB2SQNlT7PkupQJ?=
 =?us-ascii?Q?NmsrFo42LB3vhFGs/h2fkOK0n9diY+TGt1BHz/o31Io5GvyO5qvIPfcXp6V5?=
 =?us-ascii?Q?PWvGO88JRGCRfcWzJMqPxg+BWXeaOcXEvtgljjMubm8vdGO4u94E9WfGn3th?=
 =?us-ascii?Q?Ry6QqSobth3Jh18GAonyN0T9YSM+lH++m57w5Pofm1ENLiyMvSmeLSKvAPBL?=
 =?us-ascii?Q?3nSGxQoqwwMIzOEvk5PvbaIyp3VIIEijUUDKX3wVGAUUTh+ctq27d3RLhUTM?=
 =?us-ascii?Q?Im7/wj8+Z9vo21FscEUNxWDTfyCbNWTYcT2GKKmYjz9iaurlZHGdy4vw98kL?=
 =?us-ascii?Q?0NilBqCrVRnwdC33xfVbp429pgHnbuunaB5pBqwv8xQdTRb0riEPln4JjNa7?=
 =?us-ascii?Q?YwuBLOA5jgw8yWvAy7WXBfc8xhtL3wggEFWNXQMVODFU5Zfc0Kjq9I6Ef+e6?=
 =?us-ascii?Q?NVstL+6uEc/gvrMNnyqfk7e78I2eYfGBfitY5JtM8g2ehvzeLxFQoUOLelNe?=
 =?us-ascii?Q?Vwx4q3IoELBGT9Brl015tlAs9VEG54i1TX40H/tHoftsJngjP5QVQUYDzgqC?=
 =?us-ascii?Q?CGELhFozewYzCRjpApT1hM29SQuDCQTwtegqOgg9Sm6qQD4P6srdeT3AmrV9?=
 =?us-ascii?Q?naZzmB4C1u+axXoyx8q7ZjVdEI6y30Y0Se5VZlX2hGshTCwKE4I2sx/CcllS?=
 =?us-ascii?Q?a9RRgpXE/YAStJBTw3if7+wgh8t2jzgD6JBz11KrsOAf7EwXOZBDcgAnEALv?=
 =?us-ascii?Q?IIbPzpx+bsI9zbMFacJ0d1YQ8OedPub9cISE137hSVpCJSsbCzPWhd4YvmIY?=
 =?us-ascii?Q?qfGoI+LtXhXM4b0wCU3fKBPWpyYafKVTb8dfyrXOB4SJPKYvKzzendlIK8pj?=
 =?us-ascii?Q?VqdlqM4yPCcwapp2GHRCPM3ujEUXS1Ac321LT8MFZp+dEQxbn34vFX8fTkg2?=
 =?us-ascii?Q?KOePdmWplLChQPRiUhjmdOOZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b4e3c1-f06c-42e8-252b-08d8e991d752
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 22:13:06.7268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Vgi2tHX57Jz/7KMy4dUsY2FOexiIQBEmghyRQLfXhuThuf2oa+wQ1N71dRMEMFWcfyQeZM+UBCzMY0IZouyopSQeWrq7i69gWGcBvKLA6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1551
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170155
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170155
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andrey Ryabinin <arbn@yandex-team.com> writes:

> Global CPUTIME_USER counter already includes CPUTIME_GUEST
> Also CPUTIME_NICE already includes CPUTIME_GUEST_NICE.
>
> Remove additions of CPUTIME_GUEST[_NICE] to total ->sum_exec_runtime
> to not account them twice.

Yes, that's just wrong.  usage_usec looks ok now.

Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Tested-by: Daniel Jordan <daniel.m.jordan@oracle.com>
