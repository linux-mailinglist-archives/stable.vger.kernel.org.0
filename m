Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5425E9FE1
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbfJ3Pvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:51:55 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:45134 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727875AbfJ3Pvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Oct 2019 11:51:55 -0400
Received: by mail-vk1-f196.google.com with SMTP id e28so589823vkn.12
        for <stable@vger.kernel.org>; Wed, 30 Oct 2019 08:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MM8FYPP/M/qSGLzrMimtzxUAQYpF/zt1wu6EL2luqtE=;
        b=g63vcrfvchtAY5Rd4CuFqJnAncPsp38RdAVZRNM9WTGTq5FdrGZl2oMdK24C0ouZMv
         Zx3My7Upbfwkqdu1ZF5cDQ1kc66k/jp8wegkgxnQ/ALeyvgSeFHS/snQ/xWL75V7Phqp
         4MalfrNRHwi4CpIylLOnmzj9sdkHNkEDYEmmwx+aVxrHD+QCV51Rzzl6vHtIJ3iMO30J
         kFpmzeq4jWbaxsqwIjDZZneLyXJaaJdjcH+c/BSSTf8iRjl2gNc5j54vOdQqJfw/rePZ
         P3cKjDCcYPbQxJlN9cpB5CkBmYD/3vyML4pHLz4SnMVneG80kChlnAC6NwFHN0uFm/d2
         8DyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MM8FYPP/M/qSGLzrMimtzxUAQYpF/zt1wu6EL2luqtE=;
        b=BKxvDV+A78Q0BUxk+gW4GTMkv5OE3J8Z1DDkPWpsZnsQjIjf8P4vdgsebzTls9l3GF
         SlUgTZrBZhpW2qloiBAA1wn84lMZ+7ElObbR3bdu+wpwNKJDtMPmWNgYkYMLYCZKd8ua
         iTC79pDv3Z0wemIGES79RaB+bq7hTP/ZUkZEr1JUkax7bULOFGpLFqmfObzVQtHXo+l1
         bx6Uykmg4ZXz+UjKJflaNcxQGZfXSgfyCAG1UdpNXYmVwSSvs0IDB+Q7mPcQtkfEXgiU
         UpM69PJ8HJIQ2tugceNs0bjfKZq1IV4SqwE/6Hlr2DlgCPDEpZeFh7T1y5rw4iff9XP4
         Urrw==
X-Gm-Message-State: APjAAAWY8zukQi1rPn/i6JeIeX55knsv8YaMtlEkL/C+uw80CS3CyZGl
        14JKKKua18FWrca4xHXSRGGWenC+4lVcMfUvFtXbPQ==
X-Google-Smtp-Source: APXvYqyHupdgWHa7qCIjuf/ufG4zCQRus8URSrYdV3I3LkSUfaiNNDW1LPfNwtjXqRaPr+zQbaPiggFXKTik4rvlgIk=
X-Received: by 2002:a1f:2f51:: with SMTP id v78mr15055854vkv.101.1572450713564;
 Wed, 30 Oct 2019 08:51:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571510481.git.hns@goldelico.com> <0887d84402f796d1e7361261b88ec6057fbb0065.1571510481.git.hns@goldelico.com>
In-Reply-To: <0887d84402f796d1e7361261b88ec6057fbb0065.1571510481.git.hns@goldelico.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 30 Oct 2019 16:51:17 +0100
Message-ID: <CAPDyKFp3EjTuCTj+HXhxf+Ssti0hW8eMDR-NrGYWDWSDmQz6Lw@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] mmc: host: omap_hsmmc: add code for special init
 of wl1251 to get rid of pandora_wl1251_init_card
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, kernel@pyra-handheld.com,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 19 Oct 2019 at 20:42, H. Nikolaus Schaller <hns@goldelico.com> wrote:
>
> Pandora_wl1251_init_card was used to do special pdata based
> setup of the sdio mmc interface. This does no longer work with
> v4.7 and later. A fix requires a device tree based mmc3 setup.
>
> Therefore we move the special setup to omap_hsmmc.c instead
> of calling some pdata supplied init_card function.
>
> The new code checks for a DT child node compatible to wl1251
> so it will not affect other MMC3 use cases.
>
> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Cc: <stable@vger.kernel.org> # 4.7.0
> ---
>  drivers/mmc/host/omap_hsmmc.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 952fa4063ff8..03ba80bcf319 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -1512,6 +1512,27 @@ static void omap_hsmmc_init_card(struct mmc_host *mmc, struct mmc_card *card)
>
>         if (mmc_pdata(host)->init_card)
>                 mmc_pdata(host)->init_card(card);
> +       else if (card->type == MMC_TYPE_SDIO || card->type == MMC_TYPE_SD_COMBO) {
> +               struct device_node *np = mmc_dev(mmc)->of_node;
> +
> +               np = of_get_compatible_child(np, "ti,wl1251");
> +               if (np) {
> +                       /*
> +                        * We have TI wl1251 attached to MMC3. Pass this information to
> +                        * SDIO core because it can't be probed by normal methods.
> +                        */
> +
> +                       dev_info(host->dev, "found wl1251\n");
> +                       card->quirks |= MMC_QUIRK_NONSTD_SDIO;
> +                       card->cccr.wide_bus = 1;
> +                       card->cis.vendor = 0x104c;
> +                       card->cis.device = 0x9066;
> +                       card->cis.blksize = 512;
> +                       card->cis.max_dtr = 24000000;
> +                       card->ocr = 0x80;

These things should really be figured out by the mmc core during SDIO
card initialization itself, not via the host ops ->init_card()
callback. That is just poor hack, which in the long run should go
away.

Moreover, I think we should add a subnode to the host node in the DT,
to describe the embedded SDIO card, rather than parsing the subnode
for the SDIO func - as that seems wrong to me.

To add a subnode for the SDIO card, we already have a binding that I
think we should extend. Please have a look at
Documentation/devicetree/bindings/mmc/mmc-card.txt.

If you want an example of how to implement this for your case, do a
git grep "broken-hpi" in the driver/mmc/core/, I think it will tell
you more of what I have in mind.

> +                       of_node_put(np);
> +               }
> +       }
>  }
>
>  static void omap_hsmmc_enable_sdio_irq(struct mmc_host *mmc, int enable)
> --
> 2.19.1
>

Kind regards
Uffe
