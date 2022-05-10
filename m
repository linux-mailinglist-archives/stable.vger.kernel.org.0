Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46126522591
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 22:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiEJUfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 16:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiEJUfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 16:35:00 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C06E166898;
        Tue, 10 May 2022 13:34:59 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2fb965b34easo693977b3.1;
        Tue, 10 May 2022 13:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mOqaTjkCFCgM5f1lVX6xovUQRBRtPNlk9IhOikeuQsU=;
        b=e6Qj1JXV1RcOtmCFTlKdcpj8Zodefpq/nyiOWt8wTkWgF5SOxB71c47flNRRwLvibw
         gLegr683+PLeeR/wm1o6QcaaCCmwk5Z1LQ8U+ZMAXx9VuddJ2WH4cMXa7Ds46WRXfwia
         ycFnXZnxh01/ZdxxO5l/prRV5d2vA9iCynslpQixgPNaElSrwdVHE7foCEJOGSXNz2TN
         4cBKg6qMce29ASHzF9L37tCJPMsm+wGxM8DJqiDNOPXKvYzJa+8KAxQofqgklV0hlTnz
         OI31hpSwTLtV8S6or51Q0CvlAopFHDbA9qq/UN//1C8T3l+33+BV2t7S+WqO94bnv6B9
         ErWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mOqaTjkCFCgM5f1lVX6xovUQRBRtPNlk9IhOikeuQsU=;
        b=6QgVHfOBpZB9cnOlSDit+dTueXYOjW+PYbl1a0L+ZDSCAgLmJEKxpE2pmZ7gr0qHjz
         TDmAsEQTAwO0/FTF0A5+ZdEcMCcA+1P74FW3fbJTwu/Vs38tMnX19iSDFsRheikIanzR
         aae1DckCmfeSZ3t0ixupjB+ySOdoohHqBtEKRDGfARdvgL+FVpTl5kMs9LGHGtK7CyDU
         kZuCll+HAqwm43c+dVB3E+eU2hMNF0y8bulQzW2kromGdUIXsaR9FQvJN0UHR3e1xMPN
         7z1XpH6N7ryMUHFQ+nAi1ftZo/WHcaL7pRI1og25Yiv266VZEi0bE9vkSKjNkl/0APdS
         wxrQ==
X-Gm-Message-State: AOAM530ynckeutcyQBbzxUEUHc14K0VD9CvTPvjiiTM9j8QSUnK0JxXb
        zBNMfhJcTfraW+H38dpvprWkCRLXkcmadFi6nFo=
X-Google-Smtp-Source: ABdhPJxLli407szPqhh4GzJpHiOoYmJ6y/3dUelcbAu8IjmlU1gPxx1E561uKHvq/mCxCVbx+FQbRIf6D5B6B98NjA4=
X-Received: by 2002:a81:2006:0:b0:2f8:1e04:5e56 with SMTP id
 g6-20020a812006000000b002f81e045e56mr21996707ywg.39.1652214897574; Tue, 10
 May 2022 13:34:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220510130733.735278074@linuxfoundation.org>
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 10 May 2022 21:34:21 +0100
Message-ID: <CADVatmOK41UB0dNQim7h5LwL3DaG4RWQ8zMge9WKn18c_jJa=w@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/88] 4.19.242-rc1 review
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

Hi Greg,

On Tue, May 10, 2022 at 2:18 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.242 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.

Just some initial report for you,

I just moved to gcc-12 and many mips builds are failing with errors like:
arch/mips/lantiq/prom.c: In function 'plat_mem_setup':
arch/mips/lantiq/prom.c:82:30: error: comparison between two arrays
[-Werror=array-compare]
   82 |         else if (__dtb_start != __dtb_end)

It will need d422c6c0644b ("MIPS: Use address-of operator on section
symbols")  for all branches upto v5.10-stable.


-- 
Regards
Sudip
