Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6422C1B3B9F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 11:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgDVJmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 05:42:42 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:35319 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVJml (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 05:42:41 -0400
Received: from mail-qk1-f174.google.com ([209.85.222.174]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1Mq2vS-1ioIer3XkY-00n9PS; Wed, 22 Apr 2020 11:42:40 +0200
Received: by mail-qk1-f174.google.com with SMTP id b188so91078qkd.9;
        Wed, 22 Apr 2020 02:42:39 -0700 (PDT)
X-Gm-Message-State: AGi0PubM0Ba3/xw6lyC7pKnhEUWBk8gpJR9KO/ZvyTFLJOd90ZYf3o4o
        zW34phKCJ86TzuyqNK0hq8MA4HZLpjkmweVUGD4=
X-Google-Smtp-Source: APiQypI/ymCJliens2rTL4tEYpO0RaBvdBKJfx9PjnWISDf1IJDrLKMK8cr9T1HxGv56n49gXQdFjqLshcI2cTE/yOY=
X-Received: by 2002:a37:ba47:: with SMTP id k68mr25543488qkf.394.1587548558376;
 Wed, 22 Apr 2020 02:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200331183844.30488-1-ulf.hansson@linaro.org> <20200331183844.30488-3-ulf.hansson@linaro.org>
In-Reply-To: <20200331183844.30488-3-ulf.hansson@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 22 Apr 2020 11:42:22 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2n7O0-jHLASdu9scgrG7iqETJV7Un843+fW3Yt4q=UhA@mail.gmail.com>
Message-ID: <CAK8P3a2n7O0-jHLASdu9scgrG7iqETJV7Un843+fW3Yt4q=UhA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] amba: Initialize dma_parms for amba devices
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Vinod Koul <vkoul@kernel.org>, Haibo Chen <haibo.chen@nxp.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        dmaengine@vger.kernel.org, "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:IpJyPZ9YBAl88UI2HJR5kQYmnDmW08TgqsV+OQjKOowGbohVjnD
 ii7n7Y5DOK1sN2B4v+bLcNrtDlkCkmvXwmnOKkumRw4j2FT/7I2fPFDH42UgRdiu1XqCrrp
 WA2NHTjUJF35g/zH0OhUhc137HHVrAluaM0z2t0TeYD2ruHZkBLC4S13TujU8aH9sc+psfp
 ZGY0yP/zCguOyVfHo4oNw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HawH5AsHXXY=:E+b9brVrsc23wamVONBRqz
 bbg/iXJldYC8tI3huGwcyai7iHTbI5A90q9VtamjnUvRxGUDq/K2fS7ehWGBbH+3q4dcd4UUp
 be4G1dvcGHiEElQ8ae+g2OfjAaKQ93ZtS1ugSycZ+XCjJ+Fo8xxECFr2iaK4dJpLjvKo4gy//
 qgyGttThQHXW6+vQUQGWux/puHUcC08BLS9isWX4vFeL/B5ce3nom1CFocLF4alPx2eDMzmpY
 rzudb1MT/Qmgd4lzZjrwouB4mT98/X2hDKQpWeUrRJ9TBh0XW6SvdRAYSNDwTyYAB6vS79b9l
 UhXOPqRGG3B/vB60Y1swlZdYCzthNOEsTt3+RS4BjFxTrbw67cGlYP+A+5PpduAjGMHJOAWKx
 zjmDielINiLOtXgrksflJ7KH3aFoj6mw+6b73FvlVy0645GDygpoOQjS5lsjZNc5AEj7iN9S2
 zKqAUaSQa3iBxeK6QBFqM6tJJN7y+n0mXTR5ungacj7vWD73/TBpNFYrP7uLCvAL6+xBtQrEX
 z/6xbTUxpH6RcY9bw7lgP/sa0OtGZHDFOI+gqc+471xHLrQHp+iyvBqhV7S0oi8eWra989BRF
 e4lyNcQ9X4Z/cyzd3Gzie+bC+d6e6c1cHXLs+l+NLUQ5aOIMDlFdGoDhTzdJ/OS8qTj/aJI70
 Wd0ec5+EmULhNJbhFeures05auGRALI9kX8dpc208rFnCmgotWLq7x/ZoT4vwhLHM4hFFEVOF
 bfirkaW89wbnq+eja8vBZikMap8Sobe+EOcTWhRu0f6nZ2NxYFgTfbfGXwluE72mkq4+EIlqy
 ZZnAo8O/Kbp8SHSOa+lZL0xoGUrdtYRdvb4lonxBkLD484QR14=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 8:38 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> It's currently the amba driver's responsibility to initialize the pointer,
> dma_parms, for its corresponding struct device. The benefit with this
> approach allows us to avoid the initialization and to not waste memory for
> the struct device_dma_parameters, as this can be decided on a case by case
> basis.
>
> However, it has turned out that this approach is not very practical. Not
> only does it lead to open coding, but also to real errors. In principle
> callers of dma_set_max_seg_size() doesn't check the error code, but just
> assumes it succeeds.
>
> For these reasons, let's do the initialization from the common amba bus at
> the device registration point. This also follows the way the PCI devices
> are being managed, see pci_device_add().
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
