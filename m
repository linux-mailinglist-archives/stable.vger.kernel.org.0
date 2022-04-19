Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4663D506BA8
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 14:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351970AbiDSMF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 08:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351975AbiDSMD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 08:03:26 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20F528982;
        Tue, 19 Apr 2022 04:59:14 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id s25so20467524edi.13;
        Tue, 19 Apr 2022 04:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nke0HHcm55q7ZWg7KNIaQeK9cBWmjw2n9HY63k1pdI0=;
        b=qitSMZa/gzmYJvc0wtUSmri9mXcQvVE05LwgF+gp11f/Ll9YV/2FqbHdxbcYIaVItL
         RA/+2mhOCK1v650zNp6x87vcyaZvx+3V8Hdz1SFcA11QspFDlNV/YhUfrxv73+64VEDe
         FRpunRGX37zofmTMs+GYOWdhPPaKHz8R7ein1VDlbuEpGhVbFFGEIHYz6mKxLBxswJec
         ogVxSBFtEN1L/LnI2zaLoD7jMEEfjCrak0RBKLnlHJ3QbtIiHIQygfUT2Gj+jgUn/fxG
         p5Vu3PwP2YSw2UEAFXgd3SXrVGgC03ckSmBMvBPWbXkgS/VxqkC5BSCoYRbt55Sk43tv
         7c8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nke0HHcm55q7ZWg7KNIaQeK9cBWmjw2n9HY63k1pdI0=;
        b=W9NqFuoe0WCWTWKKxo4Up1VFv+TzBnUJ+MmgnJ76TO2CVXTn5t1iw83dtJLhZL91bt
         Dj1zVw/SUROg842mGErw8OasOhBcBAkW6HiG57EzLmDuLVmVMdlXIHUJMJe8g6wLcWV7
         wdt3mOxPtzgeilFFELI4K3O8/1lbTFDCcm6huHWEAnpmBeAuvjhAZFrjqBmFhc/N1aJY
         +r/wEEfWsBiYVS9ixpeGYv5hxY4b3Wrktczs79CQk15D544oT1sOTY6xpSYlKbSPuXuu
         +E+sehRECxJYZfRgiDQ88/gGXV6TTOMXwv8o5fNW8GtU8efGfmkGqQHmSox3ctuJEXhh
         xMZQ==
X-Gm-Message-State: AOAM533wX+DWNtMIonTJAAUuIydMNHkNPLym8A1mRzLJA3IexRDFoKbb
        +KlCesrzY8jKPKUK7CKLA0Y=
X-Google-Smtp-Source: ABdhPJwC+kRxxlh7ja6yWcyvetpOISZ6zaYfBGlnmVoNx/vMlCHfW1uXDfa6mZ281Sq+VYUqHCwHYg==
X-Received: by 2002:a05:6402:2689:b0:422:15c4:e17e with SMTP id w9-20020a056402268900b0042215c4e17emr17368136edd.33.1650369553437;
        Tue, 19 Apr 2022 04:59:13 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id n6-20020aa7c786000000b00410d2403ccfsm8395084eds.21.2022.04.19.04.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 04:59:13 -0700 (PDT)
Date:   Tue, 19 Apr 2022 12:59:11 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/32] 4.19.239-rc1 review
Message-ID: <Yl6kD7jIYKaxAF3K@debian>
References: <20220418121127.127656835@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418121127.127656835@linuxfoundation.org>
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

On Mon, Apr 18, 2022 at 02:13:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.239 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 63 configs -> no failure
arm (gcc version 11.2.1 20220314): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1035


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

