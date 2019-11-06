Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E55F1F58
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 20:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfKFTzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 14:55:46 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40577 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfKFTzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 14:55:46 -0500
Received: by mail-wr1-f67.google.com with SMTP id i10so6860590wrs.7;
        Wed, 06 Nov 2019 11:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fIjwGFGVNNIbsUmRjTdFv3IHqYtKbP97i66/Nt3hqrU=;
        b=Pr1nNuWtx3xpUVw3Vl7axXBVVmNB8g8Nu27pyJ2Bu29VIY1mo3TFeRQDU2w2PTqvZZ
         R1LEryTzwDVIhwB6XRPOnQ5VoMTHEjrYG2fbNRX00mpp1cUSh7cTG2xIsDUCXBhdYIez
         M6a/eCARsM8g/IzawZs1DeKrEk4nL+tU4lFoYmHP9TXXy1i+F2BkK9G3CjbLVXUfTqgT
         61rrDQ/UiMXuHTXxClGuUuiJsrogGl/0tYZ0MHqh0szDf+552L+deXG9CXZay5fAbzCE
         yThP+tTmRneSnP/6jQFGkKFaB3qCywW3RzQFCXTMFnUg1rrezsS2CuAGjFmpTDHA43Z5
         55Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=fIjwGFGVNNIbsUmRjTdFv3IHqYtKbP97i66/Nt3hqrU=;
        b=SpkKYrQpndMxL9ObM0MXgtC6NDs2l+uefMEXGS8cKqq/MjZ5kJ1JHrxgDYP7V7FR2V
         G9kfC34MqPgkV5z0vQBTKH1NQ2GzpiolzCniruchZk1IUBh+vlbmWWmuhPUo0nR0ztfm
         8hwlKUBqpHhgJjriYBWp/7329KbCmLgeC3HvYtTyBQcE2F8yqSJoLid8EKZjvQb/21Kh
         ou75sLp7HIhDohMg0HFbPbdMpsdPMVDQzRLfeUVAxh4NCwYMXaUXyCHaIMvGL3k8A5nD
         4stxYa2F/a28OFhh6ejpzcbWubGrj13DLF+Fj4nWRbwhC3kmGqQpSKMgsNSq0ohaX/ZD
         Q4eA==
X-Gm-Message-State: APjAAAUXj1TpC0iWVEqTkkqsSfiZkwCu+CjjStmn+6oXGLNYqONi4HSG
        U/qK1qpg2L04dtRhUmFI8g1xYtHf
X-Google-Smtp-Source: APXvYqxm904154X0b5Efxrf4raXJaUA21tXm3vvDU4WiZs5cj+1NZm4dmfMVepmvnLLIGtCu27KoBg==
X-Received: by 2002:adf:a31a:: with SMTP id c26mr4137124wrb.330.1573070142227;
        Wed, 06 Nov 2019 11:55:42 -0800 (PST)
Received: from [10.67.51.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v10sm4317050wmg.48.2019.11.06.11.55.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 11:55:40 -0800 (PST)
Subject: Re: Patch "net: bcmgenet: soft reset 40nm EPHYs before MAC init" has
 been added to the 5.3-stable tree
From:   Doug Berger <opendmb@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable-commits@vger.kernel.org, stable@vger.kernel.org
References: <157305078718623@kroah.com>
 <CA+PBWz0ukwrZw6hmjeJ4xDgPZ0=YaCaVYTAXdUcXqfnpsTrjjw@mail.gmail.com>
 <20191106145629.GA3730817@kroah.com>
 <CA+PBWz092XryavGihP3uTBoiDRpGSAJh=apEiTHYSKBCjZAhzA@mail.gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=opendmb@gmail.com; prefer-encrypt=mutual; keydata=
 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 YVs=
Message-ID: <f2734ecb-1e1a-3580-dcc6-5bd09e2e2471@gmail.com>
Date:   Wed, 6 Nov 2019 11:55:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+PBWz092XryavGihP3uTBoiDRpGSAJh=apEiTHYSKBCjZAhzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For clarity, this commit should be handled the same way for all stable
trees (not just 5.3), and I am replying again since my phone used HTML
which was blocked by the mailing lists :(.

My preference is to omit this commit rather than reverting it in the
near future, but if you would prefer to add this one and then revert it
because it is easier for you I will let you make that call.

Thanks,
    Doug

On 11/6/19 7:08 AM, Doug Berger wrote:
> Yes, that was my intention.
> 
> I was trying to reduce some code churn and associated merge conflicts in
> the backports.
> 
> It is not a functional problem to backport this and then backport the
> recent reversion, but I would think it would simplify things to just not
> backport this one in the first place. Perhaps it's too late to simplify
> things:).
> 
> Sorry for the confusion,
>     Doug
> 
> 
> 
> On Wed, Nov 6, 2019, 6:56 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org <mailto:gregkh@linuxfoundation.org>> wrote:
> 
>     On Wed, Nov 06, 2019 at 06:43:37AM -0800, Doug Berger wrote:
>     > Please do not apply this patch to the stable trees. It has been
>     superceded
>     > by a recent patch set and reverted upstream.
> 
>     So drop this and keep the one after this?  That would be 25382b991d25
>     ("net: bcmgenet: reset 40nm EPHY on energy detect")
> 
> 
>     thanks,
> 
>     greg k-h
> 

