Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65D854B716
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 19:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241991AbiFNQ7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 12:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356350AbiFNQ6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 12:58:25 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C22C1EAFE;
        Tue, 14 Jun 2022 09:58:13 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id j39so9543294vsv.11;
        Tue, 14 Jun 2022 09:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dX2wPJzD4N4Au++jeEu4etQ2GuWWnfjYADxdIhM8g6g=;
        b=MtduOn1vS1tVG03hAIGXGvHvZiim/NLPed9YFCM5PeY9Uj1zFIsOtRqY1on5iKsPbJ
         Vgsu616OKfoD4o/4Xj8RirPJLKavRZuzGchp+Kg0GImKn0XwEG2CB8RwvzPcw6TFWC4Z
         YY3fPq5KjyzhrPIn52LXTRTulw3FUhrnKn7AZYMZMRS3WFfG0m3ehmzlp1tZmlcLJ/N9
         78rOM3j0Z4S2q63QDa7XjVdExvF6eelhlF2IjOdWdENfFuPobQbgfZ58Fo42f9reQ4Fg
         N3+RMvXk/n+STpn7TijmGTt2amoqLUwTEO/e/RQ7Iz3t+UIIPLim8TtRp3amSn/pKiFX
         hgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dX2wPJzD4N4Au++jeEu4etQ2GuWWnfjYADxdIhM8g6g=;
        b=PCU9paneFcDXPwmYrKXgjyNijsgMqhD5fixysWX4wI70JXsN2ihq704EzWERYood7y
         ArEcb9yscaZXQ40sN0Ibk02zc3USmq3GyNae/fPQF/AKxpque5tZ+vAfl9jU/nT/+Nw5
         x+gNSNUkWBIxB7P1XehghlF0sFuJ/h19cahjjluQcTLHmMFWl6UJid8dwIKoVY+aSGrZ
         QRF7/rwv6fl34s6RYnVxGUEJQeFMDu85OBxxBttNqf0g2WG81iwYcwsiw9qEBbnlQwCw
         2nwW8/RM2EwCoa4CcnTe89Mbwkp05LYg+AikQW4ct+tinWGdyqmbCl1pP+DDj5+D+7zG
         AZLA==
X-Gm-Message-State: AJIora/mcvSU+yrSCAQxiWy+SoWS62MsddIdQW2tDkdPPaFs707wadg6
        AFfezSqUx1Sy/CLvBL9Og1tJLReu3ZDaMEVjZ44=
X-Google-Smtp-Source: AGRyM1tXnoI4uA/0ITs9VKhCcSpQFhtFVQg8G3WUIEk0HT6w3/fTPVZOxlR57eCoEAPwtB/MdQSkAgFSVvvnTkqqQnI=
X-Received: by 2002:a67:6cc3:0:b0:34b:948e:b5b8 with SMTP id
 h186-20020a676cc3000000b0034b948eb5b8mr2803731vsc.85.1655225892310; Tue, 14
 Jun 2022 09:58:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220613181847.216528857@linuxfoundation.org> <20220614153607.GB3088490@roeck-us.net>
In-Reply-To: <20220614153607.GB3088490@roeck-us.net>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 14 Jun 2022 09:58:01 -0700
Message-ID: <CAJq+SaBj3ienFDiEHxBkjnd0WE766B3TF_f6XuQ8ZjM=18UwSA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        slade@sladewatkins.com
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

Boot test:
x86_64 & arm64. No regression.

Tested-by: Allen Pais <apais@linux.microsoft.com>

On Tue, Jun 14, 2022 at 8:37 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Mon, Jun 13, 2022 at 08:19:49PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.47 release.
> > There are 251 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 15 Jun 2022 18:18:03 +0000.
> > Anything received after that time might be too late.
> >
>
> Build results:
>         total: 159 pass: 159 fail: 0
> Qemu test results:
>         total: 488 pass: 488 fail: 0
>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
>
> Guenter
