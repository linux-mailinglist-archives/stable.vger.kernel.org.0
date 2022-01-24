Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356F649875F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 18:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244769AbiAXR5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 12:57:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30229 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244534AbiAXR5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 12:57:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643047065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rgeMHkDWS/Keb+LY1LydmJ2vplko8qiVOsYgNB/f9E4=;
        b=Y6cTYwUDmaC1x00BWJ5OxeZ+q837BCGdqFZONwbkv5SZxtGHh7/xusqGq3LhZOyGGsHaSj
        PIgESlEcQgoMFiRagIkiUoq6AK7YIEJB2mZBKbSCpmWUAsuVqCLlmfbifHh2gujeuhpqrv
        kldOyxXv468N5Pp/3AH1UtNiquz7AWs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-j7PsLxTMOvujVdictVFxfQ-1; Mon, 24 Jan 2022 12:57:43 -0500
X-MC-Unique: j7PsLxTMOvujVdictVFxfQ-1
Received: by mail-ej1-f71.google.com with SMTP id q3-20020a17090676c300b006a9453c33b0so2403147ejn.13
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 09:57:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rgeMHkDWS/Keb+LY1LydmJ2vplko8qiVOsYgNB/f9E4=;
        b=3ymMstqIC3eUpH9YNvkdct/BNfcll+ae9nUE+xrxS1zwDKGJaW/1mUNf3VlSpoG2Wf
         J+tAWiQzB2VGQWzkly9QDAaVYszXkFLgVKA59AT7GzuSZy609N4Te+cLkV3F9aQfFaKL
         KlvroZByD0lOi4vMJmh+EiyxM/A5ptrS4iGBAozx6NHJX7TPo1TGUDOE+gABKoe+6337
         KHiHyNHo5yWzsDCMD2H+hk4/5UpxE9kWljKzm1HaFZIgu25bkFwOWDz0LtsmLz8x/69Q
         3TRtLN3Yuc8D0VjW3Q3BZQ1RjihyDU9gtU5xGWZIdRrPEFONXlB9qq2f217qh5h2H+Ul
         ho9g==
X-Gm-Message-State: AOAM533D0qY2ZdqhYODnTAIugjAmpoydarlh8Usv9BPbIOE/4Wg+r49P
        s0qnaRSqzEvXEn9iMQ555TJetvQ6bXMLKabnAgndJAJui0Lj2EmpJnRxM/4iqj8NcE41es8Iii5
        Q0o5MUCuDGG+1qnI/
X-Received: by 2002:a17:906:6a0c:: with SMTP id qw12mr13462093ejc.483.1643047062734;
        Mon, 24 Jan 2022 09:57:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxVE6Ys9MeGKTHYlEi84DRwK2GdMN+iigJHo7FPvFxHlo7vNWD9nhtifWmbP11ndVbS+be4tA==
X-Received: by 2002:a17:906:6a0c:: with SMTP id qw12mr13462080ejc.483.1643047062537;
        Mon, 24 Jan 2022 09:57:42 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id s7sm5147079ejo.212.2022.01.24.09.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 09:57:41 -0800 (PST)
Message-ID: <a0b8e06c-43e7-b158-5328-49a61d979a56@redhat.com>
Date:   Mon, 24 Jan 2022 18:57:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: FAILED: patch "[PATCH] KVM: x86/mmu: Fix write-protection of PTs
 mapped by the TDP" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sean Christopherson <seanjc@google.com>, stable@vger.kernel.org
References: <1642944976217120@kroah.com>
 <CALzav=eObKuocK9KOzsEACQ+8Uy9arNGzTPUc2CwUmdNAfvAyg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALzav=eObKuocK9KOzsEACQ+8Uy9arNGzTPUc2CwUmdNAfvAyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 18:54, David Matlack wrote:
> On Sun, Jan 23, 2022 at 5:36 AM <gregkh@linuxfoundation.org> wrote:
>>
>>
>> The patch below does not apply to the 5.10-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
> 
> I'll take a look and send a backport to 5.10.

It's just context, in that 5.10 didn't have shadow_mmu_writable_mask yet 
(and instead has a constant SPTE_MMU_WRITABLE).  Thanks for fixing it up!

Paolo

>> index 7b1bc816b7c3..bc9e3553fba2 100644
>> --- a/arch/x86/kvm/mmu/tdp_mmu.c
>> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
>> @@ -1442,12 +1442,12 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
>>                      !is_last_spte(iter.old_spte, iter.level))
>>                          continue;
>>
>> -               if (!is_writable_pte(iter.old_spte))
>> -                       break;
>> -
>>                  new_spte = iter.old_spte &
>>                          ~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
>>
>> +               if (new_spte == iter.old_spte)
>> +                       break;
>> +
>>                  tdp_mmu_set_spte(kvm, &iter, new_spte);
>>                  spte_set = true;
>>          }
>>
> 

