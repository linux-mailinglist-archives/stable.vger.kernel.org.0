Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972754BED32
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 23:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbiBUW2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 17:28:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbiBUW2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 17:28:41 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D6E60FE
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 14:28:17 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m22so2617725pja.0
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 14:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IqM/HrrqcPXMco+mNKrHeafOPSrFfqA+ju2cxF4/AhY=;
        b=L+rylveWfTX+QVfP2e0y6fLhK5NWrEMj2VsqkZNMa1h+B+00b9b/m4OtsxVgGD55W3
         JtrqDMhFZS4uqP/87jlicQGr7AKHg1WJ/Hs1xKHzbcKjkmuUUwVartNmtRr+TygPA+YF
         6DDFf3l5ORC/FZ/YkbpBMpDZ5WlGHs0idolIB7KFt/3zBIkcVfvEdOHuUlcKSTzs98UQ
         aeDWCea8NBvsY3Jp+FcqiJROFr3V7rlvhbBmL4pr0wvzeNIYuceqbNiqtEvW6PqleaV9
         IOgwODdV9XHsBMJbLcEvfz6gq/PL7NWf2YNnAQewFkTolFIIZPOteY4TCOK9993gBrxI
         Yaxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IqM/HrrqcPXMco+mNKrHeafOPSrFfqA+ju2cxF4/AhY=;
        b=h/9WlQWrsz/ayDfA40ii37w6/hwc1WPyRcK23wmyzyPPpOV4wWLbPd8J3x1Qp6Xv+i
         XOEriRMsMVcHN2j/qbgY1niiFNzDtF6kHFkChXOALUlXQkx341M22jrb43v6MAydecQc
         pVQXShV/3PPj9O/toiiav93BLehKK09iWa+xJCYeWg4DV9qsV7aBVgmtOPEpOqYLwmlb
         gcj7lJkNNL7Y8gT3lWQR65xYOlrGxVzbXlnWoq2pIiErIcXhZQWIvwybQpNvjZBZ6pMV
         DGCjLHErAy92Xt20yLqvia1ZnpIbzDSwnYLY+u5mgiNRfu2kFI3/uG+L3CxHKhD1Bi7p
         Wdmg==
X-Gm-Message-State: AOAM532G46ITuH4/99AtfStWm6bqsXLXMV0wBkyxqMIO4Vvk/Qmz74mL
        O3t77GaZ1cpo6RaPGDOTSi7/4ZKk+nqjenVl6v7l7g==
X-Google-Smtp-Source: ABdhPJz9OseVJlVg6tugK8F0kM3rwRT6ZJeilyKTouVlRha152nIHraupw15DKJdmwxB0fZ6WpUkBkmk4aV5pnHDhWU=
X-Received: by 2002:a17:903:228a:b0:14d:aa04:2278 with SMTP id
 b10-20020a170903228a00b0014daa042278mr20906077plh.58.1645482496637; Mon, 21
 Feb 2022 14:28:16 -0800 (PST)
MIME-Version: 1.0
References: <20220221084930.872957717@linuxfoundation.org> <d72c8af1-e93d-44ae-15e0-737302523961@roeck-us.net>
 <YhPTIFmCxjnELRyP@kroah.com>
In-Reply-To: <YhPTIFmCxjnELRyP@kroah.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Mon, 21 Feb 2022 23:28:05 +0100
Message-ID: <CAHUa44HS3idJFRuG47NCJaQEQ_OYpp3kpaUcabqjayrkZXVLnQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/196] 5.15.25-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 7:00 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Feb 21, 2022 at 09:15:52AM -0800, Guenter Roeck wrote:
> > On 2/21/22 00:47, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.25 release.
> > > There are 196 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> > > Anything received after that time might be too late.
> > >
> >
> >
> > Building arm:allmodconfig ... failed
> > Building arm64:allmodconfig ... failed
> > --------------
> > Error log:
> > drivers/tee/optee/core.c: In function 'optee_probe':
> > drivers/tee/optee/core.c:726:20: error: operation on 'rc' may be undefined
>
>
> Jens, did you build the 5.15 patch you sent?

I did, but it seems I wasn't paying close enough attention to warnings.

>
> This line looks a bit odd:
>
> +               rc = rc = PTR_ERR(ctx);
>
> And given that rc is an int, that is not guaranteed to hold a pointer
> here :(

I'm sorry it looks like I've slipped on the keyboard. There is one "rc
= " too many.
I believe the assignment "rc = PTR_ERR(ctx)" is correct when
IS_ERR(ctx) is true. If I'm wrong I have a bigger problem.

I'll send a v2 to fix this. I see that I've copied the error to
backports for 5.10, 5.4 too so I'll send v2s for those too.

Thanks,
Jens

>
> thanks,
>
> greg k-h
