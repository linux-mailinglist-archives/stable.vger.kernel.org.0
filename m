Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8254980E1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiAXNR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:17:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229729AbiAXNR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:17:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643030277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HeuS2baLvHEAE0h8q4pdEY2wBJ0BZx+TVvgA8mNherA=;
        b=OiF0I+E3yGBJNYNArhOroSevnVaxmxk0H0DU2613IDDRUsdtvoMRGYUQdSS9JB346ZYkYs
        qQXoMKa0ovtzltjw+J6N7ydTV8FcZFiWQ5+AMXZxaIltsbTShQd5kvLX0gk6wCJt6yImMB
        uOkmr1mMGm6/dVisgDfCI/reGnQIeLY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-NJe_f0kOMWyVR8Nt9PqpxQ-1; Mon, 24 Jan 2022 08:17:56 -0500
X-MC-Unique: NJe_f0kOMWyVR8Nt9PqpxQ-1
Received: by mail-ed1-f71.google.com with SMTP id bc24-20020a056402205800b00407cf07b2e0so2593423edb.8
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:17:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HeuS2baLvHEAE0h8q4pdEY2wBJ0BZx+TVvgA8mNherA=;
        b=yDNOhCM2YfpadXf0/biI8/9aHnhE2VGRVi/dz64wbOUT4cwnTOBi0U61lpITWbvvb4
         vvpTzLjyel14TQa1UD5lDrpyL2DK0e0NJKQKTlUTxPJLwdU8hoTYKZBb4QycWntIArrE
         9BzHwHHRfByFMG0gBQNXgvovVvUj8H3J7hzzGPDvbTU3FnzjdBg6dVLG3KufyQt35gHk
         qIC8W7DhiOMlgyRTl/Vp2JAXiXtv1Vg/LIZEsSG/3bkdlGv7povOdzwwv9YKE9RJKcsZ
         PdMlU19CaMQqUtU2u7uc3YDhizp+x7/6HomU3KPK+YfO+L5ER/RhRyNtq3jhp9qax+9Y
         +WPQ==
X-Gm-Message-State: AOAM531acG8m4PAlyafvJl3rCwbSr9ahMDFoFOqB40DZZuOY/+d2bg3i
        +xSyzKqXmA4gVS6yccmZea1dETwA4DkL0fvuwoY6aJ9WUsx49sM7aQ/Nl7k9Z1ndy8ZvP4UWQAS
        im7LXIp3vhuY5CjRE
X-Received: by 2002:a17:907:608d:: with SMTP id ht13mr12532799ejc.193.1643030274400;
        Mon, 24 Jan 2022 05:17:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyzh7iHVFtNA+6WJxhCXMF42fG/KEhfvz0RJMR4+jUhLXUBGU0MJYVKsKBtLXP0mYSqJGMWig==
X-Received: by 2002:a17:907:608d:: with SMTP id ht13mr12532786ejc.193.1643030274156;
        Mon, 24 Jan 2022 05:17:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id c14sm6613556edy.66.2022.01.24.05.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 05:17:53 -0800 (PST)
Message-ID: <3a46a1b5-88ec-83c1-53ac-a08e5900062f@redhat.com>
Date:   Mon, 24 Jan 2022 14:17:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH stable 5.16 v1 0/4] KVM: x86: Partially allow
 KVM_SET_CPUID{,2} after KVM_RUN for CPU hotplug
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, stable@vger.kernel.org
Cc:     Igor Mammedov <imammedo@redhat.com>, gregkh@linuxfoundation.org
References: <20220124130534.2645955-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220124130534.2645955-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 14:05, Vitaly Kuznetsov wrote:
> This is a backport of the recently merged "[PATCH v3 0/4] KVM: x86:
> Partially allow KVM_SET_CPUID{,2} after KVM_RUN for CPU hotplug"
> (https://lore.kernel.org/kvm/20220118141801.2219924-1-vkuznets@redhat.com/)
> 
> Original description:
> 
> Recently, KVM made it illegal to change CPUID after KVM_RUN but
> unfortunately this change is not fully compatible with existing VMMs.
> In particular, QEMU reuses vCPU fds for CPU hotplug after unplug and it
> calls KVM_SET_CPUID2. Relax the requirement by implementing an allowing
> KVM_SET_CPUID{,2} with the exact same data.
> 
> Vitaly Kuznetsov (4):
>    KVM: x86: Do runtime CPUID update before updating
>      vcpu->arch.cpuid_entries
>    KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
>    KVM: selftests: Rename 'get_cpuid_test' to 'cpuid_test'
>    KVM: selftests: Test KVM_SET_CPUID2 after KVM_RUN
> 
>   arch/x86/kvm/cpuid.c                          | 90 ++++++++++++++-----
>   arch/x86/kvm/x86.c                            | 19 ----
>   tools/testing/selftests/kvm/.gitignore        |  2 +-
>   tools/testing/selftests/kvm/Makefile          |  4 +-
>   .../selftests/kvm/include/x86_64/processor.h  |  7 ++
>   .../selftests/kvm/lib/x86_64/processor.c      | 33 ++++++-
>   .../x86_64/{get_cpuid_test.c => cpuid_test.c} | 30 +++++++
>   7 files changed, 139 insertions(+), 46 deletions(-)
>   rename tools/testing/selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c} (83%)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

