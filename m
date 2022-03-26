Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FC64E814D
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 15:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbiCZOGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 10:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbiCZOGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 10:06:02 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2954C166658;
        Sat, 26 Mar 2022 07:04:22 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id r64so5866146wmr.4;
        Sat, 26 Mar 2022 07:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CwwTLudbisWt/D5C3X2/LW//Oe691NzSOMLmnZTsNlc=;
        b=gZfsAH+zDHC0/Pg3z67Xjzp4LvBjBmYRv78pw89W8STqoGV5BbEqjW+GmqNPgl4YBB
         M/pW95MPaYlfRNeldAfhVSq9yTYfR9P1zbjbKY8TaE6vxPnhbfBNgcUHPYg6lhOZgsIc
         CSpC1mI55Wx5HCvSfUuoA/czkLq0LMaUoajkwFPctiCMVLtnPkj2VlW7z7ksc7C2KA8M
         VbDRAbE/RAE5ScKsBOsgyM3Zajhz2Zmsd1AmRU+3/m6mdazvpBMGf98Pi1gkTj4gh5D6
         Op5A8i3zSpKL+f+g/oDEqHQ4lEQs06Y/llrDHybQ9GiEa0w4tXdL+ybJtFlY+edn0pUJ
         qViQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CwwTLudbisWt/D5C3X2/LW//Oe691NzSOMLmnZTsNlc=;
        b=nL2NZpkTfWOSHl+m0gkw4gzroeKisdy6ltxZ/0l6juHFlRNBtzsr3PYHxX5flL4QJ0
         M7P4Sy28aFHa3+kzZLxu6L03P9T2AmEgBzqtNHde84LzZuPHS5z53SkPAhL357Bg+7Vv
         Xs/o5cZTtYZjEL5cmiAdFhRk2D+5HcYGixfzN4jDUpTyxoD3b/RdmR8eCdbpzSKd3YCR
         gAerPV5XMi+hFLaSsYR8t9UdjOfXKc6uohY7DtrfV/eSetpRGJOa25lAz0W/in+ABsAt
         P+OxZCry/cFqNUVJtTKfT/6kx06D7rFZyyp1gWSZ6zVCk9KqChNj4rW4VX7xn5hriVlU
         dWIA==
X-Gm-Message-State: AOAM5309YsT4ZaotgaJAxQznSqEnOACaNN2k67oJ3Lp6La/BRlUCBDEG
        vA2bOe+lXcqUc3+L9oBolc0=
X-Google-Smtp-Source: ABdhPJwcF1cbJl+jSj/bceDQBuIJsHSYJQYdPXrF/iSJ35NNNksV4RLF2ECgAVgbHkVb770IEGQzAg==
X-Received: by 2002:a7b:c057:0:b0:37b:ebad:c9c8 with SMTP id u23-20020a7bc057000000b0037bebadc9c8mr24568909wmc.61.1648303460717;
        Sat, 26 Mar 2022 07:04:20 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id d20-20020a05600c34d400b0038caf684679sm15827798wmq.0.2022.03.26.07.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 07:04:20 -0700 (PDT)
Date:   Sat, 26 Mar 2022 14:04:18 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/20] 4.19.237-rc1 review
Message-ID: <Yj8dYkt9MPko849q@debian>
References: <20220325150417.010265747@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325150417.010265747@linuxfoundation.org>
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

On Fri, Mar 25, 2022 at 04:04:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.237 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 63 configs -> no new failure
arm (gcc version 11.2.1 20220314): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/938


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

