Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6ED81AB64B
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 05:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbgDPDja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 23:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391128AbgDPDjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 23:39:25 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBED6C061A10
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 20:39:25 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id s202so12278173oih.3
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 20:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9IBVrWYphg4FNrmaSnWXQwZefAWMy+0If7LRq+m1YPg=;
        b=R0uYXTBL2TlSIdGoac98K6DhfD6bGK2K0TMoZ64axts0iJFfGxemmXgA8FGYdH7OL4
         +JsVFr9vfzALCbjESTO7FF2veOnzUOAnCZ8MPRjHQGUgnIk7fTt57OPPTHc5aimXRBrA
         XTYGatyJraabVhy8l4TnX9QswzKdP57HRq9EKy5yYfIDqzDdp7V6eFJWy9gTh08orY9e
         zMB/tbs392412+ix9v4QR05w7VTiMwu6Jq+TtMijzYrsyNoH0Ioe/7plMaETqYaVVM7z
         gfHObRCIY1mUAu/017Sf5ugcN1wtCamKlTetsZllLKZS+4w8Xycmu41jo31rBdAUxNko
         rR3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9IBVrWYphg4FNrmaSnWXQwZefAWMy+0If7LRq+m1YPg=;
        b=Kc8d+/dIsYTw/b75nkDsObeHLrSehg4cbwTSa1TiBJbizrIEo2Iq4k4N2E51waHuZO
         9/PxerHiqMqvmuvnSrAd7E9k8qVr/ENRD6G7LQGFFftgZgNeVdXX+Zpg4GxLWDuv0wcO
         EUP9CBYb+hj5oLhaWfeCW16Ls1VMeRLRmG1hpdgKy34Eb9HR2qv46pceSK4WyY/nWmb8
         Pbe1LCAqsl2DJMxMYXUOfmTM569ApeZq0VhgZtEZVkwoP6w88uHWn9x7rGBExA2584qn
         avidVuietTnj580lEI3hC1X8fDSqN8tZ6F0d9kdtd3FNjmHBExa7ydhEgTqGOiRoS7mO
         +PIQ==
X-Gm-Message-State: AGi0PuYTIw9TjFaXmOvG7SV92VQwvIRsdHJi/2Fh6GaFNF1yC+8hFl4s
        jH6Mk/+T/1u5mcolvorcJKs=
X-Google-Smtp-Source: APiQypIGzD/8x7Fm42lDMiYR8ViTicp8gqZBWdO7BBb/6e5hWteWNHz2QBg1Uzp7YL7h1PDE9sKo5w==
X-Received: by 2002:aca:5442:: with SMTP id i63mr1640614oib.134.1587008364999;
        Wed, 15 Apr 2020 20:39:24 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::3])
        by smtp.gmail.com with ESMTPSA id u17sm6733679oiv.21.2020.04.15.20.39.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Apr 2020 20:39:24 -0700 (PDT)
Date:   Wed, 15 Apr 2020 20:39:22 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@google.com>,
        kbuild test robot <lkp@intel.com>,
        cros-kernel-buildreports@googlegroups.com, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [chrome-os:chromeos-4.19 21350/21402]
 drivers/misc/echo/echo.c:384:27: error: equality comparison with extraneous
 parentheses
Message-ID: <20200416033922.GA19745@ubuntu-s3-xlarge-x86>
References: <202004150637.9F62YI28%lkp@intel.com>
 <20200415002618.GB19509@ubuntu-s3-xlarge-x86>
 <CABXOdTd-TSKR+x4ALQXAD9VGxd4sQCCVC9hzdGamyUr-ndBJ+w@mail.gmail.com>
 <CAKwvOdnOuMcjzsqTt2aVtoiKN3L9zOONGX-4BJgRWedeWspWTA@mail.gmail.com>
 <20200416033100.GH1068@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416033100.GH1068@sasha-vm>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 11:31:00PM -0400, Sasha Levin wrote:
> On Wed, Apr 15, 2020 at 10:51:37AM -0700, Nick Desaulniers wrote:
> > On Tue, Apr 14, 2020 at 5:56 PM 'Guenter Roeck' via Clang Built Linux
> > <clang-built-linux@googlegroups.com> wrote:
> > > 
> > > On Tue, Apr 14, 2020 at 5:26 PM Nathan Chancellor
> > > <natechancellor@gmail.com> wrote:
> > > >
> > > > Hi all,
> > > >
> > > > Sorry for yet another convergeance on this commit... :/ hopefully this
> > > > does not continue for much longer. None of the warnings are obviously
> > > > caused by the patch below.
> > > > Fixed by commit 85dc2c65e6c9 ("misc: echo: Remove unnecessary
> > > > parentheses and simplify check for zero").
> > > >
> > > No worries.
> > > 
> > > I noticed that the problems are pretty much all fixed in the upstream
> > > kernel. I just wasn't sure if it would be worthwhile sending a request
> > > to stable@ to have them applied to 4.19.y (and if necessary 5.4.y).
> > > Any suggestions ?
> > 
> > We should strive to be warning free on stable.  Thanks for identifying
> > the fix Nathan.
> > 
> > Greg, Sasha,
> > Would you please cherry pick 85dc2c65e6c9 to 4.19.y, 4.14.y, 4.9.y,
> > and 4.4.y (maybe 3.18, didn't check that one)? It applies cleanly and
> > is a trivial fix for a warning that landed in v4.20-rc1.
> 
> I'll grab it, but could we please look into disabling some clang
> warnings?
> 
> I understand warnings that might warn us about dangerous code, but this
> reads to me like something checkpatch might complain about...
> 
> -- 
> Thanks,
> Sasha

For what it's worth, I have fixed all of these (at least that I know of)
in mainline so there is no point in disabling it there. If you want to
disable it in stable, that's a different discussion. Another option
would be asking the 0day team not to run randconfig builds with clang on
stable trees. I'd prefer that over disabling the warning.

This warning wants to make sure that (a == b) and ((a = b)) do not get
mixed up, which seems worthwhile: https://godbolt.org/z/GUdL5X

Cheers,
Nathan
