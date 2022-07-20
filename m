Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8693B57B8E1
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 16:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238126AbiGTOuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 10:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239822AbiGTOuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 10:50:37 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE63652E5F;
        Wed, 20 Jul 2022 07:50:31 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h8so3748668wrw.1;
        Wed, 20 Jul 2022 07:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Z5Pwjl85d9XSaGbYigfHQuQxtGlEBXD4gu4hVUWehk=;
        b=XNG704Knrwsu6D+ad+MXD/VqINDerS9Dqs/cqj5AYs4+CgQXuOVtktYoyIWsi0u247
         E5qEINf9KBWATuvtr9GOJblJOgLffScs1oRlzDTRPJI1pWlRhnsY/dhbaRb1XF+crmh+
         Z2dw1Jnn2bfkX1AcQsoJTNqidU4XHsW8weK7GsZc0G2oo5sX17puelV4bnY0huCSBR0Q
         St0sFYQy8/bsyHNORf1ZZYhEvkkn8U9DSeNvjQhRbvzx8Ia6kNwgcwBWRvUiPj9K1xqG
         qMMgCAqFX8Ob6kFnekr4dq52i9/YyXb0mGjrdQSgK6QpRPCR/hxNpLXR72cv6qoO1ITS
         0y6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Z5Pwjl85d9XSaGbYigfHQuQxtGlEBXD4gu4hVUWehk=;
        b=SNBLdqUTxdfzmClCaKyGal3eUV3KcrPw6HaNARsflPseXzn86TaYFkTF+NWm2FK8SO
         4wsBRELHeY6SSOUWnJc+Tu3yvMz9GD9Dv/5vOvza6sIQamoVe8r3fa+K/N2XWyVwyHnx
         T2Ir087iySOLi8fq/pLCtKlO7UtQxVBj0J+/3cavtkU8yfwXn4ltkQaU4UGqKGs5HTjz
         oxh8EFNRt8O7ApvwZEuylLrgkJl5w2xDegFdaRwOQcMTz33YdeYnrfATzWdlBBAbS8Ro
         R0XiAtAiIVKrfleATyjGGwVj90a/OcfmIbycsnja+MvW0dwPlA2wOtweYf/3NuYL22xL
         c//w==
X-Gm-Message-State: AJIora+x2NFis2sFN/qsOni+vK3L7Amo6YneE3MTxz4c6XGvp3tBz5zg
        ES3dYP4plQwaVORpDS6ln40=
X-Google-Smtp-Source: AGRyM1sv3aygYGONofcm7NrZidHpxEcURN7BhcB97u8d6Rr7XnKD9mlJ33viIWkVtfiPs7GAgr+xHA==
X-Received: by 2002:a05:6000:1ac7:b0:21d:ab2c:1929 with SMTP id i7-20020a0560001ac700b0021dab2c1929mr31188090wry.634.1658328630261;
        Wed, 20 Jul 2022 07:50:30 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id s11-20020adfeb0b000000b0021e13efa17esm8871773wrn.70.2022.07.20.07.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 07:50:29 -0700 (PDT)
Date:   Wed, 20 Jul 2022 15:50:27 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/71] 5.4.207-rc1 review
Message-ID: <YtgWMxNkcWNJANuX@debian>
References: <20220719114552.477018590@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
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

On Tue, Jul 19, 2022 at 01:53:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.207 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220706):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1520


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
