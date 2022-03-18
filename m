Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9F94DDEF5
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbiCRQa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239214AbiCRQax (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:30:53 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9F6DCB;
        Fri, 18 Mar 2022 09:28:50 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id v130-20020a1cac88000000b00389d0a5c511so6913361wme.5;
        Fri, 18 Mar 2022 09:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vk4JE0LHLflJo+B6RFRUohdRJcZLP+PjloWAv/7DfzE=;
        b=fp+VS3ktbFn2/EaMOn3vWa9uLodDChe5QhvdZguP49J5796v/ZHJ0fRW0dnJ/W1lyb
         T8ZD0VpHzpN5fE7VFfxApu6TDmrK08gk+lmLmakv025T6ZOeq1946xAHBTFkzUFDN9ZZ
         9kbUxLTVszAeUcE9885PNFXW629KbPZIdl5os9kaUz0+LyJFuDQsQ5bE+nJlKO5wpwCW
         rmvS+7Px7SwwjUX4HV2/nlVZx7rspBEF2sOkhAGvxjc0zHuC6IHNLpb/d2GC8u0Zx8V9
         0ZIWD2MnWX2Dc9qfKiVtBH2JedmKllWTvEU4NAuD80o039ljvrMxtxPkrVLo1ph4XlE1
         OSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vk4JE0LHLflJo+B6RFRUohdRJcZLP+PjloWAv/7DfzE=;
        b=AU209Nt5ejr4Nz32A1FGldrPBD1jEHzZ4KPT2XnZfcyOuqSYqgfQ4ZQzz2VlvRsNAt
         8t9Kpvq/RSDfQqhEpsXcmrOtD+pqr5avHjWOw5YnNikhfbKPFT+sl01IqcyyPGvs5NAr
         ftgh8jubhkRX1lle79VMxbIAR54L54k/kNlx/oFZWWWjqTJICPdqV3HStbXUxN+SCnUU
         GfE0uwNN1NHp798H0DcdmCEEpMHaIwiTQoC1Qwqw0BknKUvDvncEb/3pD/w2yW3CNfu8
         521Q7EtIK1zolJCJkWgFdBAbGLq082W8wQ4pDU46OozZUTeMBrBkrKSVUO2SGf4jAHH+
         WnMw==
X-Gm-Message-State: AOAM530ruYWKQumPITZW30JGLXs9ihsbxjLZbRXA0VsuagGanvN2ZYX7
        mRBLyMcmj+Nfg/KMvHRv5Z4=
X-Google-Smtp-Source: ABdhPJz6/c8+gK/JPhjz0xrZwtI0JkqOWgYadx5Lf8Sg2rsMqgXZ7U+ZLCBdvRr5wpGIrKfalpiVWw==
X-Received: by 2002:a7b:ca54:0:b0:388:a579:d0ea with SMTP id m20-20020a7bca54000000b00388a579d0eamr16228072wml.192.1647620929449;
        Fri, 18 Mar 2022 09:28:49 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id k17-20020a05600c1c9100b00386bb6e9c50sm16196212wms.45.2022.03.18.09.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:28:49 -0700 (PDT)
Date:   Fri, 18 Mar 2022 16:28:47 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/23] 5.10.107-rc1 review
Message-ID: <YjSzPx04zPDKmUhu@debian>
References: <20220317124525.955110315@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317124525.955110315@linuxfoundation.org>
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

On Thu, Mar 17, 2022 at 01:45:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.107 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 63 configs -> no new failure
arm (gcc version 11.2.1 20220301): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/907
[2]. https://openqa.qa.codethink.co.uk/tests/908


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

