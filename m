Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9364317FF16
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgCJNoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:44:25 -0400
Received: from mail-oln040092065093.outbound.protection.outlook.com ([40.92.65.93]:1430
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727960AbgCJNoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:44:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sl1pzjcWcCAjORhMzuZiyBTO4IQsilHSu35OMLyxm7hyCTxgIiGSxWiItSCqBvn73Vj9gRObFAUzWTrmhyp+x0vc1sHAzKLSMdJAEJKI62kHnrRH19YEp3kuEtWWiJATykAxrq4pHYkId83Bw0aq3dizSiIrfT+75BUNAONjPVLo+VkF2gmwA+Ya7xlYNi3riarH8gZuILS1namfXB5o7oy7HmcOgVsMAFRlowclx5lur5ctJstZz64rgWhi0tm3bC4ns59O5Kd4KbuZcLD6JzbeaQhSlZ8E2jhL9OTPHeFbaaJjiTs5NQRA/LgyZE5H9tkcT5z8q4KM5XrrSCw4HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2w8kA7nLKYjr/MK4h5dN8RjAmTZ+B4sZ3UgM625k+BU=;
 b=b47lIxAU05mVuxzjPXolJzaBcZ+Rwr10CmqQzHxEviuqlENdah51P0yZpAqNbYXG+P1uikksKhXOu2GWaTviTJUtkxxH+vCKam+rTKYk48qCH78HK6dsAcRQDmun/gtTSFnItLmSJRFS8N46rtWWzGJU73MFltaqebRlFK1h44RT7Swmj80HIsA9VM7FIELmztOIhr9QD4XOMr2Xid5uE1tqIu58ikgMNNt8PmIP/4UkSWVMnBoid8EXjISGyb2vw26r7MFg6DqjHOneGK43Xy6C/TaBjzQ1PrZu7QSg4uYSu2410UqIYO1NBT1LvQ4N4N/zLMwwH+hGVD7ENbyyGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from HE1EUR01FT023.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e18::33) by
 HE1EUR01HT216.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e18::148)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Tue, 10 Mar
 2020 13:44:12 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.0.52) by
 HE1EUR01FT023.mail.protection.outlook.com (10.152.0.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Tue, 10 Mar 2020 13:44:12 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:6255AC3CD9C92B5085D302A02A35C3F6AD5082CA0CCC66D0E1AE69582A61805B;UpperCasedChecksum:20184F13FF5AF64CED2BC2E1E6DAB499BEB0726D53FFF67353B79512D3E0D90C;SizeAsReceived:10302;Count:50
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 13:44:12 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH 3/4] mm: docs: Fix a comment in process_vm_rw_core
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
Message-ID: <AM6PR03MB5170ED6D4D216EEEEF400136E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 14:44:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <877dzt1fnf.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0090.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::31) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <48be4849-1122-643f-27e9-9492d91fe89a@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR06CA0090.eurprd06.prod.outlook.com (2603:10a6:208:fa::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Tue, 10 Mar 2020 13:44:11 +0000
X-Microsoft-Original-Message-ID: <48be4849-1122-643f-27e9-9492d91fe89a@hotmail.de>
X-TMN:  [ou9ZGGBPhFouFQZnEu8wqYJoBb2ouIxM]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 50
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: 2ff791e9-35d3-45a1-b815-08d7c4f91de1
X-MS-TrafficTypeDiagnostic: HE1EUR01HT216:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wXQ1zBznHkv1PjDrUBH4mBSRIhF2dhDZJ8QBuylJ4H0Gq7tYmiYjYEpvVhpr7K57fttFWkvNPjMzHipTksw14fIySYkXDBAR3hfe1ljtPVOndOFmVJGLYB+mWyDTdOung30+y/K9bfb2wPCBIrDLumKhQkkrz5nscdJcQIo92Qv9uG8QXDDx2OeYpwdmpIug
X-MS-Exchange-AntiSpam-MessageData: h79oXhRy4jHWMXqaLK7+2Py+QC4kP/nvQxmnMy6ZHDi+IZ4bY6IhG6Do8ITWzfF7qdFUTySBVkVRsI1/6/8M0seSQWzOAG85lO0KUe/jmSNnHGxVyWaytuSZGaBXgYxOup+hpxns1a8mu+QQKTEUjA==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff791e9-35d3-45a1-b815-08d7c4f91de1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 13:44:12.6825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT216
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This removes a duplicate "a" in the comment in process_vm_rw_core.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 mm/process_vm_access.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 357aa7b..b3e6eb5 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -204,7 +204,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
 	if (!mm || IS_ERR(mm)) {
 		rc = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
 		/*
-		 * Explicitly map EACCES to EPERM as EPERM is a more a
+		 * Explicitly map EACCES to EPERM as EPERM is a more
 		 * appropriate error code for process_vw_readv/writev
 		 */
 		if (rc == -EACCES)
-- 
1.9.1
