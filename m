Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967B452516D
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 17:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356039AbiELPkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 11:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352406AbiELPky (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 11:40:54 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7E9193C1;
        Thu, 12 May 2022 08:40:52 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id kq17so11049045ejb.4;
        Thu, 12 May 2022 08:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UGcecE8BJ2FQvYEPbpshw8t/4GdCHo6m2IbbNvZmX18=;
        b=YpP2HBriKH6aDqYSwuGrjGBgjvzePevL24cgOetsAZrrTa6lA3/NSsyOZFkfufw0lt
         lJBFYiJw+y9js57P1EjojQUDGrQ1eKEIqYBFYriAc/TiIKkvwpOPevhyLHj0TzV3gjrS
         HA08imVpavvzbT0kxF6Sg/HybSGDYvXvTNDZYU+krnbCrZmhcN3ba8Gv/9F8APLbp9NF
         QKpeRYw8LN8BQ79b7yBceBvGkLFH5HkcgHpn17vt3z0Hsh3xQfC5onU4QQ50/NjzjYm8
         pxfyDegPkWjW44FmHM97QE0avUGSFDiuELMvpINEJaH4w5rwMnc6VFiEILb14ZVOxH9N
         XiVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UGcecE8BJ2FQvYEPbpshw8t/4GdCHo6m2IbbNvZmX18=;
        b=c3bEwBuV7hQKNxg4+E/TnU3YVPoV2gKgaSEB8oH2m6f2f1O30l8rb1XolIX0+Fj2Y8
         nF0Tl/a5pqwlhIumfu5WlIOToMnetY1NcPuGlErFV92/YBWJScNG0Dgnyfk2H4zc/Kxy
         HtDL1ksbGEw5hRY2fdsr95uKgcghrOi2gYKl35YeONle68F4oXGU/YWyxEWadJxjSH9l
         4hoVCqQYPDVdrFBp1gKURV/PJmRfdYFw6/q7EXGnUCrIzaylsoda1Ta4TSZfXCIAE3qD
         tklWx2z8oMcEqZnrDAgd+6m2e0XIUA4m6heS9YtYtHM5/dFHJhi0nRm5d5U2eGM8840t
         Fxwg==
X-Gm-Message-State: AOAM531ZzlTwQLzTxFKGRTuHtqLKnoodnlXMhT46mlcxXc6bYUWXfiFj
        y13r9MbMQsomFXy/rjWD6Z0L9aZuTv/pO7xA68w=
X-Google-Smtp-Source: ABdhPJxGNhZlhRylD568whW5WraQanH+Vx3FH9d+5bihMvaQ1NHaargKlr/MxbBEjytQcdV3JECNwKU2N03kmrCkHts=
X-Received: by 2002:a17:906:2e8d:b0:6f3:a30e:15c9 with SMTP id
 o13-20020a1709062e8d00b006f3a30e15c9mr441682eji.333.1652370051509; Thu, 12
 May 2022 08:40:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220510130740.392653815@linuxfoundation.org> <YnuMDWIReGg6z0Al@debian>
In-Reply-To: <YnuMDWIReGg6z0Al@debian>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Thu, 12 May 2022 08:40:40 -0700
Message-ID: <CAJq+SaC2kd1DRSjL=1t+PZrpTHrZmuOJ=Pfy7C4cBJHFnToN8A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/135] 5.15.39-rc1 review
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > This is the start of the stable review cycle for the 5.15.39 release.
> > There are 135 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> > Anything received after that time might be too late.
>

Compiled and booted on x86 & arm64 systems. No dmesg regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>
