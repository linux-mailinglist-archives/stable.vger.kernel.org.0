Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D695D316E6
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 00:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfEaWFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 18:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfEaWFr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 18:05:47 -0400
Received: from localhost (unknown [8.46.75.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7DBE26F7F;
        Fri, 31 May 2019 22:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559340347;
        bh=uyLqSEX0M2+6qLAqytbef3v0pQzToAhZXcW7pWwq6A0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JIhp4cm3zD1zhoEmpOoSECnmKncKJT9TsF8AKj/k9kbTqlJe5Yq/C0GIWuNWYV6Ix
         /oFun52v4huXht/tjxt/DfpAh+diux5+fqmG645StBJDT8OKW1dnBmB7XK39kdqwGP
         tuU+he0ei3WkSgF08aT7ssWjWtMqJWG7m/gf68nM=
Date:   Fri, 31 May 2019 15:05:35 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Soeren Moch <smoch@web.de>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "usb: core: remove local_irq_save() around
 ->complete() handler"
Message-ID: <20190531220535.GA16603@kroah.com>
References: <20190531215340.24539-1-smoch@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531215340.24539-1-smoch@web.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 31, 2019 at 11:53:40PM +0200, Soeren Moch wrote:
> This reverts commit ed194d1367698a0872a2b75bbe06b3932ce9df3a.
> 
> In contrast to the original patch description, apparently not all handlers
> were audited properly. E.g. my RT5370 based USB WIFI adapter (driver in
> drivers/net/wireless/ralink/rt2x00) hangs after a while under heavy load.
> This revert fixes this.

Why not just fix that driver?  Wouldn't that be easier?

thanks,

greg k-h
