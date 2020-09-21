Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D54A272B03
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgIUQIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbgIUQIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:08:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3887820708;
        Mon, 21 Sep 2020 16:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600704500;
        bh=GmbYJ2QJbztbWXIFo9p8wQ7ckrhyNuUNfnJ9a1/ykGM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PsiiLU4px7ZQ5Gf+qNmgObePqVOTlXmmQpKeT3FiFHjsa745d8rq5mg0eOPRr822W
         TkfrrTAXLkU/W+3vo6oq/H9PohLdTQynTxTNK8IpqHEM0fzcP6Zdy693K0II27TaZ2
         OL8/NKSCMc9/c5OwSugfSu0Y0mlPc5DddhZapw3w=
Date:   Mon, 21 Sep 2020 18:08:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: Request for backporting 72a9c673636b
Message-ID: <20200921160843.GA1096614@kroah.com>
References: <CAHp75Vc=v3wOZB7GovW6zzrQFpFB=Rpn8deo-heBLcMzTzfzFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vc=v3wOZB7GovW6zzrQFpFB=Rpn8deo-heBLcMzTzfzFQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 07:01:26PM +0300, Andy Shevchenko wrote:
> Hi!
> 
> Can we backport the commit 72a9c673636b ("x86/defconfig: Enable
> CONFIG_USB_XHCI_HCD=y")?
> 
> Today I had experienced very well the exact problem described there in
> the commit message on v4.9.236.

Sure, now queued up.  DIdn't realize anyone still used the x86 defconfig
anymore :)

thanks,

greg k-h
