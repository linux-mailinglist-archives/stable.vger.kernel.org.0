Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1207C511D57
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242220AbiD0Qah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 12:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243152AbiD0Q2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 12:28:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7EBC7366B3
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cpdTKSdO+rieFpHnkUAZpM/6Dw8rA4JkcSTNkjZ8rq0=;
        b=HhTHtiAmg5UBUPuBJOnN2ZRMUzf+PQW4XcqiepYv3IgHMOUWfU8ZoNW7dnqWt32KQU2Y8v
        wS3zcFzdab7oSopE2dBoSdxfqd7Kwz5UsbJsPpmhGJZcLBOxWKBgmtxU+E47nUUugJZaRg
        iL5v30XYEFs5nnXD7BWjXQbT2RM8KHk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-Am-Xo0OjO5uLgmfHIi54rw-1; Wed, 27 Apr 2022 12:19:29 -0400
X-MC-Unique: Am-Xo0OjO5uLgmfHIi54rw-1
Received: by mail-ed1-f69.google.com with SMTP id s24-20020a05640217d800b00425e19e7deaso1265069edy.3
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cpdTKSdO+rieFpHnkUAZpM/6Dw8rA4JkcSTNkjZ8rq0=;
        b=OA9ImEI5p7qcl6T6PemRgA1oSX8BA27hTA3XvmrRu0VnuSxstimFDRBuzJJU4b+g0o
         AjHDeZk36JfUWYbqWTjnKrleJUKSCwVbeUd57N6npprnoVXsLdTkEX58i/WW7oDQE3qu
         VJxIC0jLhUdUtE3oFM9eoRy0FUx+/cnkJfRrcT7hOIMeu/q1nX24JezUTAJoqeXzBc9R
         vnFMTD16g6AEythUMUUivBIj+rVdAKr45eL35bv/ryJ96MuKR84Bqc/huDDNu6QKfvoj
         69C8H7RHKaCM4ciYfo/ACjJxBFVmTNLLGkYgr1ibfIi24aVyPnbMA6P6mDqypTA0DWCz
         9AHw==
X-Gm-Message-State: AOAM531h+Ump6PnCLYndhhHyT+sgGKhFRMtJd8D27CsvoNZzQ4r/pREn
        PbcjU669HDTvfThZejko+puhYQYBDe9kc7ujc9i3RRBQWy0bGHwHZmLrvHxcrhAXEzID3dhNGW2
        CxA0IAeHkQJJwTkJU
X-Received: by 2002:a05:6402:4004:b0:426:1a0a:a2b8 with SMTP id d4-20020a056402400400b004261a0aa2b8mr2943537eda.241.1651076367942;
        Wed, 27 Apr 2022 09:19:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRi274/0pJFnefUE34/+I0M2mwYpfNL1VVyniwojXwdGQHhToi5cq0Vivpg5gmlGbu04FBdw==
X-Received: by 2002:a05:6402:4004:b0:426:1a0a:a2b8 with SMTP id d4-20020a056402400400b004261a0aa2b8mr2943517eda.241.1651076367773;
        Wed, 27 Apr 2022 09:19:27 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id t27-20020a1709063e5b00b006f3a94f5194sm3347586eji.77.2022.04.27.09.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:19:27 -0700 (PDT)
Message-ID: <032e22bd-4faa-7a0c-da78-8bf7ee3df31f@redhat.com>
Date:   Wed, 27 Apr 2022 18:19:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.15 2/7] KVM: selftests: Silence compiler
 warning in the kvm_page_table_test
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20220427155431.19458-1-sashal@kernel.org>
 <20220427155431.19458-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155431.19458-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/22 17:54, Sasha Levin wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> [ Upstream commit 266a19a0bc4fbfab4d981a47640ca98972a01865 ]
> 
> When compiling kvm_page_table_test.c, I get this compiler warning
> with gcc 11.2:
> 
> kvm_page_table_test.c: In function 'pre_init_before_test':
> ../../../../tools/include/linux/kernel.h:44:24: warning: comparison of
>   distinct pointer types lacks a cast
>     44 |         (void) (&_max1 == &_max2);              \
>        |                        ^~
> kvm_page_table_test.c:281:21: note: in expansion of macro 'max'
>    281 |         alignment = max(0x100000, alignment);
>        |                     ^~~
> 
> Fix it by adjusting the type of the absolute value.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Message-Id: <20220414103031.565037-1-thuth@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/testing/selftests/kvm/kvm_page_table_test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
> index 36407cb0ec85..f1ddfe4c4a03 100644
> --- a/tools/testing/selftests/kvm/kvm_page_table_test.c
> +++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
> @@ -278,7 +278,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
>   	else
>   		guest_test_phys_mem = p->phys_offset;
>   #ifdef __s390x__
> -	alignment = max(0x100000, alignment);
> +	alignment = max(0x100000UL, alignment);
>   #endif
>   	guest_test_phys_mem &= ~(alignment - 1);
>   

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

