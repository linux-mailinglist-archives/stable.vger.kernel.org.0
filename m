Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8016018D927
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 21:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgCTU0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 16:26:44 -0400
Received: from mail-oln040092073074.outbound.protection.outlook.com ([40.92.73.74]:12800
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726855AbgCTU0o (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 16:26:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1EYbEt3W4UaOwCVBaSWG4FmDFrp/JwZ4SYENyyttpG4yAkPyF65sigGQgggISP9ickYYGEgV20Z4kJypbos+XlBLiBmJIpeIKbKY+JpLhtzBNZ6+sZmIgt1MBtwi4+9Ovi7zXchbVpKv/t7RG05crmspppWuoZ4Ynelzn0gaMNd/8V0YvMM6rQSrixCKumhO8tkmloogJu9bSimo5vTxjWq9a1FRMynonLkWc6tiJn/6SYbKnnBr0FbSNvZC2F/MXT/93bATlNe9IyrUpWv/OWxzk2OkgZzds08GlxIQOmUPM6oLqwKPy7y3gFFq6ScggksOaSfA8t3sai2VK870Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WAEios10nMeycUvXAuwRkKu/z6FPhIvoF71l5/4VBM=;
 b=Gvv2rHJyh6bLBvzO0REPaTz2ZNzWj0wNZ9QH2dP2+XnxfnbZG4DIrPdB/yKrleFUwNONyyqhwdn5cVYkUYYo9BD3+40+1X5aRnqp/MwFHR4lk9So7L85II6+WALYhdAHm+Fqk3tzs2+XeHyiRnptyVvGNyvnmE0JuOxqZEL9UZO6uTFFJTE69SFiv6aQC39piPm0EJVzO3LsSNFouHXLChvY9Hwtw51pwkBFYeW1uzSpdnbmQPNZO/aSIIvcnnNpLGYl+6Re0K8l4N5BJ4Rg3zNFgn0m5nSElt9NHs1r55xjFYhf7sHOJ8rdkqamm8BfmFw4H+ZeIV1FODxexEucBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hotmail.de; dmarc=pass action=none header.from=hotmail.de;
 dkim=pass header.d=hotmail.de; arc=none
Received: from DB3EUR04FT027.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::3a) by
 DB3EUR04HT018.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::451)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 20 Mar
 2020 20:26:39 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.52) by
 DB3EUR04FT027.mail.protection.outlook.com (10.152.24.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Fri, 20 Mar 2020 20:26:39 +0000
X-IncomingTopHeaderMarker: OriginalChecksum:C4B8A6DF05E76602939B9C2840A92C28100B9893E303DE51A48F7311C3BC1C84;UpperCasedChecksum:3F37BDFA7D08737957B334CDC4450B8B72A0EFC3AA02706966907725BDFFB9B0;SizeAsReceived:9410;Count:49
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 20:26:39 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
Subject: [PATCH v6 08/16] mm: docs: Fix a comment in process_vm_rw_core
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
Message-ID: <AM6PR03MB517027F6ACBB4CF2D9BF014CE4F50@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 20 Mar 2020 21:26:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0049.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:e6::26) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
X-Microsoft-Original-Message-ID: <c15656ea-98ba-37bd-f5c7-780f53b42b35@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (92.77.140.102) by AM0PR01CA0049.eurprd01.prod.exchangelabs.com (2603:10a6:208:e6::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Fri, 20 Mar 2020 20:26:36 +0000
X-Microsoft-Original-Message-ID: <c15656ea-98ba-37bd-f5c7-780f53b42b35@hotmail.de>
X-TMN:  [O0UoP1nMdDd2i0k6pkmjCcNbj94Yz+BH]
X-MS-PublicTrafficType: Email
X-IncomingHeaderCount: 49
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-Correlation-Id: f924e2a5-acd1-4abf-64cf-08d7cd0cfe95
X-MS-TrafficTypeDiagnostic: DB3EUR04HT018:
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ttNMwqpPKJ7oLSN5dBuVUAB2u9CorEKrqUptxRV/rLBZ3OB3rpXZ6ZR597xj/G+vbxdF2XuO3BTeC/VBDzBG8N3ZLn/IsqNf7mO2Zdr/tzU/TwNdmfa+X7V5uYteMfW/O4PNaPjN7dp1Ha1N+SBpR0m6HqipIrzUjDvXl3mPS42J9XW9MnmpT0+C6UqjWwWn
X-MS-Exchange-AntiSpam-MessageData: QZW+cYFY9AA+5HK1Jm3SX7sdiIKEPys/NsdZrBflDxiAilYyyN2UcQw4c0r5VY+ywf8rCIoxAsCRj8Ia0kxC3m5B/qU1Wm4OHTdQf/SaC6wnMLnXEDtJZkW1DUGOTe69qbztME1y+tHh6FX/I9+6mQ==
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f924e2a5-acd1-4abf-64cf-08d7cd0cfe95
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 20:26:39.3578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-FromEntityHeader: Internet
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT018
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This removes a duplicate "a" in the comment in process_vm_rw_core.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 mm/process_vm_access.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index de41e83..74e957e 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -206,7 +206,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
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
