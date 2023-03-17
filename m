Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D846BE65D
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 11:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjCQKQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 06:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjCQKQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 06:16:55 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BB0729A;
        Fri, 17 Mar 2023 03:16:54 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j2so3924412wrh.9;
        Fri, 17 Mar 2023 03:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679048212;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FfXH9z2G8WERyIamgGktUjZj8sQfxYbgIgLKsc1mGkE=;
        b=dC7UlPDx8m5getrCCm+YihFdbCyC7jB5/IyK0iwAtMAqY5xaBP5dbFlDJMCb2ghbvP
         xfYwzNqjDml0s23JxtodhXSMz9wQOO91FWI9f3SXC0VsL3Xvo9rKZTF+aMDlvt8lzuJN
         +11Tvj0fwsIjrQ9OScDn46FOQTIB+fwjAprhpiuJZ03wi7JOM5vJuhmfGVCW9+zSIm1c
         AEUaTu1r4eqWzj7Vbn8ACDR/OmdTgFflN0cO8tGleofDCot5/qWH3WP/HD3yCWTVCoH9
         cJQnUCjmcpKc8xUx7vQplx0ibVADGIuQm5AMW0TzoilfXQX2gUJoUTc22/ivxdD0LVv0
         s0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679048212;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfXH9z2G8WERyIamgGktUjZj8sQfxYbgIgLKsc1mGkE=;
        b=G6QAvhHakGF0BQPJ8WEWWRR42H4a9x3S/s3XIeUOmL3+WOfO3TuDRABNF9ZC2fDUln
         JoncS93EOY346Yp+vk9pwvzQ3CsBhzCHe1OoXTMqTTwUsjmCtfYP8Ah9xnJaJ1dUo6bA
         cwMRPG/CrRowIAcHOaXjB3Di0tC/Xo46qE0GA1IqtXgozhgsVHc01wpF8wtKwsSv5ST6
         1tGfkV16t+swxdZFgT3BbjtDB2BrUoW1zx9+/+LfUZBoKNX0PwCDOY+QRcZspef1r5HD
         MoE27bB8EbtYsXk2aACHwVUCtkvL5ZhiGQp+kWSAeKwGMOCrRdnAxbhonkPf8CF5Y14y
         /kIg==
X-Gm-Message-State: AO0yUKWb77uqftu+XqEnWReFepG9Xyp8ZBOEQPMWlnyfiVFvwqY5Sg6S
        qoR+GkCuozk+gtLRG5CSd81TYOgBhQ8=
X-Google-Smtp-Source: AK7set/3Bx/oRAuleWjyhvnFFlnoKIVqXnriz77IvbmfZwrcXOGgfyPdw8FB3pbNocOteCziq2CYcw==
X-Received: by 2002:a5d:6902:0:b0:2cf:e8d2:b550 with SMTP id t2-20020a5d6902000000b002cfe8d2b550mr6400189wru.14.1679048212523;
        Fri, 17 Mar 2023 03:16:52 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id r10-20020adfce8a000000b002cefcac0c62sm1629334wrn.9.2023.03.17.03.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 03:16:52 -0700 (PDT)
Date:   Fri, 17 Mar 2023 10:16:50 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/91] 5.10.175-rc2 review
Message-ID: <ZBQ+EnIXd7z73DzD@debian>
References: <20230316083430.973448646@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083430.973448646@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Mar 16, 2023 at 09:50:03AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230311):
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
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

Boot Regression:
x86_64: Failed to boot on my test laptop. Only black screen.
Will try a bisect today.


[1]. https://openqa.qa.codethink.co.uk/tests/3132
[2]. https://openqa.qa.codethink.co.uk/tests/3143


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
