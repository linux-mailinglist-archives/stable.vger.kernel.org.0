Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B98A4D1C48
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 16:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347985AbiCHPt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 10:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiCHPtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 10:49:24 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA2B36E18;
        Tue,  8 Mar 2022 07:48:27 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so1778555wmp.5;
        Tue, 08 Mar 2022 07:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DoOVP+akfcsEpOTsTUbvwWUFXwvQXj7SzsrmJL9oUYY=;
        b=i0pgZPH+xQPjSlsFVAb+C/Q4cZkFO168Ys1lQCZLFCUyWLST06J0FABrgzPOtg1J5y
         vmclEuXe50i/BbavE2Om+R4kwuUywXFvYMSA9Gavtqu/U87FMKNrAgaM2nrVsCN0w/qW
         84XLVB4qRGn3q69k4YyPkxqFTpL/l94UvsAIDvfNH9824tJqskSAKI4wmVB8xANOXTh3
         wWRkZAnv9k7XFykqyKFQn5dHzDG8vlFqxclnyyNZFYZHX9JerHM1XPJ+XBRpN50Cx/9m
         QQVrS8nKjzSk60IgdsQuQIJtdI9MbrjYLxx6UawUajsCIG5bBhiAGtLKKQosZHzAFNBG
         yULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DoOVP+akfcsEpOTsTUbvwWUFXwvQXj7SzsrmJL9oUYY=;
        b=Q6KBlzcrZHsNYV350IbLrBVFOOfe2HhwhrkD+zMSe+3Jof0X/54TxGCXj7DM97hWIa
         9gaZPU/p5m+9bJ80aoUQXzpEGrMyRo4U7A8h8QeKz8KC4kaScIdyLZ5p7C1/iwvWBoiL
         +sNHp31NAnBmJnvBXN4l0tPx2on/KT+SHd9mjwCTQYa7ulkDpYjtMYVXB5KIlfSFIkot
         Dk+4SyDzTsBN9teYG23I9NwRwfniq16R4AfTlrDEzPOUajEyF6A0wlQ8UGfRkVRMiCN1
         tgolp+jpFCSxbY7ms691UULlaQufvOUCbkEXi7nEHmYw9nJX357L1nvvmk4Dx3dp9yeK
         rEBQ==
X-Gm-Message-State: AOAM5303hmN2w55SNJDQxx2rN2FKDWJ+gMFiAW3eDv6bLGdmrW1yungU
        ywwm+ldAFf1vnJeeLHlpIgg=
X-Google-Smtp-Source: ABdhPJwprzRbv4TAEIWEP8qMVukm2Jt5lSsKcsQj+JukvDf2dWMmYJT8o7SXrnri7y3hCMUKijPaPQ==
X-Received: by 2002:a1c:2744:0:b0:382:a9b7:1c8a with SMTP id n65-20020a1c2744000000b00382a9b71c8amr4169797wmn.187.1646754506583;
        Tue, 08 Mar 2022 07:48:26 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id r187-20020a1c44c4000000b0038377fb18f8sm3472212wma.5.2022.03.08.07.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 07:48:26 -0800 (PST)
Date:   Tue, 8 Mar 2022 15:48:24 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/51] 4.19.233-rc1 review
Message-ID: <Yid6yOjs5719+uIv@debian>
References: <20220307091636.988950823@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
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

On Mon, Mar 07, 2022 at 10:18:35AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.233 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 63 configs -> no  failure
arm (gcc version 11.2.1 20220301): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/852


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

