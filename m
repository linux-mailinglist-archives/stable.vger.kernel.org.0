Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6EBF26662C
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgIKRWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:22:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44789 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726420AbgIKRWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 13:22:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599844961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b9qx2qlxmgrx8g4SP7cER56cDyTBCXp5uBJkmrojiRE=;
        b=PeVuQpcjgOMW4x87oWvCz5bd/RNQhfyhuujawi9tGgXOATf+FtSfjBgzRBGT/GHGmZQDc+
        qmMO7bAafWSYKXxNdI6CpozsXhvIXkWxhoxQjdwxnrq+lv/JDbg0behIdomS00K9Ht6yZj
        R1XK02mGRW1wnZ7PpDU8oRDcNK5ucIE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-q88C6hjzNZ6DHaFsjFFN3A-1; Fri, 11 Sep 2020 13:22:38 -0400
X-MC-Unique: q88C6hjzNZ6DHaFsjFFN3A-1
Received: by mail-wr1-f72.google.com with SMTP id v5so3682417wrs.17
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 10:22:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b9qx2qlxmgrx8g4SP7cER56cDyTBCXp5uBJkmrojiRE=;
        b=l6j8vsMGyTPC1GmOZKEDWDSUas4PEBRzbOL84jzVVrUXBBA0rVaoxaB4zLorVSJ47E
         3wQ/VlsHoMa5KCulw4Ra+ki6uhBGn/gl2Vjl3U6aBydAhRbiN4LgNHZKG2jqlBoHBmuo
         Tke31VWInN4gOhHK6sugTo1W8uLOZcPW5A3oY/O2vMhI5zNPJ8mxJhNL4ySmUZT1NYe2
         KI43kxWVs6KHxoaqeoROEW2cVUtwOu9MgNFoCR2CuWlgKw0qUVUMnw8NmoNzgjluCnfl
         aur/G6e8JYtkD8hhAiXt9xbNkqnCbahljTLwVfUhBbgWiiOg1x7cfeYbdfEunPikKuDk
         fhKg==
X-Gm-Message-State: AOAM530Zst1gnbVneft93Y5cmaIMrVIpaJQi6fSXMc4oiLJVg/3dCPe8
        S4ZkpLVit+ztLtlgH/nABkRd1wmc4koTH/KXgusVsngOhi4D035cw9BeEWXdvuyImaQrqDyGi2j
        EdOP96A6rZE4d5tkX
X-Received: by 2002:a5d:5642:: with SMTP id j2mr3032032wrw.417.1599844956770;
        Fri, 11 Sep 2020 10:22:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxN970uQGHeqNsDfX8zqVtxxRcMZinj6LzWeXLpufZX1PCxyV3o7NKOYAslRlwaxYToKmqKeg==
X-Received: by 2002:a5d:5642:: with SMTP id j2mr3032008wrw.417.1599844956552;
        Fri, 11 Sep 2020 10:22:36 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id i16sm5676312wrq.73.2020.09.11.10.22.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 10:22:36 -0700 (PDT)
Subject: Re: [PATCH] KVM: MIPS: Change the definition of kvm type
To:     Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
References: <1599734031-28746-1-git-send-email-chenhc@lemote.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <45a71ce2-42d2-ba49-72a3-155dacede289@redhat.com>
Date:   Fri, 11 Sep 2020 19:22:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1599734031-28746-1-git-send-email-chenhc@lemote.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/09/20 12:33, Huacai Chen wrote:
> MIPS defines two kvm types:
> 
>  #define KVM_VM_MIPS_TE          0
>  #define KVM_VM_MIPS_VZ          1
> 
> In Documentation/virt/kvm/api.rst it is said that "You probably want to
> use 0 as machine type", which implies that type 0 be the "automatic" or
> "default" type. And, in user-space libvirt use the null-machine (with
> type 0) to detect the kvm capability, which returns "KVM not supported"
> on a VZ platform.
> 
> I try to fix it in QEMU but it is ugly:
> https://lists.nongnu.org/archive/html/qemu-devel/2020-08/msg05629.html
> 
> And Thomas Huth suggests me to change the definition of kvm type:
> https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg03281.html
> 
> So I define like this:
> 
>  #define KVM_VM_MIPS_AUTO        0
>  #define KVM_VM_MIPS_VZ          1
>  #define KVM_VM_MIPS_TE          2
> 
> Since VZ and TE cannot co-exists, using type 0 on a TE platform will
> still return success (so old user-space tools have no problems on new
> kernels); the advantage is that using type 0 on a VZ platform will not
> return failure. So, the only problem is "new user-space tools use type
> 2 on old kernels", but if we treat this as a kernel bug, we can backport
> this patch to old stable kernels.

I'm a bit wary to do that.  However it's not an issue for QEMU since it
generally updates the kernel headers.

Paolo

> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/kvm/mips.c     | 2 ++
>  include/uapi/linux/kvm.h | 5 +++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index d7ba3f9..9efeb67 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -138,6 +138,8 @@ extern void kvm_init_loongson_ipi(struct kvm *kvm);
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
>  	switch (type) {
> +	case KVM_VM_MIPS_AUTO:
> +		break;
>  #ifdef CONFIG_KVM_MIPS_VZ
>  	case KVM_VM_MIPS_VZ:
>  #else
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 29ba8e8..cfc1ae2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -790,9 +790,10 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_VM_PPC_HV 1
>  #define KVM_VM_PPC_PR 2
>  
> -/* on MIPS, 0 forces trap & emulate, 1 forces VZ ASE */
> -#define KVM_VM_MIPS_TE		0
> +/* on MIPS, 0 indicates auto, 1 forces VZ ASE, 2 forces trap & emulate */
> +#define KVM_VM_MIPS_AUTO	0
>  #define KVM_VM_MIPS_VZ		1
> +#define KVM_VM_MIPS_TE		2
>  
>  #define KVM_S390_SIE_PAGE_OFFSET 1
>  
> 

