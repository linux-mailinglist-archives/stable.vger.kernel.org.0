Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8E86BE651
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 11:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCQKOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 06:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCQKOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 06:14:23 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D214C3344C;
        Fri, 17 Mar 2023 03:14:21 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id w11so1922064wmo.2;
        Fri, 17 Mar 2023 03:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679048060;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=db+ZyhaTUZPRotqhew4szyywTUVHXY9zVlEAPC6GmIg=;
        b=a8iCixciO1H3l74UEdG+7Jf79fXMoP1aftoorXIj0AjNL7B7ieEW8l3cRKg55Gd6q0
         xjKRDt05FxmF7TssHlQPx80yNBaifK4r//ASX69VoGD0pTToMHDJc1AQApVR7mSv3GRH
         qSA4i3m/NComBxpRAVQI9MwjGFLbecoxxr5LSvVs2bdM81qu6/06WzfpLTez6mYVv8MS
         Yct1+0xP5sBcaa7hz4cRj47vQ4ZUPerYiJGd8qSrkoHmreMkpAg0CX8I9dNiKVbIMuG1
         aFN3ZG386Sj+29tTZ3oQOBUJp0PCURZVmAygq9SUx2VEfebCte6dOYP+TjhPboTnW0Iu
         wqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679048060;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=db+ZyhaTUZPRotqhew4szyywTUVHXY9zVlEAPC6GmIg=;
        b=C+5ipB7EofwS+SuJYNYPVUADHfStWRdXFhUHlyHN0ylE7HMoDHv4RbBn8P68C3y3sy
         mLyPU2tEWwsrqDlOppgYT4BDrgbeDdkOC2Arajfr0kxxDVXayZ86pMBCtcnuVvpHdJM1
         7L4IexCgHqB0eGg/ZsB4GKD6Hh6yIoLGzqyRLrppoNTztqaR3PT/p5N3GMZbEAkaG6Et
         i9JcKNE/2WiUx+gOpfBO+e2DlQDGZw0GHn2hICUF/glffNlkmDFz/XKllZXu55kZpmkC
         Pp2ji8zeCfPQrTXOJX3h98rEIUFwL86WqOkOjAi3PvKZycXlizvl4DCxLXXqdu450lJS
         tCzQ==
X-Gm-Message-State: AO0yUKWW6ImKqCOGAyTS1S2Ge6c8aWamDMePc+fSAQFzumqVxtWuCR2l
        GAEfgl/cgTc8Mk94b71big8=
X-Google-Smtp-Source: AK7set8Avt98ux6asduT0mciIlg0IcgiwgUUYdmjl0IJdMg4kKVit+5XhWUiVOPWVrSqwsjrflXcrw==
X-Received: by 2002:a05:600c:c06:b0:3e1:feb9:5a33 with SMTP id fm6-20020a05600c0c0600b003e1feb95a33mr24101139wmb.9.1679048060167;
        Fri, 17 Mar 2023 03:14:20 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id m16-20020a05600c3b1000b003dc4a47605fsm7563337wms.8.2023.03.17.03.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 03:14:20 -0700 (PDT)
Date:   Fri, 17 Mar 2023 10:14:17 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/137] 5.15.103-rc2 review
Message-ID: <ZBQ9eYLqhWfloNVD@debian>
References: <20230316083443.411936182@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083443.411936182@linuxfoundation.org>
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

On Thu, Mar 16, 2023 at 09:50:12AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230311):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/3133
[2]. https://openqa.qa.codethink.co.uk/tests/3144
[3]. https://openqa.qa.codethink.co.uk/tests/3145

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
