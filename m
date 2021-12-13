Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BA0472F42
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbhLMO2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbhLMO2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:28:42 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB37C061574;
        Mon, 13 Dec 2021 06:28:41 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id x15so53564384edv.1;
        Mon, 13 Dec 2021 06:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lH/u/WZORyTw93ftG0jcdGDeH90HRutLhnktEYOm1o8=;
        b=MZXTurEsFW6nIeXzoce67jVgRYKJYIPLDD2LdXvEl3ZXmrIGPmpH/M4eGTNDIWYl7y
         4fdBH1Fo48fLM1CAd/w32SvcydI/Bj65Qt6Nl7LQFyoYGirdfamAmEY12h7QT0L5w/Z2
         pDGbDMsgQj6ujz9TES0BZwu0vBQJ5TgwbJ5qRlhsniXBXWvUqajc9LuTA75qxFdnOnkL
         U0oiud4dcM5RsamuokVamRsjgr9AxoqDnuLSesam2tY3VNrW5v0V6vW/AL/qSwbNalIU
         F6LDjOvfPUBy9kRa79D4FbY9vqRnksl19tB1T7zr4MykhTZ5tOuzlacw0lSDoCM+YZRZ
         92Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lH/u/WZORyTw93ftG0jcdGDeH90HRutLhnktEYOm1o8=;
        b=BHC2HgmvdG00nLS9zEtyNjDcLtPrGnBhqUFt8bmXzWsQmYyyenmApQFyhbSFVsKbEa
         hJ2w8jOlYZsoxUy8EW//RQQjN5NKBc6t1gKseApWPAnafTFjPqF/tOZC0lQcPstbHQL6
         uCulpIlwe5DYkov5eLyaeZiHtyr/CFZDzSH6WG4Zd6wJUSxWx0gJyJoHayyVWeHL5o/C
         yXNCPbMg4vA+WiKvWoYbXU3zm6+smyTmNx5u6pWASIbm9+gB9+Wd28+pCh7irYRHxHJp
         cnuCYqmCluEowkRzK0P3hVbR8MYNve+1jI4EADswxA+7Cw1Ob/r6qKMPGL+qSwX4IDYu
         F6yQ==
X-Gm-Message-State: AOAM530UhNmbYK900epIHFZ0pYR2dSWMKYPEGocreWbBZph/3qM92dTd
        hTTbbcdbYjp/8GAVZLLKL1w=
X-Google-Smtp-Source: ABdhPJyH/5EB+Ov04JsNBfwUHjFDwGg8pBP/2wkTcUT2xQWNo2N1v7gFUUlBGhYtkGNwRxQC8OVkGg==
X-Received: by 2002:a17:907:3f07:: with SMTP id hq7mr44436776ejc.420.1639405720253;
        Mon, 13 Dec 2021 06:28:40 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id t7sm6589950edi.90.2021.12.13.06.28.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 06:28:39 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <e910756d-525d-4d37-6ede-f04c61cc8d2e@redhat.com>
Date:   Mon, 13 Dec 2021 15:28:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH MANUALSEL 5.15 9/9] x86/kvm: remove unused ack_notifier
 callbacks
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20211213141944.352249-1-sashal@kernel.org>
 <20211213141944.352249-9-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213141944.352249-9-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 15:19, Sasha Levin wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> [ Upstream commit 9dba4d24cbb5524dd39ab1e08886373b17f07ff2 ]
> 
> Commit f52447261bc8c2 ("KVM: irq ack notification") introduced an
> ack_notifier() callback in struct kvm_pic and in struct kvm_ioapic
> without using them anywhere. Remove those callbacks again.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Message-Id: <20211117071617.19504-1-jgross@suse.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/ioapic.h | 1 -
>   arch/x86/kvm/irq.h    | 1 -
>   2 files changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> index 27e61ff3ac3e8..f1b2b2a6ff4db 100644
> --- a/arch/x86/kvm/ioapic.h
> +++ b/arch/x86/kvm/ioapic.h
> @@ -81,7 +81,6 @@ struct kvm_ioapic {
>   	unsigned long irq_states[IOAPIC_NUM_PINS];
>   	struct kvm_io_device dev;
>   	struct kvm *kvm;
> -	void (*ack_notifier)(void *opaque, int irq);
>   	spinlock_t lock;
>   	struct rtc_status rtc_status;
>   	struct delayed_work eoi_inject;
> diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
> index 650642b18d151..c2d7cfe82d004 100644
> --- a/arch/x86/kvm/irq.h
> +++ b/arch/x86/kvm/irq.h
> @@ -56,7 +56,6 @@ struct kvm_pic {
>   	struct kvm_io_device dev_master;
>   	struct kvm_io_device dev_slave;
>   	struct kvm_io_device dev_elcr;
> -	void (*ack_notifier)(void *opaque, int irq);
>   	unsigned long irq_states[PIC_NUM_PINS];
>   };
>   
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Let's save 24 bytes per VM. :)

Paolo
