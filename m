Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29A323FF7A
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 19:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgHIRXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 13:23:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726207AbgHIRXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Aug 2020 13:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596993816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=60GKudByszXzSU9r7sTdue2pMvjRmoypxp10iEs7VnI=;
        b=dH7X2QcvZL5TMMJ/6eS8pciB/huALXPUeJrejXCbnJunyqOeo48GsCxL+kmXCPHNI7d/aL
        7tfD4Hc4BrOEVSPbolm6u++ZLAhvDFQvjRzV2Y2VKPHtW5fL/dPju5SPS/ZZCBlgso/xAm
        nRBNd+EOve+/znWKTYqMmIFFqPqP23Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-NghVxyoPMeKAKuhsdARi_w-1; Sun, 09 Aug 2020 13:23:31 -0400
X-MC-Unique: NghVxyoPMeKAKuhsdARi_w-1
Received: by mail-wr1-f71.google.com with SMTP id 89so3291462wrr.15
        for <stable@vger.kernel.org>; Sun, 09 Aug 2020 10:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=60GKudByszXzSU9r7sTdue2pMvjRmoypxp10iEs7VnI=;
        b=cviUzcAna/PO4xiyXSsiWq9v8bc27/5Z/Js0R3PFNrPMHY7QCQp64iLLgW+wgHmryO
         tWKw9c1N9WOpJeiOJMow3ajY0MVBeYonrxh5dn8grqg/x0Wij3s/bxqmO8XhaR9WcKzE
         TF/3PnnPNHLVHWcN81gNi4JXQbvSYk190oVcgRfhy2Ee2AoiLcPcJtTzQZXCvKqUcy2k
         Bp+lMh8HBehrlTZ/lKAqddGMT8sVjeQj5wD34Kjq7UOM2uvA2XC2Sq8G4fyGlSy6b3c2
         U/sCXlsWhZ3O4MpjPLzdIoUqF/NwMzzWTHe4xhWIC4qz19vu2Vkf9+QVU1TXKIo9KEl/
         yiRA==
X-Gm-Message-State: AOAM533lWLNgeDI/0yMu/w5H/ERNZSpt1vjmHeHeUWk9CPxAEHxh8AFl
        bmqEaFHrV5TNUkSTyqj/XcZj7+uyE6+G6hwQykgJCiaO4nnit/D/1SKNU53Mjv0/XJnHQAonay2
        PaQnIk6g7YCB0THZa
X-Received: by 2002:a05:6000:118c:: with SMTP id g12mr20755645wrx.212.1596993810607;
        Sun, 09 Aug 2020 10:23:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzwEPa1MPtSV651TG2wBd2JGpLDN+D3LrImZPSbEhFkjVn/IV+rGrVC44uH0fDnj2r1OeS2g==
X-Received: by 2002:a05:6000:118c:: with SMTP id g12mr20755633wrx.212.1596993810341;
        Sun, 09 Aug 2020 10:23:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8deb:6d34:4b78:b801? ([2001:b07:6468:f312:8deb:6d34:4b78:b801])
        by smtp.gmail.com with ESMTPSA id g7sm18096445wrv.82.2020.08.09.10.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2020 10:23:29 -0700 (PDT)
Subject: Re: [PATCH] MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64
To:     Greg KH <greg@kroah.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>, stable@vger.kernel.org
References: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
 <20200808153123.GC369184@kroah.com>
 <2b2937d0-eae6-a489-07bd-c40ded02ce89@flygoat.com>
 <20200809070235.GA1098081@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5ffc7bb1-8e3f-227a-7ad0-cec5fc32a96a@redhat.com>
Date:   Sun, 9 Aug 2020 19:23:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200809070235.GA1098081@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/08/20 09:02, Greg KH wrote:
>>>> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
>>>> index 3932f76..a474578 100644
>>>> --- a/arch/mips/kvm/vz.c
>>>> +++ b/arch/mips/kvm/vz.c
>>>> @@ -29,7 +29,9 @@
>>>>   #include <linux/kvm_host.h>
>>>>   #include "interrupt.h"
>>>> +#ifdef CONFIG_CPU_LOONGSON64
>>>>   #include "loongson_regs.h"
>>>> +#endif
>>> The fix for this should be in the .h file, no #ifdef should be needed in
>>> a .c file.
>> The header file can only be reached when CONFIG_CPU_LOONGSON64 is
>> selected...
>> Otherwise the include path of this file won't be a part of CFLAGS.
> That sounds like you should fix up the path of this file in the
> #include line as well :)
> 

There is more #ifdef CONFIG_CPU_LOONGSON64 in arch/mips/kvm/vz.c, and
more #include "loongson_regs.h" in arch/mips.  So while I agree with
Greg that this idiom is quite unusual, it seems to be the expected way
to use this header.  I queued the patch.

Paolo

