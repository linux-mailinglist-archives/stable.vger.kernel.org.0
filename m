Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582DA341981
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 11:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbhCSKHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 06:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229986AbhCSKHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 06:07:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C64B60235;
        Fri, 19 Mar 2021 10:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616148427;
        bh=1nK8tkKbT7gec5k+luR9T4YOrBq1TSo4XR82ybKJb1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NTC9lAjFwN15SOP/xQm2Mdi5wVN38bhclHRrEOdvQ8Mm41z6Qk2nKZPz6NdOnIbr7
         GtxNv2DfEnTQ4VIIhMOaIyoda2JvHQMc4woBIrsMRUyf8MrB0R/jUfXmifG86SFk58
         bxsPUmciIJv1Py4EDk8YmRwwlVT1i4uWr35OI0Q4=
Date:   Fri, 19 Mar 2021 11:07:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     tiwai@suse.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ALSA: usb-audio: Don't avoid stopping the
 stream at" failed to apply to 5.10-stable tree
Message-ID: <YFR3yJV3rvgC4ktO@kroah.com>
References: <161459255713788@kroah.com>
 <YE+6xtgW4Jq+c14P@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE+6xtgW4Jq+c14P@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 07:51:34PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Mar 01, 2021 at 10:55:57AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Now applied, thanks.

greg k-h
