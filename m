Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBE0324C86
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbhBYJLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236138AbhBYJJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:09:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEE6F64F10;
        Thu, 25 Feb 2021 09:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614243985;
        bh=vpD3Dq8Jgppm7W4KL+rtdhEnJzOvKeqE/tGeUEsU6OM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tSAoCcSGcGxUQ6GT2mV9waL8vBUBFHLW/z3ReRXL7GnyoN0xF/o7rcyR6NpXB74Df
         zGn3iL4Dsn+bPcnNucvrfr+GhZCgoJnEEwXR5KfX8iVb7P7rWnmeX3LUlbQBtF0Qlq
         VXGDqZwVgW7FAYoXpm8ugqKq1zCjRk3cIE8f6hqU=
Date:   Thu, 25 Feb 2021 10:06:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     sashal@kernel.org, axboe@kernel.dk, stable@vger.kernel.org
Subject: Re: [stable-4.19 Resend 0/7] block layer bugfix
Message-ID: <YDdohfWKqvNI7AVV@kroah.com>
References: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 04:04:19PM +0100, Jack Wang wrote:
> Hi Greg, hi Sasha,
> 
> Please consider to include following fixes in to stable tree.
> The 6 patches from Ming was fixing a deadlock, they are included around kernel
> 5.3/4. Would be good to included in 4.19, we hit it during testing, with the fix
> we no longer hit the deadlock.
> 
> The last one is simple NULL pointer deref fix.

All now queued up, thanks.

greg k-h
