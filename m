Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DEE4C8AF4
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 12:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiCALjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 06:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiCALjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 06:39:24 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9885EBC0;
        Tue,  1 Mar 2022 03:38:43 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id ay10so2193235wrb.6;
        Tue, 01 Mar 2022 03:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xQvCOthiUsedtFRxxLe/plXNgJO9SuoqwjNspTGc4HI=;
        b=FR1IsssZkWf6wRnFU1Af+NaeWLK1wBHA4DaIQ4PjpDGP+/fS1B6g1NtWJYNdiwotxJ
         UsiLOPTC5nqNHt9adhM79dSa5agise1mh7++dxwfQb5wJuvyOfU3S8wLseZqVQZmPsfl
         8eT66Dpb3LfvFR0YOSd6nb+6g/ndt4ymLgzuWKKYxBBVyOAuZjTQWG+jzWkhXnppW3ux
         N2MNO100zqTGhivwMOkGGE1OO6nuExj0CFeB/5JGv4J4aQ/oiy8rf7/MZggI26RE2dGP
         iE6DOa+KXIHxwWWlf1UttWZxehKfatlFJQmiBV2fvLyzW8s7Tg03hsAZhKee9op8DKau
         Nk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xQvCOthiUsedtFRxxLe/plXNgJO9SuoqwjNspTGc4HI=;
        b=fi+64vbElT8ED7259zy0+mwY9tepBG+lERNuIIS5krngvSbjzLfFuXbUq5XnvnQ3VT
         OuaI/1IprPahWXwXEWgh7S0Q8qFCPuvmWhm94khg2YiKeRwvUZvm8YtOq/auSAU/HXGW
         e8lLB0UcEHUrAlWKgktfa0tl0jYqBMhOCwDw2dN/X8xAsxsq4aASkbP2753t/splZgFA
         4prFZ/ZVgaMtpTboN1ukshc6H5L4FphvjbhVJwhWP2GwwkzgsBnY1ImaNDQl/shYSKPD
         ixe/QvLSw6c/u7Jm7DqpRAgaTsCxaUKmEBFeMCMUc43gjbXQlqozTEmVmR4ZcWqoete5
         KTKw==
X-Gm-Message-State: AOAM531l/q4tjoBMqlw8VyVVKcBM9z3EZRXzZW5xNGz2IfPTWQQSWI+e
        V0dI/x/K13Gyu+QQsupUE70=
X-Google-Smtp-Source: ABdhPJxw4EGTMBBlrgjbT12CegDuv7j8MuTJQOavaD/0VUBkyfWGSnb3Tpqh1IH76bgCA9VvIK7rrw==
X-Received: by 2002:a5d:4ad1:0:b0:1ef:9481:f343 with SMTP id y17-20020a5d4ad1000000b001ef9481f343mr10140017wrs.165.1646134721929;
        Tue, 01 Mar 2022 03:38:41 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id p4-20020a1c7404000000b0038140136ff6sm2986521wmc.5.2022.03.01.03.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:38:41 -0800 (PST)
Date:   Tue, 1 Mar 2022 11:38:39 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/139] 5.15.26-rc1 review
Message-ID: <Yh4Fv1lUopPHZ5CI@debian>
References: <20220228172347.614588246@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
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

On Mon, Feb 28, 2022 at 06:22:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.26 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220213): 62 configs -> no failure
arm (gcc version 11.2.1 20220213): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220213): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220213): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/822
[2]. https://openqa.qa.codethink.co.uk/tests/825
[3]. https://openqa.qa.codethink.co.uk/tests/829

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
