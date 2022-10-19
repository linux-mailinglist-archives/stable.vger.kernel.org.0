Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F4660452E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbiJSMXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiJSMWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:22:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743371C5A6D;
        Wed, 19 Oct 2022 04:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BCCDB8229E;
        Wed, 19 Oct 2022 10:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E418C433C1;
        Wed, 19 Oct 2022 10:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666176094;
        bh=mG+uroAC6bYwRkAFZgwJA22HVgUMDCYnJfDtypyCTw4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HE9QGUGdXfJFexAW0Sf9oroR0Kived9CpVY1PG9TRbdOJ7EuHPzkZUA7dxLiTusri
         XK5PaRf02SgaNEQ8GJEngJte9qsHQcb1YhGP5jOc67oAtUuu+eYLywrUOK+voz3hAD
         HYnI/R2bgkqkWUniCt0GtcYC0S3BNqPJ+/sYFQks=
Date:   Wed, 19 Oct 2022 12:41:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 523/862] phy: qcom-qmp-pcie: add pcs_misc sanity check
Message-ID: <Y0/UW4QzVmg+zyPY@kroah.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083313.087411998@linuxfoundation.org>
 <Y0/AM9F1CmAykhGI@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0/AM9F1CmAykhGI@hovoldconsulting.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 11:15:31AM +0200, Johan Hovold wrote:
> On Wed, Oct 19, 2022 at 10:30:10AM +0200, Greg Kroah-Hartman wrote:
> > From: Johan Hovold <johan+linaro@kernel.org>
> > 
> > [ Upstream commit ecd5507e72ea03659dc2cc3e4393fbf8f4e2e02a ]
> > 
> > Make sure that the (otherwise) optional pcs_misc IO region has been
> > provided in case the configuration specifies a corresponding
> > initialisation table to avoid crashing with malformed device trees.
> > 
> > Note that the related debug message is now superfluous as the region is
> > only used when the configuration has a pcs_misc table.
> > 
> > Fixes: 421c9a0e9731 ("phy: qcom: qmp: Add SDM845 PCIe QMP PHY support")
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > Link: https://lore.kernel.org/r/20220916102340.11520-2-johan+linaro@kernel.org
> > Signed-off-by: Vinod Koul <vkoul@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This was added to prevent future bugs when adding support for new
> platforms and did not have a stable tag. Please drop.

Ok, that wasn't obvious at all from the changelog :(

I'll go drop this, and the others you marked as "should not be there"
from the queue, thanks.

Maybe next time, don't use a Fixes: tag if the commit really doesn't
"fix" anything in the current kernel...

thanks,

greg k-h
