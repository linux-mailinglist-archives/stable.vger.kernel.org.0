Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B3B6C38B3
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 18:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCURzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 13:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjCURzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 13:55:50 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD1F4FF20
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 10:55:49 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u5so16853428plq.7
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 10:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled; t=1679421348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=anmwm8yh/Vv8uX68Kbemfb9lejd4xrXhy7Hrxs7x/Xc=;
        b=p+5z7EVJQPLlOQLYbDplKK87mDndC8RzhIx2+st0XPbLsiD60EhRtLtfqfOMrMg+UX
         /6Fwj04we+rGkipUMwrnIhhNChD58Q+D0HcJUHND61pTEtL7rj9utgbbf8CfmF/HIZbF
         EDeRugM3ONkg2u9p7433FET+ZotZEyzDYdmf/hRf9jAOgoYDSNjm1bEYnHJI5BHOvQ1y
         PC2DH9oJ4lT9AG6rBH6ke+6Py0SlJmK5fXwyCpNspaE/JhcQP8CehRxKb7kOddg7f5om
         LTr1C2/zgoe8GetVf6eCS9oLMEcn6Qvb3IETEgBN+7KAKQUJf6eumactKjZ0GyKoighV
         JuTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679421348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=anmwm8yh/Vv8uX68Kbemfb9lejd4xrXhy7Hrxs7x/Xc=;
        b=0EP/Nfvo8es1kYpLh1zu0jcRP9t7TCd3BmIwGtKlN9Z4IyQa7ayKhpBmXCEL7ylVml
         RsM855pkjladeD4J3aKojf3hfvP9fDbUad1plAlk6NIvarVc+h9S9Rz6I2lSBqDbU9Ia
         AUPKl7HS7oty6tdkAh4TAoGFfJ5m2+4rjbnIsl1Tca4j4ACKn91NVb6OCMoUa6Y1ic8y
         mzrfeXwWWU6zCE5LThLaidqJafVfk2E2vcB6zTT9lz4Ah/SOU99+HUN2f3pSYGPcfiIr
         GSmUpHw554QMAyUHx/xWCnvjaHqfvYV5BX1YM/vCp//6plHyX9c6r7eR+JsSw28E2/vh
         F/CQ==
X-Gm-Message-State: AO0yUKVbBAvDUQW1NP1XBsaFahPtW3EujjeU/+eyeIvKihZv4qIQLJnd
        mnApKsVAptjnjg0xJXKmFV0oMgQZSzvSx7VTJwOdxRojPnUW7yfQQoBWZhfSMdpi+hXD8CS/iaX
        KtwR1NUBiWgbAYMTlY0KF8TQXP3fKsXlZE33CZDssdPsBdg==
X-Google-Smtp-Source: AK7set+aSSNndRQzBA2NvrSAm3VcmzzTjttcwiReGOC8KcfvRLO1EcHhKyk4ELdF6t0E/8bB9RzPogDwF+CPhKhae0E=
X-Received: by 2002:a17:90b:190b:b0:23d:535f:59c7 with SMTP id
 mp11-20020a17090b190b00b0023d535f59c7mr221120pjb.7.1679421348502; Tue, 21 Mar
 2023 10:55:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230321080647.018123628@linuxfoundation.org>
In-Reply-To: <20230321080647.018123628@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Tue, 21 Mar 2023 13:55:37 -0400
Message-ID: <CA+pv=HOG7Ye9qvUTyYuCNYW=iEbmwEtGO9534EcPz4iUKTFMcg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/57] 5.4.238-rc2 review
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
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 08:06:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.238-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.

Compiles and boots on my x86_64 test systems. No errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
