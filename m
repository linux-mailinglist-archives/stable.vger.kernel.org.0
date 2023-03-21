Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CCF6C38AE
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 18:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjCURz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 13:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjCURzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 13:55:25 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0887E5070F
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 10:55:23 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id k2so16860676pll.8
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 10:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled; t=1679421322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O2f7rgn2h3aX/OgonL+LZ4pVeZntbx1pC+H3yOOxuPo=;
        b=POoPbVQzBxPUZ9UVHQFclfZPqdYhET4djBJsztO6uaI2Xh59alX2Y6nwES4W+JkJB4
         7nQ48aAarEIbKFczycMLb/dMh+p1c2KwRNUMNhTcCQ8hMO8gXPv6iPaRq7f8+31+ZPdV
         iGpsXdJ8M7bwAqddpnJNHPtPfG9cLUqrcxk6r3RyD2DWV58X5HpA0nBurpDxSGR51HQ8
         UuO/OarnuvLM+MglRW9T0uQznVVXi0Uyb7olJa69yKDPsWYO5JTHKC7XIFeE5kvkw4BO
         1iB2NgswFTkUC5TQUw1/HGNW4D0BAc6LcyFeeb5gTiGZJ4pfNpxNqdeDsO+jSY24m52q
         jamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679421322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O2f7rgn2h3aX/OgonL+LZ4pVeZntbx1pC+H3yOOxuPo=;
        b=WeJ9kuZ6sd3VqmfrZiZZvFz7VDLEy7gBozl6bBjKYmmBEke6hc+ir3y5h15SHPTU0b
         4Ho1F/7WFRNBWhn1hUCbqOnOizpow8rEIEphV3GVUa9l3hbqeUeteKbdAibz+NAW4BTm
         PS5BOmAmQQQmAj+Pp//x1+KSHFv/Aj8sS9XSWEZD0S7MiNhkTUZadr10CkghF2lMBXz3
         RjSsYXX4MDmeoIh0f+lX3YS/dbtfTtsh0K3tp2TUruuYq8RlCSafmipXQEvdh9uPPfx5
         KzGZGJQBc5T6+rFnEzAh7atty8DdWknoC4KvvDC2JRxasLMfk+kEnGzK4OhFUu3oKIKV
         ZGDQ==
X-Gm-Message-State: AO0yUKVmCIu2iezS/OFrAAqQjaNvC68btXKzy8whB1UMs7K0INDg10T1
        028Y/OpHLKoygb6WHuyq+qz1itV5wICGoXbwqCbfUwTuwtvmhmkVt0QwgX1XIFLuz+Q6/bOAgha
        Jvu4e7P0JTPQ3ApB5qGy7L0u23SQ=
X-Google-Smtp-Source: AK7set/L+0d/V5U9z7rXu+z18lp6xAoVqf1aZZt5Bgnm0x6j85D095LBMwxBvdARwmaE0pXegdHoYmXQkVGkYgWkLoI=
X-Received: by 2002:a17:902:e892:b0:1a0:7630:8ef9 with SMTP id
 w18-20020a170902e89200b001a076308ef9mr1383862plg.12.1679421320553; Tue, 21
 Mar 2023 10:55:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230321080705.245176209@linuxfoundation.org>
In-Reply-To: <20230321080705.245176209@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Tue, 21 Mar 2023 13:55:09 -0400
Message-ID: <CA+pv=HOMuAfbHwkp4BYMeoJk4sL=bSoF=rGcYeXnLHZm2HsbzA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-SWM-Antispam: Scanned by pmxgwmtau.interior-mail.sladewatkinsmedia.com
X-SWM-TLS-Policy-Status: enforced
X-Gm-Spam: 0
X-Gm-Phishy: 0
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 4:39=E2=80=AFAM Greg Kroah-Hartman
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
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.21-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.

Compiles and boots on my x86_64 test systems. No errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
