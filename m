Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72CFA17D3C8
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 13:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgCHM6j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 8 Mar 2020 08:58:39 -0400
Received: from mail-oln040092065065.outbound.protection.outlook.com ([40.92.65.65]:4559
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbgCHM6j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Mar 2020 08:58:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTOrKTspOKyvQYkVi23/gFWakov//Kc6b0t/jpVPhxsCVEHHwdCL9/Iap3kbpwibTK7m8hWjw7tL4IbsXsvd8OwdnDtuYds5RInkSC7WvaKX2p975j3iqukl2ZrTMkZxz9E/zT60sUh45J4v/lrGzM+Kmm0WOOeL6UrLBiShPrOrbMX1/JA0/XUIqn5VsARcrTF69nOVzmt04O6kVloMFAtJNWiHIrnaz87s8cFq5QGczzWPdZRukkxV80/VXqXUcoA8tGm0CfCgu7pIngl70psHg3kv5GzvNZKA6hzyiIsSeJBF9SGfxdHT1h/A8tdAS157sdsyd0C0E0iZ4yUK0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/9Aakd6wMlI9i+v8qvX3GAes78Rrq/6ZPfa1pAQvEw=;
 b=mHLPtR2r8dAMgB7YL6IBvmmZ8AzR7DL+BxBQtEja1OYdNopkDXJEB81TLsFPiUCDnXNsla7aIXJgvkxyd+30ONYySfURKZd6n85ghlYBNyful6LU37yq0ieTiYWfTRmP1zr/y3/O5hyz6wqMyp+NmYVJUapUVsej4ZkI6G1EXuvor7AnPc4ADpMEPKLvqxIQURgTI+tbZ8gPGV28AkmCiQzO4IhLSfcYsoxBdcxJE9RywfSKbKmcOQkwCxje7Zy0kSCce8ceF2io/Ak5Xk0zq2E6BOeSNC7PV5ZavgpeYliAH9aFjWG2jBBCN2Q7f1F5MU3Lrf/2Eu/oD6br4NIcKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HE1EUR01FT016.eop-EUR01.prod.protection.outlook.com
 (2a01:111:e400:7e18::33) by
 HE1EUR01HT122.eop-EUR01.prod.protection.outlook.com (2a01:111:e400:7e18::257)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Sun, 8 Mar
 2020 12:58:33 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.0.55) by
 HE1EUR01FT016.mail.protection.outlook.com (10.152.0.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Sun, 8 Mar 2020 12:58:33 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Sun, 8 Mar 2020
 12:58:33 +0000
Received: from [192.168.1.101] (92.77.140.102) by FRYP281CA0014.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Sun, 8 Mar 2020 12:58:31 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Christian Brauner <christian.brauner@ubuntu.com>,
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
Subject: [PATCH] exec: make de_thread alloc new signal struct earlier
Thread-Topic: [PATCH] exec: make de_thread alloc new signal struct earlier
Thread-Index: AQHV9UlFwrz7zF+kPUydVgrwvmKDSg==
Date:   Sun, 8 Mar 2020 12:58:33 +0000
Message-ID: <AM6PR03MB5170B44BAD4B9402F29B8B58E4E10@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87imjicxjw.fsf_-_@x220.int.ebiederm.org>
 <AM6PR03MB5170375DBF699D4F3DC7A08DE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k13yawpp.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170E9D0DB405EC051F7731CE4E30@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87sgil87s3.fsf@x220.int.ebiederm.org> <87a74t86cs.fsf@x220.int.ebiederm.org>
 <87v9nh6koh.fsf@x220.int.ebiederm.org>
In-Reply-To: <87v9nh6koh.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FRYP281CA0014.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::24)
 To AM6PR03MB5170.eurprd03.prod.outlook.com (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:3D85B0069CFCB3CB2F8D57AD2918C52AEFCFFF7E73FBBC4D30DE4B8A99032FC1;UpperCasedChecksum:B6FB0BE11F08487B16A09B3755431B739A34309DEE7FECEEE50863F42FF0B3C8;SizeAsReceived:9840;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [eZQY9KO2YxHolo9GQIy/PxCHKI6mNLdh]
x-microsoft-original-message-id: <c2894c33-5e78-a6e4-ec9a-ba20923af337@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 289a7201-5028-4e5b-d380-08d7c36067f8
x-ms-traffictypediagnostic: HE1EUR01HT122:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3/HYr4NjwhQWzo/yAEXqj+7Q1GN7r80LOLNy108m5v7/Y25AbCP2mGYGE/KCNktyxrRAcN8QNFD4okRA5EwLsSgIcYgKJGSN3PfpOo60qJFd2WRyQxcj9k6SUXlP1H+s95Rs7cyQYChiH7qKwsqSSjoKuf0UvgNraS9pZC/zEd+byS9veyppgv5b2HsUzDBr
x-ms-exchange-antispam-messagedata: B19g5ARpdk5V7AtZggLF0dkG1MXCqwutFgltE3bsPV1lMw2yBSvvNJ2sQB6hEn50w1HJ9OHwRm58pIoC/qvBwOVWPmJWz2EjuxCkraRcSrDkCaDtQAtc9+CCJErIHfVTnXuGs1PQfxRba1+ciIXM/g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <5DBB198BA9313544AD126FE23828D207@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 289a7201-5028-4e5b-d380-08d7c36067f8
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 12:58:33.2387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR01HT122
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It was pointed out that de_thread may return -ENOMEM
when it already terminated threads, and returning
an error from execve, except when a fatal signal is
being delivered is not an option any more.

Allocate the memory for the signal table earlier,
and make sure that -ENOMEM is returned before the
unrecoverable actions are started.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
Eric, what do you think, might this be helpful
to move the "point of no return" lower, and simplify
your patch?

 fs/exec.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 74d88da..a0328dc 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1057,16 +1057,26 @@ static int exec_mmap(struct mm_struct *mm)
  * disturbing other processes.  (Other processes might share the signal
  * table via the CLONE_SIGHAND option to clone().)
  */
-static int de_thread(struct task_struct *tsk)
+static int de_thread(void)
 {
+	struct task_struct *tsk = current;
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
+	struct sighand_struct *newsighand = NULL;
 
 	if (thread_group_empty(tsk))
 		goto no_thread_group;
 
 	/*
+	 * This is the last time for an out of memory error.
+	 * After this point only fatal signals are are okay.
+	 */
+	newsighand = kmem_cache_alloc(sighand_cachep, GFP_KERNEL);
+	if (!newsighand)
+		return -ENOMEM;
+
+	/*
 	 * Kill all other threads in the thread group.
 	 */
 	spin_lock_irq(lock);
@@ -1076,7 +1086,7 @@ static int de_thread(struct task_struct *tsk)
 		 * return so that the signal is processed.
 		 */
 		spin_unlock_irq(lock);
-		return -EAGAIN;
+		goto err_free;
 	}
 
 	sig->group_exit_task = tsk;
@@ -1191,14 +1201,16 @@ static int de_thread(struct task_struct *tsk)
 #endif
 
 	if (refcount_read(&oldsighand->count) != 1) {
-		struct sighand_struct *newsighand;
 		/*
 		 * This ->sighand is shared with the CLONE_SIGHAND
 		 * but not CLONE_THREAD task, switch to the new one.
 		 */
-		newsighand = kmem_cache_alloc(sighand_cachep, GFP_KERNEL);
-		if (!newsighand)
-			return -ENOMEM;
+		if (!newsighand) {
+			newsighand = kmem_cache_alloc(sighand_cachep,
+						      GFP_KERNEL);
+			if (!newsighand)
+				return -ENOMEM;
+		}
 
 		refcount_set(&newsighand->count, 1);
 		memcpy(newsighand->action, oldsighand->action,
@@ -1211,7 +1223,8 @@ static int de_thread(struct task_struct *tsk)
 		write_unlock_irq(&tasklist_lock);
 
 		__cleanup_sighand(oldsighand);
-	}
+	} else if (newsighand)
+		kmem_cache_free(sighand_cachep, newsighand);
 
 	BUG_ON(!thread_group_leader(tsk));
 	return 0;
@@ -1222,6 +1235,8 @@ static int de_thread(struct task_struct *tsk)
 	sig->group_exit_task = NULL;
 	sig->notify_count = 0;
 	read_unlock(&tasklist_lock);
+err_free:
+	kmem_cache_free(sighand_cachep, newsighand);
 	return -EAGAIN;
 }
 
@@ -1262,7 +1277,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 * Make sure we have a private signal table and that
 	 * we are unassociated from the previous thread group.
 	 */
-	retval = de_thread(current);
+	retval = de_thread();
 	if (retval)
 		goto out;
 
-- 
1.9.1
