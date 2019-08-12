Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36DC98A4DD
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 19:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfHLRt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 13:49:59 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40269 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfHLRt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 13:49:59 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so49859337pgj.7
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 10:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UlfP/u75yTdzDQjbiZ58yMYBve2dKK0PO4ky5mg2Pt0=;
        b=qmuOq+hrlYJyS+vFN+69sgI30ksAbee60jkJJ3WGqGrXS5apAC4Yi90vHmloPuvkaH
         mGSjgnfR70Bu4SB5b1TK3mmrao8nbkWVtuSeSNNIkVxeC7MyEK3ALrTGVVxu4Il1Y3sv
         MGX2JA8Zt7e78swfgqC11/ky5vg60b+zL4JPO+mF7+1pYna5rmSxDn5LUbeouYnYM9zx
         R8kt7JFWu/oESws3uE5EADp39XMZjDCi2ud1juNuf8aQbNTQWfr2zhXfRVqpT1KYNsiH
         Lr6gfMg48tgwq0aJFMgQGursfyHFgL1Kz7u1TLitR8vY1Cj8VUmAlWl+kFtXE8OuEEqN
         GqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UlfP/u75yTdzDQjbiZ58yMYBve2dKK0PO4ky5mg2Pt0=;
        b=PL97qzULheAIS9LQxDTIMMxHpVzlykneXph3/u00oAdWj9kwjO4pMyooSRQpbmpzel
         MiWNs+4t/jZKO1J5wLMwcqDby9KobIZY3Xu/GvIXqe3ICDKOUtKHbtgnVvugbPcHSom5
         7C0gMwwB4QbORLedxdTds9Os2kxkx17o9dyj41niGP5XudjyVcotUy+519AW75BEBCS1
         wdUv9XZesRwTCneIHyumbBepJWL0p3Sj16hFSGklw57NSDxEDV1HCGPAsAf0q4n6vpi2
         HzsOqVZgGd+zuckKH1VmTi1FdxaWOZu27L0Aoh0xiPWzoIRaqiZOeg2ULodHcm/WKEl8
         wI7g==
X-Gm-Message-State: APjAAAV7ono4U6rSiCLjBAi6EnvoKydv7Oa7PDR6+qQBIMUBlRDY701N
        85Pbg3RoJNhOWS4ox+0vmPQEK+q918yqx5pxL7VEfw==
X-Google-Smtp-Source: APXvYqx1SwvKUl8H4rYfsiPpLm9g3LPSk2ZZAkjvlUrFNQLWf1l/fYlG11WXSEmEdbwPA1SbUFwnjmGEHYt6R4ethx4=
X-Received: by 2002:aa7:984a:: with SMTP id n10mr8591359pfq.3.1565632198197;
 Mon, 12 Aug 2019 10:49:58 -0700 (PDT)
MIME-Version: 1.0
References: <201908120108.9KdVOsTD%lkp@intel.com>
In-Reply-To: <201908120108.9KdVOsTD%lkp@intel.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 12 Aug 2019 10:49:47 -0700
Message-ID: <CAKwvOd=JpUsD1XDSBzgwDWcAO+1VuGOLjbGNCTFne-WAqjGzXQ@mail.gmail.com>
Subject: Re: [stable:linux-4.14.y 8386/9999] drivers/gpu/drm/i915/gvt/opregion.o:
 warning: objtool: intel_vgpu_emulate_opregion_request()+0xbe: can't find jump
 dest instruction at .text+0x6dd
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     kbuild@01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 11, 2019 at 10:08 AM kbuild test robot <lkp@intel.com> wrote:
>
> CC: kbuild-all@01.org
> TO: Daniel Borkmann <daniel@iogearbox.net>
> CC: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
>
> tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
> head:   3ffe1e79c174b2093f7ee3df589a7705572c9620
> commit: e28951100515c9fd8f8d4b06ed96576e3527ad82 [8386/9999] x86/retpolines: Disable switch jump tables when retpolines are enabled
> config: x86_64-rhel-7.6 (attached as .config)
> compiler: clang version 10.0.0 (git://gitmirror/llvm_project 45a3fd206fb06f77a08968c99a8172cbf2ccdd0f)
> reproduce:
>         git checkout e28951100515c9fd8f8d4b06ed96576e3527ad82
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    In file included from drivers/gpu/drm/i915/gvt/opregion.c:25:
>    In file included from drivers/gpu/drm/i915/i915_drv.h:61:
>    In file included from drivers/gpu/drm/i915/intel_uc.h:31:
>    In file included from drivers/gpu/drm/i915/i915_vma.h:34:
>    drivers/gpu/drm/i915/i915_gem_object.h:290:1: warning: attribute declaration must precede definition [-Wignored-attributes]
>    __deprecated
>    ^

Was there another patch that fixes this that should have been
backported to stable (4.14) along with this?

>    include/linux/compiler-gcc.h:106:37: note: expanded from macro '__deprecated'
>    #define __deprecated    __attribute__((deprecated))
>                                           ^
>    include/drm/drm_gem.h:247:20: note: previous definition is here
>    static inline void drm_gem_object_reference(struct drm_gem_object *obj)
>                       ^
>    In file included from drivers/gpu/drm/i915/gvt/opregion.c:25:
>    In file included from drivers/gpu/drm/i915/i915_drv.h:61:
>    In file included from drivers/gpu/drm/i915/intel_uc.h:31:
>    In file included from drivers/gpu/drm/i915/i915_vma.h:34:
>    drivers/gpu/drm/i915/i915_gem_object.h:300:1: warning: attribute declaration must precede definition [-Wignored-attributes]
>    __deprecated
>    ^
>    include/linux/compiler-gcc.h:106:37: note: expanded from macro '__deprecated'
>    #define __deprecated    __attribute__((deprecated))
>                                           ^
>    include/drm/drm_gem.h:285:20: note: previous definition is here
>    static inline void drm_gem_object_unreference(struct drm_gem_object *obj)
>                       ^
>    In file included from drivers/gpu/drm/i915/gvt/opregion.c:25:
>    In file included from drivers/gpu/drm/i915/i915_drv.h:61:
>    In file included from drivers/gpu/drm/i915/intel_uc.h:31:
>    In file included from drivers/gpu/drm/i915/i915_vma.h:34:
>    drivers/gpu/drm/i915/i915_gem_object.h:303:1: warning: attribute declaration must precede definition [-Wignored-attributes]
>    __deprecated
>    ^
>    include/linux/compiler-gcc.h:106:37: note: expanded from macro '__deprecated'
>    #define __deprecated    __attribute__((deprecated))
>                                           ^
>    include/drm/drm_gem.h:273:1: note: previous definition is here
>    drm_gem_object_unreference_unlocked(struct drm_gem_object *obj)
>    ^
>    3 warnings generated.
> >> drivers/gpu/drm/i915/gvt/opregion.o: warning: objtool: intel_vgpu_emulate_opregion_request()+0xbe: can't find jump dest instruction at .text+0x6dd
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation



-- 
Thanks,
~Nick Desaulniers
