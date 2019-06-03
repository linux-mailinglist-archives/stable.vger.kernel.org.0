Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E403392C
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 21:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfFCTk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 15:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbfFCTk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 15:40:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAECD266DF;
        Mon,  3 Jun 2019 19:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559590857;
        bh=miHGtuBA3UVIyWCLcFGNaCgjBeN4i7RgajZReGrYwgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yejRsJFt+1avbc1/TFlmD5btBVz8hCgUZdkfc8hCLaAapeO2T8D/iDPhCo/SL5bLS
         6RXWgSmw2ED+gO9gtojrABksSU1JreqpilGL8xQ+Po00iVfByBZcpzUDgfcJW+OlaG
         iDEutqu01awqqRBlRDdb4Moo7FrxFEUMgV7XJ3co=
Date:   Mon, 3 Jun 2019 21:40:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Raul Rangel <rrangel@chromium.org>
Cc:     mathias.nyman@linux.intel.com, andrew.smirnov@gmail.com,
        stable@vger.kernel.org
Subject: Re: patch "xhci: Convert xhci_handshake() to use
 readl_poll_timeout_atomic()" added to usb-linus
Message-ID: <20190603194054.GA17062@kroah.com>
References: <155852804916633@kroah.com>
 <20190603190538.GA164323@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603190538.GA164323@google.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 01:05:38PM -0600, Raul Rangel wrote:
> Mathias,
> Are there any plans to backport this to the other kernels?
> 
> Looks like it landed upstream as f7fac17ca925faa03fc5eb854c081a24075f8bad

That is what the stable@ tag will cause to have happen.  Give it some
time...

thanks,

greg k-h
