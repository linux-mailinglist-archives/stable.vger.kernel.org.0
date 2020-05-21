Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75C31DC6AD
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 07:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgEUFqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 01:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgEUFqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 01:46:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 511902070A;
        Thu, 21 May 2020 05:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590039961;
        bh=U+kTXEwz+HBnRIKf6SIVXQYenrgzNh6i7xcNHTV5HgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L70e1SpLnZTHYT1MH3CDp5z4IRtigyf64M20BHz58mm3UXzj9qPv37lrjB5hRMZUO
         p+DJ+0cXLi9/obB5UUjcFDAAkrqekSh4L6LK3e6JpVZNC2mP5JviDiMUlPw9pMR+qO
         dsumzIg3QdA4cBUUrcuikB5OkFhth/i/IJJVczg0=
Date:   Thu, 21 May 2020 07:45:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.9-stable] watchdog: Fix the race between the release of
 watchdog_core_data and cdev
Message-ID: <20200521054559.GB2295294@kroah.com>
References: <df70afba3439e4573a8e2b61f751577ff67ab36d.camel@codethink.co.uk>
 <21124d783a72aa3292502100b1558ddf8f873b97.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21124d783a72aa3292502100b1558ddf8f873b97.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 09:15:57PM +0100, Ben Hutchings wrote:
> On Wed, 2020-05-20 at 21:10 +0100, Ben Hutchings wrote:
> > Please queue up the attached backport of commit 2351c88f8296 "watchdog:
> > Fix the race between the release of watchdog_core_data and cdev" for
> > 4.14.
> 
> And here's the corresponding version for 4.9.

Both now queued up, thanks.

greg k-h
