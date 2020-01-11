Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4E913815E
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 13:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbgAKMac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 07:30:32 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41664 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729350AbgAKMac (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 07:30:32 -0500
Received: by mail-lf1-f67.google.com with SMTP id m30so3522240lfp.8
        for <stable@vger.kernel.org>; Sat, 11 Jan 2020 04:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t06bV6pFS1ud0jboI1ItTQ0ZCaOcEXqW3e26EKOcNH8=;
        b=SHZkssv0g76+UrXxOn45/cin8KPW04fN/ThIY7Ti74qXweOEzCjEwN03nDFaJeSA8/
         HAJiaJpBBUYAhmFjgKk+Kg332X1iP6RaYn5+TFZmAF0yj4maPgQ9yJhaUSQrGbWniBlO
         SPxaXcnZGgz65n3Lf0YSZc6zaNeyIF1+rBgmkkcksbiRQ6X8zY1jx9cdWqdC+5yjqWOK
         jP+Ef3W4Y/dcuup6WqhM9r8iW8PlWlto42PGE/7PV1ZD5sxg9OJUVAyJJoA6lb93zzwN
         llD2RUyeoLhUYJkMyHSdauQmYLerlTbPvsWP2kfDroYYA1AOjKo9yfaToiTUnB9xR51E
         XNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t06bV6pFS1ud0jboI1ItTQ0ZCaOcEXqW3e26EKOcNH8=;
        b=ndu5/ozlHXpfCPLRjbFcw+RGXDurN26FO9b56Oay4XSEEc1xMQE2c5mDhoJvQSbaFa
         f9UdupRErYE7C3mMxAlU5WKSamYwX0jxud09vmB3NGLElYH747iihEeVkEO1bYfBBUD3
         oWNnjMl/MwfdB4OlRZxqRmsQj4Nb/yyE5t8g6zvSTzC+O0W/l2eGx7diMkljCakW7Ob1
         mwf8cg5RemcPvX63fxJD6UL4QBD9/mz95oTcSKzCs6KZ06XqKijkcUCWRu4D6QYDHXN0
         +Hkid9pqvGZbCGBzqNGbkzNvFPZq46xr5efM3haBu3617CZ1MZ8luUpkAoGzwPz7fu9l
         zROQ==
X-Gm-Message-State: APjAAAUukHPmlRAwzG6TY6ZAGGNSARiAmwBwjAiNcnqdd5LHJxurwe6n
        nxdRdv8NtJK7vi1r7CRewha9p6m9CtAEnAidhF7oRA==
X-Google-Smtp-Source: APXvYqxv1MsAssRhvJPaipbtV79RRnlzo6mXDhr+gfrW/7xu0BWzYfJFEJ6/eMAsmbaCElhYbPqHc1F3W2r/Q93bL0M=
X-Received: by 2002:a19:c648:: with SMTP id w69mr5302866lff.44.1578745830371;
 Sat, 11 Jan 2020 04:30:30 -0800 (PST)
MIME-Version: 1.0
References: <20200111094845.328046411@linuxfoundation.org> <20200111094910.328555272@linuxfoundation.org>
In-Reply-To: <20200111094910.328555272@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 11 Jan 2020 18:00:19 +0530
Message-ID: <CA+G9fYtfuSAcSURcz+ehqPKXOodmn+SELn2rUKGkG-CUfE-2vg@mail.gmail.com>
Subject: Re: [PATCH 4.19 65/84] arm64: KVM: Trap VM ops when
 ARM64_WORKAROUND_CAVIUM_TX2_219_TVM is set
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 11 Jan 2020 at 15:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Marc Zyngier <marc.zyngier@arm.com>
>
> commit d3ec3a08fa700c8b46abb137dce4e2514a6f9668 upstream.
>
> In order to workaround the TX2-219 erratum, it is necessary to trap
> TTBRx_EL1 accesses to EL2. This is done by setting HCR_EL2.TVM on
> guest entry, which has the side effect of trapping all the other
> VM-related sysregs as well.
>
> To minimize the overhead, a fast path is used so that we don't
> have to go all the way back to the main sysreg handling code,
> unless the rest of the hypervisor expects to see these accesses.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On stable-rc 4.19 all arm64 builds failed due to this error,

arch/arm64/kvm/hyp/switch.c: In function 'handle_tx2_tvm':
arch/arm64/kvm/hyp/switch.c:438:2: error: implicit declaration of
function '__kvm_skip_instr'; did you mean 'kvm_skip_instr'?
[-Werror=implicit-function-declaration]
  __kvm_skip_instr(vcpu);
  ^~~~~~~~~~~~~~~~
  kvm_skip_instr
cc1: some warnings being treated as errors
scripts/Makefile.build:303: recipe for target
'arch/arm64/kvm/hyp/switch.o' failed

Full build log,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.19/DISTRO=lkft,MACHINE=hikey,label=docker-lkft/413/consoleText

-- 
Linaro LKFT
https://lkft.linaro.org
