Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C60F5EAD63
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiIZQ7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiIZQ7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:59:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC090295;
        Mon, 26 Sep 2022 08:58:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73446B80B04;
        Mon, 26 Sep 2022 15:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8B2C433C1;
        Mon, 26 Sep 2022 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664207932;
        bh=6goCMhp0QclAXt8SDNg2O5UCNbJOnZFpxY/FtGz5WHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yaLQTID+rUCem2Q3DIN6ZNB8PCdOP3iNmY4UbDsFmSpjDxgNiPQZavy0oShSRep5G
         t1egDJB8itUlUIbTwmywm3LmGmj3qhdYa9C/BN0fcVPE4l+efMOOylkgRUL+NN9iuD
         TQSDipX1D3tg0L4WEbmIKhk5+uBzFJdUbj479vfU=
Date:   Mon, 26 Sep 2022 17:58:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 097/120] gpio: ixp4xx: Make irqchip immutable
Message-ID: <YzHMOXeCyc1LTlhZ@kroah.com>
References: <20220926100750.519221159@linuxfoundation.org>
 <20220926100754.551266309@linuxfoundation.org>
 <86a66m8lml.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a66m8lml.wl-maz@kernel.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 06:40:02AM -0400, Marc Zyngier wrote:
> Greg,
> 
> On Mon, 26 Sep 2022 06:12:10 -0400,
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > From: Linus Walleij <linus.walleij@linaro.org>
> > 
> > [ Upstream commit 94e9bc73d85aa6ecfe249e985ff57abe0ab35f34 ]
> > 
> > This turns the IXP4xx GPIO irqchip into an immutable
> > irqchip, a bit different from the standard template due
> > to being hierarchical.
> > 
> > Tested on the IXP4xx which uses drivers/ata/pata_ixp4xx_cf.c
> > for a rootfs on compact flash with IRQs from this GPIO
> > block to the CF ATA controller.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > Acked-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> We had that discussion[1], and concluded that none of these should be
> backported to a kernel earlier than 5.19. 5.4 doesn't currently
> contain the relevant infrastructure, nor should that infrastructure
> should be backported either.
> 
> Can we *please* stop this?
> 
> 	M.
> 
> [1] https://lore.kernel.org/all/CAMRc=Md9JKdW8wmbun_0_1y2RQbck7q=vzOkdw6n+FBgpf0h8w@mail.gmail.com/

Sasha, what went wrong here?

Now dropped from all but 5.19.y, thanks.

greg k-h
