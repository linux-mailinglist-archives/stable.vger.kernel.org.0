Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5795A48B627
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 19:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345719AbiAKSyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 13:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245171AbiAKSyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 13:54:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE494C06173F;
        Tue, 11 Jan 2022 10:54:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A569B81D19;
        Tue, 11 Jan 2022 18:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99385C36AE3;
        Tue, 11 Jan 2022 18:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641927247;
        bh=Oy/P53cZ10GPwI0alv0HEevmcdSYD8f8MCuQGIjjDZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yi0luIRp9EJwDrDYG0QiFrswTXl9GFjwoAjkpmecPqYtbZ199TWlnnNg/Btk+DQZQ
         Q3KNKJ2wpmbH04wmPgDad14Gl7o43x2hhxSphNhwSoQwMyHyDCQAw5Ku8dbkUSj7sV
         +yEW7u9p5mlxjBOVJehuieITKUTT8VQ+0rAVYrH8=
Date:   Tue, 11 Jan 2022 19:54:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guillaume Morin <guillaume@morinfr.org>
Cc:     linux-raid@vger.kernel.org, stable@vger.kernel.org,
        guoqing.jiang@linux.dev, artur.paszkiewicz@intel.com
Subject: Re: [md] Missing revert in 5.10
Message-ID: <Yd3STJyOHVBz8zUo@kroah.com>
References: <Yd3PDbLH4v5Ea682@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd3PDbLH4v5Ea682@bender.morinfr.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 07:40:13PM +0100, Guillaume Morin wrote:
> 41d2d848e5c0 ("md: improve io stats accounting") was added during the
> 5.9 cycle and therefore is present in the 5.10 branch. This patch was
> then reverted in mainline during the 5.14 cycle (ad3fc798800f) due to
> report of double faults [1].
> 
> However the revert was not picked up for the 5.10 branch. I believe it
> should be queued up.
> 
> Unfortunately, 41d2d848e5c0 in 5.10 cannot be reverted cleanly because
> of the later changes in 00fe60eae94. The mainline 5.14 revert commit
> also does not apply cleanly on 5.10 because 99dfc43ecbf6 is not in 5.10.
> Manually merging the revert is trivial though (I could provide the patch
> I've been testing if that's helpful).

Please provide a working revert and we will be glad to queue it up.

thanks,

greg k-h
