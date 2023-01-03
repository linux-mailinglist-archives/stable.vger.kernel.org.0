Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C630265C0BA
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 14:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbjACNXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 08:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjACNXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 08:23:49 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063C82D3;
        Tue,  3 Jan 2023 05:23:49 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id c9so15646585pfj.5;
        Tue, 03 Jan 2023 05:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eRPbEtbfmVz3R4J2b3g8fPSK88ox6UwjS+JxggJkrJ8=;
        b=KUNrBJ8qgTtpxHggAF37pOGTy1xAk1l8qzxGh8PqT30cB+oDcgxK7p0qw5wFthAZJy
         WNECZVVmtaDG7lfMvz4dnifINz4uIROcPTUdwiBjUHj+0zbKDTJWwazaRlWvKQ9Rc6k2
         QdRgfNsEhWbAqZQ+O9zbRwcW9d+akWQXBKH97XxoxBEFEW7AMLFNx4IvP+/c43VeG7EY
         Or12AFBbXyYPMUwRtZZockd/mjVHLX/gjHah0Pp2lB3Bt9R9nM4nhyS2PCfJwEzclGip
         tVd9TvBzcETSfTSLksCnvMAxYtxcGwlZMqCvEBOARTbT8pQReZ8uTYpYT9SCpLb6vtDU
         T9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eRPbEtbfmVz3R4J2b3g8fPSK88ox6UwjS+JxggJkrJ8=;
        b=xvd0N6On/7DQ/ykQiTcCr2EIw1NhX2nB6JCGiFwdt2EI5PYyUjCZygFsMkvzVT3nwF
         o2buUFdd/4VCExjGz1o+oyaSxrgQmdK/8rV+xfq05MeZXIJchDWBbFRhhJzWD4QBWUwa
         Gnqdq+xlnvdiu04tK2q9bv39cqueQnCwf7tUVYwDyuaqiK8uJQqCBXLgysdOLxCnw9A0
         ayI/L56VVxtTTsMA8U4yLaoYTz+uVHqkkEx+LHkxuVU5yYquGlCGKCAEgyDTS2PSbVd8
         +pKR83BGKSa6yOSp1QsYM5JVcPpQEiGVntpkX1U3b6V0cxxqyu1C3c0YweK2n667wWH7
         sJBw==
X-Gm-Message-State: AFqh2konKJvw26S7acj/YBnKkpX1dAY8jM5a7J/9qysrYQySTnAAhONk
        K365ohTmV3oNoMQWk/vljC/BTnoU6Qf0ZwDMwn0=
X-Google-Smtp-Source: AMrXdXvQ1a7h1n0kUst8FBUP4hP5eedIcCGLIn+U4wzph2MFJI5+aVrxQc4vjKolG2hZZB6iVxWg2mCCajiQLwqhuu8=
X-Received: by 2002:a63:1e57:0:b0:487:faef:be12 with SMTP id
 p23-20020a631e57000000b00487faefbe12mr1869675pgm.333.1672752228560; Tue, 03
 Jan 2023 05:23:48 -0800 (PST)
MIME-Version: 1.0
References: <20230102110552.061937047@linuxfoundation.org>
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 3 Jan 2023 05:23:37 -0800
Message-ID: <CAJq+SaDrGuOk47sbSY=XGPDdD7Dx2uTNznK95FOkM38-73+iDw@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
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

> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
