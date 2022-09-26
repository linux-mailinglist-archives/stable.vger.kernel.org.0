Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4500C5EAD95
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiIZRGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiIZRF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:05:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CA3F50;
        Mon, 26 Sep 2022 09:09:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3BAB60E74;
        Mon, 26 Sep 2022 16:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A085AC433C1;
        Mon, 26 Sep 2022 16:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664208586;
        bh=ykYhIc6M2tRQzwR1tDW3Jjg8wCLBvIE8BAtYWkCg3FY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pCy0TOa0QZY7sehJe8EsZl9J7U8kEE9pIhDBvhonXCCCZ/xpBZ6KGRZFuvTz/CUSh
         hMXZBxMi6VvS8NutR38lKPpAYIUlzX6yquruXb2+HXT4Y5GEYR2zad7B7Y1cO6RNTu
         c3pycmA1TnI+o679sRcBz3JA77ar7SNRZLKUyv/Q=
Date:   Mon, 26 Sep 2022 18:09:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yihao Han <hanyihao@vivo.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 07/30] video: fbdev: simplefb: Check before clk_put()
 not needed
Message-ID: <YzHOx12p1v4LMcy9@kroah.com>
References: <20220926100736.153157100@linuxfoundation.org>
 <20220926100736.416842592@linuxfoundation.org>
 <20220926102926.GB8978@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926102926.GB8978@amd>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 12:29:26PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Yihao Han <hanyihao@vivo.com>
> > 
> > [ Upstream commit 5491424d17bdeb7b7852a59367858251783f8398 ]
> > 
> > clk_put() already checks the clk ptr using !clk and IS_ERR()
> > so there is no need to check it again before calling it.
> 
> This does not really fix any bug, so I'd preffer not to have it in
> stable.
> 

Now dropped, thanks.

greg k-h
