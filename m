Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D41E596017
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 18:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236215AbiHPQZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 12:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236229AbiHPQZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 12:25:41 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CFAEE0D
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:25:39 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id y3so14177104eda.6
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=xZbhJ86qeK0iLd6MKqiB1IUq4Y7ffH3veK//inJpuGw=;
        b=HzNHJZQijj8JlSfru6AkH1YQh8sNxBD2pCT1ub30EiGUr0dZ23NNVuEaAlcJjV1IvI
         tn0PLnUb8rx4bgsOqlc8OOR1pWZOGydPdvCj+evhLgKSf/N+XPJWxq7aQ4awMlKkxxjD
         4PnROEjPsEBlyzR6PN6036HFnI7IfWvcedC3oiom/MVIwvnhdOGDMep6UNhhOXsE92TU
         qNb5y1D8TUMisu6UriV2L6PJZNyELkyF227cyUsZ0mqKeF1ZAq7lge59LwBgSKxXwMby
         /DteO3ayYFl/nJUCrPtutk9GpPy4YBcHzpTA1bIqF/boOg9ZxOCKd+HI5ps76Lo0p7Kx
         zCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=xZbhJ86qeK0iLd6MKqiB1IUq4Y7ffH3veK//inJpuGw=;
        b=bSnMO0OkISaUspA0jYIOeZH9NVpufA6/+eWUNBCKcGwq5n9TGWyaKbW7irTLzKGDRz
         F4dkUWwvR9E7CL2qnaq54qOl04MnSgVFRyEZqz7WK6ZqNmTID/DiqGJsZB1pcvECDWLU
         WM0jd8aXZTLJJEp4nqbQdO5zWQrDZEVdwP4oY7tVasLhhZuyRS9mIFIPswrBkkSXsaug
         1rMcMWy94Ai7umJxCrStip0Hs2UQqtjYNF6HzC2WLGdURZZ1Pqtvr7rEF4Va8tZ767gS
         7AiJi7Z+4q+5WDGU6VdyqF+2fNlCVMC7Dpp/ifnrBZTaQVaC0I0oR/HNEWUwKVod3o81
         FLtQ==
X-Gm-Message-State: ACgBeo00iAL9UjZW83VryP5PwMxUyO2BGXrN9gZWzelQIwAm/Glosp5H
        ORnmv61nZZ4pyE0KqICIpgRfh+3GbZXPKKgeIl2SxXPi7hodkQ==
X-Google-Smtp-Source: AA6agR5NVFdAVohPgwh9aCpwEvDJ61/gn3bBBuGoIDZroPm5V68OkeO32ZjkMjk/zjPc2mpGkdLRzqAUgozWEgN77lc=
X-Received: by 2002:a05:6402:2387:b0:43d:3e0:4daf with SMTP id
 j7-20020a056402238700b0043d03e04dafmr19547097eda.208.1660667138236; Tue, 16
 Aug 2022 09:25:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220816124604.978842485@linuxfoundation.org> <CADVatmPOCPfHQHEuwVmOb5oeN2HfWWMztVok3qvoq7Ndndb14A@mail.gmail.com>
 <YvutIhMRZW/nKOPi@kroah.com>
In-Reply-To: <YvutIhMRZW/nKOPi@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Aug 2022 21:55:26 +0530
Message-ID: <CA+G9fYuW48_0c08iVk9oeHLGse73tuft2ubdkC2Y-fyZdJpr9w@mail.gmail.com>
Subject: Re: [PATCH 5.18 0000/1094] 5.18.18-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Aug 2022 at 20:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Aug 16, 2022 at 03:34:56PM +0100, Sudip Mukherjee wrote:
> > Hi Greg,
> >
> > On Tue, Aug 16, 2022 at 1:59 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.18.18 release.
> > > There are 1094 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 18 Aug 2022 12:43:14 +0000.
> > > Anything received after that time might be too late.
> >
> > The hung task problem I reported for v5.18.18-rc1 is not seen with rc2.
>
> Nice!
>
> > The drm warning is still there and a bisect pointed it to:
> > 4b8701565b59 ("drm/vc4: hdmi: Move HDMI reset to
> > pm_resume")4b8701565b59 ("drm/vc4: hdmi: Move HDMI reset to
> > pm_resume")
>
> What drm warning?

WARNING: CPU: 0 PID: 246 at drivers/gpu/drm/vc4/vc4_hdmi_regs.h:487
vc5_hdmi_reset+0x1f0/0x240 [vc4]
https://lore.kernel.org/all/CA+G9fYve16J7=4f+WAVrTUspxkKA+3BonHzGyk8VP=U+D9irOQ@mail.gmail.com/

This was reported on mainline kernel on June 30th.

>
> > I have not noticed earlier, the warning is there with mainline also. I
> > will verify tonight and send another mail for mainline.
>
> Ah, ok, being bug compatible is good :)
>
> > Also, mips and csky allmodconfig build fails with gcc-12 due to
> > 85d03e83bbfc ("Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
> > regression").
> > Mainline also has the same build failure reported at
> > https://lore.kernel.org/lkml/YvY4xdZEWAPosFdJ@debian/
>
> Looks like they have a fix somewhere for that, any hints on where to
> find it?
>
> thanks,
>
> greg k-h
