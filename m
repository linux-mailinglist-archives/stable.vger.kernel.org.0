Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF93A2E9211
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 09:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbhADInK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 03:43:10 -0500
Received: from relay3.mymailcheap.com ([217.182.119.157]:50201 "EHLO
        relay3.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbhADInK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 03:43:10 -0500
X-Greylist: delayed 4360 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jan 2021 03:43:08 EST
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay3.mymailcheap.com (Postfix) with ESMTPS id 0B2803F15F;
        Mon,  4 Jan 2021 09:41:37 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 507FE2A17C;
        Mon,  4 Jan 2021 03:41:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1609749696;
        bh=xskrCESNWKJ1jYUXcJKelIh+ei8uMfdBFU8ovbU4Dzg=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=vTkCWNfQEUuSrFkTmqNneQvBRRy+9mdyMFZeTsl0to7/qRLaBt9qAenrfqEmfEIfh
         fs7lrcNxYUL/a5SUgVzkD6em5eB3Gw1SYrkT5jZXhJu3WpwHhiUGkpvHABCx+9dV+v
         DrxcHj9qyWCw+82OgPgp/+KlL1+CqU4qJG9tfatg=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nz7HS8e78ozM; Mon,  4 Jan 2021 03:41:35 -0500 (EST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Mon,  4 Jan 2021 03:41:35 -0500 (EST)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id F3EF842283;
        Mon,  4 Jan 2021 08:41:33 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=aosc.io header.i=@aosc.io header.b="UIAQMGtL";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [10.172.12.132] (unknown [112.96.173.123])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id B1F9A41F21;
        Mon,  4 Jan 2021 08:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1609749685; bh=xskrCESNWKJ1jYUXcJKelIh+ei8uMfdBFU8ovbU4Dzg=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=UIAQMGtL/5KbI6Joi+cCzDh7wPUCkq0BjJQNAJuaqi2o2skLIVzBHT41FERJbfwsa
         4UzJaIyOHBOOjRuGDzJQI4F61ZN04a4wMg+yltNad92KLvBnRCEYtrVf4uM4OuZkZV
         im/fGOLT0oPWyAaLy588vubuw+Hh9YsdRhMKgZ4I=
Date:   Mon, 04 Jan 2021 16:36:24 +0800
User-Agent: K-9 Mail for Android
In-Reply-To: <CAOQ4uxifcZTeZ15jz0PqTs-tQnDDuijV_3QjQ28EayBX-=rtdA@mail.gmail.com>
References: <20210101201230.768653-1-icenowy@aosc.io> <CAOQ4uxgNWkzVphdB7cAkwdUXagM_NsCUYDRT1f-=X1rn1-KpUQ@mail.gmail.com> <a77b2beb832d64f9f019c4505e91c7ffcbbfb61b.camel@aosc.io> <CAOQ4uxifcZTeZ15jz0PqTs-tQnDDuijV_3QjQ28EayBX-=rtdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] ovl: use a dedicated semaphore for dir upperfile caching
To:     Amir Goldstein <amir73il@gmail.com>
CC:     Miklos Szeredi <miklos@szeredi.hu>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
From:   Icenowy Zheng <icenowy@aosc.io>
Message-ID: <FEFABAF4-367B-4F18-B088-E2C0F673FFFB@aosc.io>
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[aosc.io:s=default];
         RECEIVED_SPAMHAUS_PBL(0.00)[112.96.173.123:received];
         FROM_HAS_DN(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.00)[aosc.io];
         R_SPF_SOFTFAIL(0.00)[~all];
         RCPT_COUNT_FIVE(0.00)[6];
         ML_SERVERS(-3.10)[213.133.102.83];
         TO_DN_ALL(0.00)[];
         DKIM_TRACE(0.00)[aosc.io:+];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1]
X-Rspamd-Queue-Id: F3EF842283
X-Rspamd-Server: mail20.mymailcheap.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



=E4=BA=8E 2021=E5=B9=B41=E6=9C=884=E6=97=A5 GMT+08:00 =E4=B8=8B=E5=8D=884:=
35:20, Amir Goldstein <amir73il@gmail=2Ecom> =E5=86=99=E5=88=B0:
>On Mon, Jan 4, 2021 at 9:28 AM Icenowy Zheng <icenowy@aosc=2Eio> wrote:
>>
>> =E5=9C=A8 2021-01-03=E6=98=9F=E6=9C=9F=E6=97=A5=E7=9A=84 16:10 +0200=EF=
=BC=8CAmir Goldstein=E5=86=99=E9=81=93=EF=BC=9A
>> > On Fri, Jan 1, 2021 at 10:12 PM Icenowy Zheng <icenowy@aosc=2Eio>
>> > wrote:
>> > >
>> > > The function ovl_dir_real_file() currently uses the semaphore of
>> > > the
>> > > inode to synchronize write to the upperfile cache field=2E
>> > >
>> > > However, this function will get called by ovl_ioctl_set_flags(),
>> > > which
>> > > utilizes the inode semaphore too=2E In this case
>ovl_dir_real_file()
>> > > will
>> > > try to claim a lock that is owned by a function in its call
>stack,
>> > > which
>> > > won't get released before ovl_dir_real_file() returns=2E
>> >
>> > oops=2E I wondered why I didn't see any warnings on this from
>lockdep=2E
>> > Ah! because the xfstest that exercises ovl_ioctl_set_flags() on
>> > directory,
>> > generic/079, starts with an already upper dir=2E
>> >
>> > And the xfstest that checks chattr+i on lower/upper files,
>> > overlay/040,
>> > does not check chattr on dirs (ioctl on overlay dirs wasn't
>supported
>> > at
>> > the time the test was written)=2E
>> >
>> > Would you be able to create a variant of test overlay/040 that also
>> > tests
>> > chattr +i on lower/upper dirs to test your patch and confirm that
>the
>> > test
>> > fails on master with the appropriate Kconfig debug options=2E
>>
>> https://gist=2Egithub=2Ecom/Icenowy/c7d8decb6812d6e5064d143c57281ad3
>>
>> Here's a test that would break on master (I used linux-next/master
>for
>> test)=2E
>
>Thanks=2E
>I am working on another test to improve overlay/030 that may also
>cover this bug, so maybe no need for both tests=2E I'll let you know when
>I'm done=2E
>If you like, I can post your test for you with your Signed-of-by if I
>think
>it is also needed=2E
>
>>
>> [  246=2E521880] INFO: task chattr:715 blocked for more than 122
>seconds=2E
>> [  246=2E525659]       Not tainted 5=2E11=2E0-rc1-next-20210104+ #20
>> [  246=2E528498] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message=2E
>> [  246=2E535076] task:chattr          state:D stack:13736 pid:  715
>ppid:
>> 529 flags:0x00000000
>> [  246=2E538923] Call Trace:
>> [  246=2E540241]  __schedule+0x2a9/0x820
>> [  246=2E541986]  schedule+0x56/0xc0
>> [  246=2E543616]  rwsem_down_write_slowpath+0x375/0x630
>> [  246=2E545565]  ovl_dir_real_file+0xc1/0x120
>> [  246=2E547512]  ovl_real_fdget+0x35/0x80
>> [  246=2E549303]  ovl_real_ioctl+0x26/0x90
>> [  246=2E551050]  ? mnt_drop_write+0x2c/0x70
>> [  246=2E553068]  ovl_ioctl_set_flags+0x93/0x110
>> [  246=2E555407]  __x64_sys_ioctl+0x7e/0xb0
>> [  246=2E557175]  do_syscall_64+0x33/0x40
>> [  246=2E558869]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [  246=2E561057] RIP: 0033:0x7fe4a3830b67
>> [  246=2E565799] RSP: 002b:00007ffe7ad504f8 EFLAGS: 00000246 ORIG_RAX:
>> 0000000000000010
>> [  246=2E569438] RAX: ffffffffffffffda RBX: 0000000000000001 RCX:
>> 00007fe4a3830b67
>> [  246=2E572061] RDX: 00007ffe7ad5050c RSI: 0000000040086602 RDI:
>> 0000000000000003
>> [  246=2E575509] RBP: 0000000000000003 R08: 0000000000000001 R09:
>> 0000000000000000
>> [  246=2E578932] R10: 0000000000000000 R11: 0000000000000246 R12:
>> 0000000000000010
>> [  246=2E581014] R13: 00007ffe7ad50810 R14: 0000000000000002 R15:
>> 0000000000000001
>> [  246=2E582818]
>> [  246=2E582818] Showing all locks held in the system:
>> [  246=2E584741] 1 lock held by khungtaskd/18:
>> [  246=2E586085]  #0: ffffffff9e951540 (rcu_read_lock){=2E=2E=2E=2E}-{1=
:2}, at:
>> debug_show_all_locks+0x15/0x100
>> [  246=2E589775] 3 locks held by chattr/715:
>> [  246=2E591364]  #0: ffff96a74b92c450 (sb_writers#11){=2E=2E=2E=2E}-{0=
:0}, at:
>> ovl_ioctl_set_flags+0x2f/0x110
>> [  246=2E597182]  #1: ffff96a7489c3500
>> (&ovl_i_mutex_dir_key[depth]){=2E=2E=2E=2E}-{3:3}, at:
>> ovl_ioctl_set_flags+0x54/0x110
>> [  246=2E601325]  #2: ffff96a7489c3500
>> (&ovl_i_mutex_dir_key[depth]){=2E=2E=2E=2E}-{3:3}, at:
>> ovl_dir_real_file+0xc1/0x120
>>
>> >
>> > >
>> > > Define a dedicated semaphore for the upperfile cache, so that the
>> > > deadlock won't happen=2E
>> > >
>> > > Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and
>FS[S|G]ETXATTR
>> > > ioctls for directories")
>> > > Cc: stable@vger=2Ekernel=2Eorg # v5=2E10
>> > > Signed-off-by: Icenowy Zheng <icenowy@aosc=2Eio>
>> > > ---
>> > >  fs/overlayfs/readdir=2Ec | 6 ++++--
>> > >  1 file changed, 4 insertions(+), 2 deletions(-)
>> > >
>> > > diff --git a/fs/overlayfs/readdir=2Ec b/fs/overlayfs/readdir=2Ec
>> > > index 01620ebae1bd=2E=2Ef10701aabb71 100644
>> > > --- a/fs/overlayfs/readdir=2Ec
>> > > +++ b/fs/overlayfs/readdir=2Ec
>> > > @@ -56,6 +56,7 @@ struct ovl_dir_file {
>> > >         struct list_head *cursor;
>> > >         struct file *realfile;
>> > >         struct file *upperfile;
>> > > +       struct semaphore upperfile_sem;
>> >
>> > mutex please
>> >
>
>You missed this comment=2E
>semaphore is discouraged as a locking primitive=2E
>Please use struct mutex=2E

Okay, sorry=2E

I will check it out=2E

>
>Thanks,
>Amir=2E
