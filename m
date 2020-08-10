Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DB02403AB
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 10:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgHJI4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 04:56:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56858 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726135AbgHJI4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 04:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597049813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QK1lBf3fdqSyygn/hbL7QdHaPZhuIx0fYdi0xlJuh6M=;
        b=e/dPn4g5cZokbrEVkyKUecljO9P+/fflzb+zqFnJvAvaveDx7hCuKOfLSIhJt9m0GNekAv
        97nQf2wEzjEEPVc/1Hsqt4WGqPesj9V9msMzxvM3W2U+l8lsl5jdFB2pOtYfxeNnER2FW1
        RsRDNgv2qtBsmnJAbIF1+bdqNLzGCco=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-7AaFmr6-PcCgrabLy7pSjQ-1; Mon, 10 Aug 2020 04:56:51 -0400
X-MC-Unique: 7AaFmr6-PcCgrabLy7pSjQ-1
Received: by mail-wr1-f71.google.com with SMTP id w1so3964514wro.4
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 01:56:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QK1lBf3fdqSyygn/hbL7QdHaPZhuIx0fYdi0xlJuh6M=;
        b=BTtL9mmtw/U7/djc242C64SflvMGoOR5Z/ceo9hBkIzTgA5gwt1/wpzB8q9J68Jfc5
         nMrvQTzzxQPas66c9c/qXFqNOGfp/cv86mkL+9HvozGw1svRZxCwzJdBOSd1L6wGd9s4
         xqppkHuYEUlHqJd79SuftOMM8NNSdLT0b0T7C4+ypmF5Q3FwsHYnbSiYay4Q+sKYtmBR
         oDqW/ImoeFq6xharFqed3QPZLz1J8c+uBCFF0B0KLzTr5oV0G6Y7vzWVkJWZUZLhO/OV
         lFXiRe4w83bFb0poSkVyhKdDhwo0ZeMYixX2T9c04T+QZwSsFOlI0rzeznvSmS/8kNal
         MQpg==
X-Gm-Message-State: AOAM5334zyMmrqg9VmA31+9IJUfUD7ya2SLZqQyqxOfJg1YQ5LYKVwvP
        oiL2Q6ioldo9/aeXL1LW7ZQr32FPC8NtwAv+F6JugmCp/RBHr84keiZ6dkU9wj7bnDgyJd/3aZ+
        n6pKlI+nirsQFI6KV
X-Received: by 2002:adf:de09:: with SMTP id b9mr24016621wrm.409.1597049810471;
        Mon, 10 Aug 2020 01:56:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbLVCWnrRjOybrhtLaR57NXiNKoVkHe0cAFaru2+iqq7APVclTt+MtrDeQRn4Qbj2QB8kQAA==
X-Received: by 2002:adf:de09:: with SMTP id b9mr24016610wrm.409.1597049810240;
        Mon, 10 Aug 2020 01:56:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5d6c:f50:4462:5103? ([2001:b07:6468:f312:5d6c:f50:4462:5103])
        by smtp.gmail.com with ESMTPSA id g3sm22278906wrb.59.2020.08.10.01.56.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 01:56:49 -0700 (PDT)
Subject: Re: [PATCH] MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64
To:     Greg KH <greg@kroah.com>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>, stable@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
References: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
 <20200808153123.GC369184@kroah.com>
 <2b2937d0-eae6-a489-07bd-c40ded02ce89@flygoat.com>
 <20200809070235.GA1098081@kroah.com>
 <5ffc7bb1-8e3f-227a-7ad0-cec5fc32a96a@redhat.com>
 <20200810074417.GA1529187@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5522eef8-0da5-7f73-b2f8-2d0c19bb5819@redhat.com>
Date:   Mon, 10 Aug 2020 10:56:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200810074417.GA1529187@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/08/20 09:44, Greg KH wrote:
>> There is more #ifdef CONFIG_CPU_LOONGSON64 in arch/mips/kvm/vz.c, and
>> more #include "loongson_regs.h" in arch/mips.  So while I agree with
>> Greg that this idiom is quite unusual, it seems to be the expected way
>> to use this header.  I queued the patch.
> Or you all could fix it up to work properly like all other #include
> lines in the kernel source tree.  There's no reason mips should be
> "special" here, right?

It's not just this #include, there's a couple dozen mach-* directories;
changing how they work would be up to the MIPS maintainers (CCed), and
it would certainly not be a patch that can be merged in stable@ kernels.

arch/mips/kernel/cpu-probe.c has the same

#ifdef CONFIG_CPU_LOONGSON64
#include <loongson_regs.h>

for example, so apparently they're good with this.  So if I don't pick
up the patch to fix the build it would be in all likelihood merged by
MIPS maintainers.  The only difference will be how long the build
remains broken and the fact that they need to worry about KVM despite
the presence of a specific maintainer.

KVM could of course just #include <asm/mach-loongson64/loongson_regs.h>,
which would be found unconditionally.  But there is some assembly in the
header, so even if it would compile (I didn't check) it seems wrong to
include it unconditionally and in fact it would be the only case of a
file including <asm/mach-*/*.h> even if it is not compiled for that
platform.

Another alternative would be to move CONFIG_CPU_LOONGSON64 code out of
arch/mips/kvm/vz.c and include it with obj-$(CONFIG_CPU_LOONGSON64).
I'll gladly accept a patch to do that, but I won't write it since I
don't have access to the hardware in order to test it.  For now, and for
the immediate purpose of not breaking the build, when in Rome I'll do as
the Romans do.

Paolo

