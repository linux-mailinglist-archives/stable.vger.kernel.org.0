Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D880710FDC9
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 13:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfLCMhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 07:37:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44706 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725997AbfLCMhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 07:37:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575376670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=54X8pHWwMS1IN0TIuQGpPfqhR5ohmDGILGJEdAlHlh8=;
        b=CCyN+zfWwawaka3Y6KOT/L3Qs9F+rEuFLTfc3nhhaKuAJTVzCmylaMcR5oDrYMaB5FNfoT
        aswFV0ZdoVHEkGLiDUUujlmPPmHW6oe7eWFGts8LNmuWj8yI/6IGKuDJe5GTNON1REF6BB
        oIqmcsQ6SfX/OtYSO/6+7d/Ceuerhqg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-Bm26GCEgMEqBXWdgn7snag-1; Tue, 03 Dec 2019 07:37:46 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E040107ACC5;
        Tue,  3 Dec 2019 12:37:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 64E8510016DA;
        Tue,  3 Dec 2019 12:37:45 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2DA0C1803C32;
        Tue,  3 Dec 2019 12:37:45 +0000 (UTC)
Date:   Tue, 3 Dec 2019 07:37:44 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     Cyril Hrubis <chrubis@suse.cz>
Cc:     Rachel Sibley <rasibley@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>
Message-ID: <1532241482.14811981.1575376664944.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191203122236.GC2844@rei>
References: <cki.B4696121A3.SRVKVUGWT3@redhat.com> <546bd6ac-8ab1-9a9b-5856-e6410fb8ee89@redhat.com> <20191203122236.GC2844@rei>
Subject: Re: [LTP] ??? FAIL: Test report for kernel 5.3.13-cc9917b.cki
 (stable-queue)
MIME-Version: 1.0
X-Originating-IP: [10.43.17.163, 10.4.195.11]
Thread-Topic: ??? FAIL: Test report for kernel 5.3.13-cc9917b.cki (stable-queue)
Thread-Index: MUwpaipbQw9RwUQoDqqdHMeXe+/oWw==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: Bm26GCEgMEqBXWdgn7snag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> Hi!
> > > We ran automated tests on a recent commit from this kernel tree:
> > > 
> > >         Kernel repo:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
> > >              Commit: cc9917b40848 - mdio_bus: Fix init if
> > >              CONFIG_RESET_CONTROLLER=n
> > > 
> > > The results of these automated tests are provided below.
> > > 
> > >      Overall result: FAILED (see details below)
> > >               Merge: OK
> > >             Compile: OK
> > >               Tests: FAILED
> > > 
> > > All kernel binaries, config files, and logs are available for download
> > > here:
> > > 
> > >    https://artifacts.cki-project.org/pipelines/309848
> > > 
> > > One or more kernel tests failed:
> > > 
> > >      ppc64le:
> > >       ??? LTP
> > 
> > I see a slew of syscalls failures here for LTP:
> > https://artifacts.cki-project.org/pipelines/309848/logs/ppc64le_host_1_LTP_resultoutputfile.log
> > https://artifacts.cki-project.org/pipelines/309848/logs/ppc64le_host_1_LTP_syscalls.run.log
> 
> There are a few syslog failures, which does not seem to be related to
> the kernel commit at all. The commit above seems to touch error handling
> in a mdio bus which is used to configure network hardware. I would say
> that this is connected to the rest of the unexplained failures on
> ppc64le that seems to happen randomly.

I think this is different. Test is spam-ing serial console with:
 preadv203 (765613): drop_caches: 3

which leads to RCU stall:
[ 4338.611873] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[ 4517.198118] systemd[1]: systemd-journald.service: State 'stop-watchdog' timed out. Terminating.
[ 4518.688311] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[ 4518.688318] rcu: 	0-...0: (2 ticks this GP) idle=7da/1/0x4000000000000000 softirq=208692/208696 fqs=11772 
[ 4518.688321] 	(detected by 3, t=24007 jiffies, g=280901, q=430)
[ 4518.688324] Sending NMI from CPU 3 to CPUs 0:
[ 4524.259240] CPU 0 didn't respond to backtrace IPI, inspecting paca.
[ 4524.259243] irq_soft_mask: 0x01 in_mce: 0 in_nmi: 0 current: 765613 (preadv203)
[ 4524.259245] Back trace of paca->saved_r1 (0xc000000029b47990) (possibly stale):
[ 4524.259246] Call Trace:
[ 4524.259250] [c000000029b47990] [0000000000000001] 0x1 (unreliable)
[ 4524.259255] [c000000029b47a00] [c0000000007e8b28] hvterm_raw_put_chars+0x48/0x70
[ 4524.259257] [c000000029b47a20] [c0000000007eb174] hvc_console_print+0x124/0x2c0
[ 4524.259260] [c000000029b47ab0] [c0000000001b2238] console_unlock+0x588/0x760
[ 4524.259262] [c000000029b47b90] [c0000000001b4a8c] vprintk_emit+0x22c/0x330
[ 4524.259264] [c000000029b47c00] [c0000000001b5d28] vprintk_func+0x78/0x1b0
[ 4524.259266] [c000000029b47c50] [c0000000001b5294] printk+0x40/0x54
[ 4524.259269] [c000000029b47c70] [c0000000004e6c7c] drop_caches_sysctl_handler+0x14c/0x170
[ 4524.259271] [c000000029b47ce0] [c000000000512390] proc_sys_call_handler+0x230/0x240
[ 4524.259273] [c000000029b47d60] [c000000000432098] __vfs_write+0x38/0x70
[ 4524.259275] [c000000029b47d80] [c0000000004363c8] vfs_write+0xd8/0x250
[ 4524.259277] [c000000029b47dd0] [c000000000436798] ksys_write+0x78/0x130
[ 4524.259280] [c000000029b47e20] [c00000000000bae4] system_call+0x5c/0x70

Maybe we could temporarily lower printk level during this test.

Test also fails to release loop device and subsequent tests fail
because they try to use same one.

