Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF890ACC10
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 12:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbfIHKc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 06:32:58 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:39755 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727932AbfIHKc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 06:32:58 -0400
Received: by mail-vk1-f194.google.com with SMTP id j5so2147030vkn.6
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 03:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bX3KqjL4fKpxNJSQAl68andrMAZ0zFQA7utOvXr90Wk=;
        b=c04Ea7Qd/zMKT/FcbxFqguzMDiyky5hl4KTgVxYklu0gvxwcYx9WE7wEZOM7bJ3q+T
         LpLB04fsPXAQGKS7ORsUyao+D9Ck/clQqS4zXpFn/MU9UZR94Z/MNfiW4kShbHjWnF2i
         VHF9l48x7V4MhX+e++ks14gtSiiDwTUwFRNKh2+8M27ZHd/db64VmIvFtq0a7uQvlGii
         2YuySmS+2dFEs5XirH5TuhCAvqRlBtRheiUbAGGBINaarTGq6VFq1I1yN4JHmIgR889R
         iblEZexgIi9vJAXzXuIsetwC501NJImDYFMCDS/vnHP+FuwuSu5iCcWzFDWKIJzq7pyT
         V5Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bX3KqjL4fKpxNJSQAl68andrMAZ0zFQA7utOvXr90Wk=;
        b=bfaKvsQYPW/mlJCe8mJ/vLTBMxJqJ5kWqOswSLAB5TN7zcqYvRuTClvdWKqRiOLr3g
         VI4KZUBRtd2uteVGg6swXsn4BdrTUtMeSZCZaQyPfSokVzshh0kAe4YKxlqSW6j0pZIr
         ki1UT1KTvaYyUtfIbI86Wg8+QMvTL0eDOXgVIhqHuOezMuLnFYEbM8UVrYLmx+866teS
         akEeKq/AuwXKIPvdQDlI4gofH8AeLuPuC59cBENYYLaqOaD7z/kbp7dzaE856Zk3FR3A
         vWknWqpFNkUFdbcyZ7ZSW/XwF9D+/34bqfJMq4K8G4zB7J1abfoTBTdQod6Xr1R00mtW
         TsqQ==
X-Gm-Message-State: APjAAAXfRJtdcd1T9ADqzGU0fZGO1ECXPPCQVaB71siAH/F2yTZQPZI2
        LCBBPzd/it1fJ7SFXjzdohf3sUxGzwlbEi8/E7gcQw==
X-Google-Smtp-Source: APXvYqx6AtGiyvrIbxIWnNr0Pg+dtCTgbgAuq/Fhl9QAovGWe1AuWd8I7KV41uSYL4a46U13t4KwGpG64r4f7TfJw2E=
X-Received: by 2002:a1f:5e4f:: with SMTP id s76mr8536398vkb.4.1567938777211;
 Sun, 08 Sep 2019 03:32:57 -0700 (PDT)
MIME-Version: 1.0
References: <1567928752-2557-1-git-send-email-wahrenst@gmx.net>
In-Reply-To: <1567928752-2557-1-git-send-email-wahrenst@gmx.net>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Sun, 8 Sep 2019 12:32:21 +0200
Message-ID: <CAPDyKFpdZnQaH9NfTsmFk2pjREL_pv6netQjwubMzrkXAOg6hA@mail.gmail.com>
Subject: Re: [PATCH] Revert "mmc: bcm2835: Terminate timeout work synchronously"
To:     Stefan Wahren <wahrenst@gmx.net>
Cc:     Eric Anholt <eric@anholt.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Lukas Wunner <lukas@wunner.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 8 Sep 2019 at 09:46, Stefan Wahren <wahrenst@gmx.net> wrote:
>
> The commit 37fefadee8bb ("mmc: bcm2835: Terminate timeout work
> synchronously") causes lockups in case of hardware timeouts due the
> timeout work also calling cancel_delayed_work_sync() on its own.
> So revert it.
>
> Fixes: 37fefadee8bb ("mmc: bcm2835: Terminate timeout work synchronously")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>

Applied for fixes, thanks!

Kind regards
Uffe


> ---
>  drivers/mmc/host/bcm2835.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/bcm2835.c b/drivers/mmc/host/bcm2835.c
> index 7e0d3a4..bb31e13 100644
> --- a/drivers/mmc/host/bcm2835.c
> +++ b/drivers/mmc/host/bcm2835.c
> @@ -597,7 +597,7 @@ static void bcm2835_finish_request(struct bcm2835_host *host)
>         struct dma_chan *terminate_chan = NULL;
>         struct mmc_request *mrq;
>
> -       cancel_delayed_work_sync(&host->timeout_work);
> +       cancel_delayed_work(&host->timeout_work);
>
>         mrq = host->mrq;
>
> --
> 2.7.4
>
