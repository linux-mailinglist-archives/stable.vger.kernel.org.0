Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86294117848
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 22:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfLIVTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 16:19:15 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:44651 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfLIVTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 16:19:15 -0500
Received: by mail-il1-f196.google.com with SMTP id z12so14071013iln.11
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 13:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V+fINYfX0WThUMVmPz7Se9rxOk/QEnp1Ar+VHOYBVxM=;
        b=jpa16NEuZwY2KSfk6NP5RUXRbZTqhOxIOn2ULnB+NQIxcDKg4iwohsasp3jzuTuHAb
         TgUg2VjcSreaaNF1TxupKHVp3rONn6ZriWLhvEyhlf3aIXKMvpmF2XG5Q6nzjYFXmXmb
         QhT3AdjSQXpcBJmnXhpX20x8D9bYKVGNoen0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V+fINYfX0WThUMVmPz7Se9rxOk/QEnp1Ar+VHOYBVxM=;
        b=pSD6tyL8J7Cdu7JBhjD3ZZW4PU+nVPvQiGujtli93da5BcK2vs1M6OzZiswEHSh1KL
         5S9XVXI8z15O+T4Eek7TvDToVN1hsK2VHGE/1vG9mrQvZIaI1rvnHzPoUDfmrAf5vqF5
         50ktNsH+wzCG98A3PglOZUzlXYu1XdAURlJNJ4//ZcMpYll90c+fqoRqaTLMPyF/4an1
         LdzR9szTLYWsTghmu65abys0JJdmmFB7WX+L6Kg+Cgm+cuf4mXcV1ZiqL2vz0+Q8nsKF
         JHSF7AxqHDaNSr3vXTXVVv0iMLAYOL4kPfUCBpPpi3+LQOTUNU9iOuQvTWZLY5F2KoaO
         uiTw==
X-Gm-Message-State: APjAAAXXY+gcvm8D42YAS6XGRwtJ67huLFxjFnsMUewSicv6BYmtk2oS
        ZYtGX7iiy7sA/Ok5c4qxw9ftmpV1A/I=
X-Google-Smtp-Source: APXvYqx1V9sel2eynvyFs7jEVGsRZHgO07zUptCUCFjngPnSOvwHITdbCIPEVihaXEofctUKCEveqw==
X-Received: by 2002:a92:848b:: with SMTP id y11mr30911934ilk.134.1575926354733;
        Mon, 09 Dec 2019 13:19:14 -0800 (PST)
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com. [209.85.166.177])
        by smtp.gmail.com with ESMTPSA id f7sm175827ioo.27.2019.12.09.13.19.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 13:19:13 -0800 (PST)
Received: by mail-il1-f177.google.com with SMTP id b15so14088204ila.7
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 13:19:13 -0800 (PST)
X-Received: by 2002:a92:d581:: with SMTP id a1mr27952212iln.218.1575926352743;
 Mon, 09 Dec 2019 13:19:12 -0800 (PST)
MIME-Version: 1.0
References: <lsq.1575813164.154362148@decadent.org.uk> <lsq.1575813165.830287385@decadent.org.uk>
In-Reply-To: <lsq.1575813165.830287385@decadent.org.uk>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 9 Dec 2019 13:19:01 -0800
X-Gmail-Original-Message-ID: <CAD=FV=XpyONBT_XcKLRj2qkcJHkVntoHJJs=tYbVjzF9V10ziQ@mail.gmail.com>
Message-ID: <CAD=FV=XpyONBT_XcKLRj2qkcJHkVntoHJJs=tYbVjzF9V10ziQ@mail.gmail.com>
Subject: Re: [PATCH 3.16 10/72] video: of: display_timing: Add of_node_put()
 in of_get_display_timing()
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        David Airlie <airlied@linux.ie>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sun, Dec 8, 2019 at 5:54 AM Ben Hutchings <ben@decadent.org.uk> wrote:
>
> 3.16.79-rc1 review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Douglas Anderson <dianders@chromium.org>
>
> commit 4faba50edbcc1df467f8f308893edc3fdd95536e upstream.
>
> =46romcode inspection it can be seen that of_get_display_timing() is
> lacking an of_node_put().  Add it.

I don't object, but I am curious why "From code" got turned into
"=46romcode" in the commit message.
