Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4233B8A535
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 20:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfHLSAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 14:00:51 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41541 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfHLSAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 14:00:51 -0400
Received: by mail-pf1-f195.google.com with SMTP id 196so2900871pfz.8
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 11:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LMg80cBNLp3PHQDaMvfzFcPlhbFoNlL9OXKffiCeFqk=;
        b=JAhEldzgp4BJfQp8+cO2ONaLnkUwZUIXB3Ob+6czHb+xlfDLcOXAxMUXKWq8QqgrAK
         IOZ+Ou9hAi3wzfFuvq+T1EWdreOb6ll354mscAl0z/p6LzWsBJjkebnhz2aKyvbXNF4v
         P8CBzFeF1TCTgEiB60BAMeAGaAQtZ3wh7JrQuNdt7hSq2cnhVNYehVENOLvHYA7W+MK2
         sCeOXlRMn0EyeT0iEi79R3CNb6+zJA9jB9G0eVu/K5YwINMdsJhv5QX/98+8pu++6CrA
         1Ig5R1wSwUvHGGAfhz7eXTJhBduP8m9KmJpavRKB4o1WSalIblD4ECRBrnsiCsihx1la
         7FRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LMg80cBNLp3PHQDaMvfzFcPlhbFoNlL9OXKffiCeFqk=;
        b=lFjGIUEOEgHcy+yieDcZ1K+b8/qqCFqZAYgsVFjBHx+dx69tKUdlHukoyBXIksL027
         2/HuCvTBH1H/HbpQo3c2jsW5QGl5E6G0KT8O/4xsyPZgdtjwU1kUbiRZQ6SGBfI69eLl
         g9IzQcAuERshPv3uY8s++B2RJ/fIjpCMFYA5Hi2XjxIcyEVRlGoB+rR8QcJDEw7E5AVF
         tE8ZDseIXYnglhSZsvIF3dGtsdBluK66UWtV8FTU9QjMpbnp3Uf1ewqaJe921LKDymQG
         Sv2TemokXcBRIUyrBaolkUG3aAUYweswJLL0scfy80JNBw2c50AO0U8z+4RLS4QqcWB9
         HXLw==
X-Gm-Message-State: APjAAAVVj8yb1JB0n97IDz3qT/Ky6p13bGeWpCaZENhqyhTjO1maxgW0
        leekWhDz6wDweDQxinxC2VvR3S5Ee6ArkyS8+qjaUQ==
X-Google-Smtp-Source: APXvYqwsB17leZrkmFO3Bqp/CKUjmeWCgE9xVGBrG5V0KR8KQOhG1UbADTU0DK+ZYHXMNrSpcAGsVXtj8MScj1n1d+w=
X-Received: by 2002:aa7:984a:: with SMTP id n10mr8628976pfq.3.1565632849911;
 Mon, 12 Aug 2019 11:00:49 -0700 (PDT)
MIME-Version: 1.0
References: <201908120108.9KdVOsTD%lkp@intel.com> <CAKwvOd=JpUsD1XDSBzgwDWcAO+1VuGOLjbGNCTFne-WAqjGzXQ@mail.gmail.com>
 <20190812175828.GA13040@kroah.com>
In-Reply-To: <20190812175828.GA13040@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 12 Aug 2019 11:00:38 -0700
Message-ID: <CAKwvOd=ORE==PVaXdyUc44CsNp7bShapjaQ00Ej-UA7_r4CWSQ@mail.gmail.com>
Subject: Re: [stable:linux-4.14.y 8386/9999] drivers/gpu/drm/i915/gvt/opregion.o:
 warning: objtool: intel_vgpu_emulate_opregion_request()+0xbe: can't find jump
 dest instruction at .text+0x6dd
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, kbuild@01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 12, 2019 at 10:58 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Aug 12, 2019 at 10:49:47AM -0700, Nick Desaulniers wrote:
> > On Sun, Aug 11, 2019 at 10:08 AM kbuild test robot <lkp@intel.com> wrote:
> > >
> > > CC: kbuild-all@01.org
> > > TO: Daniel Borkmann <daniel@iogearbox.net>
> > > CC: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> > > CC: Thomas Gleixner <tglx@linutronix.de>
> > >
> > > tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
> > > head:   3ffe1e79c174b2093f7ee3df589a7705572c9620
> > > commit: e28951100515c9fd8f8d4b06ed96576e3527ad82 [8386/9999] x86/retpolines: Disable switch jump tables when retpolines are enabled
> > > config: x86_64-rhel-7.6 (attached as .config)
> > > compiler: clang version 10.0.0 (git://gitmirror/llvm_project 45a3fd206fb06f77a08968c99a8172cbf2ccdd0f)
> > > reproduce:
> > >         git checkout e28951100515c9fd8f8d4b06ed96576e3527ad82
> > >         # save the attached .config to linux build tree
> > >         make ARCH=x86_64
> > >
> > > If you fix the issue, kindly add following tag
> > > Reported-by: kbuild test robot <lkp@intel.com>
> > >
> > > All warnings (new ones prefixed by >>):
> > >
> > >    In file included from drivers/gpu/drm/i915/gvt/opregion.c:25:
> > >    In file included from drivers/gpu/drm/i915/i915_drv.h:61:
> > >    In file included from drivers/gpu/drm/i915/intel_uc.h:31:
> > >    In file included from drivers/gpu/drm/i915/i915_vma.h:34:
> > >    drivers/gpu/drm/i915/i915_gem_object.h:290:1: warning: attribute declaration must precede definition [-Wignored-attributes]
> > >    __deprecated
> > >    ^
> >
> > Was there another patch that fixes this that should have been
> > backported to stable (4.14) along with this?
>
> If this is an issue on the latest 4.14.y tree, please let me know.  Look
> at how far back this commit is before getting worried :)

patch 8386/9999 ???!!!  Were there exactly 9999 patches backported, or
does git stop reporting after 4 digits? "4 digits ought to be enough
for anyone!" (except GKH, it would seem ;) ).
-- 
Thanks,
~Nick Desaulniers
