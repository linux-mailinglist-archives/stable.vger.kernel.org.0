Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36443DC3EF
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 08:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhGaG3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 02:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232049AbhGaG3Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Jul 2021 02:29:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBFB660D07;
        Sat, 31 Jul 2021 06:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627712949;
        bh=qB2Wy8qiHb0MYp5dIQ4CdQ5opxLsEZcT26fWLEqUk/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GFhUxOXSeDsOCWe+4dCcq8iLYiNDGjEItMUY8S6+uSHW4HpJpm0mRCuxJ/l1SOlpU
         /gDOG8yXG0jxiKQpOXRmW6eIGj6mRdTyoDpvWR1eHTakkHNtMrRGLGl5uCLb4z593r
         YczRidAee64QJDlWvOtrRO7pN/z+yJ+bimMVlsjM=
Date:   Sat, 31 Jul 2021 08:29:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Javier Pello <javier.pello@urjc.es>
Cc:     stable@vger.kernel.org
Subject: Re: Patch "Kernel oopses on ext2 filesystems after 782b76d7abdf"
Message-ID: <YQTts7zkCcuG/Psu@kroah.com>
References: <20210730122532.6966a03a1d2e07b81486e0f4@urjc.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730122532.6966a03a1d2e07b81486e0f4@urjc.es>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 12:25:32PM +0200, Javier Pello wrote:
> Dear list,
> 
> The current 5.13 stable kernel branch oopses when handling ext2
> filesystems, and the filesystem is not usable, sometimes leading
> to a panic.
> 
> The bug was introduced during the 5.13 development cycle.
> A complete analysis can be found here:
> https://lore.kernel.org/linux-ext4/20210713165821.8a268e2c1db4fd5cf452acd2@urjc.es/T/
> 
> A fix for this bug has been recently merged into the mainline
> kernel, with commit id 728d392f8a799f037812d0f2b254fb3b5e115fcf.
> 
> The 5.13 branch is the only one affected by this bug.

Now queued up, thanks.

greg k-h
