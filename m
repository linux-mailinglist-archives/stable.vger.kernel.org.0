Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179752533C8
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 17:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHZPd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 11:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgHZPd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 11:33:59 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0178AC061574;
        Wed, 26 Aug 2020 08:33:59 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id e6so1870050oii.4;
        Wed, 26 Aug 2020 08:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nIL1/58suiuSHSwi2XfS45sO4Fd/mY/wkCGtXqq6Pl4=;
        b=s5L2Zx9P87gJCXiucHFa/GiwtzJYSjqf3aDzUrPtJOcN8Ptp5MHx1ZAtMJBzvuE+OE
         yKqRdZcNkQolvee9Fgze4jKXT8dm5xQ2vgoKFWoCKPlgMXMwmyJ7Iqcys14drKvzS8ib
         V3LYOUO2xU65CAOAFikF1LTlBSdF51pg9PJ+loFhZJq4fbFFXn1EFRR6Ezs3lKzk2Fw4
         M/Il9t99nRHHAJKAkiPaQ4cj9UZJJsawgrF+d/n1HWbqMJ7/7cR19l0nyXoK/CTHZtCQ
         qH4vEjZt0vcq+erdKBdHWlZ7vjsMclnkB6UcTfT5ojSotFzatGIlvWflrofZvFDNzi1y
         MHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nIL1/58suiuSHSwi2XfS45sO4Fd/mY/wkCGtXqq6Pl4=;
        b=NXtxKZ8jG9+uslqLxSVh6z2M+HLqY3nNStVNi+JqqC9F9IX01g1yPYlnhWIB3m7wpX
         OxVDBoY1ynsom21QUdHuHppVn4m0yIQ7jmLX849AzsHsTqHZbs7K2B69To64Fl5FZeYI
         P7TJYLXqRBNTbAPKM6Llxlb1ZD/H36OxxQw69qvDKAy3UQTguxQfblZGgOekESh4DJNY
         NkY5/XS967QMx+HRb/890rbnDlUCNddxArtJb9Mcn63T7nzJG7AgIrwmfATT1MUpZpFF
         VxSh4+lXtJzNuekuVRALUmT7DBNMDuCjnXrMRuXvNR779Tcu3BoceLmSTMbJnkvKOLkq
         OExw==
X-Gm-Message-State: AOAM532DzO0fsskDasrXPdj1dcJoXbMr6HG0Mnhd3XJkKSGDQtsVzAn4
        jx4E5YJYk0rSymEEkrLBb+v06LK5s3M=
X-Google-Smtp-Source: ABdhPJx+Zs4+M30zN3vBrvnozXtA5K17axzNFbYGYJDZuqcfUcobinJEWKy/RF7ptW7Q6Gvjam2hdg==
X-Received: by 2002:a54:4196:: with SMTP id 22mr4353036oiy.23.1598456037379;
        Wed, 26 Aug 2020 08:33:57 -0700 (PDT)
Received: from ?IPv6:2605:6000:1025:4ecf::1e3f? ([2605:6000:1025:4ecf::1e3f])
        by smtp.googlemail.com with ESMTPSA id 59sm562990otr.61.2020.08.26.08.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 08:33:56 -0700 (PDT)
Subject: Re: Issue with iwd + Linux 5.8.3 + WPA Enterprise
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Caleb Jorden <caljorden@hotmail.com>,
        Sasha Levin <sashal@kernel.org>, iwd@lists.01.org,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <20200826055150.2753.90553@ml01.vlan13.01.org>
 <b34f7644-a495-4845-0a00-0aebf4b9db52@molgen.mpg.de>
 <CAMj1kXEUQdmQDCDXPBNb3hRrbui=HVyDjCDoiFwDr+mDSjP43A@mail.gmail.com>
 <20200826114952.GA2375@gondor.apana.org.au>
 <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
 <20200826120832.GA2996@gondor.apana.org.au>
 <CAOq732JaP=4X9Yh_KjER5_ctQWoauxzXTZqyFP9KsLSxvVH8=w@mail.gmail.com>
 <20200826130010.GA3232@gondor.apana.org.au>
 <c27e5303-48d9-04a4-4e73-cfea5470f357@gmail.com>
 <20200826141907.GA5111@gondor.apana.org.au>
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <4bb6d926-a249-8183-b3d9-05b8e1b7808a@gmail.com>
Date:   Wed, 26 Aug 2020 10:25:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200826141907.GA5111@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Herbert,

On 8/26/20 9:19 AM, Herbert Xu wrote:
> On Wed, Aug 26, 2020 at 08:57:17AM -0500, Denis Kenzior wrote:
>>
>> I'm just waking up now, so I might seem dense, but for my education, can you
>> tell me why we need to set MSG_MORE when we issue just a single sendmsg
>> followed immediately by recv/recvmsg? ell/iwd operates on small buffers, so
>> we don't really feed the kernel data in multiple send operations.  You can
>> see this in the ell git tree link referenced in Andrew's reply.
> 
> You obviously don't need MSG_MORE if you're doing a single sendmsg.
> 
> The problematic code is in l_cipher_set_iv.  It does a sendmsg(2)
> that expects to be followed by more sendmsg(2) calls before a
> recvmsg(2).  That's the one that needs a MSG_MORE.
> 

Gotcha.  I fixed the set_iv part now in ell:
https://git.kernel.org/pub/scm/libs/ell/ell.git/commit/?id=87c76bbc85fe286925cbdb53d733fc9f9fd2ed12

Regards,
-Denis
