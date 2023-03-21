Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A096E6C3899
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 18:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjCURt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 13:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjCURt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 13:49:58 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347EF13508
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 10:49:54 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u5so16837990plq.7
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 10:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled; t=1679420993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z4P54MBQ4cIozOzjCsNEj1iyhhcCLnHlDld+BAq0u/c=;
        b=TiFqbZsrplC5EapCAa+IPqjsan9R90HRFywv7MGGfpaO6c9gkLAdbwZC1RgDsjv/LK
         USI5j/M0yKBfMGQlDncNnoXa5XkP7ujR4krU3LjoUmXXIs+em4ALhohZ8jYguqFgCark
         9CtN10vas8fbD3Hmi9w+9tvghR6eS0XkrqmI/huhwBfUmQFwotwtH8I7KJr/2BBehSjE
         EnAy4j7AaLTwUKMba6+EE9Qx3Q4U9R3BGmr3h+Q3zD0G6oEfe/UpqE3+5H8M7p072W4C
         MOqKnd5f+msRt0YoDROei91jUqal9mQmSUfDOpX+frrMFAOGux4kOu9q9N9RFUSKeYTw
         mT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679420993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z4P54MBQ4cIozOzjCsNEj1iyhhcCLnHlDld+BAq0u/c=;
        b=Y0KBeCYfVokVEeNiXXGkUJDtJA2mYpTQ8LuYPYZaJ9LIDqYsMOK0hrzxOpppqlFwhx
         m1Ym2R3jGH3VZgE84JFRUKUUOTSQlum3e9uYV1PATpCCEXEs6kcBTm4OM7xrFSZkx+tK
         V80seA3M7QV0pM9jBtycR/lWOnokBh5/Dy91/i3FnPvQml4eVIXk0H10sV2sR02wo+jz
         WxQF3eIY8NCmSuB4FVwQD2I2f7GjAOmYtccEV4/9ojN4U4KuBA/j6DysA2lZiFayAP8l
         Jeye8iqZUXb+YWiJPJqSebNklSraoPW+UAAOivlY6YK5Y0ChCbOKLG2doi2mLxNa/SrC
         XNOg==
X-Gm-Message-State: AO0yUKVr7qJ+s7ZFhKLAuFKrewB8ZzKs4mB/vZnM+vFu1fNm7urlPbNt
        dndhl9LYArt6O5leUAmqAs2a3VtevtUU+ojwpOfRKhXPtrwLcCEVL7Nl8gH3H5Q+y5ktMMRytAs
        ZvGcuj1TrJ6YHpPX5bqA4xbJlso8=
X-Google-Smtp-Source: AK7set/0lIxr18ls8fqOL+XZgVodfkTEHhpZvmra/rLvuYzI/FkpyFin7e61WmLsdhHXtBlsi9VsktTTiBQ4XUastSU=
X-Received: by 2002:a17:90a:4703:b0:23f:1105:4295 with SMTP id
 h3-20020a17090a470300b0023f11054295mr231123pjg.7.1679420992946; Tue, 21 Mar
 2023 10:49:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230321080604.493429263@linuxfoundation.org>
In-Reply-To: <20230321080604.493429263@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Tue, 21 Mar 2023 13:49:41 -0400
Message-ID: <CA+pv=HO+OXXY9CMgCfRVHgeN0-EcxqQ7MxUpqug+41aWom2+xg@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/213] 6.2.8-rc2 review
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
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 08:05:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.8-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.

Compiles and boots on my x86_64 test systems. No errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
