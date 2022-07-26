Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90BB5815BC
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 16:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238880AbiGZOy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 10:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbiGZOy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 10:54:26 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [217.70.178.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B9F2A73A;
        Tue, 26 Jul 2022 07:54:24 -0700 (PDT)
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A884A20000A;
        Tue, 26 Jul 2022 14:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1658847262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Vl9dAzKmdzMw7JCXJnHE4Fod2FK/hx9X5jnLIYwfFI=;
        b=cJw0LbyGLtglgby91y7FMBnYElUiKjfTs+YroBsAZ/iH0Wkkg106cit43pBgyr7UbtbT1H
        yfGUyxBuxt0eWYLe03QPuTjqGGuVpVxPCRli52lsNFuESTVuhxOpYsB7rf8pm23rkOp92k
        rURS7gvHPLEXTlc87ti2GNrzIoW+ccVysIHgDYpXT2rs2YTYOnLS/w/YZ+L1K88ZxjK7P7
        p47PVl8xXbpd5BU6MANHhibFHvhQWtfcNDoesonFuNxCUZ+FBRHlI2W6suKz+f9HS8627V
        dm+3XFCbQCwyIq52fbEkZhmYiQoMcRH1SIwUz8cKx4uABEg9yPuUGOBgdzUxtA==
Date:   Tue, 26 Jul 2022 16:54:19 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     a.zummo@towertech.it, linux-rtc@vger.kernel.org,
        matt@traverse.com.au
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] rtc: rx8025: fix 12/24 hour mode detection on RX-8035
Message-ID: <165884722628.3161296.5974966086195813215.b4-ty@bootlin.com>
References: <20220706074236.24011-1-matt@traverse.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706074236.24011-1-matt@traverse.com.au>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 6 Jul 2022 07:42:36 +0000, Mathew McBride wrote:
> The 12/24hr flag in the RX-8035 can be found in the hour register,
> instead of the CTRL1 on the RX-8025. This was overlooked when
> support for the RX-8035 was added, and was causing read errors when
> the hour register 'overflowed'.
> 
> To deal with the relevant register not always being visible in
> the relevant functions, determine the 12/24 mode at startup and
> store it in the driver state.
> 
> [...]

Applied, thanks!

[1/1] rtc: rx8025: fix 12/24 hour mode detection on RX-8035
      commit: 71af91565052214ad86f288e0d8ffb165f790995

Best regards,

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
