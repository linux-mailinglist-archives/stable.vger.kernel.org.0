Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA656C3686
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 17:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjCUQEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 12:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjCUQEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 12:04:13 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486022D7D
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 09:04:11 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id h15so2605833vsh.0
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 09:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679414651;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mLnw4/hq8OG1me/CkEtTgL26WuqaZPsS6YVVaJ0eX1E=;
        b=iGtUdAhnLewhz9waBIa0RMr81+7nRX/lBs0MV/taQ3yXkDMOax43/6dEpZKuIsQKAF
         J1LdZRvQHfvf3Biw29W+WOArDLm3zTzlBT2FfKbctr9izh6XJEyqwVb2WbhmfRmmkpV9
         MCy8NDWLne22qk1a7vLszVVhVQz8nxVG4Z2wWdIETl2eeooOeN6i31y5RazUYVCqYGYo
         94Q7VeFObuUsAQYKJGOsP+S+Ih95g0EJTC4iYlJGRLY6lSfo13RMh7/EZZqAFVPGK8Ql
         7cT3Rj7cxi0Pi8x4Gru4CHj0upIOvuiCg7+LB5wOOzIC0GC8wKJ+nfyAPkHfFbiuTxFu
         yPMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679414651;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mLnw4/hq8OG1me/CkEtTgL26WuqaZPsS6YVVaJ0eX1E=;
        b=HbZpSQSj9WKDEfkDlb9tm4dTSpSeyvxb4fZrkiK0zueMZbsRX2T9oRQiBeX3Uwfr2e
         zHIUZ2rAFFHwH4yOQZgguZPpb96G7VHol6aFUWXUJly/Ogpvg6otLLnHOHf8Sz4gErnB
         nVn67kH3omZlBTtgdRCLnGczLEytv4g+GXnkFlQndrj1GSwqiz8eD4L9ZP4x7bhenArp
         Xi9kTegxmevaDAuH/T76xs7BYAgTlHDz5gjE/W1PCAqVHWMOmQ2+fNfzpTIQthfrHIEN
         Unzq+RRhbOnnB/xs/JqlNOFIRNOrqJmK9rYAU06JLTc/9PddniX6epZoyonOjXuMcjOZ
         nWGA==
X-Gm-Message-State: AO0yUKXbE4i18Deiifm/lwgj4P0gUNk21bnCmfLhZD9oFLt3QcYaSYlJ
        p9MjJ5VCTXUKeP8PIte0R3buAnlHEBJQcL/S8Luplg==
X-Google-Smtp-Source: AK7set/OhKD8oH7awyUpeq4BSIdxOPetYViGRrteazzF6GzXctryWjuGC9F+OfDIMmAdtLNMbw6J9ARkttXxiCEzsy4=
X-Received: by 2002:a67:e0d4:0:b0:425:b211:3671 with SMTP id
 m20-20020a67e0d4000000b00425b2113671mr1915864vsl.1.1679414650735; Tue, 21 Mar
 2023 09:04:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230321080705.245176209@linuxfoundation.org>
In-Reply-To: <20230321080705.245176209@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Mar 2023 21:33:59 +0530
Message-ID: <CA+G9fYsD6PVkfrpS+k6TBye5r1JzWVOzRwAsndSYzVwgB+dTxg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        llvm@lists.linux.dev,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 Mar 2023 at 14:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 08:06:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.21-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Same powerpc clang build problem on 6.1.21-rc2 as reported on 6.2.8-rc2.

Following patch needed,

Upstream commit: 77e82fa1f9781a958a6ea4aed7aec41239a5a22f
     powerpc/64: Replace -mcpu=e500mc64 by -mcpu=e5500


--
Linaro LKFT
https://lkft.linaro.org
