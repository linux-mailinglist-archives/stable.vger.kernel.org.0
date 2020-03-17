Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9DF187E21
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgCQKU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbgCQKU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:20:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64F80205ED;
        Tue, 17 Mar 2020 10:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584440457;
        bh=b/MTT1LbFBIYeqBe0/k2r8yUIJpdk1fnTFehUfamc1I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kahXz4FZMlhr7xCqUtWkn0N8gWot8nvQU2pfuxbwQUa9AjfTwUAM4IYN6BZbHG5na
         hovyD+I9XO8tUo5D5AfsyIhpKpVvdjJBTT1xdMXzd3FXqCIzFGPDg434+zVAntyIvq
         klx+j05T+E06yWL8hea8LWryrKuc6p1fGUGqgzA0=
Date:   Tue, 17 Mar 2020 11:19:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/24] batman-adv: Pending fixes
Message-ID: <20200317101957.GA1130294@kroah.com>
References: <20200316223105.6333-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 16, 2020 at 11:30:41PM +0100, Sven Eckelmann wrote:
> Hi,
> 
> I was asked by Greg KH to check for missing fixes in linux 4.9.y and provide
> backports for it. I've ended up with a lot more missing patches than
> I've expected. Not sure why these were missing but I couldn't find them at
> the moment in any stable release for 4.9.y. Feel free to check for things
> which I've missed too.

All now queued up, thanks!

greg k-h
