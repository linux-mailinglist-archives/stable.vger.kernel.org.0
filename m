Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4BA21F00A
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 14:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgGNMFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 08:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726748AbgGNMFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 08:05:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2BF522224;
        Tue, 14 Jul 2020 12:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594728307;
        bh=B4BRyWXYvvNkFA7USfvVX2MX2eMmEtTlHR5h7rMAFBw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JD1vKmu+sxcOXrGzEW/wg2xf3M2dntRndHqn0EqcicRsVx2mfoRbGuWYo7hXv/7Vh
         vq+GaHHXKpyba6GAvaN7DnBpjL7ttxt+N0+Q1tO5+yf5ETZv3wimQIQNppWk9Rcw9d
         R16ndrPOpTsBEL6OHxjAs0GthqxCFU/vdD8zME9M=
Date:   Tue, 14 Jul 2020 14:05:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: Please revert "ath9k: Fix general protection fault in
 ath9k_hif_usb_rx_cb" from all stable kernels
Message-ID: <20200714120505.GA1547259@kroah.com>
References: <2a5acaae-9aef-1aab-d385-0dd11d151fa6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a5acaae-9aef-1aab-d385-0dd11d151fa6@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 14, 2020 at 11:58:36AM +0200, Hans de Goede wrote:
> Hi Greg (et all),
> 
> Note several people are already working on this, so you may already have a request for this.
> 
> The "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb" commit which has been
> added to several stable kernels (at least to 5.4.y and 5.7.y, but likely also to others)
> is breaking networking for people with an ath9k card.
> 
> A revert has been submitted upstream, but it does not seem to have found it way
> upstream yet. It has been cherry-picked by the Arch people:
> 
> https://git.archlinux.org/linux.git/commit/?h=v5.7.8-arch1&id=1a32e7b57b0b37cab6845093920b4d1ff94d3bf4
> 
> So if you want to credit some of the original people working on fixing this,
> you can find the revert submitted upstream there.
> 
> Reverting this fixes / also see:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=208251
> https://bugzilla.redhat.com/show_bug.cgi?id=1848631

Now reverted, thanks!

greg k-h
