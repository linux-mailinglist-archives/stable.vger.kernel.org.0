Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CA629DF61
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 02:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403893AbgJ2BBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 21:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731532AbgJ1WR1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:27 -0400
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C58F6246A6;
        Wed, 28 Oct 2020 09:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603879030;
        bh=hCvFhlXRZP8QcFZMywnwAGeTuLKw+VShX5l+WcmL3oI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=okFfVnztN8gNMlNO/ZprsZw3qs52+ZR/00d9QoHpQJsNvdrNVqZ/nndqqMe8X3swW
         EoxudFpVnQdDs4fMV3RN8ZzY0E83nlRl4LCCYO56I8QbtqQPS6YisaGfl69PhWvxRd
         5UYEoQm2Uw8x/ShYFZXzhueZ5HgEH7O8xjgNisrA=
Received: by mail-ej1-f48.google.com with SMTP id s15so6298369ejf.8;
        Wed, 28 Oct 2020 02:57:09 -0700 (PDT)
X-Gm-Message-State: AOAM5302zJfv0RUaNlbOak4dejLxT1ztb8Pa/l8yEPZ9TV0mucgXftyG
        mgRgEzp+PWdDXoFMPyF0AjMsSIUeS13JQzA3Ay8=
X-Google-Smtp-Source: ABdhPJygjXByCdjhVHlhdVq8u/aNG3plYjxpvOMyvsUkqVxwF3rWdAOBBDnpi+MLEMgiduMT3nJgvTfbXpXCYYc8nCQ=
X-Received: by 2002:a17:907:43c0:: with SMTP id ok24mr6693694ejb.385.1603879028139;
 Wed, 28 Oct 2020 02:57:08 -0700 (PDT)
MIME-Version: 1.0
References: <20201028091947.93097-1-krzk@kernel.org> <MWHPR11MB0046B799E9AD3648C6F67BFE87170@MWHPR11MB0046.namprd11.prod.outlook.com>
 <CAJKOXPePfsRNZkY+L1XM3_iz6dMYFNZAJgrcut9JriuwYkKWsw@mail.gmail.com>
In-Reply-To: <CAJKOXPePfsRNZkY+L1XM3_iz6dMYFNZAJgrcut9JriuwYkKWsw@mail.gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Wed, 28 Oct 2020 10:56:55 +0100
X-Gmail-Original-Message-ID: <CAJKOXPf6zhpu_3oQZ2bL_FnkBx7-NwH65N_OzVkH=Nh1bYkHxw@mail.gmail.com>
Message-ID: <CAJKOXPf6zhpu_3oQZ2bL_FnkBx7-NwH65N_OzVkH=Nh1bYkHxw@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: imx258: correct mode to GBGB/RGRG
To:     "Yeh, Andy" <andy.yeh@intel.com>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Jason Chen <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 28 Oct 2020 at 10:45, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Wed, 28 Oct 2020 at 10:43, Yeh, Andy <andy.yeh@intel.com> wrote:
> >
> > But the sensor settings for the original submission is to output GRBG Bayer RAW.
> >
> > Regards, Andy
>
> No, not to my knowledge. There are no settings for color output
> because it is fixed to GBGB/RGRG. I was looking a lot into this driver
> (I have few other problems with it, already few other patches posted)
> and I could not find a setting for this in datasheet. If you know the
> setting for the other color - can you point me to it?

And except the datasheet which mentions the specific format, the
testing confirms it. With original color the pictures are pink/purple.
With proper color, the pictures are correct (with more green color as
expected for bayer).

Best regards,
Krzysztof
