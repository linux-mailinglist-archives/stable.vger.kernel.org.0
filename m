Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA45762A110
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 19:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238299AbiKOSH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 13:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbiKOSHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 13:07:37 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF48A13DD6;
        Tue, 15 Nov 2022 10:07:21 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id g24so13901190plq.3;
        Tue, 15 Nov 2022 10:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bBywltwPfbjC+ce3gndOtHFxBFbCBPvkG2/C6S0a1WI=;
        b=GaQUaznYnm3NUF/MC7IYlMFHFoWHVbc4RHuWnJN50nyCIwN7sx9p+FB5jasfcprWCE
         BWcSCAtHtnaUUkFsshq4oqZHstukeJoobJDLGVRlmSakBcZ9IMppe0BWufDYAQafwZyI
         kZ8F2okBfC8J7JMVNR1CpsgffFHGv6c6Ej2U8z+mvJCUtuIcvM3h0gLrND7I7kE8ozFB
         xtkLqoKGPyt3+FodUj+mnabAvKaCTFaAr3t0NcKg8GxYFJ3EhfJ32oNvn1ywTdLIkjir
         r2/uTSLdV1JI0GAI4wSxc8VMrpsBDFF2CirgLfJfxoyolnrIzRbqCdltuT4378tqwleD
         537w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bBywltwPfbjC+ce3gndOtHFxBFbCBPvkG2/C6S0a1WI=;
        b=ij64K552oN3MCYzE4ieRcZA4f0eO/sf69zhL6f43tTFiORrLINLl+S8kJ9H48bQijt
         Pu6HjX28fz2p+jHSIPhUA+kZDSsGGDvvuDhc77GhgQ5TZHn/z466SSV34nm6qDfUU/mc
         yPE6HD4uQTEX9ZR9EqWIt9SAP7RxK0mXl5yVyfRYf7OkZ3gptAz7Wv/KpFR1h65VQqZt
         HhxQ9bkJ/3ChpV/j2fLNbbKmQh/RpCxtBHC+NxY7UzYV6ZA5dFrtxQFgTD36cRr8yGVU
         YTL5fREjysTWmfhwNkNvL3hf2W8GTeaxkOEjQK+c+WiBlmlD4aWHEfi6KA3+SgnaG5fd
         nzlg==
X-Gm-Message-State: ANoB5pm1odTLf2i5JPhMuloRkAckkejg6ZEmFqqve2wS1r0xRJauvSTE
        rw2fZZkZu82NzJ6gmiN62I3PPbtgWCKexr1E280=
X-Google-Smtp-Source: AA0mqf4DjA77nkIh39DWoUK2zu8eLVruCRANeUn1hy+5egUcLsy5ITYNaFkdHxmQ3lPoYOKqg4XiObTZKUdlHIWnx2w=
X-Received: by 2002:a17:90a:fa43:b0:20a:f469:7307 with SMTP id
 dt3-20020a17090afa4300b0020af4697307mr1652818pjb.213.1668535641357; Tue, 15
 Nov 2022 10:07:21 -0800 (PST)
MIME-Version: 1.0
References: <20221115140300.534663914@linuxfoundation.org>
In-Reply-To: <20221115140300.534663914@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 15 Nov 2022 10:07:10 -0800
Message-ID: <CAJq+SaAF-NfnPOiVu6s1Hn5jSs0595CjeezR9n-DAuZFzDZyhA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/130] 5.15.79-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 5.15.79 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Nov 2022 14:02:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
