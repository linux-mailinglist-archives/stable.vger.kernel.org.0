Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99A14460D4
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 09:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhKEIra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 04:47:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41598 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229473AbhKEIra (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 04:47:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636101890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UEON2O/QaUYlu8aac/UW8WFRqnCIxmxxRfN8DejAkjI=;
        b=LYtFzz0mTS89ArI93qErd0LAfpugtDBHJwg/JyzE3mw5V1yi5i/KPe2tM1DGkO72Ac2kkA
        AwL4vu+edbZ5AWjhTumQpj7WAON7c6fHBkDQIRVuFOmgSNde2hMdmqhsH3kHUokyqC09wi
        gfZTN0LeugbUcKmZZsLzCkg15YMvsgQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-MWmlfFNnMZa2JzDUFQxzLw-1; Fri, 05 Nov 2021 04:44:49 -0400
X-MC-Unique: MWmlfFNnMZa2JzDUFQxzLw-1
Received: by mail-wr1-f69.google.com with SMTP id q7-20020adff507000000b0017d160d35a8so2072648wro.4
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 01:44:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UEON2O/QaUYlu8aac/UW8WFRqnCIxmxxRfN8DejAkjI=;
        b=7GODWxvhQgjkHbxWfa3BoCqy5O6q1aKB78EU90vp50JigOjvsM83ZJuK597W4Fq9vY
         B33ClFpxjPBIEpZZjhixguSybxSegF27fdx6qptXHL6zjIwDZgsw56Ri4fEWnFviV1uJ
         yQPMBoz5HfyMzk3Ydzs1OC8DJlqeDDERR5v7d/t1nMx+UlFdIPlSCIS4g4vEninJV8Af
         Zd/XBieRM5Ox1DjpmFYRZ96CdBTnrmWTnYZdD4OBPmIxbnVNNT8XJrzThOtsHhR5/ITM
         xMYtkyutmmfLkSPVDXndNZxfMZkNhOHTaOkLA5zyObmg1y6vPNDea8nkCZw3bGvLtH7B
         KCbg==
X-Gm-Message-State: AOAM531dWGQ7ITwnXIZT8LDVSy3r2rj6StMxbTvR6n6DnMS1x77AwUlf
        xdOhz4xAE/A2+UIdtuVvLApAguZTSRPj6Z8LAkBtiflBJr/QELEZozIq9wHEB39goMgyCNbksuQ
        P7DDaGM2g/Xou4Fla
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr34762547wrr.365.1636101887867;
        Fri, 05 Nov 2021 01:44:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAUuGv0L7IVSlR//LzFEV4bKp4CmVx4Lao+THFdCwRuGtlyKCM5hyR7BsjTfxDBNvA66dvwg==
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr34762522wrr.365.1636101887646;
        Fri, 05 Nov 2021 01:44:47 -0700 (PDT)
Received: from [192.168.43.15] (93-33-2-31.ip42.fastwebnet.it. [93.33.2.31])
        by smtp.gmail.com with ESMTPSA id z8sm7574365wrh.54.2021.11.05.01.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 01:44:47 -0700 (PDT)
Message-ID: <c3757fc0-09fa-b0f1-7165-795e0363058d@redhat.com>
Date:   Fri, 5 Nov 2021 09:44:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Please apply 3d5e7a28b1ea2d603dea478e58e37ce75b9597ab to 5.15,
 5.14, and 5.10
Content-Language: en-US
To:     Nathan Chancellor <nathan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, llvm@lists.linux.dev,
        Nick Desaulniers <ndesaulniers@google.com>
References: <YYQjyo/dKfDb/no3@archlinux-ax161>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YYQjyo/dKfDb/no3@archlinux-ax161>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/21 19:17, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please apply commit 3d5e7a28b1ea ("KVM: x86: avoid warning with
> -Wbitwise-instead-of-logical") to 5.10, 5.14, and 5.15, where it
> resolves a build error with tip of tree clang due to -Werror:
> 
> arch/x86/kvm/mmu/mmu.c:3548:15: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>                  reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level - 1]) |
>                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                                                                            ||
> arch/x86/kvm/mmu/mmu.c:3548:15: note: cast one or both operands to int to silence this warning
> 1 error generated.
> 
> It applies cleanly to 5.14 and 5.15 and I have attached a backport for
> 5.10. I have added Paolo in case he has any objections to this.

No problem.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

