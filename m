Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BA245FE14
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 11:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhK0Kaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 05:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhK0K2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 05:28:39 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF60DC061574;
        Sat, 27 Nov 2021 02:25:24 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y12so49021207eda.12;
        Sat, 27 Nov 2021 02:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=IAH8eQywKcQXyygvt8sMxPMX5sEe/5OuFPFc3e44zPM=;
        b=TDUxD80SMUrquWn2GJa19LWBifFELy9ctNFAuQiopqsV8xnpQsANgdyxZ6gCAsFtSB
         UosANVUtXBN9h8pMt59yxpmX0633f3CyUl82J+LPgWijhE5zVwi2+aWclLKkG8qU2S3Q
         tzzKXbibFX2ApmgxJZM9WQBHitgv8iICGA61kHUk1MQ3wu6lzN6JOAdFY7I2vtxNKbZK
         qnYez4grFv2Kji82aZLUkqs+kCHOYgACxF8a52oicU+olibCzQfX37wynfbBpTiF1MrR
         Q+54zkOlpFqyxkpqJji+nuUWwfwtbojedKAlkQqx9OdqEimPbS2X0iuszGfawHF09TY+
         qekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=IAH8eQywKcQXyygvt8sMxPMX5sEe/5OuFPFc3e44zPM=;
        b=GsMwkOkk0iLmZ/K4GzMtwW4536ke5TaXIhw6RFjKFYR6VYQjX2dhoWHKKyCJ/meEq4
         7hiQIVBkC2Binxekq7r9oUnSVRxTAZB7or58cxaFmb2xR9mH49/ySW4nYwmi/9frwGuC
         tuXXKrMaRU9X9DvrG1p8A83LcWjQ11hKYkCyPXlE5CxLTpplrw9cLEe03jXKNsy/Cm3w
         yZDI+FpmEZaYpfjfNXKYXYRTyWSIlfYO1sBc7w9L4tEXOm1llQFx5i+bQ5MXvhKW29kK
         j2X/jUkkRrMlLn2m3bGelddxo7qj/mPg3pPcPjmGDU/UdPaIwb553qCtRtjd6iO4zvCR
         nxeA==
X-Gm-Message-State: AOAM531kimm9ibzxuGx8clbaX/fQP6a3xd4Hqj/ex2EiXli1JqYNOsyt
        JAQATDRkJ+SjO9OJu8EHpSY=
X-Google-Smtp-Source: ABdhPJwp9FZxKpc89c921E5Gk9DJjdAAbI37HUmRmNixcN21oFuT7Rrf1BDb3Z37gKXpWEdCo9wCcw==
X-Received: by 2002:a17:906:bcce:: with SMTP id lw14mr45139426ejb.411.1638008723383;
        Sat, 27 Nov 2021 02:25:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id u10sm5208993edo.16.2021.11.27.02.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Nov 2021 02:25:23 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <b5e2c332-59a8-7fa8-5e59-4cb2e5be3b8d@redhat.com>
Date:   Sat, 27 Nov 2021 11:25:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Lai Jiangshan <laijs@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>
References: <20211126132131.26077-1-pbonzini@redhat.com>
 <2091ec8e-299a-8b3d-596e-75cf4b68fde1@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: MMU: shadow nested paging does not have PKU
In-Reply-To: <2091ec8e-299a-8b3d-596e-75cf4b68fde1@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/21 02:21, Lai Jiangshan wrote:
> 
> 
> On 2021/11/26 21:21, Paolo Bonzini wrote:
>> Initialize the mask for PKU permissions as if CR4.PKE=0, avoiding
>> incorrect interpretations of the nested hypervisor's page tables.
> 
> I think the AMD64 volume2 Architecture Programmer’s Manual does not
> specify it, but it seems that for a sane NPT walk, PKU should not work
> in NPT.

The PK bit is not defined in the nested page fault EXITINFO1, too. 
Thomas, can you have it fixed in the APM that the host's SMEP, SMAP and 
PKE bits do not affect nested page table walks?

> I once planed to set
> 
>      cr0 = X86_CR0_PG | X86_CR0_WP;
>      cr4 = cr4 & ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
> 
> It adds X86_CR0_WP and removes smep smap just because it is always usermode
> access, and it has no meaning for CR0_WP, smep, smap.  Setting it like this
> ways can reduce the role combination.

Adding WP is a good idea (the host hCR0.WP bit is ignored under nested 
paging).  Adding PG is unnecessary though, it must be on.

Removing SMEP and SMAP makes sense, but not really because of the role 
(if you add WP, then SMEP and SMAP are not part of the role because SMEP 
& ~WP and SMAP & ~WP are both zero).  Special-casing hCR4.SMEP basically 
allows us to implement Guest Mode Execute Trap essentially for free and 
even on older processors, because it's the same thing as SMEP---just 
governed by a field in the VMCB control area instead of host CR4.

I'll send a v2 that also removes WP, SMEP and SMAP.

>> -    update_pkru_bitmask(context);
>> +    context->pkru_mask = 0;
> 
> It is not worth to optimize it since update_pkru_bitmask() will also just
> set context->pkru_mask = 0 and then return.

I didn't think of it as an optimization, but I can undo it.

Paolo
