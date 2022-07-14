Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DAF5745C4
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 09:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbiGNHQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 03:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiGNHQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 03:16:35 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FB114099
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 00:16:34 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id va17so1870211ejb.0
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 00:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EQybo/mazhxMtTGDkUYLtW7YqQjdHytFSKMWIUktp7Y=;
        b=d0t45VsacujveQ1Wbw+8kJppeMT4oBRwrnHJc5niW+JN5hKi2+w6CtcYcyeNZy6G2u
         dEHaxNaZ3lF2sPjottqApmcaflK4v4ApaVApCRvj3V5H6/TfIhNa0lzcwzkIZDxeBlSI
         2debgcqeNHjAdD58AceU4k89Wa6DnwFGtWRqwxcMIZtbZrNcddOIEm72fnKprSiSd3+d
         p95n4/bALpxsfNjaJ1XpJFHAwpqXRzC9jRqoLZC3GD1roSaH3xbiWEEg3TAVJy/XHTvN
         TyKh0ytQc+lfU1sLydq/sBxfvgKtvLiJ11uN0jkDhRQFeSwdU41zqa9NjdAFRBz560Nc
         yKNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EQybo/mazhxMtTGDkUYLtW7YqQjdHytFSKMWIUktp7Y=;
        b=YYsqlzOiwwS+kZVjppTjdtAISTnWgPZF8qUFEHl5sDotNmHIaYhEZ1sjLFYW7kqCvE
         YnJKQdoJOdKP08IU+CaXCGSh05pJrFNc6jpoeo1fjtjkmgIFzUySnJLMBEl/Lf0ek7qN
         YJvqwyqVGMSW32p+EoABF2egqwdEWy3VjjWfaLwBKDhYlkTWWaHP1osLYSLQERl0tXRA
         +yj/tGZVC1Ww2Z3VcQlOy6TLwTKsdoOJY+8d7aJl4PflAUNOM2xG7TZZygaMTeT4m7v0
         DMR9dHkwH3jcHAOzqkqGLN5ldRUxkuX4JOuUbJQzt/PwCZYlY51px585BXnW5Nm2PJHI
         Mvuw==
X-Gm-Message-State: AJIora/M5LP2NjH/320VFYO46nBuWUQP4pjhn2A9MGjeyi9JTzz5YYUb
        uv4j2jMfeHVIAnapPHdvRXNepXjzEejcXOYZ+MEOpg==
X-Google-Smtp-Source: AGRyM1voA8NMtQEOdGczAdieyK2B7k8X/4dsXZ8MlAJApwx1KhWFIhSPlEElA0Xr24VkrlO5A7TIjYYq/QfBLQj3SeA=
X-Received: by 2002:a17:906:8a69:b0:72b:40d3:7b6c with SMTP id
 hy9-20020a1709068a6900b0072b40d37b6cmr7372491ejc.624.1657782992615; Thu, 14
 Jul 2022 00:16:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAMGffEm9y0wnn8LNS9Qo3obPhs0GD5iJZ0WejFzC4baGPDsYTw@mail.gmail.com>
 <CAMGffEnTobhKvwKcRTnSz1JgNBVeTTtbOvP2OtAMgceqOOhN4A@mail.gmail.com>
 <Ys7CFYqA62YcIFiT@kroah.com> <CAMGffEmdqz-ggqkHOwddu7bTPBs47tY-5cSi58qvYwPmxrYumg@mail.gmail.com>
 <Ys81Bor99YlUrM0k@google.com>
In-Reply-To: <Ys81Bor99YlUrM0k@google.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 14 Jul 2022 09:16:22 +0200
Message-ID: <CAMGffEmRC2FWp=U5Bbbp4B+gb-OPsaz-NSAcr50dtmkGHY-ViQ@mail.gmail.com>
Subject: Re: 5.10.131-rc1 crash with int3: RIP 0010:xaddw_ax_dx+0x9/0x10 [kvm]
To:     Sean Christopherson <seanjc@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 11:11 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jul 13, 2022, Jinpu Wang wrote:
> > On Wed, Jul 13, 2022 at 3:01 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Jul 13, 2022 at 02:26:44PM +0200, Jinpu Wang wrote:
> > > > On Wed, Jul 13, 2022 at 12:49 PM Jinpu Wang <jinpu.wang@ionos.com> wrote:
> > > > > #5.10.131-1+feature+linux+5.10.y+20220712.1850+30f4172c~deb11
>
> ...
>
> > > > > [ 1895.979325] Call Trace:
> > > > > [ 1895.979325]  ? fastop+0x59/0xa0 [kvm]
> > > > > [ 1895.979326]  ? x86_emulate_insn+0x73a/0xe00 [kvm]
> > > > > [ 1895.979326]  ? x86_emulate_instruction+0x2d0/0x750 [kvm]
> > > > > [ 1895.979326]  ? vmx_vcpu_load+0x21/0x70 [kvm_intel]
> > > > > [ 1895.979327]  ? complete_emulated_mmio+0x236/0x310 [kvm]
> > > > > [ 1895.979327]  ? kvm_arch_vcpu_ioctl_run+0x1744/0x1920 [kvm]
> > > > > [ 1895.979327]  ? kvm_vcpu_ioctl+0x211/0x5a0 [kvm]
> > > > > [ 1895.979328]  ? __fget_files+0x79/0xb0
> > > > > [ 1895.979328]  ? __fget_files+0x79/0xb0
> > > > > [ 1895.979328]  ? __x64_sys_ioctl+0x8b/0xc0
> > > > > [ 1895.979329]  ? do_syscall_64+0x33/0x40
> > > > > [ 1895.979329]  ? entry_SYSCALL_64_after_hwframe+0x61/0xc6
>
> ...
>
> > > > > Is this bug known, any hint how to fix it?
> > > > I did more tests on different Servers, so far all the machine
> > > > checked(Skylake/Icelake/Haswell/Broadwell/EPYC) crash immediately
> > > > except AMD Opteron.
> > > > kvm-unit-tests succeeded without regression.
> > >
> > > Same issue on Linus's tree right now as well?  Or does that pass just
> > > fine?
> >
> > Hi Greg,
> >
> > I haven't try linus tree, but just tried 5.15.55-rc1 on Intel Skylake,
> > it crashed the same.
> >
> > I will give Linus tree a try.
>
> Looks like fastop() got broken by the retbleed mitigations, i.e. this isn't unique
> to stable trees.
>
> https://lore.kernel.org/all/20220713171241.184026-1-cascardo@canonical.com
Hi Sean,

Thanks for the link, I will give it a try, to apply to kernel  5.10, I
adapted it a bit to

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 59e5d79f5c34..aa7b5adac633 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -189,7 +189,7 @@
 #define X16(x...) X8(x), X8(x)

 #define NR_FASTOP (ilog2(sizeof(ulong)) + 1)
-#define FASTOP_SIZE 8
+#define FASTOP_SIZE (8 * (1 + (IS_ENABLED(CONFIG_RETHUNK))))

 struct opcode {
        u64 flags : 56;

With it, kvm-unit-tests is working again, no gression found.

Thanks!
