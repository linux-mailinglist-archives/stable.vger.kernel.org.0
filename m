Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D955E4ADAA9
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 15:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377387AbiBHOCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 09:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344364AbiBHOCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 09:02:42 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92502C03FED0;
        Tue,  8 Feb 2022 06:02:41 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v12so2231304wrv.2;
        Tue, 08 Feb 2022 06:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xp9QZN/2z/upaKAhd3EP5sH3V0LGEoUW36DmbK5D1mg=;
        b=ksZMV3wZESIE8s3J+vkEoZkwAmwMNgXzV9D6ABMTidn81xM22dEolwar416EYM0ixW
         X9glk6wkCWMndCidF8Yx/ulOlgs/9T6gVVnFXJnbze1EaQ1TZgIVm5jFZT/jvpQTCPxr
         8GVVXnDR5G2hiLdT2LVRg8opk0K/hGxyMx1GQsvtU7T0C3kOLhch6NFxiO+cxrBMD/SD
         o/mPZuSNF7sxcraugnXC75Y/grsfqMHVxg5SwJ+R64AN3ldEr7MDQa0DilIs7FtPkLQp
         CvipfInGq0fJ5mRKXollmJTSwtco25lCmOUhu4UM9QXesusAgWL8nXDQktewIv6RMaan
         FpKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xp9QZN/2z/upaKAhd3EP5sH3V0LGEoUW36DmbK5D1mg=;
        b=RODyjfBn4+fdb1RCQHhjLMoE4ckmwrwohbZe023qpeBmbJjcC8HGgTOwaLBDXQbXKJ
         tcDn0vHRtLMYlSOZSXHLU89C1HE1JpeCRIxnabbUOhTUxNBqEAM6V8HXrzbnPs7ZNguD
         N/CeXqjZI334TyJhWjkhh9CK3UrZ7XbDVFSisyp8FShpc+S9obrn1X0HllEzHiwu7eey
         kxTaxdsRRH0B0VxM/XQiv6TN1U3eToJUF9XrT6YEwRSu5HqcxWAgt4ZR7TSE/7wFrQSf
         a9Prx49oE1nn3bcyn3NxZIXAsJi2WBPDyGJaJYgWmcb1kRI6+eepo+lpXGYGS974Eo/8
         NMvQ==
X-Gm-Message-State: AOAM530T3GQJByYrHrz+6ZjYCI1Vf22BxL9yF5dMuHsx8dC6YFdjUP+A
        jHmYr1xx/xs75op1L8N+3wo=
X-Google-Smtp-Source: ABdhPJxvppN8OLWxCr62/0Hv9hDWKUKj61tfD4E/YEG8VR8gsHj0IZwiv4IYdKRcs/NueVeFgvyXmg==
X-Received: by 2002:adf:f90c:: with SMTP id b12mr3624219wrr.97.1644328960198;
        Tue, 08 Feb 2022 06:02:40 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id h4sm15477041wre.0.2022.02.08.06.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 06:02:39 -0800 (PST)
Date:   Tue, 8 Feb 2022 14:02:38 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/86] 4.19.228-rc1 review
Message-ID: <YgJ3/tVg/MT4G2qi@debian>
References: <20220207103757.550973048@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
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

On Mon, Feb 07, 2022 at 12:05:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.228 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 63 configs -> no failure
arm (gcc version 11.2.1 20220121): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/722


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

