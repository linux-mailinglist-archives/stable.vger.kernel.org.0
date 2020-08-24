Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA3C24F39B
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgHXIFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgHXIFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:05:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D54CB2072D;
        Mon, 24 Aug 2020 08:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598256345;
        bh=iVOlCbNxKHbmrmyxNfKTenorZp5sM9JrS7B4LcsFOII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BTyyx1Pf6dYdPLwyvtC7Hge/KKITYfGhYMoVm6m5CU93XWaP/rA64QGROBBFaAttY
         aFqtvajEHt+LhtGaTLaVFV4ZUAJmVZpxWNktdbyh+EIRpbP+LBgKgtLnmFyL0mVFLW
         k0wQL7ReldOPdfIoJRCiak1MMM1gl//EOESP8R+8=
Date:   Mon, 24 Aug 2020 10:06:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [STABLE 4.4 to 5.4][PATCH 0/2] epoll fixes
Message-ID: <20200824080602.GA4176128@kroah.com>
References: <20200824080211.1037550-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824080211.1037550-1-maz@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 09:02:09AM +0100, Marc Zyngier wrote:
> Hi Greg,
> 
> Here's the backport for a couple of epoll fixes that don't cleanly
> backport to anything older than 5.7. These backports cleanly apply
> from 5.4 all the way to 4.4.

All now queued up, thanks for the backports!

greg k-h
