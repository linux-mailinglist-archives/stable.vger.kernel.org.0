Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E32C339165
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 16:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhCLPez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 10:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbhCLPeh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 10:34:37 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C93C061574;
        Fri, 12 Mar 2021 07:34:37 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id b23so2087279pfo.8;
        Fri, 12 Mar 2021 07:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IMlB5WRb/6LYe66SQ3A66bzr1N8mWxVpXGv0FndsikQ=;
        b=muhrLMxp/uhE6jH7vYF+83nHcyO0KVTdqDJuVyASfzrwNi8lq1s/ZIOZHbyEsHQxJf
         k98hS/4nfRZR1u4xTbDadvAqekIrCuF8NXRqVwnCLuKka1Jej74JNdLDbIbmJXZPAg+P
         ck5EMD9D3uKVSFX4T6GdvDXcf8vL0I4l3vsyzf7TYD8glKZ1ABmX/4kl0DgdOeB/orNt
         xgpvFtaMYceWhE424xf3nLjH5cSc7yRFBy3oy3d/HUgf8M1QyiwzYJsctzESvcQCRocp
         NS9k3c2Z+EZ1rzGrTUxnuB3N1+CsdKRPvoOAL0PvfwLVP0RvMlCM9jNuTBupbGVEBZVx
         CjNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IMlB5WRb/6LYe66SQ3A66bzr1N8mWxVpXGv0FndsikQ=;
        b=IYM10SX29ZhsvaLeCqV/hadSxds82yL0b8wtpO3/3Wn8bs/Si1K7xkRXMC6tCniHJY
         REVDyKzYuttbl1MaKiirYyv6HGHkXTJOd26vicZfwWW7Jfazo3s8zABg5pXehcTrOQBB
         nsv3uCDxqHGwbmr2vJSjRjlqAgNqVGM2wX7N2nFFPe6zq1OWwqetjqSvYXnoNXZrAxXT
         NW9Xdy5xBZgXBwgHGOBG6OcXOFVmeb8lJL6/Hi4FPTq14ojxupb5RjEmLs9pBDKscr7b
         HPa22d7BicRkFd2qKG8hHrHSP8a/pZiCSV8KSYfIELCDnqzFu5MPdc9Cf8Iu3GgimnYG
         1Uww==
X-Gm-Message-State: AOAM532h55Tbio9QmAKsmuH8EniBi12/l3k/aRgFFCgjFHtTqnHg4ksq
        ZJI4+5mNJvH7Vwh2+hRkb7HNURON3mLuk00BQ/I=
X-Google-Smtp-Source: ABdhPJzjDWG88EO20WB2WDa3XuyhugX6rwbSGpAoIxt+2i+AgxXkbWt/XdIl3kTfrvHcZXJlVrZ4GrNx5PBhfweiv/E=
X-Received: by 2002:a62:528e:0:b029:1f5:c5ee:a487 with SMTP id
 g136-20020a62528e0000b02901f5c5eea487mr12812604pfb.7.1615563276638; Fri, 12
 Mar 2021 07:34:36 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvXBk8njCeodicbtc72LLwSGvODLqqBTjfEHthjvUH7AQ@mail.gmail.com>
 <YEtuo59GNHSGZ5eK@kroah.com>
In-Reply-To: <YEtuo59GNHSGZ5eK@kroah.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 12 Mar 2021 17:34:20 +0200
Message-ID: <CAHp75VcM-UtzxE84cD+fCYCNNgQZTSy7R5C9gRnR7TgaP6Tktg@mail.gmail.com>
Subject: Re: drivers/gpio/gpio-pca953x.c:117:40: error: 'ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER'
 undeclared here (not in a function)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 3:39 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Mar 12, 2021 at 06:57:51PM +0530, Naresh Kamboju wrote:
> > While building stable rc 5.4 for arm and arm64 the following warnings / errors
> > were noticed.

> Should now be fixed up, sorry about that.

Right, thank you, Greg, for fixing this mess up!

-- 
With Best Regards,
Andy Shevchenko
