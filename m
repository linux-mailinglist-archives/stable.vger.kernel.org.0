Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C755957B8B7
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 16:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiGTOqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 10:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiGTOqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 10:46:39 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6737B4C61F;
        Wed, 20 Jul 2022 07:46:38 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a5so26424543wrx.12;
        Wed, 20 Jul 2022 07:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HYI5tt+FlJj48Grt0WehrdL6jvSycstVtPc16DbkSlo=;
        b=el7CjnGlnZwhOXfYh++0pTDoWc5gNB/VuXBQIDxxzyWGBPwj8Zadsw3yfl/qLIFKwP
         H8m3Ck/zz643n0opkQOkXH3asPt6IQnp9MvR3dD80NM7zWy7V4to+CvnIOf8XADl4nMc
         r93DjWvGfUYw31DDMr4os6LzWNxOlORm56aUAE6Zxu7yMhws+afmcGQWHhE77jmRIkZH
         YgzMutW3KwcATKboOqBIS7XkPiSihzHo6bjxpohr240Gi1CJxXpd9OG4RMfeHSOgs8qs
         4JP7a3GOJe2wWR8mxLjt5JRPKCwGoBaKadaPVStoJEhM1ECwtnGsC0PfDb2uFmvB4b2/
         7xFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HYI5tt+FlJj48Grt0WehrdL6jvSycstVtPc16DbkSlo=;
        b=y+mrSzOz4bUrF38/09yX6M3fexmzadhVN0DbXZAk8PAnIUrpzy8ODhp8R4ExukaJfY
         jw2TCm2UAmfr1BHeZMa3nEB0nwGnKLol74tdX8WOvv6JqSR7uw3nmFVKdWUOjAohMzFD
         UwAQ/DYll0eaf2fl+82nGq94q1AO/Lwccf2Awn/gljGHqaCdMf0sx6HURcLvCXLZ7axZ
         tIQpxipBvhQpuopiXVF7g+QdmkE/nvdxghjM2DyswApbUmvWpJFVcmCgMGTl+bPi30e6
         29ULghFlucRKO8cI9SDdxbOgFceEYpNtWz4HcJphcLWU97BjSW6c5HmtYcpEcGt5pnMI
         VEmw==
X-Gm-Message-State: AJIora9Xgpt7Ww4hlvld11tyxHAuGg3G1Lkso/ssDbhNf96poLKCylcC
        NPGKnW1kXB1VQK0Ia+N0hz0=
X-Google-Smtp-Source: AGRyM1sF+Trc/6Zh6ZxB7TspOTtC70GeCqD18+eKGbsj00DQa5pL71e+g4qHDr0+JPAXNdRPik/b7A==
X-Received: by 2002:a05:6000:1548:b0:21d:acfc:29f5 with SMTP id 8-20020a056000154800b0021dacfc29f5mr29929869wry.520.1658328396896;
        Wed, 20 Jul 2022 07:46:36 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id l19-20020a5d5273000000b0021d60994b0asm15806892wrc.100.2022.07.20.07.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 07:46:36 -0700 (PDT)
Date:   Wed, 20 Jul 2022 15:46:34 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Message-ID: <YtgVSgkxxX3R5ine@debian>
References: <20220719114714.247441733@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
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

On Tue, Jul 19, 2022 at 01:51:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.1.1 20220706):
mips: 59 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1523
[2]. https://openqa.qa.codethink.co.uk/tests/1532
[3]. https://openqa.qa.codethink.co.uk/tests/1534

Note: seen lots of build warning as reported by others.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
