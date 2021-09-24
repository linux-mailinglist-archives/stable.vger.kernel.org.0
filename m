Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C2A4176B9
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 16:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346691AbhIXOWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 10:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346629AbhIXOWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 10:22:07 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBEDC061613
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 07:20:34 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id q125so13567158qkd.12
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 07:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7cWc4yzdb0VnFfnu4UMB5K2rNfvo1h4uviMaG/9Luy8=;
        b=jUq7bdAP6GfaQzVHqsEAN1yhZxpZXIpCQX6jGOig1ZIcsJ16N5sRYGiVzSBsnsrAQF
         +Q80Vj1jInTt6ZbMMlSOTBWvZykFl6FWvPtSP1LUG2/LkzZ8kE5Os1NmxLaXE4V3EOik
         X4TQbe6kou6y73WNqR4j5gIhSIuvW6ThKo4o2nA0DX6LcOa63bN4ad0XkoP1B8nAcnVe
         pNI5vwGwzYcMVcEGk0VictQerdTKB20vJVowJCn21NzV+VienIlUX6NPY52Ziy8SE4Ef
         phvB07TanfmqYer6svKLlkxX1/VR927Lxk8YbXE40sT3O/ts9yJ1ORRwbTyitYbfTLGB
         7edw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7cWc4yzdb0VnFfnu4UMB5K2rNfvo1h4uviMaG/9Luy8=;
        b=7uDBlovSfZPw62dir1E78VFRsfUr4IQojX4rtpEmcbm0BXXoloDBNaGclPq+3ZuiAd
         Rng/1dmlw62ibg0L0DEZDqRsGqz9TT+rWpkHlbbl2pmDhbaDLCZjHhItX9nfVXT5h0mn
         p6FpnhCPoKLKbzOoswn85FvfvH2Flwf5+yMB54rOU84rjZaWxgjBmc/lU2NaPW/FLTOm
         6Q1KupbBUlXeEQ4TMuKAgUEMC0tb/8srom2AC/avhYR37qcPXd0K1xEpkrGaraEyJjPg
         uP8WFUJ3/km5uwpO2xCfKIlRl1nDlk3pDRZoe5OLHOPdBIqy38oTB/KmZdid8Y6dIW11
         6kIA==
X-Gm-Message-State: AOAM533HvcB3sCRNGvkihhK0Ku0xRKmpLkYbJlbXmonHvQrqypUoyfUj
        tni5br4vLxWYzTe7BZ0ZE6d/oQ==
X-Google-Smtp-Source: ABdhPJw0YEb7syFNucm0QZguZSbj1llvgZ897+2/7RW+V9bkpAcfpW1rJ64+ZabX7Iv75/M/bWZjrw==
X-Received: by 2002:a05:620a:238:: with SMTP id u24mr10627934qkm.404.1632493233224;
        Fri, 24 Sep 2021 07:20:33 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id c16sm5531221qkk.113.2021.09.24.07.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 07:20:32 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mTm40-005CHZ-8x; Fri, 24 Sep 2021 11:20:32 -0300
Date:   Fri, 24 Sep 2021 11:20:32 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, peterhuewe@gmx.de,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tpm: fix potential NULL pointer access in
 tpm_del_char_device()
Message-ID: <20210924142032.GY3544071@ziepe.ca>
References: <20210910180451.19314-1-LinoSanfilippo@gmx.de>
 <204a438b6db54060d03689389d6663b0d4ca815d.camel@kernel.org>
 <trinity-27f56ffd-504a-4c34-9cda-0953ccc459a3-1631566430623@3c-app-gmx-bs69>
 <c22d2878f9816000c33f5349e7256cadae22b400.camel@kernel.org>
 <50bd6224-0f01-ca50-af0e-f79b933e7998@gmx.de>
 <20210924133321.GX3544071@ziepe.ca>
 <b49f4b52-44c4-8cb8-a102-689e9f788177@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b49f4b52-44c4-8cb8-a102-689e9f788177@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 24, 2021 at 04:17:52PM +0200, Lino Sanfilippo wrote:
> On 24.09.21 at 15:33, Jason Gunthorpe wrote:
> > On Fri, Sep 24, 2021 at 03:29:46PM +0200, Lino Sanfilippo wrote:
> >
> >> So this bug is triggered when the bcm2835 drivers shutdown() function is called since this
> >> driver does something quite unusual: it unregisters the spi controller in its shutdown()
> >> handler.
> >
> > This seems wrong
> >
> > Jason
> >
> 
> 
> Unregistering the SPI controller during shutdown is only a side-effect of calling
> bcm2835_spi_remove() in the shutdown handler:
> 
> static void bcm2835_spi_shutdown(struct platform_device *pdev)
> {
> 	int ret;
> 
> 	ret = bcm2835_spi_remove(pdev);
> 	if (ret)
> 		dev_err(&pdev->dev, "failed to shutdown\n");
> }

That's wrong, the shutdown handler is only supposed to make the HW
stop doing DMA and interrupts so we can have a clean transition to
kexec/etc

It should not be manipulating other state.

Jason
