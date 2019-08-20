Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B52096652
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 18:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfHTQ1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 12:27:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726981AbfHTQ1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 12:27:40 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08E0B22CE3;
        Tue, 20 Aug 2019 16:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566318460;
        bh=GLxcVqdAsKKY2ZpZlybGf0ICy6d86ea47UFnD08IQR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dLQN5Y3ul3CJGiSLXWQ2zyuxpDhW98hriSENXmILwqzazLTS9YbOqypNaUa9BDWK7
         t5QWmSxIAM0D1r6dP/4kjatOsuHhuGIdQK/G/kaYwswDWyyQ64SXFFgfXlJfHlv+9Q
         E5pYc+DaaRnmJWY1XhtsUaVIIrc+qJkf4CGrbb7Y=
Date:   Tue, 20 Aug 2019 09:27:39 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org
Subject: Re: gcc 9.0 support in v4.4.y
Message-ID: <20190820162739.GE8214@kroah.com>
References: <20190819233809.GA13230@roeck-us.net>
 <20190820015043.GG30205@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820015043.GG30205@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 19, 2019 at 09:50:43PM -0400, Sasha Levin wrote:
> On Mon, Aug 19, 2019 at 04:38:09PM -0700, Guenter Roeck wrote:
> > Hi,
> > 
> > please consider applying the following two patches from v4.9.y to v4.4.y.
> > 
> > fe5844365ec6 ("Backport minimal compiler_attributes.h to support GCC 9")
> > 2c34c215c102 ("include/linux/module.h: copy __init/__exit attrs to init/cleanup_module")
> > 	(upstream commit a6e60d84989f)
> > 
> > ... to enable compiling v4.4.y with gcc 9.x.
> > 
> > This already works for the most part, but alpha:allmodconfig and
> > arm:allmodconfig fail to compile. The above two patches fix the problem.
> 
> Queued up, thanks!

THanks for this, my build results are _much_ nice looking now :)

greg k-h
