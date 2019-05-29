Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827572DC73
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 14:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfE2MLZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 May 2019 08:11:25 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35211 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfE2MLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 08:11:25 -0400
Received: by mail-yw1-f65.google.com with SMTP id k128so965812ywf.2;
        Wed, 29 May 2019 05:11:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/zS8XSc0Bsf4p5JdX2AukLz21gZj8Rsl14Xpu86zwzQ=;
        b=Djzfw9PKcOY8Xy8SnkvHFtWEVV9rjaSx+1KyqpsP1IAcEGlLa+rneMRECAYBeiNgPk
         b7OugE4f94giD+i1/1BdTt16VwbOX19xJwNzk5uwYld+L1ob8t2QI7oKQ4QpLpH6DTaE
         CAMZkWslQt5jnMjmkhtzkpIcCc1PjDvY4HD8yCEZ74qW6opzWAQu6+kmGHonQWYPr9gK
         7eCbKrB7g9GESuNrYjaqmrrUu1T51c/mDzCLjWHI9T55IKu/mfevhu5F7XQ0b5pIqD4J
         /CcmxQRZSHUPmiiW3NoozM1Afxa5RvJg7vkkD1z2TK5Y1ejcu7XVjkWREIunQbAYae+8
         7/0A==
X-Gm-Message-State: APjAAAVh5EuricLbb/P2Ziz1ot6nCF1Nu0bzr5r8X2ggDuHC7ThJyrCY
        9rvh+50kcleRdQo9fVzwpiTx9wQgbrBM5WSGot8=
X-Google-Smtp-Source: APXvYqw7ui8pB/5/mM+JgtNyKXm29XoHNv/MZgfK7quZ8QKtq5yeCKtOUeUahTciiBEiSO6rVWgjuNGM5uZz5/+TFGI=
X-Received: by 2002:a81:7d86:: with SMTP id y128mr6708928ywc.443.1559131883550;
 Wed, 29 May 2019 05:11:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190528172111.3843-1-paul.burton@mips.com>
In-Reply-To: <20190528172111.3843-1-paul.burton@mips.com>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe@mathieu-daude.net>
Date:   Wed, 29 May 2019 14:11:12 +0200
Message-ID: <CAAdtpL5cPFudBw6gD7+aFscFY6hAAuGW_e5_LAtuGFJepEGwhg@mail.gmail.com>
Subject: Re: [PATCH] MIPS: pistachio: Build uImage.gz by default
To:     Paul Burton <paul.burton@mips.com>
Cc:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Paul Burton <pburton@wavecomp.com>,
        Kevin Hilman <khilman@baylibre.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 28, 2019 at 7:34 PM Paul Burton <paul.burton@mips.com> wrote:
>
> The pistachio platform uses the U-Boot bootloader & generally boots a
> kernel in the uImage format. As such it's useful to build one when
> building the kernel, but to do so currently requires the user to
> manually specify a uImage target on the make command line.
>
> Make uImage.gz the pistachio platform's default build target, so that
> the default is to build a kernel image that we can actually boot on a
> board such as the MIPS Creator Ci40.
>
> Marked for stable backport as far as v4.1 where pistachio support was
> introduced. This is primarily useful for CI systems such as kernelci.org
> which will benefit from us building a suitable image which can then be
> booted as part of automated testing, extending our test coverage to the
> affected stable branches.
>
> Signed-off-by: Paul Burton <paul.burton@mips.com>
> Reviewed-by: Kevin Hilman <khilman@baylibre.com>
> Tested-by: Kevin Hilman <khilman@baylibre.com>

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>

> URL: https://groups.io/g/kernelci/message/388
> Cc: stable@vger.kernel.org # v4.1+
> ---
>
>  arch/mips/pistachio/Platform | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/mips/pistachio/Platform b/arch/mips/pistachio/Platform
> index d80cd612df1f..c3592b374ad2 100644
> --- a/arch/mips/pistachio/Platform
> +++ b/arch/mips/pistachio/Platform
> @@ -6,3 +6,4 @@ cflags-$(CONFIG_MACH_PISTACHIO)         +=                              \
>                 -I$(srctree)/arch/mips/include/asm/mach-pistachio
>  load-$(CONFIG_MACH_PISTACHIO)          += 0xffffffff80400000
>  zload-$(CONFIG_MACH_PISTACHIO)         += 0xffffffff81000000
> +all-$(CONFIG_MACH_PISTACHIO)           := uImage.gz
> --
> 2.21.0
>
