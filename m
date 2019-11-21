Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54C901053E7
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 15:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfKUOEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 09:04:21 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:38581 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUOEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 09:04:21 -0500
Received: from mail-qv1-f45.google.com ([209.85.219.45]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1M76jv-1iUCAn3WNb-008aaE; Thu, 21 Nov 2019 15:04:19 +0100
Received: by mail-qv1-f45.google.com with SMTP id cv8so1443034qvb.3;
        Thu, 21 Nov 2019 06:04:18 -0800 (PST)
X-Gm-Message-State: APjAAAUcTRtphHzKa1PuvTueI1SSIZkWn4aaQ3uOVoDSr04RKDFmYz6M
        GT8Wi7l2XOKSACgSGf34SvLAv4enLrAhn/ufQik=
X-Google-Smtp-Source: APXvYqxGJKDevMqGXHCfpshFTRTpEsI+ahENxha33s1Adcjl8n9v6B+Ztqx2ECoC+IZykQ0h6TF9HFyn+lOGGs0Fb98=
X-Received: by 2002:ad4:50a4:: with SMTP id d4mr7944964qvq.211.1574345057594;
 Thu, 21 Nov 2019 06:04:17 -0800 (PST)
MIME-Version: 1.0
References: <20191108203435.112759-1-arnd@arndb.de> <20191108203435.112759-7-arnd@arndb.de>
 <41baf20a190039443cb2b82aea0c2a8ec872cfed.camel@codethink.co.uk>
 <CAK8P3a3U0GWCyU9WOnrGQ2tqnHoyAbJ=HdYJGfTHuxVqcww0wg@mail.gmail.com> <a187cb75cc15ba8ee4a7b652fae8317cb9b03020.camel@codethink.co.uk>
In-Reply-To: <a187cb75cc15ba8ee4a7b652fae8317cb9b03020.camel@codethink.co.uk>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 21 Nov 2019 15:04:00 +0100
X-Gmail-Original-Message-ID: <CAK8P3a34sty4kTfFSKz8e-D+B14e3oTUPaACzGq_1SjYeuoytg@mail.gmail.com>
Message-ID: <CAK8P3a34sty4kTfFSKz8e-D+B14e3oTUPaACzGq_1SjYeuoytg@mail.gmail.com>
Subject: Re: [Y2038] [PATCH 6/8] lp: fix sparc64 LPSETTIMEOUT ioctl
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Bamvor Jian Zhang <bamv2005@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:vewZiqcUvewdI1whKBH+bm/MkhVl8m2XyYfjPCbSvFGlZXNT7bI
 jekfxwrrl1po78fxpusdmeJOKZffxnVTmZ2bujuFMzomkdSCgw73qJvb+eLswEvNT8JMQkf
 JUf2lySyEN5couEkWfEUFTURopgRGF57YLJuABU1jmn9xjP1GQ5g0ega53o6JEMIQZlzM6u
 1TlLm0q4Pc4WRe836vx3g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vOZG7/b6cZQ=:knuCdckBDnhMtcOl8vl+AD
 iQpwdD8NnW8Wm/l33QO0mW0pxtkIF7J+Y/kVcME98xZe6qxyK41zWGR6gU0UMfWr1AdBZXYBB
 YzfHnzhZlDVToMyqpMd/C6++n/dGCEy2p6Rtj4Bkeis24anhqf/jQ3ANWpRkAR34pa2eu7dE8
 c29V+14UL1w+J9D+Icmti4DBzHpAj75/TGWVYiB1HInFRaiEZPuBqRavS7NSibmCCBeK+SS85
 IMkFeqXugd/VxW8Izjm3VUnMocfRhr4jr+qHjsDkYk2oy+2Lt8XWVA/g+dENU8VmPzJNiInhH
 4BAIyroTFQuUJQ+gDrqSn3jrYSYJk7SUWSPxdjLDTVoobrllDdnXYrCFGsJd477GQbUvViDmt
 nD7VEYKjnFaorjUU/XdmzYjjpl0xREYhxmcSffMQ8YHWnLDaOaH/I2FPyyN8l/bSzjETQ1dln
 UxJCODZu3/KddUzqvHT+lkw4Pr1M1HrDNNfU6Yw6PSNjmnEtC/ouLHszgD8uZ/WqwQA99y7qV
 7cDlRngnxEezh70onqv9WQRBC767zLINx+3fAEorvPyYcqWz48du9EjzQKPMoKvwPqFFyzTLZ
 BpXe/vnMzhzGZtW9GydYln/MnhqPpcv9Chk2MQxGAXfhxFogCsm20ExG1yDOgfbd/J0sUkzk6
 IdLJMFuw338zppQZ0Ab2DU27nY+/OtChbfFxcITcgNrUODh5bJFZDSv58ChhOBagvoCj2r33M
 NWeW7im5JSHYf6uKkXLexEPglCCjxMulyvVshE+Xf+rfSOkndaO+95FQL+awvvs10BQY7cJie
 nIt4JDBWlyowAtI4QcaxHKE0/g3CK+NHTsgJ/ctZgxvBnl6Ng3ZPh+Gl1+8BBQ6QuwYsoesqj
 5QIKr2siMbXzq9QPAqAA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 20, 2019 at 11:10 PM Ben Hutchings
<ben.hutchings@codethink.co.uk> wrote:
> On Wed, 2019-11-20 at 20:46 +0100, Arnd Bergmann wrote:
> > On Wed, Nov 20, 2019 at 8:27 PM Ben Hutchings <ben.hutchings@codethink.co.uk> wrote:
> > -
> >         return lp_set_timeout(minor, karg[0], karg[1]);
> >  }
> >
> > +static int lp_set_timeout(unsigned int minor, void __user *arg)
>
> That function name is already used!  Maybe this should be
> lp_set_timeout_old()?

Yes, that's what I used after actually compile-testing and running
into a couple of issues with my draft.

> > @@ -730,11 +736,8 @@ static long lp_ioctl(struct file *file, unsigned int cmd,
> >         mutex_lock(&lp_mutex);
> >         switch (cmd) {
> >         case LPSETTIMEOUT_OLD:
> > -               if (BITS_PER_LONG == 32) {
> > -                       ret = lp_set_timeout32(minor, (void __user *)arg);
> > -                       break;
> > -               }
> > -               /* fall through - for 64-bit */
> > +               ret = lp_set_timeout(minor, (void __user *)arg);
> > +               break;
> >         case LPSETTIMEOUT_NEW:
> >                 ret = lp_set_timeout64(minor, (void __user *)arg);
> >                 break;
> >
> > Do you like that better?
>
> Yes.  Aside from the duplicate function name, it looks correct and
> cleaner than the current version.

As Greg has already merged the original patch, and that version works
just as well, I'd probably just leave what I did at first. One benefit is
that in case we decide to kill off sparc64 support before drivers/char/lp.c,
the special case can be removed more easily.

I don't think either of them is going any time soon, but working on y2038
patches has made me think ahead longer term ;-)

If you still think we should change it I can send the below patch (now
actually build-tested) with your Ack.

       Arnd
---
commit 93efbb1768a5071a0a98bf4627f0104075cf83a6 (HEAD -> y2038)
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu Nov 21 14:45:14 2019 +0100

    lp: clean up set_timeout handling

    As Ben Hutchings noticed, we can avoid the special case for sparc64
    by dealing with '__kernel_old_timeval' arguments separately from
    the fixed-length 32-bit and 64-bit arguments.

    Note that the behavior for LPSETTIMEOUT_NEW changes on sparc64 to
    expect the same argument as other architectures, but this is ok
    because sparc64 users would pass LPSETTIMEOUT_OLD anyway.

    Suggested-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index bd95aba1f9fe..cc17d5a387c5 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -696,14 +696,14 @@ static int lp_set_timeout(unsigned int minor,
s64 tv_sec, long tv_usec)
        return 0;
 }

-static int lp_set_timeout32(unsigned int minor, void __user *arg)
+static int lp_set_timeout_old(unsigned int minor, void __user *arg)
 {
-       s32 karg[2];
+       struct __kernel_old_timeval tv;

-       if (copy_from_user(karg, arg, sizeof(karg)))
+       if (copy_from_user(&tv, arg, sizeof(tv)))
                return -EFAULT;

-       return lp_set_timeout(minor, karg[0], karg[1]);
+       return lp_set_timeout(minor, tv.tv_sec, tv.tv_usec);
 }

 static int lp_set_timeout64(unsigned int minor, void __user *arg)
@@ -713,10 +713,6 @@ static int lp_set_timeout64(unsigned int minor,
void __user *arg)
        if (copy_from_user(karg, arg, sizeof(karg)))
                return -EFAULT;

-       /* sparc64 suseconds_t is 32-bit only */
-       if (IS_ENABLED(CONFIG_SPARC64) && !in_compat_syscall())
-               karg[1] >>= 32;
-
        return lp_set_timeout(minor, karg[0], karg[1]);
 }

@@ -730,11 +726,8 @@ static long lp_ioctl(struct file *file, unsigned int cmd,
        mutex_lock(&lp_mutex);
        switch (cmd) {
        case LPSETTIMEOUT_OLD:
-               if (BITS_PER_LONG == 32) {
-                       ret = lp_set_timeout32(minor, (void __user *)arg);
-                       break;
-               }
-               /* fall through - for 64-bit */
+               ret = lp_set_timeout_old(minor, (void __user *)arg);
+               break;
        case LPSETTIMEOUT_NEW:
                ret = lp_set_timeout64(minor, (void __user *)arg);
                break;
@@ -748,6 +741,16 @@ static long lp_ioctl(struct file *file, unsigned int cmd,
 }

 #ifdef CONFIG_COMPAT
+static int lp_set_timeout32(unsigned int minor, void __user *arg)
+{
+       s32 karg[2];
+
+       if (copy_from_user(karg, arg, sizeof(karg)))
+               return -EFAULT;
+
+       return lp_set_timeout(minor, karg[0], karg[1]);
+}
+
 static long lp_compat_ioctl(struct file *file, unsigned int cmd,
                        unsigned long arg)
 {
