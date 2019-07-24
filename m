Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C7A726E4
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 06:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfGXEqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 00:46:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50058 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfGXEqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 00:46:12 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hq692-0004Q6-CE; Tue, 23 Jul 2019 19:32:40 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hq691-0003ye-Le; Tue, 23 Jul 2019 19:32:40 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Jeff Layton <jlayton@primarydata.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
        <20190715134655.4076-39-sashal@kernel.org>
        <CAN05THSdj8m5g-xG5abYAZ=_PE2xT-RwLtVhKrtxPevJGCSxag@mail.gmail.com>
        <CAH2r5mu9ncYa1WTHuuMEk3=4TU5-RBH6nBKME4Bm+dntOtORTQ@mail.gmail.com>
Date:   Tue, 23 Jul 2019 20:32:33 -0500
In-Reply-To: <CAH2r5mu9ncYa1WTHuuMEk3=4TU5-RBH6nBKME4Bm+dntOtORTQ@mail.gmail.com>
        (Steve French's message of "Tue, 23 Jul 2019 19:29:10 -0500")
Message-ID: <87v9vs43pq.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hq691-0003ye-Le;;;mid=<87v9vs43pq.fsf@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19WPNvkH+gWSBLcyA8Qu0HmQ+IFY+GAvQc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa08.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=8.0 tests=ALL_TRUSTED,BAYES_00,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMGappySubj_01,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0035]
        *  0.7 XMSubLong Long Subject
        *  0.5 XMGappySubj_01 Very gappy subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Steve French <smfrench@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 335 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 4.9 (1.5%), b_tie_ro: 3.3 (1.0%), parse: 1.19
        (0.4%), extract_message_metadata: 4.6 (1.4%), get_uri_detail_list:
        1.83 (0.5%), tests_pri_-1000: 4.2 (1.3%), tests_pri_-950: 1.54 (0.5%),
        tests_pri_-900: 1.18 (0.4%), tests_pri_-90: 23 (6.9%), check_bayes: 21
        (6.3%), b_tokenize: 5 (1.6%), b_tok_get_all: 7 (2.1%), b_comp_prob:
        1.96 (0.6%), b_tok_touch_all: 3.2 (1.0%), b_finish: 0.98 (0.3%),
        tests_pri_0: 276 (82.5%), check_dkim_signature: 0.48 (0.1%),
        check_dkim_adsp: 3.0 (0.9%), poll_dns_idle: 1.34 (0.4%), tests_pri_10:
        2.6 (0.8%), tests_pri_500: 7 (2.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH AUTOSEL 5.2 039/249] signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> Very easy to see what caused the regression with this global change:
>
> mount (which launches "cifsd" thread to read the socket)
> umount (which kills the "cifsd" thread)
> rmmod   (rmmod now fails since "cifsd" thread is still active)
>
> mount launches a thread to read from the socket ("cifsd")
> umount is supposed to kill that thread (but with the patch
> "signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of
> force_sig" that no longer works).  So the regression is that after
> unmount you still see the "cifsd" thread, and the reason that cifsd
> thread is still around is that that patch no longer force kills the
> process (see line 2652 of fs/cifs/connect.c) which regresses module
> removal.
>
> -               force_sig(SIGKILL, task);
> +               send_sig(SIGKILL, task, 1);
>
> The comment in the changeset indicates "The signal SIGKILL can not be
> ignored" but obviously it can be ignored - at least on 5.3-rc1 it is
> being ignored.
>
> If send_sig(SIGKILL ...) doesn't work and if force_sig(SIGKILL, task)
> is removed and no longer possible - how do we kill a helper process
> ...

I think I see what is happening.  It looks like as well as misuinsg
force_sig, cifs is also violating the invariant that keeps SIGKILL out
of the blocked signal set.

For that force_sig will act differently.  I did not consider it because
that is never supposed to happen.

Can someone test this code below and confirm the issue goes away?

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 5d6d44bfe10a..2a782ebc7b65 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -347,6 +347,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	 */
 
 	sigfillset(&mask);
+	sigdelset(&mask, SIGKILL);
 	sigprocmask(SIG_BLOCK, &mask, &oldmask);
 
 	/* Generate a rfc1002 marker for SMB2+ */


Eric
