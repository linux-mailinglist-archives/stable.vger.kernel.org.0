Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6937B6D8DA9
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 04:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjDFCt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 22:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbjDFCtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 22:49:40 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB41AF0A;
        Wed,  5 Apr 2023 19:47:00 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id w4so36249108plg.9;
        Wed, 05 Apr 2023 19:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680749219; x=1683341219;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uHA5gOYuEN9+cwpsK5Jf8OpixnKs1IAW1nJs78pOjkQ=;
        b=hCuWgBHIPql9uxthjwmU6uWR1K/B6v97ekkhp3pbSOLqrD6lCwKpLhl1smWtki1AOM
         K80q50qliBzAoIpFx5etvmQgwsIkxWot734Z/EJMhPtmwqR9qAllizzBJc1oVlW6FfN4
         nQfrTdX4gugjLklP97/XBJOuVBDOuW4nuDvQUdbct5ytmLxoXB8ImKfwXAKLphTZocLL
         Ew4d57p6eH7kzVfl43WQA4E5BqD2LDC6+y/yGmPdsurHXGiGer+Nh7q2WNcYyA4PNS1u
         Vw5dMFgLHNj5YFp/A/VR+ZeBwA4PQPb+xBvcondGlK7kc797voNokVLIPbc2f2zt1MG7
         vpRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749219; x=1683341219;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uHA5gOYuEN9+cwpsK5Jf8OpixnKs1IAW1nJs78pOjkQ=;
        b=8EcuMqVrhqN/4ESihESYgSOvlc9dVYSKkcL8Tym95giTRD3U1EkufcD4QenUIivRQf
         5mz+6SaXapZo4NfaJo5Z46AWVbSnAsPqvR0p/8PQ1+p1LRE7IdkRBtXs3/rvrNxYAbA5
         8IUzgaHavYcgSxeIWu+YnfznUQkILQ7J5IaNXGKHZ9DiGOj0IsjmmB6NiGJtzoCxwukY
         OUWVve/OXxoIA7SgxJRrEvNGIFntwSwZs9xAq/23NghtuJBYk/1MomP+CTZyP9DJDAYv
         9c5heF6YwalxWYLws1HwFDjgrLEJ9x0PGUFW32sJr+dvUYfgDbo6t7qlOY6rlSCX3n7m
         O9Ug==
X-Gm-Message-State: AAQBX9eBZmuIqkjoyL7S7xflzZpRgED2a9TXjrSfJqQ3gfM9DRN8W5SV
        gw8UWQh+Igo5lPlr9TNjGp3eYDryg7qfQVq5584=
X-Google-Smtp-Source: AKy350b5Hyez+XCFm4zwuGJSvWVUJWRnBYp0HXwmgeqw2yrQga6spQZbhjMTWPgRiJrPWfSVykUmADgiGMmDap/makw=
X-Received: by 2002:a17:903:1c4:b0:1a1:b318:2776 with SMTP id
 e4-20020a17090301c400b001a1b3182776mr3653414plh.0.1680749219607; Wed, 05 Apr
 2023 19:46:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230405100309.298748790@linuxfoundation.org>
In-Reply-To: <20230405100309.298748790@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Thu, 6 Apr 2023 08:16:48 +0530
Message-ID: <CAJq+SaCeiSguHSztp_ufOeK-QKG--LAa_p+j5hVKZJLkPvcZJA@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/185] 6.2.10-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 6.2.10 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Apr 2023 10:02:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.10-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
