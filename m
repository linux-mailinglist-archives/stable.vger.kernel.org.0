Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4EC529FF1
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 13:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiEQLDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 07:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344819AbiEQLDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 07:03:39 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B03167F3;
        Tue, 17 May 2022 04:03:38 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n6so2493945wms.0;
        Tue, 17 May 2022 04:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vfy9Os3UW9T3hZZCa7QJexO5wB3rAWO3Au4xTjOjkNc=;
        b=Dm52qyiYB52HQbXqOeuuDpZ/Ujm20JoCfgoXUqw5MwFTzH9pUZlwGiAiNBHtKLeyjz
         FrF99KZ+6wk3gdO36F6Ia1fXvngwDrWUJUQ1GEGRIOewi7ia2rAvFLun7LXwC7W8o65G
         qZZHrQSMMaf/GOISTN9O2fc6DdA+KvXJeMclsEIuNGzBku3cVhpr/I6GcbfhIn5Hy51V
         d8vHeHovHV0IKYfdVZ8bQE9yZEGEpDaCIvZArcyD4EA9NDW6tm7o4i7joRz0xDVcf0mr
         /IUhkKCXEhgVLCkQNY2qh2z+W0LXL6l++NCIo7P+ELZadOE97rQhhjzSoFLs3x9pkJEo
         ceiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vfy9Os3UW9T3hZZCa7QJexO5wB3rAWO3Au4xTjOjkNc=;
        b=7ZorXTV22kqdZDTGckVyNXVi/rCt1se1peSXyyTkqHfOn7n4Mxf9OmKrrdjtNcSG2k
         B/yP6lsejynPNspvYKzMFfE72HvNZv4rV3qiCsFgPEVqkTIAO2V42isrmg9oO1arozsi
         NFfQ2R5MfquV6/dop3TX6C/5KeeDbdKFiNea/yVjBhOVdFjgpu+c/g44lzUP9kErD6YZ
         5aO3vwaARbWyolIWPoDuC+rDTan138ZfpOHd+696VHVD9OqqE2V4pipz1FjN18lH7HLw
         xTKlsQQnMRUc/p4NwroJSY6RWO7Zn8wmn5nPFiH9kxJaV1ZLG0t+ddXFaxlQ002LSPN9
         TgYQ==
X-Gm-Message-State: AOAM533WetVZmGG1WjKclCiyRupeTG5XngzGg/k95i7+n3fRpjBWggeq
        7uZv/o8j81zdrUD04hOYHDc=
X-Google-Smtp-Source: ABdhPJz4EDR5tVCkKy+nOkeUOp5w4c/MrXNJj2o+RBe5T5RhUzV4tdeLpTOBVQB8LZNCh9Mc7xtyZw==
X-Received: by 2002:a05:600c:3b93:b0:394:57c8:5901 with SMTP id n19-20020a05600c3b9300b0039457c85901mr21198828wms.77.1652785417212;
        Tue, 17 May 2022 04:03:37 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id d5-20020a05600c4c0500b003942a244f4esm1545876wmp.39.2022.05.17.04.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 04:03:36 -0700 (PDT)
Date:   Tue, 17 May 2022 12:03:35 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/102] 5.15.41-rc1 review
Message-ID: <YoOBB91uq+8J6D/h@debian>
References: <20220516193623.989270214@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
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

On Mon, May 16, 2022 at 09:35:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.41 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220408): 62 configs -> no failure
arm (gcc version 11.2.1 20220408): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1157
[2]. https://openqa.qa.codethink.co.uk/tests/1162
[3]. https://openqa.qa.codethink.co.uk/tests/1163

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
