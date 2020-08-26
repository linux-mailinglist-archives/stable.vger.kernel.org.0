Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6C6253103
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 16:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgHZOQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 10:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgHZOQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 10:16:15 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2F8C061574;
        Wed, 26 Aug 2020 07:16:14 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id n128so1655612oif.0;
        Wed, 26 Aug 2020 07:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zxVgg2i7/7/Fu+XiJJojH2EN5w632NV5sZ/Jjl7MPaE=;
        b=n7LCmpxoboG7nlfzJOThgcNKqWCmiQYtBsm4u6M2pGo18MUWq6JZB85fAPfqJ0AnnS
         13ySdrzu2M4N0MnbT81oDUPYjmxA3vKAkqG8QGAxLCR62iVqKLaf4hoI1wcT/CptQtNR
         YWcpmfuDcJUeFaVeEhTDOxRMMEqesyv5DQYiP1isatsGpwpl4Wfe+ffcxlzknPBxkFxG
         1Y4+9JdtJ1xFCEWfxMp9wDmfyyDtADFDT1bbrLNkmv0YJ8mwEl8zaCLc90AddyjXcFqz
         me6Phi35e353HSTXbfkijv2ql3KuvfIeXsgY1ZeahqJI68pJs4g7L36aqqgm+mJ4BT6C
         6kTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zxVgg2i7/7/Fu+XiJJojH2EN5w632NV5sZ/Jjl7MPaE=;
        b=Lbu9MFJZTNjffqVV7MdOGCwjds1phAa6bn4HqxLBuc267gy5mGt7f2Buj3HU+3KaNo
         VCoZ0WmX+d/yGhcFn0MXXECBDcK0to7q3lPCe54wVsFb5GXR74ajUCv4csyBLuv+D3dC
         xIepkga3Ebzo/ZnBKTmDk8Q7nz6sEsasrHaQxxmrk/iV0W4L9X1uI9BHIEHhZXY7/zAb
         9UzbnN7HBgPpsGnhKndPAWz1g1BFVsPd/IkW/Wg8Mv7NYYBUGySkisA9c7W4lgLWGX7H
         /z8X06rS08h8CDh9LhPIHWCmGXi31U6Vg9SYtghWREG4sQJFdOgQvUMAtsGH/vd80kD0
         vRaw==
X-Gm-Message-State: AOAM533u6S89Oo/gFbNWTFn2963MZqbcSmYjPCgpVEMSGZ7lBaq2Rl46
        AiyKnbzKr7GEK7/198mx9J3GFMhte4c=
X-Google-Smtp-Source: ABdhPJzJOnuXBn4L4NbeW15q3Chnv/vOzpmlIu2XQdby867Qjs9ssrT9W7xat4fPICsY4r25RmjwBQ==
X-Received: by 2002:aca:4fc3:: with SMTP id d186mr4282731oib.20.1598451372152;
        Wed, 26 Aug 2020 07:16:12 -0700 (PDT)
Received: from ?IPv6:2605:6000:1025:4ecf::1e3f? ([2605:6000:1025:4ecf::1e3f])
        by smtp.googlemail.com with ESMTPSA id v18sm527842oic.12.2020.08.26.07.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 07:16:11 -0700 (PDT)
Subject: Re: Issue with iwd + Linux 5.8.3 + WPA Enterprise
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
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
From:   Denis Kenzior <denkenz@gmail.com>
Message-ID: <c27e5303-48d9-04a4-4e73-cfea5470f357@gmail.com>
Date:   Wed, 26 Aug 2020 08:57:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200826130010.GA3232@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Herbert,

On 8/26/20 8:00 AM, Herbert Xu wrote:
> On Wed, Aug 26, 2020 at 02:58:02PM +0200, Andrew Zaborowski wrote:
>>
>> Running iwd's and ell's unit tests I can see that at least the
>> following algorithms give EINVAL errors:
>> ecb(aes)
>> cbc(aes)
>> ctr(aes)
>>
>> The first one fails in recv() and only for some input lengths.  The
>> latter two fail in send().  The relevant ell code starts at
>> https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ell/cipher.c#n271
>>
>> The tests didn't get to the point where aead is used.
> 
> Yes ell needs to set MSG_MORE after sending the control message.
> Any sendmsg(2) without a MSG_MORE will be interpreted as the end
> of a request.

I'm just waking up now, so I might seem dense, but for my education, can you 
tell me why we need to set MSG_MORE when we issue just a single sendmsg followed 
immediately by recv/recvmsg? ell/iwd operates on small buffers, so we don't 
really feed the kernel data in multiple send operations.  You can see this in 
the ell git tree link referenced in Andrew's reply.

According to https://www.kernel.org/doc/html/latest/crypto/userspace-if.html:

The send system call family allows the following flag to be specified:

     MSG_MORE: If this flag is set, the send system call acts like a cipher 
update function where more input data is expected with a subsequent invocation 
of the send system call.

So given what I said above, the documentation seems to indicate that MSG_MORE 
flag should not be used in our case?

Regards,
-Denis

> 
> I'll work around this in the kernel though for the case where there
> is no actual data, with a WARN_ON_ONCE.
> 
> Thanks,
> 

