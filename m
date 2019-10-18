Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07EFDD421
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391031AbfJRWWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbfJRWWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:22:07 -0400
Received: from localhost (unknown [12.245.223.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85ACC205C9;
        Fri, 18 Oct 2019 22:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571437326;
        bh=qAIBQeIpmd6hAmZu10ZR2fdEX8y4SeQuRmmYFchHdsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u3KZZ1LTgCdf45rUtjlIg48GKcVjFB96rdYjKcelrz6bAiB8rkEUhdcqzsDDy3nZU
         cYukfsuKsZH8Jd+/C6akNROyFB/FRD/Oz9nSUU9z6GpCJkNh74RvWAgRcJh1rbU6nb
         gdnBKR6Oetd8v8ClUPucqUHTWyC4xz3AJcc4Ve6Y=
Date:   Fri, 18 Oct 2019 18:22:05 -0400
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 095/100] USB: usb-skeleton: fix
 use-after-free after driver unbind
Message-ID: <20191018222205.GA6978@kroah.com>
References: <20191018220525.9042-1-sashal@kernel.org>
 <20191018220525.9042-95-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018220525.9042-95-sashal@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 06:05:20PM -0400, Sasha Levin wrote:
> From: Johan Hovold <johan@kernel.org>
> 
> [ Upstream commit 6353001852776e7eeaab4da78922d4c6f2b076af ]
> 
> The driver failed to stop its read URB on disconnect, something which
> could lead to a use-after-free in the completion handler after driver
> unbind in case the character device has been closed.
> 
> Fixes: e7389cc9a7ff ("USB: skel_read really sucks royally")
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Link: https://lore.kernel.org/r/20191009170944.30057-3-johan@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/usb/usb-skeleton.c | 1 +
>  1 file changed, 1 insertion(+)

This file does not even get built in the kernel tree, no need to
backport anything for it :)

thanks,

greg k-h
