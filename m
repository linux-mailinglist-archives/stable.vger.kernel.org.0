Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29ADF712F3
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 09:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732775AbfGWHfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 03:35:10 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52636 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731328AbfGWHfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 03:35:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so37447667wms.2
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 00:35:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=weeVjf/Jly+Inq7rrMi7gHQ0j/OuLTL5EFdg7avawSo=;
        b=R2SGjPTZNoo4tVxTtlrrsRW/sQra8sMSF6Qa5cbiPfJlCcnWCmxz3XiCuhuVc8noDH
         98+kbMt2+pCxhGZ0kgKkEGiaCSQqe+BRH74BfcZ77F+wS72F5yiAk5fEU+k+Ck49Y2In
         RTsepwrSLV/cFksAhUcnvi7Rwgrj6QT+38npRbcwLFBbVPcKnFb/cb0Yo3pqpCX3okvx
         X5oAycWSg2kKg8TJI2w18VgLDqcHb6Ump1AC+muByP1D8KVUn/YwoebhD1qSPGkBbVQP
         ILZalrVYnMg/rVxVx+gVp7NhHeSdysoVOXWZ6+pjJe482CH+S8qnrnpiuYDGkO/Qjb81
         AY1Q==
X-Gm-Message-State: APjAAAVZUw2PGXsuNopZi6EMCn3hG72tGbvvjfBuFFAedC/0D67Lv2HN
        cpIX548UdqWv3hWcbp1q8Twu1g/FQVM=
X-Google-Smtp-Source: APXvYqyWvaMO5IsmxLwfIf/M3f3J+BPyluUZ9RtI3u69i6rj0Wg7FwJpPmGYV2DVsW5IwZS6ldTMwg==
X-Received: by 2002:a1c:3cc4:: with SMTP id j187mr64455922wma.36.1563867307765;
        Tue, 23 Jul 2019 00:35:07 -0700 (PDT)
Received: from [10.201.49.73] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id r14sm37030867wrx.57.2019.07.23.00.35.06
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 00:35:07 -0700 (PDT)
Subject: Re: [PATCH] Revert "kvm: x86: Use task structs fpu field for user"
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <1563796594-25317-1-git-send-email-pbonzini@redhat.com>
 <20190723043132.556EC2239E@mail.kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e30db831-6498-95df-031d-908b18cf37f3@redhat.com>
Date:   Tue, 23 Jul 2019 09:35:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723043132.556EC2239E@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/07/19 06:31, Sasha Levin wrote:
> 
> v5.2.2: Build OK!
> v5.1.19: Failed to apply! Possible dependencies:
>     0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
>     2722146eb784 ("x86/fpu: Remove fpu->initialized")
>     4ee91519e1dc ("x86/fpu: Add an __fpregs_load_activate() internal helper")
>     5f409e20b794 ("x86/fpu: Defer FPU state load until return to userspace")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

I have 5-6 pending stable patches and I will send a backport for all of
them.

Paolo
