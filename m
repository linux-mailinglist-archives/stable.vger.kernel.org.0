Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D65B1F6666
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 13:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgFKLRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 07:17:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbgFKLRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 07:17:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B6662063A;
        Thu, 11 Jun 2020 11:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591874250;
        bh=ZSYZmXkfqEM3hd5tJHnJtCy1cFu4oAcHdJVjPBIsios=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HELAFOa77IpCarkqCzLvwd2+yzIUbzLAgsuiEqK6hCBi7CtXRUv80Suy0bHCjEm6A
         Y98XF55DnXp9vPoLEbbspXvJorLlQTDQR+p+TSQwe4c0Uy+qEqfOEsYEfHbvip3Aih
         dPmTuR/Mwu4unz6e9EuYV754cG5z1R/cVHH2lC7I=
Date:   Thu, 11 Jun 2020 13:17:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Chase <jnchase@google.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org
Subject: Re: Please apply commit 7b06a6909555 ("igb: improve handling of
 disconnected adapters") to v4.4.y/v4.9.y
Message-ID: <20200611111723.GH3802953@kroah.com>
References: <CALTkaQ1ABhqF2hS=SsUrJ5BgTCc-=JDhCMK_hbR=0DAKvDGmfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALTkaQ1ABhqF2hS=SsUrJ5BgTCc-=JDhCMK_hbR=0DAKvDGmfg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 05:02:15PM -0700, Jeff Chase wrote:
> Hi,
> 
> Please apply upstream commit 7b06a6909555 ("igb: improve handling of
> disconnected adapters") to v4.4.y and to v4.9.y. It fixes a kernel
> panic observed in chromeos-4.4.

As that commit showed up in 4.5, how can it also work in 4.9.y?  :(

I'll queue it up for 4.4...

thanks,

greg k-h
