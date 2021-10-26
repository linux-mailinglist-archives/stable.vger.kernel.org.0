Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D51243B327
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 15:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbhJZNdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 09:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235339AbhJZNdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 09:33:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 606E060EB4;
        Tue, 26 Oct 2021 13:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635255041;
        bh=sn4s98HdC2qKJsLKjqTV3zcN9AvfBPiE+tmD7sjrIcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PTUfJro5M79NHhJIkFvbDTOGy34+4a6eetEXLw4zf9pwou9w1Qw+WQWXqD7YbFzRt
         kEDu3Hpx+0bKb3pShPlOgJWIJ8irf5U1JpJTY1h6QaDFt3LHN/S5XTdFt0JXBlf9nT
         MUdIcPziVd1T9TnhHrWziVxufGQPSHQ5LrvSALug=
Date:   Tue, 26 Oct 2021 15:30:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.com>,
        syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.14 165/169] usbnet: sanity check for maxpacket
Message-ID: <YXgC/6VwCxyrmoQp@kroah.com>
References: <20211025191017.756020307@linuxfoundation.org>
 <20211025191038.360463849@linuxfoundation.org>
 <YXf1tdKi0b0M4XCx@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXf1tdKi0b0M4XCx@hovoldconsulting.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 26, 2021 at 02:33:57PM +0200, Johan Hovold wrote:
> On Mon, Oct 25, 2021 at 09:15:46PM +0200, Greg Kroah-Hartman wrote:
> > From: Oliver Neukum <oneukum@suse.com>
> > 
> > commit 397430b50a363d8b7bdda00522123f82df6adc5e upstream.
> > 
> > maxpacket of 0 makes no sense and oopses as we need to divide
> > by it. Give up.
> > 
> > V2: fixed typo in log and stylistic issues
> > 
> > Signed-off-by: Oliver Neukum <oneukum@suse.com>
> > Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
> > Reviewed-by: Johan Hovold <johan@kernel.org>
> > Link: https://lore.kernel.org/r/20211021122944.21816-1-oneukum@suse.com
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Please drop this one from all stable queues until
> 
> 	https://lore.kernel.org/r/20211026124015.3025136-1-wanghai38@huawei.com
> 
> has landed.

Will drop it now and wait for that one, thanks!

greg k-h
