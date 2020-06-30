Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B7220EAFD
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 03:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgF3Bgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 21:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgF3Bgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 21:36:37 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EDCC03E97B
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 18:36:37 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g13so14437883qtv.8
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 18:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l2Xg4aQwUyetnTxL0PwCdz9HzeQwoFK5MsRigLULc90=;
        b=YzFIJVJ/Sw7j2tzy65Yy+gqcrGf6iq4u3OgvAr6xS4iJ/A/shX5XG/5576LGcx+LaW
         7nFbDmXxHkShYE32yooPq3SORcZlMebYHQBKJWKpkz04GSwyKu6bFzKoRLZ50sUD0oMj
         Fzy8bpjn5lNBjYKJZeVfWEaB8Qv2C7RooI02r4Yx3Dh68IfgOT5fLfdwNS/TZIEls4jn
         IF2MZoj+xNuvggxJ0hdZWr67hkPvaPCyhA5Skflke00gfGLcmy2+5Mvjsn3hJjdVyeEW
         Xz7g/DU6h71hdpbSkSj4gmnEt3yAvaRqxY4FRY8xGOKpjtCydxPIweQbDrY3nxNVBHiV
         +gzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l2Xg4aQwUyetnTxL0PwCdz9HzeQwoFK5MsRigLULc90=;
        b=kYcNtQtSKToWX+WqG/zjwTiY3DoVlND+N43e3rWw/6uYLDlnWTDKOuxYMpWED8QhSz
         2GypliiFoGdiSVlFzsSZeo1rqWe+z3RpNZ1wpCYoVDJvSsvKQSjPGCcTgNzrM1x7zd9S
         9XzEbjTbGovM7ag2NlL6DL5piW8X5hhJeXDTEmiuFW1RYedWBPSongP0UwUgkoAxLJVg
         /Rbk6OzGtup1TU1Qg3gz52VDvE+70wCfGWVYxSbXDXlP9UO+dZLMO/z7vWqm6T+VydB/
         itXuMYvzN8CZmUT2yLVzxFdsZlg8JUqaXAHPDb3v22Ef7R/72yWVQYNJeUSYCp7/ropj
         v0wg==
X-Gm-Message-State: AOAM531s9NifAGAY6gyz0PrPPvonLfjDH7xUmgFJVLoz5Fp3VT06PHGF
        9S8GSPbl5oECQ4kON6U2iF8aaw==
X-Google-Smtp-Source: ABdhPJwJ2tBwLuCXC4nb7gGwAadRBqolulV56bI5ht0QSbVmXHbbTCC95NBxsvzxVfB16FCzxcRQ5w==
X-Received: by 2002:ac8:7508:: with SMTP id u8mr18615749qtq.339.1593480996652;
        Mon, 29 Jun 2020 18:36:36 -0700 (PDT)
Received: from localhost (rfs.netwinder.org. [206.248.184.2])
        by smtp.gmail.com with ESMTPSA id q28sm1890413qtk.13.2020.06.29.18.36.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Jun 2020 18:36:36 -0700 (PDT)
Date:   Mon, 29 Jun 2020 21:36:35 -0400
From:   Ralph Siemsen <ralph.siemsen@linaro.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Pavel Machek <pavel@denx.de>,
        Serge Semin <fancer.lancer@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Georgy Vlasov <Georgy.Vlasov@baikalelectronics.ru>,
        Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Rob Herring <robh+dt@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4.19 182/267] spi: dw: Return any value retrieved from
 the dma_transfer callback
Message-ID: <20200630013635.GA27038@maple.netwinder.org>
References: <20200619141648.840376470@linuxfoundation.org>
 <20200619141657.498868116@linuxfoundation.org>
 <20200619210719.GB12233@amd>
 <20200622205121.4xuki7guyj6u5yul@mobilestation>
 <20200626151800.GA22242@maple.netwinder.org>
 <20200629142606.GR1931@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200629142606.GR1931@sasha-vm>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 10:26:06AM -0400, Sasha Levin wrote:
>>diff --git a/drivers/spi/spi-dw-mmio.c b/drivers/spi/spi-dw-mmio.c
>>index c563c2815093..99641c485288 100644
>>--- a/drivers/spi/spi-dw-mmio.c
>>+++ b/drivers/spi/spi-dw-mmio.c
>>@@ -358,7 +358,7 @@ static int mmio_spi_dma_transfer(struct dw_spi *dws, struct spi_transfer *xfer)
>
>Um, I can't find this function anywhere... what am I missing?

Nothing... my bad. The code in question was added on a vendor branch
(https://github.com/renesas-rz/rzn1_linux/blob/rzn1-stable-v4.19/drivers/spi/spi-dw-mmio.c#L338
if you are curious).

I'm very sorry for wasting your time... please disregard the patch!

-Ralph
