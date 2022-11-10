Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF516241DF
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 13:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiKJMCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 07:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKJMCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 07:02:54 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618D923BCA;
        Thu, 10 Nov 2022 04:02:53 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id bk15so1901728wrb.13;
        Thu, 10 Nov 2022 04:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Avvv7NRvku7zvyizHbN8B9ExE8lCIMUiZYQSaRhLeWo=;
        b=Xmnjw0mG/ThpwygD5TA8lP8tXz3wGo8gMaUAgaFGm7qxDjd0sio5SwlKiPPsg4rG69
         /jF9UJ3lrpcQK4Zgq1J10uAHYltBaDtZoVFxMrJ2MtUPYOgOzn6ZP62/j8gzjpKKCMRI
         dVOjXrp4bNZGnaIoGtgl7Nl2H6YjqbdF7WNmlhobd96nr2cc+zZT4PCF8gLKiMh8WtsL
         DEA31PMZ9b/aWTl5/WrqRUnI9QHY3X9fv4Sk2B13yn4BhBwzzNgaZ1i4evWctkeTYqVE
         ik2kjc1lIDIAyx6+9pMygNQ9c9AOwlMk/blucYFWPQMGNsP1AHQJ1eukhlAiIYMHKiEn
         PwOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Avvv7NRvku7zvyizHbN8B9ExE8lCIMUiZYQSaRhLeWo=;
        b=lWljagaBpqdj4B1eky93b+KLKAl5grl7FtstYkJ8T5cQzI6ISITugT73y5w8eSb0zW
         muWU6dSfUlRXs2F29uKPfrxoHDvhyZ7zc5D0GQcXwVFm78uU3DMSgwqwxinEzOSS5BY7
         sE5+AsYDZmVAt13fk+8PTvTBD+fzUai0yLJxVMhCOAfRy5KRxtv/EMNUbWnhHBeHqHay
         sknHzTS4O+L8JM0g3aUEfpccSWJPq6zVS/Zt2xY0naj4AgR3I+iOO8oWThqnDPnFFphD
         cSyHS+O3Vhn/UALk4X6jB5O1V8k7hsmS2FMwDz75lrTLF85ivb61WwY0jPk9eDyLNCyI
         ny/A==
X-Gm-Message-State: ACrzQf35l3RjA64+GqStJkYT2gQ5x7sHYMBy6JHVHWxmw5wpU/xd8DEs
        fZFhpQJs1haGxG2eLsvyjA4=
X-Google-Smtp-Source: AMsMyM45PjxHkkftJgBg+V7naw2V8wpbAmLUTLj7z87KH6UOtWUN9cVTI4B30lQr0dnHZHieQpqMGg==
X-Received: by 2002:a05:6000:24a:b0:236:bc3a:48b2 with SMTP id m10-20020a056000024a00b00236bc3a48b2mr38913563wrz.495.1668081771820;
        Thu, 10 Nov 2022 04:02:51 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id j7-20020a05600c190700b003b47e8a5d22sm5607828wmq.23.2022.11.10.04.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 04:02:51 -0800 (PST)
Date:   Thu, 10 Nov 2022 12:02:49 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
Message-ID: <Y2zoaQsn8tARua/n@debian>
References: <20221108133354.787209461@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
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

On Tue, Nov 08, 2022 at 02:37:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2129
[2]. https://openqa.qa.codethink.co.uk/tests/2135

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
