Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C272651F96
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 12:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiLTLVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 06:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLTLVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 06:21:49 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAECEC76;
        Tue, 20 Dec 2022 03:21:48 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h10so11415277wrx.3;
        Tue, 20 Dec 2022 03:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jXvNzSwe14GwembRofkcyx2c3hAwwdfCyz2pLlFfdRc=;
        b=MU4jSemS38tVlsQiYswpcuwJNcGecNw7YNZQxU8fBDHclLKMLGBZv667yDqqTzvXDn
         cSB4B+NZr9XlM/dxYOvp+OCAL3bxmO6MlnMnDYy/5cRBQsmf+l/X1NnIXiWndgeyVzXf
         c2V553sAMdGCyfG3h0L+XjZUqGqwlkOzR+4mZsu6DkRTkWctpzpXG6rOSfz9tflNOWCT
         Q/XcWVW0D1VC/LfYIEL1GT34OXGLYGtCImbnJ6ugfI02ZoUOJUjDTeoGpuFDKj6e8vCg
         kNzQPVsls7dWzf7AvL9EpQiEQTqtgJG/qup95G9XWx3pveeb8VLCEtLn/hWoWnyygTYw
         V/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jXvNzSwe14GwembRofkcyx2c3hAwwdfCyz2pLlFfdRc=;
        b=T3/X+2IluY/46HtMrd/GVuaUnOSgymM6ptXmPSCoEJ9R+669mcm/7tZiIujk+qKMh3
         O+zj/lpr3ZHMVEPJ/UBOnWsSaPtEVD7rAkjqc0PsexooIJqXx9ppQCFIyd8pdNCDECLb
         0nVH82qXyezVbl/a2J3cg7PeXrBGFjPddo4zB5yGT5Qq8xO9IuzzsT0ROh4naQU3UDqu
         FXPNRS95cTjmEMZuMqYEgKAzjH7BQvB4BKMO/OAcoNhXR8FpURu93MOX/5qODZq8fR4C
         zg9AFwn8GA6RRO3jfG3Is/GCnTVVT2K131cBz/kpUf6GcexjlI9JdxTxU9LxoK8pEz6p
         O+lw==
X-Gm-Message-State: AFqh2kr3JWmEs7tUlHptYo54EevA9cBpLOr1uhVkHTF8Sn0dsu+0XvUN
        m7PZSPVrcUxZgPMKvVYBekQwex9ZRqI=
X-Google-Smtp-Source: AMrXdXtpanZSi3KG2wNuIs05bD0kXsEQp3YLAjyOipKywJY3kNlVyZYRAbIlo5AWHPqXnQRYCa5Rlw==
X-Received: by 2002:a5d:4041:0:b0:242:8177:62ad with SMTP id w1-20020a5d4041000000b00242817762admr1250599wrp.0.1671535307159;
        Tue, 20 Dec 2022 03:21:47 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id bh10-20020a05600005ca00b00242442c8ebdsm12597012wrb.111.2022.12.20.03.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 03:21:46 -0800 (PST)
Date:   Tue, 20 Dec 2022 11:21:45 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Message-ID: <Y6GayS3t0QReca3q@debian>
References: <20221219182944.179389009@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 19, 2022 at 08:22:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.15 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2421
[2]. https://openqa.qa.codethink.co.uk/tests/2426
[3]. https://openqa.qa.codethink.co.uk/tests/2429

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
