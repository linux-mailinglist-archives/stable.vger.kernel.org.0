Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29077644FCB
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 00:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiLFXsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 18:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiLFXsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 18:48:06 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693A927DF7;
        Tue,  6 Dec 2022 15:48:06 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 6so14772663pgm.6;
        Tue, 06 Dec 2022 15:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=um9Hcw2o48paIqU5FPh9HJQhrZz180gbgMLBUyWpz5M=;
        b=mNnzmCKaWRpiFBderq4iNe8dBMZyUGTVjDQyqS7Cfb8/vhiB4s4195/0OPtakWRm/h
         khUt/rs9BC6RR0FL9QnbTsxwFioHNExYXFfvyz44kGMld2Y2cz6teyrKOMDahL2a9sEr
         9Ww8mesGKcvpoq8Q7+uP4oDIlbk7zbvt/Szs+QuneNIwLYsaUJTcYh0OoP/L60NYPrA6
         7bn9SUSBdHyezL8gz8tXI9g5k3BDTGjn17NbdHrW3LeRR1mKnacen4eecyrW3/vPHHgx
         mimmQyupxGZQzf53BoS4WB55KNGcnNuVoNENeBrx3vGygBtM+xO+g97oJ7VpskhAnQBU
         Juaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=um9Hcw2o48paIqU5FPh9HJQhrZz180gbgMLBUyWpz5M=;
        b=dbLY6kS56hhdlDh6mwZjMxxONv0ccNbjifX8H+OXfzH9WtOlGvHYNIy+DKyf4I+qw0
         haC0hTSHtpw2iNwA1Bl7UBNBcsTPKdxHxcXcQ1/0gwu3p3BNiuEvAq/Wy0lPJ2E003lR
         R47A1pI/ZzYfrPAmciXb0qPCFC/OpcirZwLhUxcVv/hpQGoVmfJCzOdkywMlDc/VCLRP
         1F20eIFun9lHV7loND0oRWkH3f65UflBqPhpGqrCa3zW1/DByj8EDOx0caEz9Oe+Mac1
         gOEwd1u6otFTMZ4xBN6UuJR7BSV0pgAxdg9Nlm4oikAqS2r+MgIXTvw4FFDbYRtTjJ+7
         3rQQ==
X-Gm-Message-State: ANoB5plhCxCJzstUcds7SZoDJD8RSMBlUORE2OkXy7DWZS/ya24RCOMi
        euXcZkutOINARVobnW2CQGgvtYLNvYNcc9s4EEE=
X-Google-Smtp-Source: AA0mqf61GIWWGTUrz18zgGeHvgf3eMnoN781eYgNf1B0oen/Ln/Xmwq4NwvvpwX9VPD2RmvnKZaSquPSMq5upsxszKE=
X-Received: by 2002:a63:1f52:0:b0:477:8fed:8121 with SMTP id
 q18-20020a631f52000000b004778fed8121mr61048988pgm.342.1670370486026; Tue, 06
 Dec 2022 15:48:06 -0800 (PST)
MIME-Version: 1.0
References: <20221206163439.841627689@linuxfoundation.org>
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 6 Dec 2022 15:47:55 -0800
Message-ID: <CAJq+SaBg0nmt0pzr4F-NhiAvgjdLRosxtsLS-pazx4uNrZBFZQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
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

> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 16:34:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.82-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
