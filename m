Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD48E141EED
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 16:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgASPvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 10:51:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgASPvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Jan 2020 10:51:50 -0500
Received: from localhost (unknown [84.241.197.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 615A420679;
        Sun, 19 Jan 2020 15:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579449110;
        bh=pH4zHIYMH+RYfutX/BxK/DKPgQLnsGFzBAUFRQtPKW8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sVhAd7D3ZNPT0rOHfQKkAIVYZ3fEVQv1oLvI/WUa25vQPak+gOWMNgcA2Z+poCx3K
         42hmb3KlC84fdYaw1qmJrGJ0aDF3CrgW25adWUgGO1lvkSJM1pT5Yy+haHMlDSSeNT
         mydamPj7qMHmH4hHAYj81a69niRslii2B95qn8x0=
Date:   Sun, 19 Jan 2020 16:51:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     johan@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] USB: serial: keyspan: handle unbound
 ports" failed to apply to 4.9-stable tree
Message-ID: <20200119155146.GA345231@kroah.com>
References: <157944127621242@kroah.com>
 <20200119154733.GR1706@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119154733.GR1706@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 19, 2020 at 10:47:33AM -0500, Sasha Levin wrote:
> On Sun, Jan 19, 2020 at 02:41:16PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From 3018dd3fa114b13261e9599ddb5656ef97a1fa17 Mon Sep 17 00:00:00 2001
> > From: Johan Hovold <johan@kernel.org>
> > Date: Fri, 17 Jan 2020 10:50:25 +0100
> > Subject: [PATCH] USB: serial: keyspan: handle unbound ports
> > 
> > Check for NULL port data in the control URB completion handlers to avoid
> > dereferencing a NULL pointer in the unlikely case where a port device
> > isn't bound to a driver (e.g. after an allocation failure on port
> > probe()).
> > 
> > Fixes: 0ca1268e109a ("USB Serial Keyspan: add support for USA-49WG & USA-28XG")
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable <stable@vger.kernel.org>
> > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Grabbing the prerequisite for the other USB patch also resolved the
> conflict here, now queued for 4.9 and 4.4.

Thanks for this and the other fixups you're doing here, much
appreciated.

greg k-h
