Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD86302E94
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 23:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733085AbhAYWBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 17:01:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733095AbhAYWBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 17:01:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611611993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lTaS+FJ+pDjg42gXdYSeQXvC2ANYuAqrw02JSEW1Iro=;
        b=WsEloqmdVveSVnX3eRyfSivhA5X8F6ihjftLx1FoHtLjJkp0w5mD9STTN8FSNwg2E1d37a
        LjPqEHq0FD0QVF6Qa8fAlcV/dalZ9KAh8H3AczhPbXRE2aWkOL4AXDyG9mqUsraMXmSrHX
        L+imaj7JE2cV4seAbqhHaG6eraoVxFc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-C3dRv2MlP6-5Fq2xv2myBQ-1; Mon, 25 Jan 2021 16:59:52 -0500
X-MC-Unique: C3dRv2MlP6-5Fq2xv2myBQ-1
Received: by mail-ed1-f69.google.com with SMTP id j12so8251376edq.10
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 13:59:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lTaS+FJ+pDjg42gXdYSeQXvC2ANYuAqrw02JSEW1Iro=;
        b=UlYtyU2hzR5Cw9wSjyiDvfAGeRrql3LB8HpnrQ2ty0/EDzoaO6uJzvuixW2D3uOSDk
         I4IL5xi19jf0a0MQKqYoiRBMY+O+Z6ZBz3yEPvCmMdQ2ime5Onr/uuDyo2S74uIzdlqi
         uvht10ZHFVnk2wlfOkHT/coTqGiIcQaTG2a4yqDcHwxRxg2LG9q6icvTNQGcCzmB4Z7B
         ax9eZ0sEX+rotkR2mRSqbCuXU7LdAgdz3reJMOPOGyj0WW0xukjX/l/WEOk/836VqgGu
         WrIh3r3buu9DyvToabWB8091ekwJ3NuAZ/cSV5VCsGh6cYdyN+B/4Cso4RmgIP8WdznO
         YMUQ==
X-Gm-Message-State: AOAM532IZBAhzN5gaw9J4PPIcrFfmkmwaCbBXkXOIHAbJYZYQ+uSITDG
        O78dmCtpjgqMMZtkH7fp0ks3HSQucP4iOsJbh2+7nX4oSYfCFUo+NISm6mNZox9XTLy0v2N+tnN
        OsHCi+GaXhStIYCPdbxcIXzdCqXVew01Uqy8o0ZfOP0JcZAjz054hT2ANcfPe/c7T+hLZ
X-Received: by 2002:a17:906:653:: with SMTP id t19mr1628479ejb.44.1611611990767;
        Mon, 25 Jan 2021 13:59:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwFicYGI8UZfLBuXqK/9ExrQkJcwoegaqfEX0vXIxsXsElafNGgvf039NuqutCFQCTGnV9zJA==
X-Received: by 2002:a17:906:653:: with SMTP id t19mr1628467ejb.44.1611611990543;
        Mon, 25 Jan 2021 13:59:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d9sm8882754ejy.123.2021.01.25.13.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 13:59:49 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside
 guest mode for VMX
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <20210125172044.1360661-1-pbonzini@redhat.com>
 <YA8ZHrh9ca0lPJgk@google.com>
 <0b90c11b-0dce-60f3-c98d-3441b418e771@redhat.com>
 <YA8hwsL8SWzWEA0h@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0a1e025a-ff66-8a68-1eae-8797a0a34419@redhat.com>
Date:   Mon, 25 Jan 2021 22:59:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YA8hwsL8SWzWEA0h@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/01/21 20:53, Sean Christopherson wrote:
> Eh, I would argue that it is more common to do KVM_REQ_GET_NESTED_STATE_PAGES
> with is_guest_mode() than it is with !is_guest_mode(), as the latter is valid if
> and only if eVMCS is in use.  But, I think we're only vying for internet points.:-)
> 
>> however the idea was to remove the call to nested_get_evmcs_page from
>> nested_get_vmcs12_pages, since that one is only needed after
>> KVM_GET_NESTED_STATE and not during VMLAUNCH/VMRESUME.
>
> I'm confused, this patch explicitly adds a call to nested_get_evmcs_page() in
> nested_get_vmcs12_pages().

What I really meant is that the patch was wrong. :/

I'll send my pull request to Linus without this one, and include it 
later this week.

Paolo

