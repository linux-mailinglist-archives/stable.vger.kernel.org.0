Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07212CA0A7
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 12:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbgLAK50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 05:57:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48372 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730281AbgLAK50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 05:57:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606820160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YNmzJgJQLIGrY0kWToPJSLKakWyOb7HVyuXtRLTuB8E=;
        b=PQ4sNKFXk4YM0SL6kAKU3qMLXHNZv7bwqHZe8Z5/kBjtAfrZyN63pe+0MR/vOCs0OtC/+H
        cAvtMi3Q0usvvpRfdf3IiWJN3DVYLeBvTPlQm9cUHkE3XQDWBMbSo+jHYddkTG5pLNdF/G
        TKs1ha82IBl05JshtyhxTQQ+N8mGcY8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-h-19A6p4NrSh_UWr5FSgnQ-1; Tue, 01 Dec 2020 05:55:58 -0500
X-MC-Unique: h-19A6p4NrSh_UWr5FSgnQ-1
Received: by mail-ej1-f71.google.com with SMTP id e7so1004480eja.15
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 02:55:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YNmzJgJQLIGrY0kWToPJSLKakWyOb7HVyuXtRLTuB8E=;
        b=HiWsS79ph8koOq6XRLJ6mKW8YhNNaswY5tSsPlor7ZxEbzIZhl/D01uNbOzX3mKNzU
         CTCnCOecChwmYG28gE5Ef2KzdVs8GWBnvNr10Pz0g97kcFvC+T3V7KXZSXs9EG3fEnv1
         QA7+od1MIRin1bjLQ7kHq+GUg9mMJ/whzyWC6TdHZswPVLdOz97nHuOdSBuSwV2LM/Fb
         6dc0vgbDOQi6NWNS0iL592NGGn8j6X2IQ0ONJW/FfzvbPAUMpE6ScLMDMWt0A8TU1kNM
         nG2IVQXgXD9xnNvow6ogX2pTV0+AE7zf3keIIb5zMW0W2mEziijMwV+8l7sgPSpDFBP1
         x7PQ==
X-Gm-Message-State: AOAM5300J6gR7WFAWqnGG1/Tdt8csLOYxJfJjCUiDPc04/BYYIiDO6W1
        yBEmazs2kUhmVSGaxWB7xxWafCZwY61LLK5pZZ8lryADZhAU6Bw/c3btRbsXaSeBdMiTJK84gCS
        bI5+EIeG00x3fY6MT
X-Received: by 2002:aa7:dc05:: with SMTP id b5mr2437763edu.47.1606820157437;
        Tue, 01 Dec 2020 02:55:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyy59KJA4uSChalvYHv1solJ1McrcUqAiGkBuL/vfQh0c20l3gQAj1/6gwR35CKHhPUGUlP5w==
X-Received: by 2002:aa7:dc05:: with SMTP id b5mr2437751edu.47.1606820157251;
        Tue, 01 Dec 2020 02:55:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k16sm657569ejv.93.2020.12.01.02.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 02:55:56 -0800 (PST)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        Nikos Tsironis <ntsironis@arrikto.com>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201084648.690944071@linuxfoundation.org>
 <d29c4b25-33f6-8d99-7a45-8f4e06f5ade6@redhat.com>
 <X8YThgeaonYhB6zi@kroah.com>
 <fe3fa32b-fc84-9e81-80e0-cb19889fc042@redhat.com>
 <X8YY2qW3RQqzmmBl@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4.19 08/57] KVM: x86: Fix split-irqchip vs interrupt
 injection window request
Message-ID: <d3311713-013b-003c-248b-22ebf1e45c7c@redhat.com>
Date:   Tue, 1 Dec 2020 11:55:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X8YY2qW3RQqzmmBl@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/12/20 11:20, Greg Kroah-Hartman wrote:
> Ok, I will go drop this patch from 4.14, 4.9, and 4.4.  Or, should the
> needed pre-requisite patch be properly backported there instead?

I would just drop it.  It was not reported in five years so it's quite 
unlikely that people will see the bug.

> And was it marked somewhere that this patch depended on that one and I
> just missed it?

I don't see anything in stable-kernel-rules.rst about how to mark such 
semantic conflicts, so no, it wasn't marked.  (The commit message does 
say "thanks to the previous patch", but I don't expect you or your 
scripts to notice that!).

Thanks,

Paolo

