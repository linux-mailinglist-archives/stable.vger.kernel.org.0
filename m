Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D9E58ECE9
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 15:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiHJNS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 09:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiHJNSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 09:18:23 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFE722298;
        Wed, 10 Aug 2022 06:18:22 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id s23so612231wmj.4;
        Wed, 10 Aug 2022 06:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=4/6jnVLoLFCcYZqNhg67rhZsLZRrer8rrjCvo1v3AgU=;
        b=FkJHfIGo+XX57HUvyImG3URjElPioFGuzK5xv2ab/13owqQid/RCwPKwQTi75Z/Nko
         3pMjfxM5mizyMKchI6MSg9PHq5xRrMp7sJ01GpDxctJMeWy7t5KUC9tgh6EzzUOnvzq3
         KY6NP3kjdtk0lDgiv7BCCBGVFcoNvKZPProR6TXWt7Xlf15Kfm5j3XpIlpKKt9QzXXgv
         Q2YdRu+ErWbtpOQsA+kE9qrpa9ewVc9PhQDURRZsQRe+6FPd90gZrZ7T8ZS6pzmfyYM3
         4EARlbpK1PVOVWGQA0in2b6KHGRlBRHLJ5qaG55tHHSljXPS5AcGGAnhkFOVqAeEB0eu
         mJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=4/6jnVLoLFCcYZqNhg67rhZsLZRrer8rrjCvo1v3AgU=;
        b=x2J7XL3igJoqfZMlEa/UrTI1S3lVm8zgkiivWHk61i/IzmdWx2jshivWzBJbNDmWLq
         jXp+uRi7qX++Q88/KNblPdWbzbU4+IVYYz4ahq0V4LWuotl0W50o02a82ezDfIUDlSxL
         XkyhqRzNL7+5QLmT2jp04CezlOpDfV/onk54CMZ6iCkZWIgbBXjgPeYSm7Vph//vX1ZZ
         QDrbSxViOHIIERl3LJ8lQsFx+9pQZDvhIaW4r4ahFitnIGNiAWLelm+86iFrshbrDk3J
         E5XVrevpiBHpP9FMJ9XmN0JYXcifCIEXPkqyyUMV+HvYCGQe6BbKbi+VPcG4mkqVNb3M
         XS1A==
X-Gm-Message-State: ACgBeo1NYzrop0q5ArQkw8goWRzPEa2EIpSu5yTigDDksD2vNMSL07zm
        +h7b9oKr8DiknDRABxMbpJWSBGmjYF8=
X-Google-Smtp-Source: AA6agR5vQRKlqmGy6V4gB1K/w9cx+K83y57S2SQho9w0zCUmLlsOqloE/uvjvpHgFUpmJXEFBWfqvA==
X-Received: by 2002:a1c:cc04:0:b0:3a5:3f8e:d2a with SMTP id h4-20020a1ccc04000000b003a53f8e0d2amr2489098wmb.138.1660137501012;
        Wed, 10 Aug 2022 06:18:21 -0700 (PDT)
Received: from debian ([2405:201:8005:8149:e5c9:c0ac:4d82:e94b])
        by smtp.gmail.com with ESMTPSA id j20-20020adfd214000000b0021ec32d130asm16029231wrh.74.2022.08.10.06.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:18:20 -0700 (PDT)
Date:   Wed, 10 Aug 2022 14:18:09 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/32] 4.19.255-rc1 review
Message-ID: <YvOwEWFE7NbqqylC@debian>
References: <20220809175513.082573955@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
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

On Tue, Aug 09, 2022 at 07:59:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.255 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220807):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1616


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
