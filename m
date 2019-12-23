Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEA11296B6
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 15:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfLWOAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 09:00:23 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40779 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfLWOAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 09:00:23 -0500
Received: by mail-io1-f66.google.com with SMTP id x1so16222735iop.7;
        Mon, 23 Dec 2019 06:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OFxMEwkfjVDC+roxVZgSMk80KpDttjYT+pCn9s4WeAQ=;
        b=h2lDY9R8ghEfdafvt7lgQO0ZE8x2YMbw0d7+Z/BtuD1hKFVUJuybKhmfvmtAM/TB5M
         a4jqmvyY5cQgIm7oZEWO3dIsgpSWstkvQlYUWbokJgx7kzRVvhaaYDLSm3pwL/MEO2ly
         61JMGvrYku5h8Gsgaoh1/C+Kmz6rlTOIAggxV/JDIPLhdxSW4qlVF7Hg61Bf56j5tsgK
         uf1jQ2wxnUhiWiEutsQsRmogjX2xwawCuVtCka9ZW1o/X/wYeUwMkrK+M8RApO6PJ4LU
         u6Oipxwl0RME3YoYqhto8smEuF5+X+mG9crkfKGmMJN/fHvdFQNkh60aKqoBFU4cNock
         uS8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OFxMEwkfjVDC+roxVZgSMk80KpDttjYT+pCn9s4WeAQ=;
        b=WGIa25qNYowMPRzpCCxHrScKasZAcBBnnIzWJYzVQWFpy8EHMKLXenhl2VzOsaJm3W
         qFIt+hwZZJxbEqFLTmWoXHaG+sLGCB96wj6uJcGA7fS1QYMablJx2y1L0Rsmcl2gpgoL
         mB6ILiJJD2N5qR6WPiQVWA9qN/Fm9h3vbvrRuvqbC9yDLV0WjQbfTVOicFxHW7E/Z1qe
         vLQkfIEio020b8Sx+eo9uZfKb0AZ5spm4fp9puQ2P8MharcLRTekhkTOlPTwBLEvF+5h
         LY0aXOsyTDENeCj2dNzSEHJimXs6xnIoup8I1wVQA8cy8m9y73pdTAR+8rB5QhRtVwpl
         6cXw==
X-Gm-Message-State: APjAAAXMSWiEoxY+I6nru1OwCut5mqx0QoJxBuhFEOsN2D6mbzFAZQnv
        8bDFicOrX3W2FGScbC6GAblYuqCZvcFNCw+Wt8Y+88Px
X-Google-Smtp-Source: APXvYqwmTB1oVJxXgF8yMmyaeU3BCiL7+q8HErDzR5EA/WvDWbMk12ae12kb02VCvlQ93ycZujvPTBFMHZjwPOCSyRI=
X-Received: by 2002:a02:a38a:: with SMTP id y10mr23491227jak.55.1577109621904;
 Mon, 23 Dec 2019 06:00:21 -0800 (PST)
MIME-Version: 1.0
References: <lsq.1576543534.33060804@decadent.org.uk> <lsq.1576543535.242452079@decadent.org.uk>
In-Reply-To: <lsq.1576543535.242452079@decadent.org.uk>
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 23 Dec 2019 08:00:11 -0600
Message-ID: <CAHCN7xKJE1_pNn_psm4zsLWp==55v6u+N7GoJwOWOKd9=AG6mA@mail.gmail.com>
Subject: Re: [PATCH 3.16 013/136] drm/omap: fix max fclk divider for omap36xx
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Jyri Sarha <jsarha@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 6:51 PM Ben Hutchings <ben@decadent.org.uk> wrote:
>
> 3.16.80-rc1 review patch.  If anyone has any objections, please let me know.
>
> ------------------

I tried to do the same for 4.4, 4.9 and 4.14, but I haven't seen
anything applied yet.

I just looked at the upstream fbdev driver for the dss, and it's still
showing 32 and the value.

Even though the fbdev driver isn't enabled by default any more, I
wonder if it should be fixed as part of the justification for the
backports.

adam
>
> From: Tomi Valkeinen <tomi.valkeinen@ti.com>
>
> commit e2c4ed148cf3ec8669a1d90dc66966028e5fad70 upstream.
>
> The OMAP36xx and AM/DM37x TRMs say that the maximum divider for DSS fclk
> (in CM_CLKSEL_DSS) is 32. Experimentation shows that this is not
> correct, and using divider of 32 breaks DSS with a flood or underflows
> and sync losts. Dividers up to 31 seem to work fine.
>
> There is another patch to the DT files to limit the divider correctly,
> but as the DSS driver also needs to know the maximum divider to be able
> to iteratively find good rates, we also need to do the fix in the DSS
> driver.
>
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Adam Ford <aford173@gmail.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20191002122542.8449-1-tomi.valkeinen@ti.com
> Tested-by: Adam Ford <aford173@gmail.com>
> Reviewed-by: Jyri Sarha <jsarha@ti.com>
> [bwh: Backported to 3.16: adjust filename, context]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/video/fbdev/omap2/dss/dss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/video/fbdev/omap2/dss/dss.c
> +++ b/drivers/video/fbdev/omap2/dss/dss.c
> @@ -708,7 +708,7 @@ static const struct dss_features omap34x
>  };
>
>  static const struct dss_features omap3630_dss_feats __initconst = {
> -       .fck_div_max            =       32,
> +       .fck_div_max            =       31,
>         .dss_fck_multiplier     =       1,
>         .parent_clk_name        =       "dpll4_ck",
>         .dpi_select_source      =       &dss_dpi_select_source_omap2_omap3,
>
