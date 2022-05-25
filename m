Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C205533445
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 02:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238903AbiEYAXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 20:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbiEYAXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 20:23:52 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3B65BD21;
        Tue, 24 May 2022 17:23:51 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id o16so12920292ilq.8;
        Tue, 24 May 2022 17:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oh7IQWIZ3peE69FCjIauLlZHhes85Wb72An0tykVojE=;
        b=MiwAbK50xPaA6WyUZqHsYzlwDATpBvsomOGizrUMQhu0LB6Dl4DlOUnfkhYhZTpDRc
         ZhJO6A8I03MDobNUPTdhA8nZrH2KMxaMp3imgBGlnhT8UKJPF6Tim43JScF3AiB2FK96
         8zNJU/J+H6WeWTFT81TkxkGQtu8VMDY1MuY7gzL9WEVDAPZOpharJEqABnQQBavPYjmp
         Z35mAb/wtsRIusrR7t36MsQjUQ7Dqtzm4Vd/nNn3kZMxKjv99KKNpg45E3YPzpprmnEl
         ymPyhscVcd1dzvMhJ1HjQvvFUOMWYqD9tAIQ3IeJtOf1dsjxOK/7vc1EklaYlGV9fdTA
         hHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oh7IQWIZ3peE69FCjIauLlZHhes85Wb72An0tykVojE=;
        b=dic1jDvVJv8XY5LX50IOe1JjciK44MzBcvehc6dMH6Om/DygO4LpnI6Jv+Z/LYLlRk
         oH5PzI68Q/eRn8Fx9tQklBcbx8jldivsIuoydZBCwuienLJt6o7cc/PhhHp7rmQU+WEQ
         kyRJarmj64Lykt1y6e3GHBnlCB/hniZFXsNcGT6hDTQk3QbUisU6MxVooydPxHJvY0+u
         AwwpVe6KtNs9AsC+QrfLh6PvjCvh9zHPolP7eSNaGtWKpAcj/dz92bg94LK0yJTLElVD
         KzhfS7Ah2eahkXo9adD79YYcyPdj2JDVLLzShX/MGYnxgmkssxh8txxC7eaCiHydr5GR
         kHsQ==
X-Gm-Message-State: AOAM533ozZlCe0eTHqDUGUyINWv82hTqWV1JqDfz8ZUVc8rA5HDx947F
        pjLiO3S524VI0PwSEHWW43HJLscMkUi3GdUzasc=
X-Google-Smtp-Source: ABdhPJxynA3FtMX0PZW2cTomP11Gz9aj0hFtPgBBBo8nCM7bVbaZL7xCEumiMoL9b0tQoXyziDoMcaqyzFKtB+wpVTI=
X-Received: by 2002:a05:6e02:1ca9:b0:2d1:3c18:a63f with SMTP id
 x9-20020a056e021ca900b002d13c18a63fmr14510403ill.259.1653438230961; Tue, 24
 May 2022 17:23:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220523165823.492309987@linuxfoundation.org>
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
From:   Khalid Masum <khalid.masum.92@gmail.com>
Date:   Wed, 25 May 2022 06:23:40 +0600
Message-ID: <CAABMjtH6c6iFXxONOz19Cixuo6+HwDwvM5u34Hb7DDCUQVecJA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/132] 5.15.42-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 11:08 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.42 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.42-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my arch x86_64 system. No dmesg regressions.

Tested-by: Khalid Masum<khalid.masum.92@gmail.com>

thanks,
-- Khalid Masum
