Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753BB1FC85E
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 10:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgFQIRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 04:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgFQIRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 04:17:21 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6199CC061573;
        Wed, 17 Jun 2020 01:17:20 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y5so1701340iob.12;
        Wed, 17 Jun 2020 01:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PsTw2FmNStfH4y60NRLUawfmwCoZcfnTxnkA/RcGv3Y=;
        b=lRLAR04rQ53JYXf3cpvtIjqVvXpGVVnKsjsI9/kJp3saObwCu4DTe89t7Bd29cACQg
         NooYTkYf/qZvQmat3GV9UUudiHHrhtEP8yQkSX14b0vVyMpYJdqVNax15SM64cNXR/iA
         HfRle2f3uSUogyxnEYXMTrTKwB9Ymk9IXyka0UqmRGHvOxxbniXfcpa6QoexUc8IdGL+
         5CvrjWs8sTXPAirblhLAySefibkvNKChxbMkPWQ+SPtMxFC2dwyM7eSPHiLxDWEkFkul
         BsMWP19Vn/qjxlEKo7SxOMW4ahSd94ydXizylzL7fUTsfIOioGVZpOQ9WURmoV2Gq6EN
         SZdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PsTw2FmNStfH4y60NRLUawfmwCoZcfnTxnkA/RcGv3Y=;
        b=eTqLuOYxrrtDp61bP8eeVdzYoYuq3a+GUXBniaeBWktGKSdpfBnAeIJwHE9bnlowYj
         mui79Cp1XGNZQYeKR1ZOVQoDHDIVZIquGB/reIEeTv76JRQK1dQpOxyKl5jFJkNI5VRw
         +Y9S5y97qURBz4RiaIPGRPAtdQa3OVRDxijopklKXyL9SpWJgKCajL3SilogWvhUptsz
         9bxnJjybvGh8oJtjQtvEeAHFnh18mVzcvRXw7lbSJwfDaXM2WzxTJnUAAqloXi/3XREP
         bnB/duy1AfHs48rj+BM2eYwvZkFXziVRyRf6ULlDwKxxs4cEZOlVUVonYdilsD/5jPC/
         HPfQ==
X-Gm-Message-State: AOAM532Jj6h/K9PCo3ufpOQJzefziTvMMiQBGPfzc0zZ38yv0oOoj9zp
        pX+zQMcXg2bHeaYBbwvO66dzwgBvCZFXaw3w9uX8CUj1Eb8=
X-Google-Smtp-Source: ABdhPJyUB0qrHEjmlOPPDD1pUhS9xxVKwZ+hljmmvTC1+D0nLw84O0Yh0oOdSy+SqKZZIuKkk49y1vDlBej1UH5Si/o=
X-Received: by 2002:a05:6602:34f:: with SMTP id w15mr7111702iou.2.1592381839097;
 Wed, 17 Jun 2020 01:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200525025049.3400-1-b-liu@ti.com> <20200525025049.3400-5-b-liu@ti.com>
In-Reply-To: <20200525025049.3400-5-b-liu@ti.com>
From:   Macpaul Lin <macpaul@gmail.com>
Date:   Wed, 17 Jun 2020 16:17:07 +0800
Message-ID: <CACCg+XNfOaE7LE01NPeR6amvCTyrJaJ3sj3AF+Se49T0YFy_Uw@mail.gmail.com>
Subject: Re: [PATCH 4/6] usb: musb: mediatek: add reset FADDR to zero in reset
 interrupt handle
To:     Bin Liu <b-liu@ti.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bin Liu <b-liu@ti.com> =E6=96=BC 2020=E5=B9=B45=E6=9C=8825=E6=97=A5 =E9=80=
=B1=E4=B8=80 =E4=B8=8A=E5=8D=8810:53=E5=AF=AB=E9=81=93=EF=BC=9A
>
> From: Macpaul Lin <macpaul.lin@mediatek.com>
>
> When receiving reset interrupt, FADDR need to be reset to zero in
> peripheral mode. Otherwise ep0 cannot do enumeration when re-plugging USB
> cable.
>
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Acked-by: Min Guo <min.guo@mediatek.com>
> Signed-off-by: Bin Liu <b-liu@ti.com>
> ---
>  drivers/usb/musb/mediatek.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/usb/musb/mediatek.c b/drivers/usb/musb/mediatek.c
> index 6196b0e8d77d..eebeadd26946 100644
> --- a/drivers/usb/musb/mediatek.c
> +++ b/drivers/usb/musb/mediatek.c
> @@ -208,6 +208,12 @@ static irqreturn_t generic_interrupt(int irq, void *=
__hci)
>         musb->int_rx =3D musb_clearw(musb->mregs, MUSB_INTRRX);
>         musb->int_tx =3D musb_clearw(musb->mregs, MUSB_INTRTX);
>
> +       if ((musb->int_usb & MUSB_INTR_RESET) && !is_host_active(musb)) {
> +               /* ep0 FADDR must be 0 when (re)entering peripheral mode =
*/
> +               musb_ep_select(musb->mregs, 0);
> +               musb_writeb(musb->mregs, MUSB_FADDR, 0);
> +       }
> +
>         if (musb->int_usb || musb->int_tx || musb->int_rx)
>                 retval =3D musb_interrupt(musb);
>
> --
> 2.17.1
>
Could this bug fix also been applied to stable kernel?
Thanks!

Best regards,
Macpaul Lin
