Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB105E5BB6
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 08:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiIVG7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 02:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiIVG7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 02:59:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56394B6D76;
        Wed, 21 Sep 2022 23:59:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFEE7B82748;
        Thu, 22 Sep 2022 06:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10556C433C1;
        Thu, 22 Sep 2022 06:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663829944;
        bh=LkOfiXS8DzcdT8MAp1XGqo0docBpokRUmM/Rlp4siGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OfozlvThpEpSspZsIFcjWlOw9Za+8IIWfXYIwi1J4aqcuXzk+CANhMearP1lQY+Aw
         v501SEERtnbAC7pJ1O0MNxurWDGB7YMc2wk6W5HvrupxCqe/j8huRci+3mIYjBlOsQ
         qTRfHLFPJ3mWkhHwTbezO4Il5Eg/7DEG0YsUOk8s=
Date:   Thu, 22 Sep 2022 08:59:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH 5.10 25/39] Revert "serial: 8250: Fix reporting real
 baudrate value in c_ospeed field"
Message-ID: <YywH1v2EB7CPnCww@kroah.com>
References: <20220921153645.663680057@linuxfoundation.org>
 <20220921153646.560456712@linuxfoundation.org>
 <20220921200502.GA32055@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921200502.GA32055@duo.ucw.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 10:05:02PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Johan Hovold <johan@kernel.org>
> > 
> > commit d02b006b29de14968ba4afa998bede0d55469e29 upstream.
> > 
> > This reverts commit 32262e2e429cdb31f9e957e997d53458762931b7.
> > 
> > The commit in question claims to determine the inverse of
> > serial8250_get_divisor() but failed to notice that some drivers override
> > the default implementation using a get_divisor() callback.
> 
> I believe it would be better to remove bad commit and its revert,
> since it was not yet released.

No, our tools keep picking the original up as "hey, you missed this
one!", so I just added the revert here to make sure all is good going
forward.

thanks,

greg k-h
