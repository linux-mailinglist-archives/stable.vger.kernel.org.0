Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEDD310538
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 07:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhBEGxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 01:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231314AbhBEGxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 01:53:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C517064DD6;
        Fri,  5 Feb 2021 06:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612507954;
        bh=13RKzPIthbeuEKO976rvEHlOAKHIalGKFo8bQQrWTbs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2DQCQmjuJrwIn+06zEbKwMRsiv3HlJ2uJD8rH2HuB3+RwerS9llpXJg0LEhny+xZV
         Aryk7sTNmPcxyRZaP6IfGCOhYdpYvdUib1d2qlRczRygCwNWT01RdwUrA4bJ0J6qTg
         Kd6nMLbXr4BH7aauJJqF9tEYiGrd7or/munf4q7w=
Date:   Fri, 5 Feb 2021 07:52:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Kernel version numbers after 4.9.255 and 4.4.255
Message-ID: <YBzrL/NS0vVeTe0/@kroah.com>
References: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
 <YBuSJqIG+AeqDuMl@kroah.com>
 <78ada91b-21ee-563f-9f75-3cbaeffafad4@kernel.org>
 <YBu1d0+nfbWGfMtj@kroah.com>
 <a85b7749-38b2-8ce9-c15a-8acb9a54c5b5@kernel.org>
 <b17b4c3b2e4b45f9b10206b276b7d831@AcuMS.aculab.com>
 <1612468714@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612468714@msgid.manchmal.in-ulm.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 09:19:33PM +0100, Christoph Biedl wrote:
> David Laight wrote...
> 
> > A full wrap might catch checks for less than (say) 4.4.2 which
> > might be present to avoid very early versions.
> > So sticking at 255 or wrapping onto (say) 128 to 255 might be better.
> 
> Hitting such version checks still might happen, though.

By who?  For what?

> Also, any wrapping introduces a real risk package managers will see
> version numbers running backwards and therefore will refrain from
> installing an actually newer version.

package managers do not take the version from this macro, do they?  If
they do, please show me which ones.

thanks,

greg k-h
