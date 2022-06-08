Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7101542EE6
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 13:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236967AbiFHLNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 07:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238063AbiFHLNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 07:13:05 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6CF22DF8A;
        Wed,  8 Jun 2022 04:12:30 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id g201so8091213ybf.12;
        Wed, 08 Jun 2022 04:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GD3JxClwfU5+IuSyMUXXeLQkaDSPIdPYNFrjwKk38AQ=;
        b=jnHPyLL7vJZSKKZ6QpHYFOr1oDQl9/+UueuHtoXJ/y3IUhFM7vIzmp8iYJa94W1Gcc
         Km5vnw0fNfBsFzsuJqOLTXctFyPNlZwmAFQGyEGTrlifZlkDFIrOfzrqZp8QiHQIPwLq
         Pi4qLDmxz/UCQe4JkaZb2prQycHDfmQJ+l9Hkw+uwVUjYl1+NHTovB4Esk+oYSP29Vow
         Xg9rW7PVAIPv6Pb6SCzJVCjxmDVQWMMXOacqghiVnm/Qi8I2+ebVSPhvSDNkX8zdV33/
         bTMRkFbPkui9Q5xPjz9s8IuGPyPKKxA4grfB3gA6aptDwzTV10sR7agPXt8VdQ2thFZQ
         sWbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GD3JxClwfU5+IuSyMUXXeLQkaDSPIdPYNFrjwKk38AQ=;
        b=jDMNWSn5bR6hgFwizCTEHccieHPvjFE5rpaoP2dpHuqH5oZl94CFy2WQOJyMStMqW4
         vIs4aITocuVcWILi6PkmjPwcejC1zGTFpYoEZ/3r2Z4VRCENiACLc6/Y5muxEOgYBR2r
         OA3kkb2Yj/jpt1TGI1hrLIKstJhGcD41W4uC67+mD6fgKy1atZhj3sihgBnD11hVCCMO
         UhJqY0w9VIXmLt7wCWfWtEykeAnhAi7ehgDsSB3siXJ6tPIeXg9rhyOKF+6cXPEBK3QH
         aWfCD92pDmXGvJuE2nUBJwOKq3t2G/fJDN8cs1xTBqTwtgNNdXM0ZfvNdP8ZwCYHSjEy
         MTbw==
X-Gm-Message-State: AOAM532tyW9wJpI/vjbqOw4a3OZXv8BLzqkz3CAiwLBvPXgC3l+65yG6
        23i7PSCfaD+d70cQdNNNjwIpeT7vEzhNAtPCbq0=
X-Google-Smtp-Source: ABdhPJwb9+pcn/uVj4U85cBgIN7KfJQsF2C8MI3iyNmGC68WgFDMU5ah+lD7COpfAj8a88DG3b5K4aswQB1hLxrTFAw=
X-Received: by 2002:a05:6902:1341:b0:65c:f2a0:dc8e with SMTP id
 g1-20020a056902134100b0065cf2a0dc8emr33576780ybu.517.1654686749508; Wed, 08
 Jun 2022 04:12:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220607164934.766888869@linuxfoundation.org> <YqB1e83SqynwHqQZ@debian>
In-Reply-To: <YqB1e83SqynwHqQZ@debian>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 8 Jun 2022 12:11:53 +0100
Message-ID: <CADVatmNFdgXpD+fJq6Yu-7877WPbPcsg4aD0vppLPj_hCJ9Ngw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/667] 5.15.46-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Jun 8, 2022 at 11:10 AM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Tue, Jun 07, 2022 at 06:54:25PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.46 release.
> > There are 667 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> > Anything received after that time might be too late.
>
> Build test (gcc version 11.3.1 20220606):
> mips: 62 configs -> no failure
> arm: 99 configs -> no failure
> arm64: 3 configs -> no failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> csky allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure

I did not mention powerpc allmodconfig failed to build as I have just
started building that arch and I did not have a good build to know if
its a new failure or not.

But It failed with the error:
{standard input}: Assembler messages:
{standard input}:255: Error: unrecognized opcode: `dssall'
make[2]: *** [scripts/Makefile.build:288: arch/powerpc/mm/mmu_context.o] Error 1

and will need - d51f86cfd8e3 ("powerpc/mm: Switch obsolete dssall to .long")


-- 
Regards
Sudip
