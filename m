Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CD03726B2
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 09:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhEDHmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 03:42:51 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:33317 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbhEDHmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 03:42:50 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MJW18-1lxYOx0Riq-00Jtyu for <stable@vger.kernel.org>; Tue, 04 May 2021
 09:41:55 +0200
Received: by mail-wm1-f48.google.com with SMTP id 4-20020a05600c26c4b0290146e1feccd8so693638wmv.1
        for <stable@vger.kernel.org>; Tue, 04 May 2021 00:41:55 -0700 (PDT)
X-Gm-Message-State: AOAM5309/m6PSPiq7ZFrbD49RKAOW9pRsQPHkRbVYT/mEDiZMPSsX8+J
        wsTaSQ4K2fiClRhqKnPEsPkBAxuCEh7yTkVAKIk=
X-Google-Smtp-Source: ABdhPJy4WbzHjDbstNcLBzQ20e0fbkv4jB7XoWaAATPr4ZzFRDOzH7OWB0X1v9qu8nvbxeCVntqFnKiDV+osg6fl+Yo=
X-Received: by 2002:a1c:a949:: with SMTP id s70mr2478434wme.84.1620114114819;
 Tue, 04 May 2021 00:41:54 -0700 (PDT)
MIME-Version: 1.0
References: <202105030311.xWwkyV9z-lkp@intel.com> <CAK8P3a0ZdZY94KVwF-C_t+7rx=iHC60ty52AQAmc1VDZwsn9Rw@mail.gmail.com>
 <CAKwvOdmCmvHNpyjNtNU1OeSzK_E_9n9T4CPiFGD7K_JuJDOj-w@mail.gmail.com>
 <CAK8P3a3KLasm-CdcM3HCP6EZO1Vr0ay17jw7zSy0btqPr32WRg@mail.gmail.com> <YJDQ0ePGHxmcB7dX@kroah.com>
In-Reply-To: <YJDQ0ePGHxmcB7dX@kroah.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 4 May 2021 09:41:14 +0200
X-Gmail-Original-Message-ID: <CAK8P3a30xJ1+zrCC4fk+q9xzLspHuE4VM0UHSWiU3-iFeNN+6g@mail.gmail.com>
Message-ID: <CAK8P3a30xJ1+zrCC4fk+q9xzLspHuE4VM0UHSWiU3-iFeNN+6g@mail.gmail.com>
Subject: Re: [stable:linux-5.4.y 5541/6083] ERROR: "__memcat_p"
 [drivers/hwtracing/stm/stm_core.ko] undefined!
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Sasha Levin <sashal@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:on8RTpaBuqYkQNZp9WGSXDe+A2Q5+EQMb/y15ZVKcbLrJ5I84BH
 kysUUR8ecJ2XAcWWFDC3NO3OiljTXozfUe5AmUND7evgLsIgu3wBsQIgQzRXqGy8yMmBJ/8
 zRSnK1U5Qwl3anjen94nAEAM/+xvO3WKFkhA6OODlwNJJzNKNA5I+lEa6nB0VsR0rF3bAd3
 inxy8XI1YZFQREl1TAN4g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EIDHqlE8be8=:BrcaDXBnYfTWOHCcQyUkT8
 uzX/8zx1SSfEe/M61/cOD9QnF/UAV6eI5UzsDNKTo4GoaJEnVsQZ2YKAU1htS4l/r/ovPkjox
 6m59Z33KCngzogyH6vSVs2vKqA785EUxlshCyfvUjReLnZeVgQyZyl5gdN1nWV14S2joKwZ2H
 DJg2DXYUtR8i8DUS0b7WPFzBjg+3vWfsSwW3g9QaE4ihjYT3EROrtPcvJfmTNHDYbFM9VMBk5
 wBVQQN9nlCmZ1dt7d+VSmQvJecOF6iBdu3OFdGZmqIGLxVYNpHypF1j11QrNiGgPeoc8if7Wj
 9jWyzOWMrY005dFjyyQ7yB2Lt5HvkPvJPNG3Lc2EhMzdWFisN89MHhT+fhzL+r1YLEJ3YObdR
 DmsIedaNcB/DIKbA0zgV1iJoeH2pqFXcYAmrOg5O+OMuvZrMJ7a5cIU9XP//tas4cND/Q0XDA
 ouQsu0AHXd5u7KO8XFEICud3+znaeUVW1UFDgiogJnJsR+NDvExFXV+3KJJ2k/dDzI764pmk2
 u3h5J3pV6zX3x8nEnfbN4gNTLOhmftuHwLkPXgz7DiyWmNLT/9ct0u8WIxavqC0nBy/XFHfag
 ogm7mqnBaR7yHkIQHKdlX9SyuqGyO1rpsfl0H4bZWIzzvST1knKHfT4ZHu+HTAJO8ctLRe1AY
 McQs=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 4, 2021 at 6:43 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, May 03, 2021 at 09:16:42PM +0200, Arnd Bergmann wrote:
> > On Mon, May 3, 2021 at 7:00 PM 'Nick Desaulniers' via Clang Built
> > Linux <clang-built-linux@googlegroups.com> wrote:
> > > > > >> ERROR: "__memcat_p" [drivers/hwtracing/stm/stm_core.ko] undefined!
> > > >
> > > > I'm fairly sure this is unrelated to my patch, but I don't see what
> > > > happened here.
> > >
> > > It's unrelated to your patch. It was fixed in 5.7 by
> > > 7273ad2b08f8ac9563579d16a3cf528857b26f49 and a few other dependencies
> > > according to https://github.com/ClangBuiltLinux/linux/issues/515.
> > >
> >
> > Ah right, the big hammer.
> >
> > Greg, not sure what we want to do here. Backporting
> >
> > 7273ad2b08f8 ("kbuild: link lib-y objects to vmlinux forcibly when
> > CONFIG_MODULES=y")
> >
> > to v5.4 and earlier would be an easy workaround, but it has the potential
> > of adding extra bloat to the kernel image since it links in all other
> > library objects as well.
>
> I've lost the thread here, but what _real_ problem is happening here
> that doing the above is required?

Randconfig builds fail if drivers/hwtracing/stm/stm_core.ko is a loadable
modules and nothing inside vmlinux forces lib/memcat_p.o to be
linked in. A simpler workaround for v5.4 would be:

diff --git a/lib/Makefile b/lib/Makefile
index a5c5f342ade0..745d1207e9e2 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -33,7 +33,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
         flex_proportions.o ratelimit.o show_mem.o \
         is_single_threaded.o plist.o decompress.o kobject_uevent.o \
         earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
-        nmi_backtrace.o nodemask.o win_minmax.o memcat_p.o \
+        nmi_backtrace.o nodemask.o win_minmax.o \
         buildid.o

 lib-$(CONFIG_PRINTK) += dump_stack.o
@@ -48,7 +48,7 @@ obj-y += bcd.o sort.o parser.o debug_locks.o random32.o \
         bsearch.o find_bit.o llist.o memweight.o kfifo.o \
         percpu-refcount.o rhashtable.o \
         once.o refcount.o usercopy.o errseq.o bucket_locks.o \
-        generic-radix-tree.o
+        generic-radix-tree.o memcat_p.o
 obj-$(CONFIG_STRING_SELFTEST) += test_string.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o

which is the same as what 7273ad2b08f8 does, but only for this one file
instead of all of lib/*.o.

       Arnd
