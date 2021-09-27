Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCA84199C6
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 18:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbhI0Q6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 12:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235316AbhI0Q63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 12:58:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20CCD60F3A;
        Mon, 27 Sep 2021 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632761811;
        bh=G8mwtJ4TE4xA22If+xuDqtpIjJGXqHaf5v84caXWOPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2G04AAom/Fh8EgwBah3pXo8j8Wx+b/w/onV8ESq9YDCP2H4HmSGtqxuzUf0B43ETe
         oZy2X9ORuKQzw0KCiMQgwToai/9mx4mk2CN61c1BPdbP05JIwE6GujkxlVOi5lHF+g
         jKFsxzqbf+tMrLZY2I1yZ+M59jEjmVRFmvKV7hWk=
Date:   Mon, 27 Sep 2021 18:56:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jack Pham <jackp@codeaurora.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable-5.14 2/2] usb: gadget: f_uac2: Populate SS
 descriptors' wBytesPerInterval
Message-ID: <YVH3yzBL8+HE+gtd@kroah.com>
References: <20210927161253.10977-1-jackp@codeaurora.org>
 <20210927161253.10977-2-jackp@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927161253.10977-2-jackp@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 09:12:53AM -0700, Jack Pham wrote:
> commit f0e8a206a2a53a919e1709c654cb65d519f7befb upstream.
> 
> For Isochronous endpoints, the SS companion descriptor's
> wBytesPerInterval field is required to reserve bus time in order
> to transmit the required payload during the service interval.
> If left at 0, the UAC2 function is unable to transact data on its
> playback or capture endpoints in SuperSpeed mode.
> 
> Since f_uac2 currently does not support any bursting this value can
> be exactly equal to the calculated wMaxPacketSize.
> 
> Tested with Windows 10 as a host.
> 
> Fixes: f8cb3d556be3 ("usb: f_uac2: adds support for SS and SSP")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Jack Pham <jackp@codeaurora.org>
> Link: https://lore.kernel.org/r/20210909174811.12534-3-jackp@codeaurora.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [jackp: Backport to 5.14 with minor conflict resolution]

Both now queued up, thanks.

greg k-h
