Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57179652AE7
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 02:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbiLUBTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 20:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbiLUBTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 20:19:01 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CE76167
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 17:19:00 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id c7so9652893pfc.12
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 17:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bAITO3y/ju2E/+p9GTxr9wsk3UMDCPB8LrqMLu/DxU4=;
        b=aaR0yhDR1arVKz9UQcdkfu1yGghKA2d2lXbz/Cn/BqodlUjjfi3OCW26wJtpzDeGk3
         bCaPIfQfvFQl2mTdqe8hv9EV8QenxNPJ4/R6cYOX+ukofz46aSIxI+zoiAKqJTkKy+Zt
         RuX+ycRwOEPUOKg4nHusyucYQIdjA07axDoFxzJF01glILrSPMhaHlpI1pFaHRfgZQfg
         xh2geX9EOJ2ad93Sdq9+NLZo3afz9NB4MbOiguMi/vInckRPFZadMGZhhGivuxWDI6Oe
         otblobrKwemL8pruCySEOPyagZrZDEMzLY8Yyeo5lkHiuD4JkLNIk0Xujb7K0eDSQp3p
         77YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bAITO3y/ju2E/+p9GTxr9wsk3UMDCPB8LrqMLu/DxU4=;
        b=HLwqS+HFgWfuiHMXaW/5oCtTwnYpdeGFL3CJ0DzSL7KAFVDWCFog6ltqpear03ilgr
         dZSOL5FnUsTbyqzgEIql//rq9Ar9MziDmH59nV5No2Rq6ghHLeIeDXa9cjjfbic+qH3t
         tJYqBQTDUNBQzThfrHQxSoVoW6VIB2krYY/NS0CFQJNhBr1n79JleABjWZ+iefxmhe8P
         PEQ/Mca0ywCOGopIh2AGyhz/tW5TyvGGjOLz6xp4NGXE1YeZk8MIqbiOpTaaJraVuToT
         YKD8kiyCzBf4aHNoykx5b9D9k798S2g+QCiGXpAG1nG5anZMOcKDM+aTxVxM8/+6gcGr
         9r5Q==
X-Gm-Message-State: AFqh2kqIYGncE5O2d+FTLjL6r8Y9AOb62UYOscjarJ6yhr7MOeBzsFvN
        cYA1oRoS8ifm1M590Q63r55eWuNch5PUxDXELQ4ALw==
X-Google-Smtp-Source: AMrXdXuQj6iDU7ydKDNX2WXWS08ZB8AjLM2GmHfB3McWYiawQPSS9mrhaOw5Fb4C64BzytTsKhuh4PfhqlYK1PRCf60=
X-Received: by 2002:aa7:8887:0:b0:57f:fc4d:f773 with SMTP id
 z7-20020aa78887000000b0057ffc4df773mr21306pfe.3.1671585540202; Tue, 20 Dec
 2022 17:19:00 -0800 (PST)
MIME-Version: 1.0
References: <20221219182940.739981110@linuxfoundation.org>
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Tue, 20 Dec 2022 20:18:49 -0500
Message-ID: <CA+pv=HPtWrkHhjNu77bxHzZ1xBJ_1vhocbiQYuaNHnyF9ZQm2Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 2:27 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.85 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Hi,
Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
