Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4A83506EA
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 20:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235855AbhCaSyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 14:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235626AbhCaSxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 14:53:50 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F7DC06174A
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 11:53:49 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id k8so20691271wrc.3
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 11:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3u7Et0H7oZ1l5+ZT9yV0GYS4scsUtLZ5FCnJUgJcrYc=;
        b=Mgm0NPTvspRnm2H/4m2momQHT290auYuLqDANl89pFpeXPjht2MQjc/9oGe/0kRF3r
         FFfSpw6pLg7HQUNMO+FUmKd7OlPJbzAdBkLOxYHVvGKD4bpvCSd93fmeWrM5UsixRe5Q
         FhpXRqxw19IrLrm3HlvXkMF5B74Oyn6XmtPUM9MzKL8IkLh5lxoQd6S+8Jsvv+MX2ZBy
         OHFJcVWq89q46mVCPuTkBi5800JUenUswWCTssAgpxdylHdEaVznXTpUGm4QbKkQl/jq
         R99EYo+OIkW5UzTANDPKCSwh+FWDFaGVPT0OyYd37kX3i5AUAfX/I2OZYTiZI/NH+yKL
         J2QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3u7Et0H7oZ1l5+ZT9yV0GYS4scsUtLZ5FCnJUgJcrYc=;
        b=Ob+TIy6Nv2LrDUbf39F0UIOMj+fACm2KIJWpnCJ1JDVnjUBH6HlLIRvIze09/8aXNb
         zZWQJDN9FiWgPTFFd+NP6WHSIG0Qnnw4gKXejnLQevoA7h99QZPu5Q6yRF7Ryv51XvO/
         7OkzfAQ073c3kzrXnQGUaA55G47RzFGdEFMnc9YbrUErXrObHTZ4Q1VHjAbmhfRnQkF2
         l4liGmbAdley9tg/4Fk5jZvyNGMB9Wt9Q1ZSzOHTCNSgqQU0r8aKT/k6GkySJQ7rNIU9
         EV+s5jvni5MH1g0eM6Y82oLppNqpS47w6rG7Mp5otzLrxcOG+ABY8YBHo7iFCRIpqr4d
         2PiQ==
X-Gm-Message-State: AOAM531snYBXTxEtW5/biOXekXYDv5+c2gG/3YPatpAybKwoVwF4Hr9K
        LB84gwU0dc/FCONEc9gasl9Sxg==
X-Google-Smtp-Source: ABdhPJyPqgg2NxjIPCh/BtXZYrR1Sey+m3sh2KHpQm1VyfXtUb7l7xh32RumbSLj4ZvX3qCECfmddw==
X-Received: by 2002:adf:e34f:: with SMTP id n15mr5278586wrj.224.1617216828332;
        Wed, 31 Mar 2021 11:53:48 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id u20sm6368269wru.6.2021.03.31.11.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 11:53:48 -0700 (PDT)
Subject: Re: [PATCH] powerpc/vdso: Separate vvar vma from vdso
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20210326191720.138155-1-dima@arista.com>
 <09e8d68d-54fe-e327-b44f-8f68543edba1@csgroup.eu>
 <8735wby77v.fsf@mpe.ellerman.id.au>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <361ec8ba-8335-157a-53e8-38a656626519@arista.com>
Date:   Wed, 31 Mar 2021 19:53:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <8735wby77v.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/31/21 10:59 AM, Michael Ellerman wrote:
> Christophe Leroy <christophe.leroy@csgroup.eu> writes:
[..]
>>
>>> @@ -133,7 +135,13 @@ static int __arch_setup_additional_pages(struct linux_binprm *bprm, int uses_int
>>>   	 * install_special_mapping or the perf counter mmap tracking code
>>>   	 * will fail to recognise it as a vDSO.
>>>   	 */
>>> -	mm->context.vdso = (void __user *)vdso_base + PAGE_SIZE;
>>> +	mm->context.vdso = (void __user *)vdso_base + vvar_size;
>>> +
>>> +	vma = _install_special_mapping(mm, vdso_base, vvar_size,
>>> +				       VM_READ | VM_MAYREAD | VM_IO |
>>> +				       VM_DONTDUMP | VM_PFNMAP, &vvar_spec);
>>> +	if (IS_ERR(vma))
>>> +		return PTR_ERR(vma);
>>>   
>>>   	/*
>>>   	 * our vma flags don't have VM_WRITE so by default, the process isn't
>>
>>
>> IIUC, VM_PFNMAP is for when we have a vvar_fault handler.
>> Allthough we will soon have one for handle TIME_NS, at the moment
>> powerpc doesn't have that handler.
>> Isn't it dangerous to set VM_PFNMAP then ?

I believe, it's fine, special_mapping_fault() does:
:		if (sm->fault)
:			return sm->fault(sm, vmf->vma, vmf);

> Some of the other flags seem odd too.
> eg. VM_IO ? VM_DONTDUMP ?

Yeah, so:
VM_PFNMAP | VM_IO is a protection from remote access on pages. So one
can't access such page with ptrace(), /proc/$pid/mem or
process_vm_write(). Otherwise, it would create COW mapping and the
tracee will stop working with stale vvar.

VM_DONTDUMP restricts the area from coredumping and gdb will also avoid
accessing those[1][2].

I agree that VM_PFNMAP was probably excessive in this patch alone and
rather synchronized code with other architectures, but it makes more
sense now in the new patches set by Christophe:
https://lore.kernel.org/linux-arch/cover.1617209141.git.christophe.leroy@csgroup.eu/


[1] https://lore.kernel.org/lkml/550731AF.6080904@redhat.com/T/
[2] https://sourceware.org/legacy-ml/gdb-patches/2015-03/msg00383.html

Thanks,
          Dmitry
