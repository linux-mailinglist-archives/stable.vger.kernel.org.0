Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C33C7BF32
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 13:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfGaLXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 07:23:44 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37429 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfGaLXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 07:23:44 -0400
Received: by mail-wm1-f68.google.com with SMTP id f17so59443765wme.2;
        Wed, 31 Jul 2019 04:23:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Vvv54g/EpOR/8Ex2zJ0vIMb4LQOnfvh3/O79aWVpSA=;
        b=dZSCPGyZh4h+LEXgdKVBQyBT7Jg2HRVAk1ci7PWBecm9xGTbJVpwvlqdDusY+mawuO
         MhagmwSRXreDl0GX+Y+UdABPTLw8Ya+jI4JXwtz32ge4WK7gtQjEL6SCqZ4qEpUiOgOs
         vq88uh6+8XTl8D5HLXwX0t6U1sfmyUJBXro9qO20fhOI1+lMAyiH9ORZVMyc4SQrytVg
         PSMJpwqAQR7s8kHY1Z28yR29Sy8kc0w6shLlLUvvSkJ13+TGzgzGAeANuLSDnm8IaAVj
         YwQuAMDEiNRtJ0UNQiGWRx4HEAlBMssdR7o1SN1GkvKYzxSH58t1gFbEGJV/6aknF+ve
         Op8A==
X-Gm-Message-State: APjAAAWUz5TfzojPDtN3AUZAoBqXZ099m7oMqa9iT8YwSnMYonMhWgCN
        sQMucw91wxeK2IMfIVDHnWAN+EIxiTFX/j6NW6Q=
X-Google-Smtp-Source: APXvYqwkGrlVoyO/zr0mualeskMS+XAfllwPaWnmaxVLcdCULWwIoXTi5yBB9XmatBuEMbeEz95s9TZS3zFE8mm4Muk=
X-Received: by 2002:a05:600c:254b:: with SMTP id e11mr103137207wma.171.1564572222178;
 Wed, 31 Jul 2019 04:23:42 -0700 (PDT)
MIME-Version: 1.0
References: <1564568143-3371-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <1564568143-3371-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 31 Jul 2019 13:23:29 +0200
Message-ID: <CAMuHMdWjN79_F_7qf9f+NSaSxyHi4Wrtn5aZtwaK30s6GaT24A@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: udc: renesas_usb3: Fix sysfs interface of "role"
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 1:17 PM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> Since the role_store() uses strncmp(), it's possible to refer
> out-of-memory if the sysfs data size is smaller than strlen("host").
> This patch fixes it by using sysfs_streq() instead of strncmp().
>
> Fixes: cc995c9ec118 ("usb: gadget: udc: renesas_usb3: add support for usb role swap")
> Cc: <stable@vger.kernel.org> # v4.12+
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
