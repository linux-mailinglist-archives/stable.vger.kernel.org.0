Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC93344C252
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 14:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhKJNr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 08:47:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231460AbhKJNr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 08:47:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75F49610CB;
        Wed, 10 Nov 2021 13:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636551912;
        bh=TPhSrpdtr/8zzwVcId5xplTiYgg+ge+YF6dWEYzx1/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n0XrG8zZy3VjJOpsa6625jGq8ONDCMlmtFypWCNjiESdXbl8YwnQh5nX+XSQ2AWg8
         r8rqUrI9eLyqwJol2lZoI6GsR+4al4fdf6ohd1e2phMW6mitOqHS3+5c9s8mT/htUW
         1UXNO3E0sb/MT0OETzbLRE+91latnr3WyZUjhGzI=
Date:   Wed, 10 Nov 2021 14:45:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: Please add 2cf3f8133bda2a09 to 5.15.x
Message-ID: <YYvM5Yf2nsj9ajNZ@kroah.com>
References: <20211110124147.GT28560@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110124147.GT28560@twin.jikos.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 01:41:48PM +0100, David Sterba wrote:
> Hi,
> 
> please add commit
> 
> 2cf3f8133bda ("btrfs: fix lzo_decompress_bio() kmap leakage")
> 
> to the 5.15.x tree. It's been merged during the 5.16 pull, it's a fix
> for a crash on 32bit architectures with enabled lzo compression.
> Applies cleanly and has been tested.

Now queued up, thanks.

greg k-h
