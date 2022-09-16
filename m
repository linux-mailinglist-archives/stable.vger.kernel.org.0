Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9105BABED
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 13:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbiIPLCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 07:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbiIPLB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 07:01:57 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4991CFDB;
        Fri, 16 Sep 2022 03:54:22 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id o5so11798367wms.1;
        Fri, 16 Sep 2022 03:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date;
        bh=as5qbV1zgeHsUS0PT6BJlWeyoNQRvlWywcs7yIo6KkE=;
        b=IjAoTYpUj4L7seU/elTdtGkV+58urlsKmEb28xUwlAFOGP+QYdURtsS2r1nMwu6TKh
         LIAxp+nV6UxWcM7vsnFFx1LAUoi4AmHZ+sUhzkKUG74jnklrvIjdtiBQ0q+pb/x2Dpdo
         +5F0J17P+84g6XF+r34NK4xEm5l14BGWJcuK65Qdqd7n9fS/GpbEPWqYeBaAUQcuIcx6
         Zh2tgHJ3HmWGb2ru3nCMQ06GJMgJYhEZ1d3I2/B3eMTNSoQyq913W2zxt5czXwrCOFqy
         mfF8qA1RFE0+EPx3prR5axg4gpeMSRzGIVCaAjHorFvwaFBUFy9VybBlaDXhicwuMANk
         BFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=as5qbV1zgeHsUS0PT6BJlWeyoNQRvlWywcs7yIo6KkE=;
        b=iyzKAqYeztZG71WS5a12AOPo+4pSoMtaYK2lJmS44x+dpqS7bjYThPE1Zl/mub4t63
         08dMDWllS1OEh0qjlACvRSjC6R6Tcl3F1/8OZWBCbCZOk4iOvMlpd5gvxtkEjaShJuTh
         3L0mDx1bOtuy18J1u7g9kVBLjLKxKWgEbwLJt93XFwU8f79GhZJJPW2lUo3w+H5rjzTi
         muCUVhNUPwXy/dQLK3kROMV/KNYj9IhrawFkoyxvge+8OJX1cEa3vkZqEe7FMiGmpB7W
         hjNqehuCDl3no5YQW5fFXqAXBSzsNnuZeUgzhAyLRNptUrDIsyDU1VC4aY6fC2R6lmQg
         95fw==
X-Gm-Message-State: ACrzQf14W9M8G4X0q+GdXch8+rAudxGtp5FZUYzgcFGaZ5fLwhNCeTHJ
        GLpCjC3/CzIxvcR6hLR5IFo=
X-Google-Smtp-Source: AMsMyM4/vz3bTIqD782eceBcv3WxXpbx7kU8s77sCUA728nVphdNUakbhnIE7OfoHmX/BrbAa1yZSg==
X-Received: by 2002:a1c:f709:0:b0:3a6:3452:fcbe with SMTP id v9-20020a1cf709000000b003a63452fcbemr2958300wmh.164.1663325660161;
        Fri, 16 Sep 2022 03:54:20 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id d4-20020adffd84000000b00228daaa84aesm4646533wrr.25.2022.09.16.03.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 03:54:19 -0700 (PDT)
Message-ID: <632455db.df0a0220.9684.aafc@mx.google.com>
X-Google-Original-Message-ID: <YyPpZS9Cdteeiv4o@Ansuel-xps.>
Date:   Fri, 16 Sep 2022 05:11:33 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: nand: raw: qcom_nandc: handle error pointer from
 adm prep_slave_sg
References: <20220916001038.11147-1-ansuelsmth@gmail.com>
 <4dcb0e76-b965-42da-b637-751d2f8e1c51@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dcb0e76-b965-42da-b637-751d2f8e1c51@www.fastmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022 at 11:01:11AM +0200, Arnd Bergmann wrote:
> On Fri, Sep 16, 2022, at 2:10 AM, Christian Marangi wrote:
> > ADM dma engine has changed to also provide error pointer instaed of
> > plain NULL pointer on invalid configuration of prep_slave_sg function.
> > Currently this is not handled and an error pointer is detected as a
> > valid dma_desc. This cause kernel panic as the driver doesn't fail
> > with an invalid dma engine configuration.
> >
> > Correctly handle this case by checking if dma_desc is NULL or IS_ERR.
> 
> Using IS_ERR_OR_NULL() is almost never a correct solution. I think
> in this case the problem is the adm_prep_slave_sg() function
> that returns an invalid error code.
>

Yes I was honestly not certain on what to fix... The adm driver or the
nand driver. Dediced to fix the nand driver since it was the one that
was causing the panic and to me it seemd bad to remove error code from
the adm driver. (But we have debug log anyway so...)

> While error pointers are often better than NULL pointers for
> passing information to the caller, a driver can't just change
> the calling conventions on its own. If we want to change
> the dmaengine_prep_slave_sg() API, I would suggest coming
> up with a new name for a replacement interface that uses
> error pointers instead of NULL first, and then changing
> all callers to the new interface.
> 
>        Arnd

I also notice this that dmaengine_prep_slave_sg always return NULL in
case of error so you are right and the real problem here is the changed
calling concention. Seems overkill to introduce a new API just for a
commit that changed the naming convention...

So I think we should just ignore this and I will send a better fix that
will just return NULL and fix the adm driver. 

Thanks for the review and the clarification!
(Also extra point the fixes tag will match the driver)

-- 
	Ansuel
