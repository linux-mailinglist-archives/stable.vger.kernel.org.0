Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870FA58A5CC
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 08:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbiHEGJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 02:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiHEGJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 02:09:12 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4115A153
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 23:09:11 -0700 (PDT)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 8E7AB3F136
        for <stable@vger.kernel.org>; Fri,  5 Aug 2022 06:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1659679749;
        bh=h/+KiAlEysn+dIys/0yezAvHiCHVxX/Jn+Rak91weDg=;
        h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
         Content-Type:MIME-Version;
        b=sgjevAvTf3f0nUotgLTdXIZGDDOGdb5M3bwPtr/GS+3JSeDlRjnp/SC0VsHLTbusw
         l6dUHRD8Lr1doTumw1PcxG3Wg/DkVip1dE9EgebNPa4OfqxwieJ9mvJ64Is/uz2TVu
         w7aRNIsl4G94QDay0kB7pvAXEnNgXgzGbAuxXQ1MLIkeRBLJQuD/RJ8QVNGVKKQp4/
         4YiqavxerY/FZnGt87tOGMKhLyPyphX2foYFJX8FCDrbYVAFcVUcKwZ1Z4Ze8J2w5+
         tCTbAg9gCw9/UQ/OUjWie1nBT8Qzua3RxPB1Dg9RoEuWLTwxWKg/XrDog33Jdi1y4k
         E3G9KUFLmCRDg==
Received: by mail-wm1-f72.google.com with SMTP id p2-20020a05600c1d8200b003a3262d9c51so3722105wms.6
        for <stable@vger.kernel.org>; Thu, 04 Aug 2022 23:09:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=h/+KiAlEysn+dIys/0yezAvHiCHVxX/Jn+Rak91weDg=;
        b=nT3xwvj1JtPiuKbJOMV5zCISgoT+JITRH7eMtYCssbXjprysWtDzdvGhEdWX9kxZ3t
         qIbdWvfoBK3tKSkCyw2h0cloObvMQS7wPL3eyPSeJbrWntcB6NmWrbIUqXe3iLb0l1Kf
         rGiN1J+cFmZoZ3u9UYcElV7VnsSazT2uIBl2QRJ03Dw3D4FDx5tug8jlw3ONYtGBXr3h
         TKbZ2V5EYxdS1OSrU9pTgqCRZx3m+b0tiwAa3sq6uUCrVoI43wLULQXe0rHenlLqe4YA
         L80gUz0IMoAUqTUOqSG37Uw/Q8ID0xTwT8yIzQoVBAdHLx5bdfincx6RfaAIMk2dyXE0
         OoEQ==
X-Gm-Message-State: ACgBeo3devOgsuGmJoLAQVbFKcZtrjhGTFA7TOEknmlpyFCEwLOIrzV4
        AS1Gu/jy6uH8H2KDVlnqQocJcCwDnnZopUrGQk4wftSMt55D427C7WmWZzrg/5SkDE59x2npOW4
        xSd2Z0aq+jhAliV+LPK/I+v6VMUPPVbMEWQ==
X-Received: by 2002:a05:6000:1a4e:b0:220:5e43:9843 with SMTP id t14-20020a0560001a4e00b002205e439843mr3141041wry.566.1659679749154;
        Thu, 04 Aug 2022 23:09:09 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5yn2gCyHZ12bIPwXIJUkSnmQsfGprwK5jKgRgYQSHp7TFzWSUN40h955r/TzdIaaAXpY4Slw==
X-Received: by 2002:a05:6000:1a4e:b0:220:5e43:9843 with SMTP id t14-20020a0560001a4e00b002205e439843mr3141028wry.566.1659679748916;
        Thu, 04 Aug 2022 23:09:08 -0700 (PDT)
Received: from [192.168.1.28] ([176.217.6.172])
        by smtp.gmail.com with ESMTPSA id c5-20020a05600c0a4500b003a305c0ab06sm9980921wmq.31.2022.08.04.23.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 23:09:08 -0700 (PDT)
Message-ID: <602ce75b5b6dba51bc24cace86c1ada27fb6b0e9.camel@canonical.com>
Subject: Re: [PATCH stable 4.14 v3 2/3] fbcon: Prevent that screen size is
 smaller than font size
From:   Cengiz Can <cengiz.can@canonical.com>
To:     Chen Jun <chenjun102@huawei.com>, stable@vger.kernel.org,
        deller@gmx.de, geert@linux-m68k.org, b.zolnierkie@samsung.com,
        gregkh@linuxfoundation.org
Cc:     xuqiang36@huawei.com
Date:   Fri, 05 Aug 2022 09:09:06 +0300
In-Reply-To: <20220804122734.121201-3-chenjun102@huawei.com>
References: <20220804122734.121201-1-chenjun102@huawei.com>
         <20220804122734.121201-3-chenjun102@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-08-04 at 12:27 +0000, Chen Jun wrote:
> From: Helge Deller <deller@gmx.de>
>=20
> commit e64242caef18b4a5840b0e7a9bff37abd4f4f933 upstream
>=20
> We need to prevent that users configure a screen size which is smaller th=
an the
> currently selected font size. Otherwise rendering chars on the screen wil=
l
> access memory outside the graphics memory region.
>=20
> This patch adds a new function fbcon_modechange_possible() which
> implements this check and which later may be extended with other checks
> if necessary.  The new function is called from the FBIOPUT_VSCREENINFO
> ioctl handler in fbmem.c, which will return -EINVAL if userspace asked
> for a too small screen size.
>=20
> Signed-off-by: Helge Deller <deller@gmx.de>
> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
> [Chen Jun: adjust context]
> Signed-off-by: Chen Jun <chenjun102@huawei.com>
> ---
>  drivers/video/fbdev/core/fbcon.c | 28 ++++++++++++++++++++++++++++
>  drivers/video/fbdev/core/fbmem.c | 10 +++++++---
>  include/linux/fbcon.h            |  4 ++++
>  3 files changed, 39 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/=
fbcon.c
> index a97e94b1c84f..b84264e98929 100644
> --- a/drivers/video/fbdev/core/fbcon.c
> +++ b/drivers/video/fbdev/core/fbcon.c
> @@ -2706,6 +2706,34 @@ static void fbcon_set_all_vcs(struct fb_info *info=
)
>  		fbcon_modechanged(info);
>  }
> =20
> +/* let fbcon check if it supports a new screen resolution */
> +int fbcon_modechange_possible(struct fb_info *info, struct fb_var_screen=
info *var)
> +{
> +	struct fbcon_ops *ops =3D info->fbcon_par;
> +	struct vc_data *vc;
> +	unsigned int i;
> +
> +	WARN_CONSOLE_UNLOCKED();
> +
> +	if (!ops)
> +		return 0;
> +
> +	/* prevent setting a screen size which is smaller than font size */
> +	for (i =3D first_fb_vc; i <=3D last_fb_vc; i++) {
> +		vc =3D vc_cons[i].d;
> +		if (!vc || vc->vc_mode !=3D KD_TEXT ||
> +			   registered_fb[con2fb_map[i]] !=3D info)
> +			continue;
> +
> +		if (vc->vc_font.width  > FBCON_SWAP(var->rotate, var->xres, var->yres)=
 ||
> +		    vc->vc_font.height > FBCON_SWAP(var->rotate, var->yres, var->xres)=
)
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fbcon_modechange_possible);
> +
>  static int fbcon_mode_deleted(struct fb_info *info,
>  			      struct fb_videomode *mode)
>  {
> diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/=
fbmem.c
> index 9087d467cc46..264e8ca5efa7 100644
> --- a/drivers/video/fbdev/core/fbmem.c
> +++ b/drivers/video/fbdev/core/fbmem.c
> @@ -1134,9 +1134,13 @@ static long do_fb_ioctl(struct fb_info *info, unsi=
gned int cmd,
>  			console_unlock();
>  			return -ENODEV;
>  		}
> -		info->flags |=3D FBINFO_MISC_USEREVENT;
> -		ret =3D fb_set_var(info, &var);
> -		info->flags &=3D ~FBINFO_MISC_USEREVENT;
> +		ret =3D fbcon_modechange_possible(info, &var);
> +		if (!ret) {
> +			info->flags |=3D FBINFO_MISC_USEREVENT;
> +			ret =3D fb_set_var(info, &var);
> +			info->flags &=3D ~FBINFO_MISC_USEREVENT;
> +		}
> +		lock_fb_info(info);
>  		unlock_fb_info(info);

Why do we lock and unlock here consecutively?

Can it be a leftover?

Because in upstream commit, lock encapsulates `fb_set_var`,
`fbcon_modechange_possible` and `fbcon_update_vcs` calls, which makes
sense.

Here, it doesn't.

>  		console_unlock();
>  		if (!ret && copy_to_user(argp, &var, sizeof(var)))
> diff --git a/include/linux/fbcon.h b/include/linux/fbcon.h
> index f68a7db14165..39939d55c834 100644
> --- a/include/linux/fbcon.h
> +++ b/include/linux/fbcon.h
> @@ -4,9 +4,13 @@
>  #ifdef CONFIG_FRAMEBUFFER_CONSOLE
>  void __init fb_console_init(void);
>  void __exit fb_console_exit(void);
> +int  fbcon_modechange_possible(struct fb_info *info,
> +			       struct fb_var_screeninfo *var);
>  #else
>  static inline void fb_console_init(void) {}
>  static inline void fb_console_exit(void) {}
> +static inline int  fbcon_modechange_possible(struct fb_info *info,
> +				struct fb_var_screeninfo *var) { return 0; }
>  #endif
> =20
>  #endif /* _LINUX_FBCON_H */

