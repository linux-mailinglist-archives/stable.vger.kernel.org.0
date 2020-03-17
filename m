Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1A6187DED
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgCQKOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgCQKOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:14:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CDC5206EC;
        Tue, 17 Mar 2020 10:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584440081;
        bh=ZJBD52t1CTdeKzrCfyMpPNssQmVSACwGAdBVdFRetfo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z7DYY0Qb9F+5gnrbADt/ddh7IwhlSQEtFy7Kic6oSUVvtXV39ddUSfr4ldt+L1lQ+
         HvCu21DRJCMYZ6wLoMswVsubL0VWjqNrCdrdQV83QTyOwGjAt+NM8oxb4AJyz8tOff
         QfP8YCbOsoKqpfOrEdU2tXeHfdcWuU2jnJi++MEM=
Date:   Tue, 17 Mar 2020 11:14:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/15] batman-adv: Pending fixes
Message-ID: <20200317101438.GA1100468@kroah.com>
References: <20200316223032.6236-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316223032.6236-1-sven@narfation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 16, 2020 at 11:30:17PM +0100, Sven Eckelmann wrote:
> Hi,
> 
> I was asked by Greg KH to check for missing fixes in linux 4.14.y and provide
> backports for it. I've ended up with a lot more missing patches than
> I've expected. Not sure why these were missing but I couldn't find them at
> the moment in any stable release for 4.14.y. Feel free to check for things
> which I've missed too.

All now queued up, thanks!

greg k-h
