Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FA53AC74C
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 11:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhFRJWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 05:22:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49008 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhFRJWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 05:22:52 -0400
Received: from mail-ed1-f70.google.com ([209.85.208.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1luAg6-0003Ro-Sn
        for stable@vger.kernel.org; Fri, 18 Jun 2021 09:20:42 +0000
Received: by mail-ed1-f70.google.com with SMTP id i19-20020a05640200d3b02903948b71f25cso1151227edu.4
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 02:20:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XLwZNZ4otXkAw6BwOA+rhbVdW5LvRzIV/4Z53bTw29I=;
        b=nvHrVGD2iQ/KHsz/8MsiVo+Ce0KdT6RXjR6NWSjHQNrSp8IAuJ/pZOdQw+HZAxYsO+
         JuzX8Wm7UJ34NiRe0hMj1yLpKrkex8oIQ0rIOaQwbz44t2GTl1X3o9wU8Jn03m3aXspY
         btSi0NNRtU7tye6Ublg08g6L61L+wDqJi2skhTktsvt+XpffAD1zP1Gx80/JASJ7U79X
         x/YdF2KRO3PEecUBk1dhVXgFCkcSGgi/RtB6DO0KPYurH7sRBPP5B/YH1uZJ9izRi37c
         317waimHLdIBotlTiGzCL0LuIhirLby9gTj2RrtdzmMOkm/Len0kDhmcdMvzt2VKLAjH
         fqMA==
X-Gm-Message-State: AOAM531oPE/4quXPXOrQhalLYaP5oIjKSlSJPaHKf8RC7IOe1kNkwNDT
        uxhYdr0mDxmdwi146Sc7iB0JbCHvJROz3vuKLsxVx9sG8E3/MgzT+I7G/HooOuw8Jjnq+7+PW+T
        4PDn2etmoxezm2pvlDthrzyRc95Juuz8rBg==
X-Received: by 2002:a17:906:bb0e:: with SMTP id jz14mr9962292ejb.285.1624008042604;
        Fri, 18 Jun 2021 02:20:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRZ0TH6yHstiGZprKtSYakYTPdMot+ATxcRqYcr49pButi51xFQFHnhc0ltdf0K3Or1zK1Jw==
X-Received: by 2002:a17:906:bb0e:: with SMTP id jz14mr9962285ejb.285.1624008042476;
        Fri, 18 Jun 2021 02:20:42 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-177-222.adslplus.ch. [188.155.177.222])
        by smtp.gmail.com with ESMTPSA id l7sm2966663edc.78.2021.06.18.02.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 02:20:42 -0700 (PDT)
Subject: Re: [PATCH 5.4 031/184] modules: inherit TAINT_PROPRIETARY_MODULE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Laight <David.Laight@aculab.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, Jessica Yu <jeyu@kernel.org>
References: <20210510101950.200777181@linuxfoundation.org>
 <20210510101951.249384110@linuxfoundation.org>
 <8edc6f45-6c42-19c7-6f40-6f1a49cc685b@canonical.com>
 <5ac70bdf2c5b440c83f12e75ca42a107@AcuMS.aculab.com>
 <YMxlBCzztbWGvi/l@kroah.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <6a2ea1d8-1ea0-a283-2210-360e63f2fdaf@canonical.com>
Date:   Fri, 18 Jun 2021 11:20:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YMxlBCzztbWGvi/l@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/06/2021 11:19, Greg Kroah-Hartman wrote:
> On Fri, Jun 18, 2021 at 09:07:53AM +0000, David Laight wrote:
>> From: Krzysztof Kozlowski
>>> Sent: 18 June 2021 09:57
>>>
>>> On 10/05/2021 12:18, Greg Kroah-Hartman wrote:
>>>> From: Christoph Hellwig <hch@lst.de>
>>>>
>>>> commit 262e6ae7081df304fc625cf368d5c2cbba2bb991 upstream.
>>>>
>>>> If a TAINT_PROPRIETARY_MODULE exports symbol, inherit the taint flag
>>>> for all modules importing these symbols, and don't allow loading
>>>> symbols from TAINT_PROPRIETARY_MODULE modules if the module previously
>>>> imported gplonly symbols.  Add a anti-circumvention devices so people
>>>> don't accidentally get themselves into trouble this way.
>>>>
>>>> Comment from Greg:
>>>>   "Ah, the proven-to-be-illegal "GPL Condom" defense :)"
>>>
>>> Patch got in to stable, so my comments are quite late, but can someone
>>> explain me - how this is a stable material? What specific, real bug that
>>> bothers people, is being fixed here? Or maybe it fixes serious issue
>>> reported by a user of distribution kernel? IOW, how does this match
>>> stable kernel rules at all?
>>>
>>> For sure it breaks some out-of-tree modules already present and used by
>>> customers of downstream stable kernels. Therefore I wonder what is the
>>> bug fixed here, so the breakage and annoyance of stable users is justified.
>>
>> It also doesn't stop non-gpl out-of-tree modules doing anything.
>> They just have to be reorganized with a 'base' GPL module that
>> includes wrappers for all the gplonly symbols and then all
>> the rest of the modules can be non-gpl.
> 
> Ah, the "gpl condom defense".  Love it that you somehow think that is
> acceptable (hint, it is not.)
> 
> That's what this patch series is supposed to be addressing and fixing,
> but someone has shown me a way around this.   I'll work on fixing that
> up in a future patch series next week.

Greg, for real, no one argues with the patch in the mainline. But what
is the justification for stable kernel backport? How does it match the
rules of stable kernels?

Best regards,
Krzysztof
