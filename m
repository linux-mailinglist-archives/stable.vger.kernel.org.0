Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15C829716B
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 16:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750663AbgJWOha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 10:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372730AbgJWOh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Oct 2020 10:37:29 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C29C0613CE
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 07:37:28 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id qh17so2710655ejb.6
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 07:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dBrkr9zmUeTgBkYcp8Rpfp5TUVgoqTa3803HELP5ZHs=;
        b=VZsApkbSQC0HMPn8HjQBU6WbYBIJixwSGOKsEXPFB3k2Jn+OS3IfSXQItth7kVAdqb
         AyxDJ/E20C6gHkqb9IJ2098SXiWOGNoGf60IZZWzQrpHZxvWI6FZ2aVTJkQHYu7fGMCr
         mQPpBUfD3uXiR+3ROkpyg/H4puQH1DMsqFzGk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dBrkr9zmUeTgBkYcp8Rpfp5TUVgoqTa3803HELP5ZHs=;
        b=UOOIU5qK6D3kOU5x988bHVdwCdJT4o3htEZrWW0vNrldmqSgE+TcuhN9fGLbo3E5Lh
         xdZ7lz4cV89dw+qRmlcZ+4+YnLru2kZCDsHRHxMLXSInDVqJjV1Dtn3Ai5NFS+DKaqKg
         ad/fhsC5/DQLE2KpQD++3MybESjaJANQNiyOU8jN3fGxdRCSOHookTI4fQ+PrfKtTBBi
         gq5meINlFldSBolKAe1EF2vkJJsOp77MOKiFj43oBIlgojDBw1cvW239kjuNrhhVLqOg
         mg9WoIKUqSx73LPul4CfqW5a4llT9mr10w29zPnkChXMHl6r8ZMNemLvRPNY/wPrlyOb
         hCuw==
X-Gm-Message-State: AOAM530CQLxl+GJIsyIIyiJj+LsoJp7DGhK3WB9urGr1ppTfaSToViv+
        xo7KO5ohOhBNvsaMrRJpd6jROCamgXzyNt3L/S4=
X-Google-Smtp-Source: ABdhPJyxu6PW39WYDmT7PE4MBHSgUkaSJHIM7C1Ku2Y2n7uvVHv7S+PpUr04XDSGc6B6WGw4SkQGwg==
X-Received: by 2002:a17:906:590d:: with SMTP id h13mr2209988ejq.226.1603463847252;
        Fri, 23 Oct 2020 07:37:27 -0700 (PDT)
Received: from [172.16.11.132] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id yz15sm943009ejb.9.2020.10.23.07.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 07:37:26 -0700 (PDT)
Subject: Re: does 548b8b5168c9 qualify for stable?
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <4f1324d2-6b0f-dcb6-ff58-a6a05a15d407@rasmusvillemoes.dk>
 <20201023142231.GA2518006@kroah.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <d4e98ed1-bd02-fb7a-d520-8ccdd91e9c48@rasmusvillemoes.dk>
Date:   Fri, 23 Oct 2020 16:37:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201023142231.GA2518006@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/10/2020 16.22, Greg KH wrote:
> On Fri, Oct 23, 2020 at 03:40:26PM +0200, Rasmus Villemoes wrote:
>> Hi,
>>
>> Please consider whether
>>
>> commit 548b8b5168c90c42e88f70fcf041b4ce0b8e7aa8
>> Author: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> Date:   Thu Sep 17 08:56:11 2020 +0200
>>
>>     scripts/setlocalversion: make git describe output more reliable
>>
>> qualifies for -stable. 
> 
> Looks like it qualifies, how far back do you want it to go?
> 

Cool, thanks. I think we have a project using 4.9.y, certainly we have
projects based on 4.19 and 5.4 - so might as well make it all of the
ones listed on kernel.org currently.

> And yes, backported patches always make it much easier to apply :)

OK. How do you prefer to get those? Individual patch emails with [PATCH
X.Y-stable] in subject? Or should I put them in a git repo you can
cherry-pick them from? Should I include the "Commit
548b8b5168c90c42e88f70fcf041b4ce0b8e7aa8 upstream" line? How about notes
on how it differs from the upstream commit (e.g. when just the context
uses `` instead of $() or similar)?

Rasmus
