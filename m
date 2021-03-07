Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055023302A0
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 16:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhCGPVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 10:21:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230442AbhCGPUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 10:20:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BE55650F7;
        Sun,  7 Mar 2021 15:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615130427;
        bh=nXKxoUJjKVCIOOJHuc6luZfpOsvtjKJFXLxcmPHvaKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Px4Ob06xdkXmLCkMYOaaff/9bGwhMslNlWvbN4tVQHtdjTMJdNbQEe4xr30U5AckX
         U5y/hraSwyGte+bC5hXhUHN5PC57n3MWiJdazIiIQyCMxHBH9W0NQY3W6127o9F3GW
         wetChXsyEEzsMPT+h7YskYVewoBid7igLNJ5o14w=
Date:   Sun, 7 Mar 2021 16:20:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?utf-8?B?TWljaGHFgsKgTWlyb3PFgmF3?= <mirq-linux@rere.qmqm.pl>
Cc:     Linus Walleij <linus.walleij@linaro.org>, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: stable: KASan for ARM
Message-ID: <YETvOfBpfGrzewmt@kroah.com>
References: <20210307150040.GB28240@qmqm.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210307150040.GB28240@qmqm.qmqm.pl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 07, 2021 at 04:00:40PM +0100, Michał Mirosław wrote:
> Dear Greg,
> 
> Would you consider KASan for ARM patches for LTS (5.10) kernel? Those
> are 7a1be318f579..421015713b30 if I understand correctly. They are
> not normal stable material, but I think they will help tremendously in
> discovering kernel bugs on 32-bit ARMs.

Looks like a new feature to me, right?

How many patches, and have you tested them?  If so, submit them as a
patch series and we can review them, but if this is a new feature, it
does not meet the stable kernel rules.

And why not just use 5.11 or newer for discovering kernel bugs?  Why
does 5.10 matter here?

thanks,

greg k-h
