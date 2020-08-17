Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E321E2475CF
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgHQT25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732232AbgHQT2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 15:28:52 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B265C061343
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 12:28:52 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id bs17so13285114edb.1
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 12:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BGsB8D0XAi+Cvc7KHUcpfYUVIGSNq3G/WO34F4vqdyQ=;
        b=T+E3zriZu69ah+IgJ8OoAnCws9KQrCrCely4hZfsAPx1yPGgrIlSy4WTtDhvPuPywL
         XVQUAbGwBiSy2gTqdep4YQwMvTtuFyQGHlZpXRUTwyxnwIy+9viVcWFjPB2qCOHa2GhK
         88q5mJysE4UGG7zgA/hNeRR4vQBA8bhwqO4xh2lj7ar/MmhGZYIcVgx6mqYsyYLHgey3
         l8qVIoMnlpZlZIbPl/SrxaBmEUeWvv9vvcoj4jqpRreyGuVanTq1WiM4GK1qzN57vY/d
         ZRcJ0qcpjDoePBUNF7680q+rxIK7ASSkhIsiKn6D12HLl3CBM0ufAofX4cMq2TzbmFLf
         4LcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BGsB8D0XAi+Cvc7KHUcpfYUVIGSNq3G/WO34F4vqdyQ=;
        b=gKlsGAMlikb0FX1vq6Fcj4doxTJaMrjdd/FufCO68RI73W8ZUpHsymzsBjfath3wgy
         0y40lmnhtHQYExvLKohLvN8V/Etb+EF0OwWMcCZS07VDNnGjj6TKGMOrXbDh5qaQyFL7
         jH8dIilI7+KgEyGxwnD/9VfaGb8zi1vIDQDEFBqiVSoQ8pki1Zkk1u5N2UOUuzF5Nwon
         649yYop4N9/kAQLOUlbZs7UAD7ONEPjG5XHOjdG/1Lz5tbV8Mg4w3L191lw8aeoE/jUu
         llDczcQ7/SPeUV+zt8Se98cWTkXL960B4F4uQ4j+NKREW5ZHxGpncyzD3eLjJsYoMK1r
         MX7g==
X-Gm-Message-State: AOAM531uYKXZ2GoEDQAAGZJAqR/Om8P/EvrIZvbX6z6LV0TwMsYZ63KK
        mR5dBcwwyv5S7lo9RAHIvAgDh9q7gEX6Fiuj
X-Google-Smtp-Source: ABdhPJwOppwVN5V7uAq9kWdpx/JXrQn7jki7yxN40x+S8QZEV46B147UkBJtbLvwFTHQUFBvAycA0Q==
X-Received: by 2002:aa7:d5cb:: with SMTP id d11mr16560944eds.330.1597692530425;
        Mon, 17 Aug 2020 12:28:50 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:a03f:5a32:bd00:41f1:972d:5bac:bf85])
        by smtp.gmail.com with ESMTPSA id bx22sm15240077ejc.18.2020.08.17.12.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 12:28:49 -0700 (PDT)
Subject: Re: Patch "net: refactor bind_bucket fastreuse into helper" has been
 added to the 4.14-stable tree
To:     gregkh@linuxfoundation.org
Cc:     davem@davemloft.net, tim.froidcoeur@tessares.net,
        stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>
References: <159765838685222@kroah.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <9f27fa03-b205-9195-758c-c9c67b384a21@tessares.net>
Date:   Mon, 17 Aug 2020 21:28:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159765838685222@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 17/08/2020 11:59, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>      net: refactor bind_bucket fastreuse into helper
> 
> to the 4.14-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>       net-refactor-bind_bucket-fastreuse-into-helper.patch
> and it can be found in the queue-4.14 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

(...)

> Patches currently in stable-queue which might be from tim.froidcoeur@tessares.net are
> 
> queue-4.14/net-refactor-bind_bucket-fastreuse-into-helper.patch

Thank you for backporting this patch!

It seems the backport of the companion patch -- d76f3351cea2 ("net: 
initialize fastreuse on inet_inherit_port") -- was lost somewhere for 
4.14 version. It was backported in all other newer stable versions: 5.8, 
5.7, 5.4, 4.19 but not in 4.14.
The patch backported here is a preparation for the real fix which is the 
missing patch.

I guess the intention is to backport d76f3351cea2 to v4.14 as well. If 
not, this refactoring is maybe not needed :)

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
