Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1DC18D92F
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgCTU06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:26:58 -0400
Received: from mail-oln040092074077.outbound.protection.outlook.com ([40.92.74.77]:27486
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726789AbgCTU05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:26:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0wNIxvVwlPSxE9GCH1Wm/nPzFaqW9AP2wnnihfO2CZnlMV7NNJQ1v17zfGLp3uheal6ZjGndDHyrpQov8m8QygLlvvXFI7sc/qH80sNYb/RiCFYghBRsOd5BCI/tTaToZb3bxOjKEyvhIAzg7XkBs11XxS3252E2OHf9OS7ZhazU3+HMA52XMFStY8Nrg8nGZPCi/InAAscgmEPBqyKDO7imTULVBK9fe8586tIqaY+kMUeng+LIqQ5ChxRWmO//DJ05f76deTxnw5kfe5ug1YYszvF0Is42ie76e5MTpyOP06kEufo2CENGTFnGI1q9/rLDZ/PCIAkbRsZyz5B6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpPIWBM553stJnYfPnlGbAKN81TYnG2nSTD5mtmPrlA=;
 b=nqgwM5SPdgs/RjOXJlqODU5HSTk5OhflVV9wpG9J2gJwAQ9LIVWnhAUKPJm/7Wfjb8p0Ud2Nm1pfmL5RmVhK4b0Y4Rcmx1YOROAwKEt3Luy8UVlYn0P1O1gShSUqME3ukLK9VKADv7xmUxenYkbXDKwFlSsotv286/wqrMAQDQmqqGNEyvUvoGKOqAonXQzvvuFNnds2yzvY37Km6ztU5z2tjaFJaWPccwH/Uw73ATMeCsCG2iJKhH6PbDvm5o3XKOQGwb2zz40GtMfA1iAwF+NLr2fZFBrx6BvMcjhe8I2BH+3yikG319Ug3fBJ2p/jZt9A8QPFhPi92Mtn9YHaHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::3b) by
 DB3EUR04HT092.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::240)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:26:53 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:26:53 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:4061BB92384CDEA684C84B58E3457B5C76473096AFCB5002D2639E2BB6CA153B;UpperCasedChecksum:63A3C0299B4706505D66FC3814E4FFDDBA902DA0AABB32D778CC2218BE7E54BF;SizeAsReceived:9417;Count:49
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:26:53 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 09/16] kernel: doc: remove outdated comment cred.c
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
References: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Message-ID: <AM6PR03MB51705CEFAB7D02E6EA6CEBA6E4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:26:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0064.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:e6::41) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <8671c24a-42b9-f92a-dc36-113dd21f7370@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR01CA0064.eurprd01.prod.exchangelabs.com (2603:10a6:208:e6::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Fri, 20 Mar 2020 20:26:52 +0000
X-Microsoft-Original-Message-ID: <8671c24a-42b9-f92a-dc36-113dd21f7370@hotmail.de>
X-TMN:  [oUNEAunj85Er7VY1+p48LIuwnntnObg8]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 49
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: e66d3f46-03bd-4698-a004-08d7cd0d0728
X-MS-TrafficTypeDiagnostic: DB3EUR04HT092:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7sI2X4qRaZmDpeiZFdf/2ECDI0HNZa4mbO21sKEfCanlJyQl0KXzA9GNJXPlOM3CUAzIJy5/VJg4U84J0sui+zTrQ25B+222axWvQKBS1C8s6Gp0yKMYdPuIIUI3lwV6ZXN09fKfLF6UXWVNEyVbvS6tuJPY1ALqcX4rZN/m7e9R5hvtMX6dR9SHlvJbcWef
X-MS-Exchange-AntiSpam-MessageData: tmQsxmFL29R1TflVrtmdbcdc4X6iauHN2XBnAt65+16FGkVkLvnXl7pXGGcuIJqRSdaRBCbDo5A17omWfZQ/tlwP3WVIMMJgdvxf+dqOfBBcOmLFjhTFxV1BmVgajgKXw9zZsM73cs153jJF0jp5yQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e66d3f46-03bd-4698-a004-08d7cd0d0728
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:26:53.7514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT092
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This removes an outdated comment in prepare_kernel_cred.

There is no "cred_replace_mutex" any more, so the comment must
go away.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
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
