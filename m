Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE241E1F42
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 12:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgEZKCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 06:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbgEZKCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 06:02:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 154A02073B;
        Tue, 26 May 2020 10:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590487355;
        bh=lnPJYvXyDhrES0wQCn80s7nytjTqTvl9DDXfJof+iTo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AW8RrYHbyFkqiELtGw+4N6011dwOQKnmrsjRDHx2OwyXLJUFQ/L0ONB8MaY0raPoS
         SiRQqFtCnc4RsQJKz//ql0rHMMZK26tfT8zmlcKdigzOP9IhuEDP5y+Svf9o3B6fdl
         6WRuYunjb5bvZc10gKvmJ8lQv53AHbm1kLiGqqwQ=
Date:   Tue, 26 May 2020 12:02:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: Build errors in v4.{4,9.14}.y.queue
Message-ID: <20200526100233.GB2738150@kroah.com>
References: <7438c781-c359-9b4e-dc05-f321ea0f538e@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7438c781-c359-9b4e-dc05-f321ea0f538e@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 09:01:41PM -0700, Guenter Roeck wrote:
> Building x86_64:allyesconfig ... failed
> --------------
> Error log:
> drivers/edac/ghes_edac.c: In function 'get_dimm_smbios_index':
> drivers/edac/ghes_edac.c:79:29: error: 'ghes_pvt' undeclared (first use in this function)
>    79 |  struct mem_ctl_info *mci = ghes_pvt->mci;
>       |                             ^~~~~~~~
> drivers/edac/ghes_edac.c:79:29: note: each undeclared identifier is reported only once for each function it appears in

Offending patch now dropped.  Odd it doesn't build in 'make
allmodconfig', sorry about that, I should have caught it earlier.

thanks,

greg k-h
