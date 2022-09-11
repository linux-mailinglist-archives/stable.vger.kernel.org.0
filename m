Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E475B4D60
	for <lists+stable@lfdr.de>; Sun, 11 Sep 2022 12:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiIKK3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 06:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiIKK3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 06:29:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FCF18E30;
        Sun, 11 Sep 2022 03:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46F82B802BD;
        Sun, 11 Sep 2022 10:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0249C433C1;
        Sun, 11 Sep 2022 10:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662892188;
        bh=DTHSVzIVYT+Qx+wDPENBufz6OmfYkreG9a7uUW6kU4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bYQdGOwyAcJT73nNItJvtRQ0EaJWHooqWpZYticV6CUO1FbwIx+GVK4cxoT4x1FLw
         /u/Y9gV091QnuawKiRUJy5tqBxiPx6Luf9GhqpYtMAZtXJ6Vmu8wsBPNr11S3LaZHs
         LTf6Ntn88Yf1kh35l8Ln7fLWqefly8hm371JOYHIPXzdLe0Yo2CWmT5IZGNynNpxU2
         7J7E6ucDKN7YlNvuK0D61dzdq4UrIc/5Qi5orKMhW0iaPihHdgr1wAq6/Z7/+VjjSQ
         Af7q8hQyACPRaD8tQ3z5PunTcU3yr4/7qhzPQY6MeIXQgaRC+cSwheEhhxzoXtUcYY
         EUUw0isJYLwtw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oXKDr-0000wH-MQ; Sun, 11 Sep 2022 12:29:55 +0200
Date:   Sun, 11 Sep 2022 12:29:55 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-4.19 0/4] USB: backports to 4.19
Message-ID: <Yx24o3VLE7bv0spk@hovoldconsulting.com>
References: <20220906134915.19225-1-johan@kernel.org>
 <Yx11oB0C3h7D6I2H@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yx11oB0C3h7D6I2H@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 11, 2022 at 07:44:00AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 06, 2022 at 03:49:11PM +0200, Johan Hovold wrote:
> > And here are the corresponding backports to 4.19.
> > 
> > Johan
> > 
> > 
> > Johan Hovold (4):
> >   usb: dwc3: fix PHY disable sequence
> >   usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup
> >   USB: serial: ch341: fix lost character on LCR updates
> >   USB: serial: ch341: fix disabled rx timer on older devices
> > 
> >  drivers/usb/dwc3/core.c      | 19 ++++++++++---------
> >  drivers/usb/dwc3/dwc3-qcom.c | 14 +++++++++++++-
> >  drivers/usb/dwc3/host.c      |  1 +
> >  drivers/usb/serial/ch341.c   | 15 +++++++++++++--
> >  4 files changed, 37 insertions(+), 12 deletions(-)
> 
> All backports now queued up, many thanks for doing these.

I believe you can apply the two ch341 backports also to 4.14.

Johan
