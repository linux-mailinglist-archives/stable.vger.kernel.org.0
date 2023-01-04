Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3ED65DF4E
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 22:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240337AbjADVtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 16:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240358AbjADVsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 16:48:39 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE6F11442;
        Wed,  4 Jan 2023 13:48:38 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso3069857pjf.1;
        Wed, 04 Jan 2023 13:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8adn/A+ajwGMUNs0+eHz0ODK0JoWcFgYpFS5En2WFqI=;
        b=WlGHn9tSSddPZCXT08KVBFVDHSDRlD1XtEo5BEpKQIGauMpYh0EWw2jh3DxU4yZAZ4
         iDx2Yx0AAoTjl8KXkFOyLPi2MUdx9cHorPJ5Dn/vlYF7v4XCkoSYtl0SYvbXH61GtWwi
         iWHPg+0iQ396j3Jxqmj9NfgSRu9+rTrpM9zJvvd5YPyi8xRnSy2YnF4Okb8EIufXAew5
         o7jWcWb0a+VkZyS8hhwBigYG8R80v2idgL4Q9a3u3YEtFZ+8/OjjyQtZ2uAgq2ExXIYC
         DP5SY59mJ9dRjn5D1wLjpYX7mtA753yvpB2P/fvU7lrzgAHAWjf6VRjfbhxJsoIN9nRF
         gRBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8adn/A+ajwGMUNs0+eHz0ODK0JoWcFgYpFS5En2WFqI=;
        b=LjirRZexANjWhWVAv3/LP2/+znXJ6/cXKtpBVUFszqgERdWo0I5jvgBj2rB1cFxqCz
         46S7mBk6uRGEe0kpup62MuRZc2hYu0gk8WPQ1dc228vL1ACU5fgDKfEEAHuTasXS/9Gs
         EfBCMxYWEw7d2sb1PuNGMBQbPRFA0NbKnUe4bP20YBNX2TS6JHQGbs2okAb1sVEaC0im
         l+/AwG16dYeZxjeDW3hWpQYc3i+cwb6YOa63b/H13xjEzSBv1f3zNZiPDm0V8WYbDz57
         3ARUxvz4ILdSJ89wEWAyPJ4wTGDwEKYFKdZOm+A4/XHfiO6q/tnTZQFvLdRxgWZwIcfH
         UYgA==
X-Gm-Message-State: AFqh2krwEixi9I5VTAhe4zl7g15bRu8wI9cgiMKOQOwJbk0OyXqluYbW
        Vkei4S6i9vmGMk3Aoh/rPkh4RhKcIPi5V+gAz64=
X-Google-Smtp-Source: AMrXdXsFdmIMy4C/H9FbcspY++BB3gUKc4jjVkr3RAo+sbvY/tSFk1ExfBfK4XwUf+4E+MFv9nT2wZmgHfLD8SIJiCo=
X-Received: by 2002:a17:902:ef95:b0:192:97d1:a4d8 with SMTP id
 iz21-20020a170902ef9500b0019297d1a4d8mr1914957plb.74.1672868917682; Wed, 04
 Jan 2023 13:48:37 -0800 (PST)
MIME-Version: 1.0
References: <20230104160507.635888536@linuxfoundation.org>
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 4 Jan 2023 13:48:26 -0800
Message-ID: <CAJq+SaAfWD3JskX1bASjUa+fpTaHrxm1Tzg=4vzgK2gzNCPTbA@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
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

> This is the start of the stable review cycle for the 6.0.18 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
