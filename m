Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFD527B599
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 21:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgI1Tqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 15:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgI1Tqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 15:46:48 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8246C061755
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 12:46:47 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id x203so1507040vsc.11
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 12:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E9ec9yvt58Js1FAZ+6UPtMS6FN3BVEw4OijVbGlIAQM=;
        b=lgNvZD4oanV2WNxCyBdWhJHjKFFRi0g5o4u53kYbbphOmGnBzauHA0n8MCtQvVEsqJ
         84i05TWI/C60YBjS2ER9hBJJ4Xf8HJ7MWUvV6zs336Bdn82GxjS96zkVZvJgW+aUk9dB
         r6V+lC05vbQcqCTEmw3jKHXw7nxVGDCOesPTHVH35OP4ZFRYPZ+fFSgxBzkQGNbl/4nJ
         9MyAnUPBU46W1MzcTewtL/iGMeXFdxLbwctOfbv5TWv9Eo4ALO/5/HInepi5Dnyajv2r
         oR85IRf5FsY3M68nqoYj8URfCPO/7EEOOUm0VBGOvXeEZes483y0f0XXoEriNlSdWCQA
         7zvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E9ec9yvt58Js1FAZ+6UPtMS6FN3BVEw4OijVbGlIAQM=;
        b=gJQPgHIt3MR5z7lhI28j+5BKjU7EeMLUx2G79LEjcG9Q97bpp/zUDvRVd1CsWgSunJ
         kvEUsmTAQ4w6NVrjKN+uCRINtbNCxVwElrksFJjgJN5nxvYWotAuO5kE0hfB/GYbr0eq
         kxFV8NrvnBMPV8v+h0A9NUPNSFaAkQE9rXDlVs2TgsghwQtmkQ+Ejb+NPYRHt35kvcSD
         VKwcTLHlHLyS4Lo3CcM2c9pdhwY34tcDaz/GJGzuNWGYpIYtc0WM9OdOGjKSLKUYt1Vw
         5+pmQ/qdAIeHN7Qwt0ITktLSMesfxqR0S0VDclFbpdG53aVE1BlaOg0ZBugs/ZVBQgHc
         ktNg==
X-Gm-Message-State: AOAM533qRBbWA060clpMLr5g+kWNfGMEIj9Ae8LOaT+gyJgqOKGZ4aj8
        AqK3M/NbTB8ywViOo4emv9nUorQVKy+XW/hB0O5lXzPJRJ5StW3f
X-Google-Smtp-Source: ABdhPJzdiMQLvH3vkJ1RdZ0ajge0V6/gTSPBO4+mZmJBF1FiBoomF9LvtxvGIRW8i/QBtpynFEvqyJG/cYtaUeyp9Pc=
X-Received: by 2002:a05:6102:2085:: with SMTP id h5mr975930vsr.26.1601322405883;
 Mon, 28 Sep 2020 12:46:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200928171850.618223-1-maz@kernel.org> <20200928174629.GA2118806@kroah.com>
In-Reply-To: <20200928174629.GA2118806@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Sep 2020 01:16:34 +0530
Message-ID: <CA+G9fYs5DpC7fq6Ukqs6iS4wEOz2+g5zwgup3B5JPnE52_fvYA@mail.gmail.com>
Subject: Re: [PATCH stable-5.8] KVM: arm64: Assume write fault on S1PTW
 permission fault on instruction fetch
To:     Greg KH <gregkh@linuxfoundation.org>,
        linux- stable <stable@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>
Cc:     Will Deacon <will@kernel.org>, kernel-team@android.com,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Sep 2020 at 23:16, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Sep 28, 2020 at 06:18:50PM +0100, Marc Zyngier wrote:
> > Commit c4ad98e4b72cb5be30ea282fce935248f2300e62 upstream.
> >
> > KVM currently assumes that an instruction abort can never be a write.
> > This is in general true, except when the abort is triggered by
> > a S1PTW on instruction fetch that tries to update the S1 page tables
> > (to set AF, for example).
> >
> > This can happen if the page tables have been paged out and brought
> > back in without seeing a direct write to them (they are thus marked
> > read only), and the fault handling code will make the PT executable(!)
> > instead of writable. The guest gets stuck forever.
> >
> > In these conditions, the permission fault must be considered as
> > a write so that the Stage-1 update can take place. This is essentially
> > the I-side equivalent of the problem fixed by 60e21a0ef54c ("arm64: KVM=
:
> > Take S1 walks into account when determining S2 write faults").
> >
> > Update kvm_is_write_fault() to return true on IABT+S1PTW, and introduce
> > kvm_vcpu_trap_is_exec_fault() that only return true when no faulting
> > on a S1 fault. Additionally, kvm_vcpu_dabt_iss1tw() is renamed to
> > kvm_vcpu_abt_iss1tw(), as the above makes it plain that it isn't
> > specific to data abort.
> >
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Reviewed-by: Will Deacon <will@kernel.org>
> > Cc: stable@vger.kernel.org
> > Link: https://lore.kernel.org/r/20200915104218.1284701-2-maz@kernel.org
>
> Thanks for all 3 of these, now queued up!

stable rc branch 4.19 arm64 build broken.

../arch/arm64/kvm/../../../virt/kvm/arm/mmu.c:1283:13: error:
redefinition of =E2=80=98kvm_is_write_fault=E2=80=99
 1283 | static bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
      |             ^~~~~~~~~~~~~~~~~~

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

build log,

make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j16 ARCH=3Darm64
CROSS_COMPILE=3Daarch64-linux-gnu- HOSTCC=3Dgcc CC=3D"sccache
aarch64-linux-gnu-gcc" O=3Dbuild Image
#
In file included from
../arch/arm64/kvm/hyp/../../../../virt/kvm/arm/hyp/vgic-v3-sr.c:22:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from
../arch/arm64/kvm/hyp/../../../../virt/kvm/arm/hyp/aarch32.c:14:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c:23:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/hyp/sysreg-sr.c:23:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/hyp/switch.c:29:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/../../../virt/kvm/arm/arm.c:51:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/../../../virt/kvm/arm/mmio.c:21:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/../../../virt/kvm/arm/psci.c:25:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/../../../virt/kvm/arm/perf.c:23:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/regmap.c:24:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/inject_fault.c:25:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/../../../virt/kvm/arm/mmu.c:31:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
../arch/arm64/kvm/../../../virt/kvm/arm/mmu.c: At top level:
../arch/arm64/kvm/../../../virt/kvm/arm/mmu.c:1283:13: error:
redefinition of =E2=80=98kvm_is_write_fault=E2=80=99
 1283 | static bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
      |             ^~~~~~~~~~~~~~~~~~
In file included from ../arch/arm64/kvm/../../../virt/kvm/arm/mmu.c:31:
../arch/arm64/include/asm/kvm_emulate.h:382:20: note: previous
definition of =E2=80=98kvm_is_write_fault=E2=80=99 was here
  382 | static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
      |                    ^~~~~~~~~~~~~~~~~~
make[2]: *** [../scripts/Makefile.build:303:
arch/arm64/kvm/../../../virt/kvm/arm/mmu.o] Error 1
In file included from ../arch/arm64/kvm/handle_exit.c:31:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/guest.c:32:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/debug.c:26:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/reset.c:34:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/sys_regs_generic_v8.c:27:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/vgic-sys-reg-v3.c:17:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/sys_regs.c:35:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/../../../virt/kvm/arm/aarch32.c:26:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from
../arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:22:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from
../arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.c:20:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from
../arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c:30:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
In file included from ../arch/arm64/kvm/../../../virt/kvm/arm/pmu.c:23:
../arch/arm64/include/asm/kvm_emulate.h: In function =E2=80=98kvm_vcpu_sys_=
get_rt=E2=80=99:
../arch/arm64/include/asm/kvm_emulate.h:379:6: warning: unused
variable =E2=80=98esr=E2=80=99 [-Wunused-variable]
  379 |  u32 esr =3D kvm_vcpu_get_hsr(vcpu);
      |      ^~~
../arch/arm64/include/asm/kvm_emulate.h:380:1: warning: no return
statement in function returning non-void [-Wreturn-type]
  380 | }
      | ^
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/linux/Makefile:1074: arch/arm64/kvm] Error 2


--=20
Linaro LKFT
https://lkft.linaro.org
