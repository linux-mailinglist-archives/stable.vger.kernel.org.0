Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BB7287A6F
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 18:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgJHQ7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 12:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729585AbgJHQ7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 12:59:38 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0643C0613D2
        for <stable@vger.kernel.org>; Thu,  8 Oct 2020 09:59:37 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id 13so3395409qvc.9
        for <stable@vger.kernel.org>; Thu, 08 Oct 2020 09:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NDfxYtvvuUlHPjp/UryiR3z82AL5IMXxGc4N8yJFAH8=;
        b=dYafy2qhKL78nC90MkoOQZOk+KZv8xX0vL3ui37u6gtvf/zKI9wulZSzgWi5ji1GmY
         a7nobnXmZfuwHwETk+vS6on4VEdCUGVIznSBIZaHzxEg1TMkIwWGLzSgXG/zNk20pzfg
         KZ6lrabGTTvEEj9X7Im975xG+yrv1otXkZUksk86V5haQO4VonW0O6Jzn+0jI5eeInsc
         /k+I2eAUAV8nlm8RqMIN/E3WAn+v7VeeQ39IqSqxgZSVZqANarF2Cff4HywSepe7kdSb
         FlxjAHkdXTB/8cDp7azuueiu++naSRfNeqozHMwVfRxkBcPXTr4CT/LfPVtHTamMwnhM
         K+dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NDfxYtvvuUlHPjp/UryiR3z82AL5IMXxGc4N8yJFAH8=;
        b=lbbmSrexVTwwHd7ZcYprWGB4TW03nEqkmPp8TI4Gq39ntl2q++z+uEqKzjAEoQ07Ur
         eq4G43xEc0wmB/hWtNzX//ZCuJMRL7ttTcNJ2hbLgvxlViQg48P0jcI6ZBcTP10xsjFr
         famrIzKVH3ucxy2r+bz7DrTBNs0DK9a5/SdQGi6BbNtnjxw6KEqUkZIb5EdtVvUkdpd+
         cHXSJ8lnwo648Vhxz/kl3mSCORxGK1eu/PQeChrINgCT2xn5DH6lsUrNPFF4WXVAhPkY
         KmpJFgUk1PoUXXwmSLzFvxey/3u5+R9V7PUAJmLoyHYC56B3FhY1JpYVA5SaGrN0aCaa
         E/+Q==
X-Gm-Message-State: AOAM5313saTLVZP5ioKlfS0PyhuSXGwQkVycNdL5AHyYqlUj4iBqnmhf
        kB/w4M17gXUcPWyqoNOZ+Yw9VRab8hmfsARzinWydQ==
X-Google-Smtp-Source: ABdhPJxVvJE8adLq7/QRWgtibNwolccI0QK0yhgp6S5zvzns9wUWgUouwgUdqK3UIR09BIuRSUwe7A4Fwb4/xzdvMxw=
X-Received: by 2002:a0c:e5cf:: with SMTP id u15mr9219809qvm.14.1602176377192;
 Thu, 08 Oct 2020 09:59:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <160197822988.7002.13716982099938468868.tip-bot2@tip-bot2>
 <20201007111447.GA23257@zn.tnic> <20201007164536.GJ5607@zn.tnic>
 <20201007170305.GK5607@zn.tnic> <CAPcyv4jgLRzDzXkbdHwA-XUwWuSoA1tZfVqgvFQ5jxq=m2P_Bg@mail.gmail.com>
 <20201007192528.GL5607@zn.tnic>
In-Reply-To: <20201007192528.GL5607@zn.tnic>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 8 Oct 2020 09:59:26 -0700
Message-ID: <CAPcyv4j=EfGKO6nNBggQunxmkOQqxAMX1M5kQDr68uU+ZQnRLA@mail.gmail.com>
Subject: Re: [tip: ras/core] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-tip-commits@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        stable <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 7, 2020 at 12:54 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Oct 07, 2020 at 11:53:15AM -0700, Dan Williams wrote:
> > Oh nice! I just sent a patch [1] to fix this up as well,
>
> Yeah, for some reason it took you a while to see it - wondering if your
> mail servers are slow again.
>
> > but mine goes
> > after minimizing when it is exported, I think perhaps both are needed.
> >
> > http://lore.kernel.org/r/160209507277.2768223.9933672492157583642.stgit@dwillia2-desk3.amr.corp.intel.com
>
> Looks like it.
>
> Why not rip out COPY_MC_TEST altogether though? Or you wanna do that
> after the merge window?
>
> It would be good to not have that export in 5.10 final if it is not
> really needed.

I'll draft a patch to rip it out. If you have a chance to grab it
before the merge window, great, if not I can funnel it through
nvdimm.git since the bulk of it will be touching
tools/testing/nvdimm/.
