Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C275A946A
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiIAKXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbiIAKXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:23:31 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7FD1360AA;
        Thu,  1 Sep 2022 03:23:30 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 193so7948829ybc.10;
        Thu, 01 Sep 2022 03:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=zuIt814uy8cH66N+75Ycqn2FRBkniQjebN0QWbVfWcw=;
        b=S3g3LWq85ULTjqeOQKMoyjkoDB34kTgQTpXBC5dt+O/7OmNyhkfXpin84jkIR37dfT
         8H7K1rvi/OEysJAj6cbE+dChbxEx5lPWOrDisPe0moP/KCmP7/8sC3PFgm3cBc9jqpYB
         gC2i2vlaI69tOmgt/3z3AlJ2o6kdwP3DQndybSYaO74gzXvFxE7gnGcFwE8XrttAXER6
         NFkGbFAO/mmQN+3S3Wsnp29MffqpEPZ25qiommPsr3vlvjAQbBU4yb4X/59L6EwTovge
         BK8ukxe0YAsneVoIRbvb6SmIHGNfp81bbOjSoCxdLRNyDPVdm2EEeyEgOQKwRr2FCwpd
         +qsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=zuIt814uy8cH66N+75Ycqn2FRBkniQjebN0QWbVfWcw=;
        b=AwMLa26sx12+ZOeNcCzfMTfqNMTSc8fhUZPovwNUavpOTJK6wWVhRcRNRCQCSBH0pY
         Y/eWzhhM5l1vJYT2ITDH3U/on4nN1s5rF7KE1JsRO0ZdZjKaDTNG70P8f8bOOoi0qOlj
         rogptLkU13eGB7qZ0Af0LRxROHw3X3/EaVgRsoYKYOz0tmvAAxpxML5lyt61vwpQf/Xo
         nYayNumk4CMOCwCVh4U8YCWjVET4+ZfpCmg0ToJUa1A3FR/kKdKJpO8KRoKFopRhWAwL
         6YNNVEzhP9zTv56cI4NZxOm2OegPKMjNBdCbeVTyDyH21n41Ohdw3tqFmynEMD4WKn75
         w7lg==
X-Gm-Message-State: ACgBeo3RQDI/vsdA0hxLlFlyCcIZ6pnHUxyPJ2YD7B8wjpLOjrgIx0Pq
        OvNQEcANZ893W0p9xGBHO0aqiwh8rZr60kbTbaw=
X-Google-Smtp-Source: AA6agR5QKMlivKE09ufpKBkhb+dXPLWiv4LXo3V9uv2CGz8tRLYiYIO9Y5CKTKiYsO9HUg82jjatDHUkzn44LiPpBAc=
X-Received: by 2002:a5b:845:0:b0:683:6ed7:b3b6 with SMTP id
 v5-20020a5b0845000000b006836ed7b3b6mr18096646ybq.183.1662027809868; Thu, 01
 Sep 2022 03:23:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220829105804.609007228@linuxfoundation.org> <CADVatmOLoaGgAW951JqEk3v88EA7mn3qur84Xd30QJWP21+eVg@mail.gmail.com>
 <YxB/ZPFEQG9zS+wa@kroah.com>
In-Reply-To: <YxB/ZPFEQG9zS+wa@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 1 Sep 2022 11:22:53 +0100
Message-ID: <CADVatmPxfdEA3yi9KGHtvmQA2n-mA=ekBidqU+keGrBsL+rFeQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/136] 5.15.64-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 1, 2022 at 10:46 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Aug 29, 2022 at 09:11:28PM +0100, Sudip Mukherjee wrote:
> > Hi Greg,
> >
> > On Mon, Aug 29, 2022 at 12:00 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.64 release.
> > > There are 136 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> > > Anything received after that time might be too late.
> >
> > My builds are still running, but just an initial report for gcc-12. (I
> > know v5.15.y still does not build completely with gcc-12).
> >
> > x86_64 and arm64 allmodconfig build fails with gcc-12, with the error:
> >

<snip>

> >
> > Introduced in v5.15.61 due to 2711bedab26c ("Bluetooth: L2CAP: Fix
> > l2cap_global_chan_by_psm regression").
> > But v5.19.y and mainline does not show the build failure as they also
> > have 41b7a347bf14 ("powerpc: Book3S 64-bit outline-only KASAN
> > support").
>
> Ick, ok, what to do here?  I can't really backport 41b7a347bf14 to 5.15
> easily as it's huge and a new feature.  Any other ideas?

Yeah.
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=b840304fb46cdf7012722f456bce06f151b3e81b
will fix the it for mips and csky failure in mainline and v5.19.y. And
I just verified that it will fix for powerpc also in v5.15.y. So, we
just need to wait for now.


-- 
Regards
Sudip
