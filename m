Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E0E104482
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 20:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbfKTTqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 14:46:49 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:56085 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbfKTTqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 14:46:48 -0500
Received: from mail-qt1-f181.google.com ([209.85.160.181]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1McpW6-1hyjPo2WXK-00Zvn5; Wed, 20 Nov 2019 20:46:46 +0100
Received: by mail-qt1-f181.google.com with SMTP id t8so857044qtc.6;
        Wed, 20 Nov 2019 11:46:46 -0800 (PST)
X-Gm-Message-State: APjAAAU51hy9Hz0YQS3JNRr2UAbkYPU2asSe5zDLE+Sl/k8UAuBTpy3n
        BrKrBh9TIJc4gtQGUwu2fon7o/OS5cH/AlBv8Xg=
X-Google-Smtp-Source: APXvYqxPZzv5p9M0S54RVzyCQ3+IKHoZHHwaet1h8egEPSf91VBYkxihnAwuFZfH1zdk4pgEJL+YwqwpgpxJECT1PWs=
X-Received: by 2002:ac8:18eb:: with SMTP id o40mr4514073qtk.304.1574279205448;
 Wed, 20 Nov 2019 11:46:45 -0800 (PST)
MIME-Version: 1.0
References: <20191108203435.112759-1-arnd@arndb.de> <20191108203435.112759-7-arnd@arndb.de>
 <41baf20a190039443cb2b82aea0c2a8ec872cfed.camel@codethink.co.uk>
In-Reply-To: <41baf20a190039443cb2b82aea0c2a8ec872cfed.camel@codethink.co.uk>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 20 Nov 2019 20:46:29 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3U0GWCyU9WOnrGQ2tqnHoyAbJ=HdYJGfTHuxVqcww0wg@mail.gmail.com>
Message-ID: <CAK8P3a3U0GWCyU9WOnrGQ2tqnHoyAbJ=HdYJGfTHuxVqcww0wg@mail.gmail.com>
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
X-Provags-ID: V03:K1:hSbHdgcgUeQgXlEmJ4EKRoKgZD9UulCtypIgHNsbgkKidt/myew
 7klpYhHFggiuBVAmwNkcUnfUrJDiRg0U7PzUaiO+MW9RQZi/Wo0ut5pTDc25UCjiCpw1zT5
 BfmTsRxFk5o/19TXgk4xdXOtFvxSFsl5Kh1yAHBnGEF1B8vAPDBZoaDnOBlE+EAe43yVsRs
 8E12ft1ifcWDEEiwYdIHA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:lSDmNxSpplg=:Sdqq8e/aFeeyZsdBAJ274E
 4J1Exa+yWf6evZgi9nr3xLR8IDFZFQiGgg1dYkkP5SMvm0/TD1OXf6zJG+HNwQVWz2zz5FdFb
 5FiP6nOy/rPmuvyDwm3HpgTIqg9+2gAIudlf/6KdeLkiiP1EddK1Gw9ivZYi715uiyfeWbi/r
 4HE44BicCjHI6Uj5/gJFOs1B3s2W6ZpV3wqhDnT/zAd2vz/r45pe53hFHw1m5dENtwTNnkgG1
 D9A7N5vEpAs0hYXR0jghj2HyGX0/ll94MPyiNdecBcLH/4jQH0H4Tfva4Gg9qpCSr0bu2cscK
 2eZJPU6dH++nPU1zFfE49eE8qOyK7cpHkp+nx+jnnvS1ztehVstF5tKn6lXS1ofocgmbDzd+f
 PGt06QQKyeu/2ZhEXvhXQPDU3f0D3HdRqfgUbjwLUBKVsEx6PoJpC3SRv0vyMA+8wVs3QE0aH
 GVCHzvK5pxBtuhZ22r0jLUOXfOml4ujKVIZFhqGt+A6I/hHihx+Mntq7lMeN4jRe4rokY1tgv
 bR8L97XCJHnFAdoy1a16lqQbZwBoAyNf3XTkYlNHbLCYZcg/8hJaJoC2Opn73/F8htenN6ayZ
 9E4ikI30aNDAjjLr9s1jR7dMfSZjI9ZLeMEQlI0HqSO9KZXI31kOSypHEqVXo+qUdX86EYCYs
 NMhBj9cz6DfAnTzruvbmxf4FY2+4femfGsXmkTUXp8Iz0QDj8bLB1WobWHcdd9ylmjvlhKEMd
 yc1ylLCGDRmkcGxvrRG/5ca6N2CNHHvsxM4L7rBJi+U6lbOvjWaUICuoCaU60rH9crfRXfs9m
 9GW6j/ZMKf6hzW6S5qhQ+Mkwz+KKQYy6dDUyGy/GTZRVgu1sIOufWR8ciotz9jSjFlromntYv
 IicryZ8Unp11GgycQISg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 20, 2019 at 8:27 PM Ben Hutchings
<ben.hutchings@codethink.co.uk> wrote:
>
> On Fri, 2019-11-08 at 21:34 +0100, Arnd Bergmann wrote:
> > The layout of struct timeval is different on sparc64 from
> > anything else, and the patch I did long ago failed to take
> > this into account.
> >
> > Change it now to handle sparc64 user space correctly again.
> >
> > Quite likely nobody cares about parallel ports on sparc64,
> > but there is no reason not to fix it.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 9a450484089d ("lp: support 64-bit time_t user space")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/char/lp.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/char/lp.c b/drivers/char/lp.c
> > index 7c9269e3477a..bd95aba1f9fe 100644
> > --- a/drivers/char/lp.c
> > +++ b/drivers/char/lp.c
> > @@ -713,6 +713,10 @@ static int lp_set_timeout64(unsigned int minor, void __user *arg)
> >       if (copy_from_user(karg, arg, sizeof(karg)))
> >               return -EFAULT;
> >
> > +     /* sparc64 suseconds_t is 32-bit only */
> > +     if (IS_ENABLED(CONFIG_SPARC64) && !in_compat_syscall())
> > +             karg[1] >>= 32;
> > +
> >       return lp_set_timeout(minor, karg[0], karg[1]);
> >  }
> >
>
> It seems like it would make way more sense to use __kernel_old_timeval.

Right, that would work. I tried to keep the patch small here, changing
it to __kernel_old_timeval would require make it all more complicated
since it would still need to check some conditional to tell the difference
between sparc32 and sparc64.

I think this patch (relative to the version I posted) would work the same:

diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index bd95aba1f9fe..86994421ee97 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -713,13 +713,19 @@ static int lp_set_timeout64(unsigned int minor,
void __user *arg)
        if (copy_from_user(karg, arg, sizeof(karg)))
                return -EFAULT;

-       /* sparc64 suseconds_t is 32-bit only */
-       if (IS_ENABLED(CONFIG_SPARC64) && !in_compat_syscall())
-               karg[1] >>= 32;
-
        return lp_set_timeout(minor, karg[0], karg[1]);
 }

+static int lp_set_timeout(unsigned int minor, void __user *arg)
+{
+       __kernel_old_timeval tv;
+
+       if (copy_from_user(tv, arg, sizeof(karg)))
+               return -EFAULT;
+
+       return lp_set_timeout(minor, tv->tv_sec, tv->tv_usec);
+}
+
 static long lp_ioctl(struct file *file, unsigned int cmd,
                        unsigned long arg)
 {
@@ -730,11 +736,8 @@ static long lp_ioctl(struct file *file, unsigned int cmd,
        mutex_lock(&lp_mutex);
        switch (cmd) {
        case LPSETTIMEOUT_OLD:
-               if (BITS_PER_LONG == 32) {
-                       ret = lp_set_timeout32(minor, (void __user *)arg);
-                       break;
-               }
-               /* fall through - for 64-bit */
+               ret = lp_set_timeout(minor, (void __user *)arg);
+               break;
        case LPSETTIMEOUT_NEW:
                ret = lp_set_timeout64(minor, (void __user *)arg);
                break;

Do you like that better? One difference here is the handling of
LPSETTIMEOUT_NEW on sparc64, which would continue to use
the 64/64 layout rather than the 64/32/pad layout, but that should
be ok, since sparc64 user space using ppdev (if any exists)
would use LPSETTIMEOUT_OLD, not LPSETTIMEOUT_NEW.

> Then you don't have to explicitly handle the sparc64 oddity.
>
> As it is, this still over-reads from user-space which might result in a
> spurious -EFAULT.

I think you got this wrong: sparc64 like most architectures naturally
aligns 64-bit members, so 'struct timeval' still uses 16 bytes including
the four padding bytes at the end, it just has the nanoseconds in
a different position from all other big-endian architectures.

      Arnd
