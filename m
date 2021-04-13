Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96CB35DF71
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 14:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242430AbhDMMwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 08:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237813AbhDMMwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 08:52:11 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433CDC061574
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 05:51:51 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id j12so57832ils.4
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 05:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hV+sBSdg06uJCBSWfYclaLZtePK5lExXT9p5JLrGTeA=;
        b=J7SpGs23XtsMueRKu661JyR+rccf1L793lTiEb89azxxpSOASDAxe4wv/9d95jqFJs
         PAW4qJw5K+F7QOKdtYH5eaadOWi4fZjFO57GkdfGc5CeHaRZg3lt1l8xnL8c5+5hsJM1
         IIsY+iDw84CMQwOhemz/YVnWE3I7RjaTQBG4MwM5PsZUGR37RqlbVa40Dnn8vEWdMLB4
         Rc/Zub12OuO8I2DrF98iIfdSVVuYkk2esPOAE3fsXxncpMHCJRUpI/ikQPDFaOQ2L/Jq
         l4Q+iracWLzebVu4Pe0LtOTPCKusT7Pxyrtb3pVX7nAuWJaGNDLf5Xqc2chIKbesMMxl
         Jx9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hV+sBSdg06uJCBSWfYclaLZtePK5lExXT9p5JLrGTeA=;
        b=IBlrYGRqcqmyX8IapphsHH2c/IX8/1xg73pk9YSMVqnOJWVbU+iCt6AH7CVXEsGKAY
         M6asPpLEIu6VaZV9gOg6dzkbSOUBcvASleuTw7lOX6AZhnzzUW2jG8G9WmmVNt+RFXCo
         Kpe4JYwtAGr/aKYNqDnA5PduOQtgNYIrhlHxKHSWizs9+R8S2rpcAjNuGc05cNzFBntc
         9ldNZKuAC9fvEvaIUH2K5beDFig6O4tXencDip95Q6rBHwpeA0X4cseKMDEcQmRhep7N
         4p+itpzT3nQZaYVz7WrVMrFRPRCIa4cOTZZuaon0O9Gx/K5Rrqo1AmYc2ERtdKZhKxdc
         QWPA==
X-Gm-Message-State: AOAM532if3wmNpZmP/MkpqQ1xi7cAly2ig/rp3NGl5X8aUxGsLFOg2rx
        6Vnzc3yGvD6oIfjat+0J+fI=
X-Google-Smtp-Source: ABdhPJy//boO50IaEs92YipMfPwjULhXoBVu32sH975PxYZGVp6/C9f3yUp5+ldScxePbxtJj+OuWw==
X-Received: by 2002:a05:6e02:1a0b:: with SMTP id s11mr22315292ild.105.1618318310722;
        Tue, 13 Apr 2021 05:51:50 -0700 (PDT)
Received: from localhost (pppoe-209-91-167-254.vianet.ca. [209.91.167.254])
        by smtp.gmail.com with ESMTPSA id g12sm6611292ile.71.2021.04.13.05.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 05:51:50 -0700 (PDT)
Date:   Tue, 13 Apr 2021 08:51:48 -0400
From:   Trevor Woerner <twoerner@gmail.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mtd: rawnand: lpc32xx_slc: Fix external use of SW
 Hamming ECC helper
Message-ID: <20210413125148.GB34377@localhost>
References: <20210413095916.330405-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210413095916.330405-1-miquel.raynal@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 2021-04-13 @ 11:59:16 AM, Miquel Raynal wrote:
> Since the Hamming software ECC engine has been updated to become a
> proper and independent ECC engine, it is now mandatory to either
> initialize the engine before using any one of his functions or use one
> of the bare helpers which only perform the calculations. As there is no
> actual need for a proper ECC initialization, let's just use the bare
> helper instead of the rawnand one.
> 
> Fixes: 19b2ce184b9f ("mtd: nand: ecc-hamming: Stop using raw NAND structures")
> Cc: stable@vger.kernel.org
> Reported-by: Trevor Woerner <twoerner@gmail.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>

Tested-by: Trevor Woerner <twoerner@gmail.com>

> ---
>  drivers/mtd/nand/raw/lpc32xx_slc.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/raw/lpc32xx_slc.c b/drivers/mtd/nand/raw/lpc32xx_slc.c
> index 6b7269cfb7d8..65663f5ba54f 100644
> --- a/drivers/mtd/nand/raw/lpc32xx_slc.c
> +++ b/drivers/mtd/nand/raw/lpc32xx_slc.c
> @@ -27,6 +27,7 @@
>  #include <linux/of.h>
>  #include <linux/of_gpio.h>
>  #include <linux/mtd/lpc32xx_slc.h>
> +#include <linux/mtd/nand-ecc-sw-hamming.h>
>  
>  #define LPC32XX_MODNAME		"lpc32xx-nand"
>  
> @@ -344,6 +345,18 @@ static int lpc32xx_nand_ecc_calculate(struct nand_chip *chip,
>  	return 0;
>  }
>  
> +/*
> + * Corrects the data
> + */
> +static int lpc32xx_nand_ecc_correct(struct nand_chip *chip,
> +				    unsigned char *buf,
> +				    unsigned char *read_ecc,
> +				    unsigned char *calc_ecc)
> +{
> +	return ecc_sw_hamming_correct(buf, read_ecc, calc_ecc,
> +				      chip->ecc.size, false);
> +}
> +
>  /*
>   * Read a single byte from NAND device
>   */
> @@ -802,7 +815,7 @@ static int lpc32xx_nand_attach_chip(struct nand_chip *chip)
>  	chip->ecc.write_oob = lpc32xx_nand_write_oob_syndrome;
>  	chip->ecc.read_oob = lpc32xx_nand_read_oob_syndrome;
>  	chip->ecc.calculate = lpc32xx_nand_ecc_calculate;
> -	chip->ecc.correct = rawnand_sw_hamming_correct;
> +	chip->ecc.correct = lpc32xx_nand_ecc_correct;
>  	chip->ecc.hwctl = lpc32xx_nand_ecc_enable;
>  
>  	/*
> @@ -819,8 +832,14 @@ static int lpc32xx_nand_attach_chip(struct nand_chip *chip)
>  	return 0;
>  }
>  
> +static void lpc32xx_nand_detach_chip(struct nand_chip *chip)
> +{
> +	rawnand_sw_hamming_cleanup(chip);
> +}
> +
>  static const struct nand_controller_ops lpc32xx_nand_controller_ops = {
>  	.attach_chip = lpc32xx_nand_attach_chip,
> +	.detach_chip = lpc32xx_nand_detach_chip,
>  };
>  
>  /*
> -- 
> 2.27.0
> 
