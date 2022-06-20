Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD1B5521C4
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 18:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240109AbiFTQCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 12:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238583AbiFTQCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 12:02:44 -0400
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69901C128
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 09:02:41 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id g26so669343ejb.5
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 09:02:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yiYvbLnEekkvWxxpYdJMuyxTp22cuJMd+CcZym4RkP8=;
        b=P9WCE/0I0wSAMwlenLSZ0QNxpV9slkODHQV4epcSnYhdWCKnZLIU5kRcfvQwEbLlB1
         Fap5W6daGx8YyWfnKkB/ySRQlMZe0+Kpwai81Wr/JKFFmYs2RcrVcT/+JSIal2qpZ8vW
         RYR1kfbAqaO1Arf22oj3A6WYP/rk6xv/MOdzchs4VYrIlR3HtKHr+pGOfo/LpwbPoN6Z
         3BTc2nJovW8oP/m/MWy6SKsO8rJWAx5JQc7EptYXxM+0iP/E9dOTEaSfnj4l+xwu0F9C
         dRRXsiZlEk+WxzC+jzFln21/HibW0EEtMs2HokeZgzX2Lxim7Ih3DAKYYkCH91emhUqf
         d94g==
X-Gm-Message-State: AJIora8R38v9KCnW4Acp9MdYFbSnM8ZTYvrJGhBaN0co/Wfmi+hM6+FB
        A/M5ES8J+HW1VA/HWoXRShKX5sNPidlGilAJaRLWdw==
X-Google-Smtp-Source: AGRyM1tpkik6QOauWuHQl27t7x5EusPr6YTpYq0PbQVCRCctMDzLlhDChkanCU7DArjU4vwDpqZ+dO/wN+WNIvSS0eY=
X-Received: by 2002:a17:907:72d2:b0:703:9177:7d1f with SMTP id
 du18-20020a17090772d200b0070391777d1fmr21377212ejc.144.1655740960182; Mon, 20
 Jun 2022 09:02:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220620124729.509745706@linuxfoundation.org>
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
From:   Justin Forbes <jforbes@fedoraproject.org>
Date:   Mon, 20 Jun 2022 11:02:29 -0500
Message-ID: <CAFxkdArwJoMEKGjmJFu_tc+-sA8g4j+wGR=_7Bb708+T-3dPEw@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/141] 5.18.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 7:55 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.6 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
