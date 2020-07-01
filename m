Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7918210454
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 08:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgGAGzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 02:55:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbgGAGzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 02:55:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 900F620663;
        Wed,  1 Jul 2020 06:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593586524;
        bh=QyxhO1k2rXqkl+v7MCtJlLRuWWr4xZLfxkTHcUyGmWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p7JLZjVdangjvXw7HSQK3AdTm42FN1teObpYrvL8EbJTHUBpHz4KKOhEHrsrs0mZN
         YTJiao46Ar+aKrW6ykt0FM7HzfuYIwT4DPzEVwcsfdYnGQpl8JMLSt39jKA/8XbEbj
         tMQicrME9R3Yu5S7cIzC3uQ0ER3pzh9TIChKEcFY=
Date:   Wed, 1 Jul 2020 08:55:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/59] 4.9.226-rc2 review
Message-ID: <20200701065510.GD2044019@kroah.com>
References: <20200602101841.662517961@linuxfoundation.org>
 <3c900c0e-b15c-da05-d3d8-e68acf660076@roeck-us.net>
 <20200602163346.GQ1407771@sasha-vm>
 <20200630214634.GC7113@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630214634.GC7113@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 30, 2020 at 11:46:34PM +0200, Pavel Machek wrote:
> Hi!
> 
> > >FWIW, if we need/want to use unified assembler in v4.9.y, shouldn't all unified
> > >assembler patches be applied ?
> > 
> > We don't - I took 71f8af111010 as a dependency rather than on its own
> > merit.
> 
> Would it be possible to somehow mark patches that are "dependency"
> rather than "on their own"? It would make review easier...

That's a lot of extra work on our part, and would make the changelog
text change, which isn't always liked, sorry.

greg k-h
