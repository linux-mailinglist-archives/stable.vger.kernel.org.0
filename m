Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4675EAD9A
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiIZRG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiIZRGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:06:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096F356BA0;
        Mon, 26 Sep 2022 09:11:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3148CB80AE3;
        Mon, 26 Sep 2022 16:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0BAC433C1;
        Mon, 26 Sep 2022 16:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664208671;
        bh=3eU5TmEiyjEpeYYnFYxutd+Pf+feUB53l0kDy7AoQ04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vl2Ftk7lxkZ1NtjOonMv7Sd4HVjUHdURD1DBu7mI23yE/7GGbPUzisIE/Wb+7Dclz
         MKFQHFEPCrBxWlk8aWnbfXWz09hE/fzdOhrQ8aDS7zaNtpex/YUVQqeMRfSRBsHQO2
         GKfx6K3xIM2gx9foc1Rw0+yp+y+xqswosJKAX044=
Date:   Mon, 26 Sep 2022 18:11:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Melissa Wen <mwen@igalia.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 03/30] drm/vc4: crtc: Use an union to store the page
 flip callback
Message-ID: <YzHPHB/J/n7dThPd@kroah.com>
References: <20220926100736.153157100@linuxfoundation.org>
 <20220926100736.283415181@linuxfoundation.org>
 <20220926103759.GC8978@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926103759.GC8978@amd>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 12:38:00PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Maxime Ripard <maxime@cerno.tech>
> > 
> > [ Upstream commit 2523e9dcc3be91bf9fdc0d1e542557ca00bbef42 ]
> > 
> > We'll need to extend the vc4_async_flip_state structure to rely on
> > another callback implementation, so let's move the current one into a
> > union.
> 
> AFAICT this is preparation, not a bugfix; and I don't see patch this
> prepares for queued. So we should not have this one, either.

Dropped.

For some reason we had a bunch of 4.9-only patches that were not in any
other stable tree, so they shouldn't have only gone to 4.9.  I'll review
them all again and then push out a -rc2.

thanks,

greg k-h
