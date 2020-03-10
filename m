Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEA5317FF1D
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgCJNoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:44:30 -0400
Received: from mail-oln040092065064.outbound.protection.outlook.com ([40.92.65.64]:21094
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbgCJNoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:44:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsjjE4kKS6KrTu1V2AsyqPh6fKHbdgb28cEziFyjxyRs30uGyZjpEFz4hQg5utQt6Wf7Gjm4z3XW3SuKo2t+6zZksneiPJJCSW4zJgpdDhLr/Dq9l3rfnEiFu6frBJWKTAkGFgKbRcFps8lLKJqwKKjRNHUwjPG9pbhbt8tEfiarxwDz/P6TTYg/lwRepWPUldDo7S00Dabq/5247n2BDlIEBur4WXAfoKkYQjh9Qww+lD3jwNMXG/IEFY0KVqhSr+7iDNa6/hp/u5ZCxF5gcie5IC0/yKSNbf7S1EX8QfHBpggkmiNDy4E0hwIu+tMgOFukJU9G6ECIKqoR146XRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLHW4bnkRE8FhDXjRsEkmXEsSRfI6uPgd9InYXaTyn4=;
 b=lxDJrM+xPKjfdADIHE6E+GE0b/6l+L/uPtSyXLyVWS3f0XJK/vC9yuNjcw7DaHFMF4GjUa6ci8Sa8mr5yUYUFjAI5PKhK1KFGjQ/0TdPnUX2FpK1+bHaNjo1/G6Y9pZxExGZcO+oCIBZe14D6x7mIxjyXG6VtEqLtJ7iymN2aatahD7gPPW7/n3yBmrS2LqIaVsSat8wQDiYI7CWSnDAm3Rgc6MIYYZpVZRWepQG9hY9tPGs9723VrFkVBu3L3jgvQJhq5iHJvXmCRsjUInTwKxgA9+HXgo7UFS/4Xu8sPvHVaANJpIsHCMKZnIhJzaT8ZtPGNpaBgValjRfOHKFSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR01FT023.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e18::38) by
 HE1EUR01HT184.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e18::426)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 13:44:21 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.0.52) by
 HE1EUR01FT023.mail.protection.outlook.com (10.152.0.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 13:44:21 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:7E750738653F338AC5481CC98ABEC498EE56D1454207C1D827F599A94EC87B9E;UpperCasedChecksum:546C79F509E24C24D31C77329F65014E73A7551D242F040C319041A4C5FA5FC8;SizeAsReceived:10300;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 13:44:20 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH 4/4] kernel: doc: remove outdated comment cred.c
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
 <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <878sk94eay.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y12yc7.fsf@x220.int.ebiederm.org> <87k13t2xpd.fsf@x220.int.ebiederm.org>
 <87d09l2x5n.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rq12vxu.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <877dzt1fnf.fsf@x220.int.ebiederm.org>
Message-ID: <AM6PR03MB517039DB07AB641C194FEA57E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 14:44:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <877dzt1fnf.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0087.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::28) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <26ec8f1e-607a-3464-e580-c68ae3cdbc70@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR06CA0087.eurprd06.prod.outlook.com (2603:10a6:208:fa::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 13:44:19 +0000
X-Microsoft-Original-Message-ID: <26ec8f1e-607a-3464-e580-c68ae3cdbc70@hotmail.de>
X-TMN:  [fGR2VABPmKiLligx1HY68sPKWOnof6VG]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: a9c155f3-bd6d-4879-c15e-08d7c4f922a1
X-MS-TrafficTypeDiagnostic: HE1EUR01HT184:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Zh7x99FEz4cVfBEjGLhgYuzTuULKoVywh+n1v+3vpN8MSa68Yfye2zoJeUA3axCxAweLjyZYosWdyZIXte1s1QjvucfKtOYxpzJUUoqCR0W+Dz/4YpkyPU5G7mKFRXrUuV3yNvNmK3xg6h5SF7eyJ2rOeTfgH6jA6VQi8uAdS8rEAh/rqHKV59rkWRzdGPo
X-MS-Exchange-AntiSpam-MessageData: ivLrgL/u02+FA2EPMhnF+65aFV1Qaky912d50Y5zLXtrJ+jE6gM09S8uzLts73rqNYJfcJ3RURUBl+wdBVZDwBdd3DFdie3i93MvOWgq+nVlQfJ6+7Di6e5Ns5Kprtk4GG2t7kREoSOzoSCc5YxSUw==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9c155f3-bd6d-4879-c15e-08d7c4f922a1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 13:44:20.5919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT184
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This removes an outdated comment in prepare_kernel_cred.

There is no "cred_replace_mutex" any more, so the comment must
go away.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 kernel/cred.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 809a985..71a7926 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -675,8 +675,6 @@ void __init cred_init(void)
  * The caller may change these controls afterwards if desired.
  *
  * Returns the new credentials or NULL if out of memory.
- *
- * Does not take, and does not return holding current->cred_replace_mutex.
  */
 struct cred *prepare_kernel_cred(struct task_struct *daemon)
 {
-- 
1.9.1
