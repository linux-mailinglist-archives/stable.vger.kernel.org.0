Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA99735AC65
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 11:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhDJJWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 05:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbhDJJWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 05:22:17 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86A1C061764
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 02:22:02 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id w3so12321004ejc.4
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 02:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RCY/uzytg+00OXSbJzdDQusGwDBz4DC76EcTISMF7o8=;
        b=rF+iqDy+u3OsS+gqlWrT+SzPPTe+x9l0yKPkSge5sBdNZiFyC8uKNhmu0gzLMZleHD
         BMefEaOVkLEXx7m/XLekwgm5FHoucz/BOxUIP9B7bDum8oCY6wkWxbj9GR5Ajr1YrgU6
         SweYM43KBJ8NimK6e/QaUrbjxTfdjRs9HPSpKdUgy+LgGTh13u/GsZ5L52W9hibEfH1O
         3etx048wlcDvaEqHVLt0j8HvsbCHPmOhgQWxSb/rbppdxjcxOcIMrd1Jex7RzOM+5yAH
         PFqAd4K6qEE/ohRso44Esn0GGMHRNbmZ25v0lb+QBwGbbzZBgvjPyCcg7EEx9eEQaPkf
         IKlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RCY/uzytg+00OXSbJzdDQusGwDBz4DC76EcTISMF7o8=;
        b=IboveoXqh5YC11CfUVID6sZkaDBJhwciVVAKm/kaP3IJ9RdMljfnWTEwRCP2vz9oKl
         e7jpiUfNTcSJcLdtMf6izwm3ujoPLRsDxhFZyECEbIXiCtA5aMcmKl402ly2bOQNuLXm
         kgvZ8Fmrp2fDxhFS6P6rjA6OGIsCKjS/nH4CkdEdjbpEiIpLqcUuJQS/jOOqR2hsKScQ
         YH+a+fj5KOXXdVmB6IwlqU0wL1HL0L3NWHiOxOFrbngPOddh1yJEvPf8r3DuIPp/qW1E
         dhfrY6SjpJxlNV4xfSwtBsZLaJRPAsPax7FNn4tDgE+pyi7Gn9wKCdY1sddtwNqU9ZPn
         uSew==
X-Gm-Message-State: AOAM533SH75GQZFLzWDx/DZyZHwHOInTtKn3Nz9VeV05pu51V7ATrrcI
        2fDdcf5UnMUAqr5yaWmFrKXmao/2rNVhVwwFJnbevQ==
X-Google-Smtp-Source: ABdhPJyegHJygyq6dKJ28f+uttoZFBjfstvv6nfTx5DPHKiolUbo7ydSTuMplCjCxqiQLKRIn1BecPmDbaJcUIn45ow=
X-Received: by 2002:a17:906:2a16:: with SMTP id j22mr19620436eje.247.1618046521190;
 Sat, 10 Apr 2021 02:22:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210409095300.391558233@linuxfoundation.org> <20210409201306.GC227412@roeck-us.net>
In-Reply-To: <20210409201306.GC227412@roeck-us.net>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Apr 2021 14:51:49 +0530
Message-ID: <CA+G9fYuB5wgnoa4Q7Ag5XW+HSKeXKRFOtScQ3m6OZGLEnBs0dQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/14] 4.14.230-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 10 Apr 2021 at 01:43, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Fri, Apr 09, 2021 at 11:53:25AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.230 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> > Anything received after that time might be too late.
> >
>
> Build results:
>         total: 168 pass: 168 fail: 0
> Qemu test results:
>         total: 408 pass: 408 fail: 0
>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
>
> Having said this, I did see a spurious crash, and I see an unusual warning.
> I have seen the crash only once, but the warning happens with every boot.
> These are likely not new but exposed because I added network interface
> tests. This is all v4.14.y specific; I did not see it in other branches.
> See below for the tracebacks. Maybe someone has seen it before.

I do not notice these warnings.
Please share the testing environment / device / setup / network interfaces
and Kernel configs and steps to reproduce.

 - Naresh
