Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10CF775321
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 17:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389483AbfGYPrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 11:47:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46216 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfGYPrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 11:47:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so51289673wru.13
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 08:47:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8E/W+J79L+KYsv7Uh31e54tPI2Vvux5yVJ3FL+wNPf4=;
        b=GyiUdWoPoIegx289HEt+A0GbmXupt9Lnv+8PrmAqGE/0caeEeWkgvxF5EFkJ16gu10
         fkZUmkm1lZdm25BYbQpg1zlueALjTZqddfcNs8TmBw375ENzsPv0CG9mhXb0f0ABWTya
         H43o8toNT8ggI++Xgli9Az1HHNx+1SWxwYf2s/xCP419efI6553ifJnH7bfWOdaTXXgN
         Mbbsjx5da4TYZd1nsVPM7RZpB0ZuNlcOjf8gABLglrSf/N7B3I2NP1OWWcGdGD50iFT/
         zxXOlr0ZRM8lq2YYo2Vn22n55rPYBynDp0E6mrMLFIdLSGs+Xej0Ky2IOU9+ZMjB9hL2
         T40A==
X-Gm-Message-State: APjAAAVQNyX0m/H1dsUUjM7PZZw4Gmci9olLqG5AxPAhMxk4W8xEIHgv
        jqTIRNqHaOkuQPOSEyvCPkK1tw==
X-Google-Smtp-Source: APXvYqx8F4rl5cD7W/KK+pbOY5/EcnFeHrrid7MBUlv1f7jQoc3usw2wMBNEimIgXyzH9Mg8NMGD3g==
X-Received: by 2002:adf:f046:: with SMTP id t6mr10549790wro.307.1564069664285;
        Thu, 25 Jul 2019 08:47:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:cc23:f353:392:d2ee? ([2001:b07:6468:f312:cc23:f353:392:d2ee])
        by smtp.gmail.com with ESMTPSA id n5sm38864628wmi.21.2019.07.25.08.47.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 08:47:43 -0700 (PDT)
Subject: Re: [PATCH stable-5.2 0/3] KVM: x86: FPU and nested VMX guest reset
 fixes
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <20190725120436.5432-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5c3736e4-4987-5396-c3a7-c5c97241eb2d@redhat.com>
Date:   Thu, 25 Jul 2019 17:47:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725120436.5432-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/07/19 14:04, Vitaly Kuznetsov wrote:
> Few patches were recently marked for stable@ but commits are not
> backportable as-is and require a few tweaks. Here is 5.2 stable backport.
> 
> [PATCHes 2/3 of the series apply as-is, I have them here for completeness]
> 
> Jan Kiszka (1):
>   KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested
> 
> Paolo Bonzini (2):
>   KVM: nVMX: do not use dangling shadow VMCS after guest reset
>   Revert "kvm: x86: Use task structs fpu field for user"
> 
>  arch/x86/include/asm/kvm_host.h |  7 ++++---
>  arch/x86/kvm/vmx/nested.c       | 10 +++++++++-
>  arch/x86/kvm/x86.c              |  4 ++--
>  3 files changed, 15 insertions(+), 6 deletions(-)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
