Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0A255980E
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 12:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiFXKoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 06:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiFXKoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 06:44:01 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277EA522C0;
        Fri, 24 Jun 2022 03:44:00 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id r20so2605040wra.1;
        Fri, 24 Jun 2022 03:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KXP2NoRUSiA/f1IWzAj8E8aTf8Sj6tyMk16O8T/6F9E=;
        b=LdEhM6018+juissl5qFXGFrAbw3UNUVRMtgdqZBN497/h6BObOLGfeRjBMsgeHdu0g
         Ol9hpM0mw0oPbuZJtH4ITBV+JvXb6cdvrHen3Jbv7Blsuyk0ttUJQJO4PS+HiDxrHS0J
         mSth07Ig7a9qTX1ipELnzivZxJBZNjCaKtwksFewRSzqQd+IK0nCKgU/R8JZeGP0hZOk
         R2YFy9tfHEkGd+1oBGDnvKX9M9lyxk7aAhtObjKRici78PDsby7y5SQ4JbKz5M5RKW1y
         uWOcYCn28OodNG5un/X0xMg8b+DrFXM//osPikNp9dYTthIngTzwGNyeNKCaF2nd2bBp
         0E8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KXP2NoRUSiA/f1IWzAj8E8aTf8Sj6tyMk16O8T/6F9E=;
        b=ztkNFdiUpMZqh7LG6XLtGb0TXZoIIpo5SBLe9GXzPlGKM7WHwNaVWwjX0zPS7qftIN
         tgAe8s3TpA7hz5mfVVYI151ah9aezC3OD0Beb2AiKfrgnMTHnYD8RqopQ8deacpLZpbb
         83WesjgpLLrn6Evsjvs2b/qkDUQQAcLubQLADtBVrL/vh1uo9Brneo+GjMBYeZFZDzAN
         A9RFs2jetPzjo28bYCwby0lDnoBcv3vqYyKhbGZXhLcEZdlo7Btis5N8b3HDWkKs/pV/
         E32EJL5bU6cAVMmXX8uFewlnKRlW7ncNNpoOWMlqnrbgwHs6XeAD1UYy0/za8Bh9iz3K
         Xu4g==
X-Gm-Message-State: AJIora+fzRaiaNwOfSGrq0QoyAB5I3K0CpN3ewl7+HREIwAcm4EfZCax
        woP5T91owFI29oiJ2i/sg1k=
X-Google-Smtp-Source: AGRyM1sTiGmuDrh6YeoyUG0aOXQ9XW3xuZRmLNgXr1kkVXSNVtkGXTed4M0vyU42GsR+8e6iKt6QoA==
X-Received: by 2002:a05:6000:168a:b0:21b:b8a4:799 with SMTP id y10-20020a056000168a00b0021bb8a40799mr1101234wrd.56.1656067438615;
        Fri, 24 Jun 2022 03:43:58 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id j19-20020a05600c191300b0039ef836d841sm6918970wmq.42.2022.06.24.03.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 03:43:58 -0700 (PDT)
Date:   Fri, 24 Jun 2022 11:43:56 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/11] 5.10.125-rc1 review
Message-ID: <YrWVbGbEUEyryB8n@debian>
References: <20220623164322.296526800@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164322.296526800@linuxfoundation.org>
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

On Thu, Jun 23, 2022 at 06:44:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.125 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220621):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1380
[2]. https://openqa.qa.codethink.co.uk/tests/1385


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
