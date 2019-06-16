Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9274757D
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 17:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfFPPYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 11:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbfFPPYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 Jun 2019 11:24:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74322216FD;
        Sun, 16 Jun 2019 15:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560698649;
        bh=3mpTj/i03TZrHLI07mdmhJvVURUjNgKvb6BbfeCAAqA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vOczlg8PIQhMsk0/lYdnbEcoO7eOc+DaYylJj+HbLVuzl7kPI4kzj75gzEOX4WPES
         ZiCc+K1hwJvvuowRk72fa1yfbnKFgJD+eOcTuOFn11TJm9IAUrlMwm5vqSjyEfpVlP
         qj57OX/uBIdv/y0R4c+hvc4ejgn8x2qmhppKtGo0=
Date:   Sun, 16 Jun 2019 17:24:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: Build failure in v4.4.y-queue
Message-ID: <20190616152407.GB16197@kroah.com>
References: <88e25ca4-9e77-74b7-4466-2477cb07ce20@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88e25ca4-9e77-74b7-4466-2477cb07ce20@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 16, 2019 at 07:01:57AM -0700, Guenter Roeck wrote:
> Building um:defconfig ... failed
> --------------
> Error log:
> kernel/time/Kconfig:155:warning: range is invalid
> /opt/buildbot/slave/stable-queue-4.4/build/arch/um/kernel/time.c:59:14: error: initializer element is not constant
>   .cpumask  = cpu_possible_mask,
> 
> Caused by commit 502482cde8ab ("uml: fix a boot splat wrt use of cpu_all_mask"),
> which fixes a problem which does not exist in v4.4.y.

Now dropped, thanks.

greg k-h
