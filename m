Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D035D536D82
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 17:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbiE1P1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 11:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbiE1P1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 11:27:41 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC81E13F1F;
        Sat, 28 May 2022 08:27:39 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 129-20020a1c0287000000b003974edd7c56so2695430wmc.2;
        Sat, 28 May 2022 08:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p6jQdkjY0mE3LQIF6FbakAEeSwNcU+QtLip1oolNF3g=;
        b=nCZ8i8iXH6ipnGhwWr2KhVeVT1rTJQZm8VCe0ZtzlzQBwXzRn8/MXNCpD6ThaY9zhT
         nFzHooyNbfxXe4MwEIr/gLg5R9+Kc2ClfUg75zpH6Aye3ggLI1PpmTb6V3qAUSPnUphY
         diUDnwuXjXIpc/bZUw5spJ8ig2v8uLwmgctES2ZnyWGtMkM/vppujwMPhm/+IR3T+peF
         aNFDE4pADW5kXxTRlikHXXJrLyXYD3fzREFGE0ItQEgXW/JH99kHCNrppK/wUyO2ELtH
         37f/Dkk3slfbsDQOLHrk3WFDirgNz6JoXWEc9db9KX3mdiNGzJFmieAC0/9SmuZadd+w
         k6mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p6jQdkjY0mE3LQIF6FbakAEeSwNcU+QtLip1oolNF3g=;
        b=vChfgzdHJRkALTTlfpn6LrSOJwiDgqxEhKh0reOmkT5qB/ZpvVunnyB48jIYrQfy8w
         LyTNrRMp1M3WGuF9Mb8axtbJmJ3smkvJJzDWSVyR5wTeJKJ8BEuqaP+gk0ugNqR8pvRd
         ODK4mUxVlrMQ3wH55kd7FqYe0hOGb9cMXJn7bsA76ymzG7a5y+eJEOQ3mEGthl1zyCOo
         sxvwctCQrhFRQ6zBUooYKYuMbilXYl6S8gO2CoTAIw37ae2MMCUCNKNJv4bIVW02U156
         mXdmVsg9f7DDwRNobAIAvc5EdD9FHkw9W5LwwbmTHP9CLvTATsLILOQgow+x4NJ7MF79
         /yKA==
X-Gm-Message-State: AOAM531aIPlSlsGX0/gt/Wk/YReHGS3riBb5Uc9lwO5e2pa1I16paPrx
        kULm3uxbezlOdGiTmwEZeaI=
X-Google-Smtp-Source: ABdhPJwCTYruU9fd0ZRNj2hc5pcSKzOMqGs5CrWXaEPq3pleE3fQxLUOfZsPFvMvxr6gzoncOMXtIQ==
X-Received: by 2002:a1c:4e19:0:b0:397:7b13:1bc7 with SMTP id g25-20020a1c4e19000000b003977b131bc7mr11540704wmh.114.1653751657651;
        Sat, 28 May 2022 08:27:37 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id d11-20020a05600c3acb00b003942a244ecbsm5059066wms.16.2022.05.28.08.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 May 2022 08:27:37 -0700 (PDT)
Date:   Sat, 28 May 2022 16:27:35 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/145] 5.15.44-rc1 review
Message-ID: <YpI/Z979BA4g80yt@debian>
References: <20220527084850.364560116@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
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

On Fri, May 27, 2022 at 10:48:21AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.44 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 May 2022 08:46:32 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.3.1 20220517): 62 configs -> no failure
arm (gcc version 11.3.1 20220517): 100 configs -> no new failure
arm64 (gcc version 11.3.1 20220517): 3 configs -> no failure
x86_64 (gcc version 11.3.1 20220517): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1217
[2]. https://openqa.qa.codethink.co.uk/tests/1221
[3]. https://openqa.qa.codethink.co.uk/tests/1222

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

