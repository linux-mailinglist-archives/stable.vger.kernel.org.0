Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D961A193F
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 02:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgDHAa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 20:30:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57334 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726508AbgDHAaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 20:30:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586305823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2MZBPDUxV9RhejRmNfB7mo4jhMQj38Op7zbCkOjFq48=;
        b=FisQMVwgqk+QwiHEkbn6jdK0Kbd1WBvj96xXljwx59nz8XjQGsXWsvmmu+YWIu+zZkXJnW
        UrI1P4KNe9qICM9+WJVkHj7bV95vWg0sAVNgaG5TTZjLcDwB/PqCzdsF2+nDjngj7qZWx3
        nSxOvdkvB2CqcNk1FPBn3q+925dDBco=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-gGdLjWeiN1KEjDZhojeJ6g-1; Tue, 07 Apr 2020 20:30:21 -0400
X-MC-Unique: gGdLjWeiN1KEjDZhojeJ6g-1
Received: by mail-wm1-f69.google.com with SMTP id o5so1634875wmo.6
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 17:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2MZBPDUxV9RhejRmNfB7mo4jhMQj38Op7zbCkOjFq48=;
        b=OW4s0WtC/phEIJEp9YrULXplvoXoP2WfX0+6ufY6U4YKjx1SYaIH+Ly51kggtUgBP9
         rD+br/P4idoIDhP4xDTkjSlS4jsEr03cz/u4KIIzwE2m8qKTGjiU2I+1pKJa4fa6paae
         cT3JtQ41qYj3n0aNizCZuLtEeM0h/3oDmfxIUu2/4Net1hpTsmjqJY+ReSONGXvcP0U+
         xkVQwMlFoTjPmVIh/CjNBtFyiktYhIxJazCQJnPRXKIoHdJhbJ772lDbxZ9U6RfhtsLy
         sEnrcW9Wc2/5ZYCQUPHhp2KTFtDSl+OpNQ4lqmzLsavEay/NttGMX97t6qGwbk0MYjnp
         yPpA==
X-Gm-Message-State: AGi0PuYyoubyj+Lb/ioiL9d0zfeFr/wwUANvrSSdaniyzXPdrOnxPUyX
        5o2nxIjMCWfEPFvP2GVav416HwsZgfeLXwLy/8v4EX5spg5Dybe1iX4Gi5KARjL3sLm3IKtQ60H
        FvMs61cS4d/DglQjx
X-Received: by 2002:a5d:4085:: with SMTP id o5mr5042787wrp.327.1586305820545;
        Tue, 07 Apr 2020 17:30:20 -0700 (PDT)
X-Google-Smtp-Source: APiQypKoQMFSt24mcYF1v+WDBRR73pOTR2uHEj2ttnoL4Vy/+kjZdxsveaYn+BYQj9ifCX3Vaxkjhg==
X-Received: by 2002:a5d:4085:: with SMTP id o5mr5042763wrp.327.1586305820293;
        Tue, 07 Apr 2020 17:30:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bd61:914:5c2f:2580? ([2001:b07:6468:f312:bd61:914:5c2f:2580])
        by smtp.gmail.com with ESMTPSA id n124sm4772405wma.11.2020.04.07.17.30.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 17:30:19 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <2776fced-54c2-40eb-7921-1c68236c7f70@redhat.com>
 <0255CF03-D45D-45E0-BC61-79159B94ED44@amacapital.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4c2499b0-a303-8d91-357e-99b78cbfdc23@redhat.com>
Date:   Wed, 8 Apr 2020 02:30:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <0255CF03-D45D-45E0-BC61-79159B94ED44@amacapital.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/04/20 00:29, Andy Lutomirski wrote:
>> I prefer #VE, but I can see how #MC has some appeal.  However, #VE has a
>> mechanism to avoid reentrancy, unlike #MC.  How would that be better
>> than the current mess with an NMI happening in the first few
>> instructions of the #PF handler?
>>
>>
> It has to be an IST vector due to the possibility of hitting a memory failure right after SYSCALL.

Not if syscall clears IF, right?

> I think #MC has a mechanism to prevent reentrancy to a limited extent. How does #VE avoid reentrancy?

In hardware, it has a flag word and delivers a vmexit instead of #VE if
that word is not zero (see towards the end of 25.5.6.1 Convertible EPT
Violations).  Here it would be the same except it would just do the page
fault synchronously in the host.

Paolo

