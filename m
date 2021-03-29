Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C08334D8BE
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 22:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhC2UAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 16:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbhC2T7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 15:59:38 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F4AC061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 12:59:38 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id k128so7193812wmk.4
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 12:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DKVpcQ+QpAoXvlyjRMhAGyT+Qqak2JfgZMLiBaSa29E=;
        b=YJPerRzl5+2JaKjv1Eb55P40KGWj7y6pfAam3YE3y8qhoEgUMMSGIdVfB6lepj10yJ
         D9JgvhbtBcvf8hfGDmq8z3Zv50QkNtIZMKlL7qEOsF0W8nlkcRq2Gz4nkYLLJ4Opvwcy
         GeQxTIHi0wGIiu/1stxEX8XdpEX32jglLEn2f5JXz86HT81AdRitSFe+KAw4HGbMqphK
         DL1N4R+sQxYSbcUqJpXZk6egdDmBADKsmQ/uJ+kUO2jfcDoV/VEjpB4e2hoPxcjqs62B
         jlYp0Woty23AO0P9Hdodnyz6GSb0jC1JbWGj8zhE4+rI4qkYA+zhreLGydVxQMXtRKcv
         NAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DKVpcQ+QpAoXvlyjRMhAGyT+Qqak2JfgZMLiBaSa29E=;
        b=dmn+HyltEc0K6hmJAuzO8ksSZhmcAtJ+LNa0L/mnE91Ls47p7dFYqeOQpfYOuPML9W
         yOpwcxjGSyZS8Kn4rJV18LsFki+uUgivllEtUyX2JnKUQEgK/N4Y9bKD8ksp13Phrv/V
         QhzfhWd0D5DmQaaNsGji5LDQsQJt0nvjeo0WFjtOjj1cJvyEN5grBHcLRYMAzo755ZWM
         yx4z9YK/ZXpgOyLhe37zPNi374/btA6epb06OOHxq7T7+CwH3vkWXmhjo4NfSwNqt6Ll
         P2rPYniXVK3zJiFQG2aWUbrFrIo98lp75qXcncOf5Ki7SkQ5aA2syZ5fRY7gmoxFQHD1
         M0rQ==
X-Gm-Message-State: AOAM532wmv9Tgj23+RlmCC3kC14NxzGcfby0ZlUTlHuHDQrr42j+jvk0
        DJQTYyubkxZ4kHAr21yILu5Hbg==
X-Google-Smtp-Source: ABdhPJxY4+UJ5NboEvKsiKSfoZc8oEQ4w+NW1XvxfFLt4qF5Y5WCR92gIYO1xNtxtzr0yNW21PC1TQ==
X-Received: by 2002:a7b:cbcd:: with SMTP id n13mr624923wmi.112.1617047977314;
        Mon, 29 Mar 2021 12:59:37 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id l6sm32426474wrn.3.2021.03.29.12.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 12:59:36 -0700 (PDT)
Subject: Re: [PATCH] powerpc/vdso: Separate vvar vma from vdso
To:     Laurent Dufour <ldufour@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Andrei Vagin <avagin@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20210326191720.138155-1-dima@arista.com>
 <f97f3ff9-6ae2-64cc-fada-49fcac34ae47@linux.ibm.com>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <50b7a78a-76e6-7d28-5324-a3ada9c43019@arista.com>
Date:   Mon, 29 Mar 2021 20:59:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <f97f3ff9-6ae2-64cc-fada-49fcac34ae47@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/29/21 4:14 PM, Laurent Dufour wrote:
> Le 26/03/2021 à 20:17, Dmitry Safonov a écrit :
>> Since commit 511157ab641e ("powerpc/vdso: Move vdso datapage up front")
>> VVAR page is in front of the VDSO area. In result it breaks CRIU
>> (Checkpoint Restore In Userspace) [1], where CRIU expects that "[vdso]"
>> from /proc/../maps points at ELF/vdso image, rather than at VVAR data
>> page.
>> Laurent made a patch to keep CRIU working (by reading aux vector).
>> But I think it still makes sence to separate two mappings into different
>> VMAs. It will also make ppc64 less "special" for userspace and as
>> a side-bonus will make VVAR page un-writable by debugger (which
>> previously
>> would COW page and can be unexpected).
>>
>> I opportunistically Cc stable on it: I understand that usually such
>> stuff isn't a stable material, but that will allow us in CRIU have
>> one workaround less that is needed just for one release (v5.11) on
>> one platform (ppc64), which we otherwise have to maintain.
>> I wouldn't go as far as to say that the commit 511157ab641e is ABI
>> regression as no other userspace got broken, but I'd really appreciate
>> if it gets backported to v5.11 after v5.12 is released, so as not
>> to complicate already non-simple CRIU-vdso code. Thanks!
>>
>> Cc: Andrei Vagin <avagin@gmail.com>
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
>> Cc: Laurent Dufour <ldufour@linux.ibm.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: linuxppc-dev@lists.ozlabs.org
>> Cc: stable@vger.kernel.org # v5.11
>> [1]: https://github.com/checkpoint-restore/criu/issues/1417
>> Signed-off-by: Dmitry Safonov <dima@arista.com>
>> Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> 
> I run the CRIU's test suite and except the usual suspects, all the tests
> passed.
> 
> Tested-by: Laurent Dufour <ldufour@linux.ibm.com>

Thank you, Laurent!

-- 
          Dmitry
