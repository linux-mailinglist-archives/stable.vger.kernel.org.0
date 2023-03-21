Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213586C280F
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 03:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjCUCYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 22:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjCUCYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 22:24:12 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2732B37B6E;
        Mon, 20 Mar 2023 19:24:10 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id u38so3344701pfg.10;
        Mon, 20 Mar 2023 19:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679365449;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KBp3hodYXuxgjFv1xVDSLLR5sBVnx2dAi5bauwPJ9As=;
        b=kRNPCobLYyveiwrz97+qBUd6Y+yDw6wCRufopTl6egsG9zjGXuuHujgyRpUR9QxCll
         4o2nsOEf95FlHWjd1X6vOJLBDkDFfAQIKmAwuzVtRLg0DEA86CGBYJvwo4/sIJhm/QVa
         mof60+FtL//trUiGzWypSWNkxdxPxS4f5D1sTagYvogp9ZzqC75G1UwuHL7/iUSBLBxZ
         y5TFH10/L0GEpxJrcdM3TsVL3wbLAQEXa68YaUiluTE7qUWLmInSQtyx6UG8AOgJ8P03
         zeei6H4pqKXaQ4RwZKJKCxL6ZoqMpO7bLGsmTnFrucQKDT5+wumwNFKU9Z+G01EcluJJ
         eHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679365449;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KBp3hodYXuxgjFv1xVDSLLR5sBVnx2dAi5bauwPJ9As=;
        b=EejCMZ+oBo7EYd5YybZtFi7d3bZ5SUmU6nRkrakE1JoG3tPqvz2D0zAYm42KWmkz0y
         moDKhLkh6pF5acAxf/Si8ve6Fm+lcsq8O62PhW4arX3EL4plJW2xo53G/7CHYAY4wn+V
         sQXc+w093rMx1JswdOGC2Gmyj1Y8qPW62o2j0TS1v5iaWR0MnA9lQp+hOVvok3uezyhy
         7+CvU93FsU5IwIIAtRIgx/6ZAyKGtfeVywtd496lxNPQ/HQ0Inzlqd823sFBVxVwtSN6
         toRIFfvBj+nNGIxVUDx6Sy3FFxA7P2vWuYsZSSMzkQIru86agDWZpMiL/o2xxSrIQsO5
         MMpw==
X-Gm-Message-State: AO0yUKWTZ8jmfIPGxLwzezI+UIWcw2G+LwaSoIE/RUHIfWr8Nd8WJMll
        YPELZK4ltA2Xd5uyDyslUKiYKnv0t4Ia/oTk+wE=
X-Google-Smtp-Source: AK7set/6akrAshpxac6FFFp3TU4oiU1mFSNH2zV40w97FSSiie+v1Zzqu1mzigHWIWaE4/zudCFRQPcUBem3mfqW0hc=
X-Received: by 2002:a65:4309:0:b0:503:8226:f872 with SMTP id
 j9-20020a654309000000b005038226f872mr210899pgq.0.1679365449652; Mon, 20 Mar
 2023 19:24:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230320145513.305686421@linuxfoundation.org>
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Mon, 20 Mar 2023 19:23:58 -0700
Message-ID: <CAJq+SaAcQe4ZgTNrvXWsX7+u9xPhHYbdK5qFf8a_XF6whb9+gg@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/211] 6.2.8-rc1 review
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

> This is the start of the stable review cycle for the 6.2.8 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Mar 2023 14:54:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.8-rc1.gz
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
