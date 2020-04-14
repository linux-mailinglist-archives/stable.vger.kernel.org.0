Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A4D1A7A70
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 14:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439940AbgDNMOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 08:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729799AbgDNMOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 08:14:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27A8820732;
        Tue, 14 Apr 2020 12:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586866454;
        bh=ww/tUopAhzBG3g7l2JnC7wSR+DOAcc+XJW7NSVkDjLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KufTQlqjdE8WTVTC2UTJv98SJJMeL9SNFvbPBmydOiE2+w/6uYLAs3bUiTT5BAaZ4
         u/Esr+KBO9HZT65Hic/PTr2Gcw8owtkhTouZsopquvsngtsQBMHrXz6o0W1Ci7DfSw
         SJTcrI62RXkW2udl7Jz+hMMprNzJ0HKtmvqWUlEo=
Date:   Tue, 14 Apr 2020 14:14:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>
Subject: Re: printk: queue wake_up_klogd irq_work only if per-CPU areas are
 ready
Message-ID: <20200414121412.GA605766@kroah.com>
References: <20200414120613.GD12779@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414120613.GD12779@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 09:06:13PM +0900, Sergey Senozhatsky wrote:
> Hello,
> 
> Commit ab6f762f0f53162d41 Linus' HEAD.
> 
> printk_deferred() does not make sure that it's safe to write to
> per-CPU data, which causes problems when printk_deferred() is
> invoked "too early", before per-CPU areas are initialized. There
> are multiple bug reports, e.g.
> https://bugzilla.kernel.org/show_bug.cgi?id=206847
> 
> 	-ss

So where do you want this commit backported to?

thanks,
greg k-h
