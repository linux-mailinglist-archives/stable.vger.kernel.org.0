Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3184BF7C9
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 13:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiBVMH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 07:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiBVMH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 07:07:27 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95EA90276;
        Tue, 22 Feb 2022 04:07:01 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id k3-20020a1ca103000000b0037bdea84f9cso1633328wme.1;
        Tue, 22 Feb 2022 04:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IJKZ3DzNTnMs7ghsS35I7GgW6AncsP9hbNlD6hh1Vyo=;
        b=q6t21GadQCxE3Kbueq749cAc/V4/hcdwM0SUfy/FDzyv31mMdj5Fo/GUT7qrpWOuUP
         m612nkEMUP0rw4rxKm29j0FadlfiRODNqgbV5AJxnknxmh/W1vttd1lvy6beYtBWU870
         hwCA6+kQ3nNokd3gzbm2upggDJKHmSJ0WCgREoqjxYDlNJTKo6AkF2WrjtTNiIfrKk9n
         gDYwoPnlOsVNZuX4/y34s/97A7u0Q690eKfSOAcT5vLIIkHBxYlmVkpWhsvdMDyUAkyX
         QFaix36IuzZxcQeoooIIqjO92bEdjYdwGUTZsVf6C6bR1iAbdSHt0Clqiuizf3ejagRj
         Hxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IJKZ3DzNTnMs7ghsS35I7GgW6AncsP9hbNlD6hh1Vyo=;
        b=mRPTHI3FqXEeCrchs3AFRaZVbpGo4PH76PKQ9EKOlQ2XIyTaAXZ5ioLt13K7Db4u5U
         gObrDcJa+buOVAg3m6qfbuCl6KcnyIiy90rAuEpUBRywdpwtC6S7hANaETbh3uBd60n/
         rX42jACyRRocY/y0/u57XSG/ll5xJqMae9O2ZyQzqvK9FwvZgTzQ14jTSjGpAgU+eBoK
         /2FZNjKkJnOXXTewcq3wTrWTqvrT+D/QA6Rzug7L8ib9qaXvGWZWe1wlqRWP9A4EJ2a9
         PyXWPn/I9yUpqB/dfLdMvCNHg5BOiKCwiOXWAMunyCwyXs53ZO7MZCzN0WG8Ksn4iXSl
         1Pyg==
X-Gm-Message-State: AOAM532FDTQ6FMyqgGEa2YNozR2+89zpZvjsRghjTdPLFM0HRO/51k0h
        KrP+dQs6WbpXrVpQZo03qbY=
X-Google-Smtp-Source: ABdhPJyHWhIZ/wGrUCALXDDN5Z8Q7E6OAlvwAkMOx26DrNupE9NEXBPJCYbT6OFbKR17uYPWxtnOew==
X-Received: by 2002:a1c:35c9:0:b0:37b:edec:4d88 with SMTP id c192-20020a1c35c9000000b0037bedec4d88mr3049959wma.159.1645531620387;
        Tue, 22 Feb 2022 04:07:00 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id q13sm53992582wrd.78.2022.02.22.04.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 04:06:59 -0800 (PST)
Date:   Tue, 22 Feb 2022 12:06:58 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/121] 5.10.102-rc1 review
Message-ID: <YhTR4l4Et1/BxLiV@debian>
References: <20220221084921.147454846@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Feb 21, 2022 at 09:48:12AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.102 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220213): 63 configs -> no failure
arm (gcc version 11.2.1 20220213): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220213): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220213): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/797
[2]. https://openqa.qa.codethink.co.uk/tests/799


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

