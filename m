Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8D22D4054
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 11:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgLIKwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 05:52:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbgLIKwJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 05:52:09 -0500
Date:   Wed, 9 Dec 2020 11:52:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607511089;
        bh=gxZvIXJIju5zSeWQjr66NyC6FRe3iPh9PWurDEGzsBU=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=qTCTDkINY89L6x/MR9T0cxOnNe5pbtGM5gwpECMdf5I3pWifT9/Oj9QkTYWNc89Mg
         kF6PVawEdsZ4+sdMUU+FoBHnB4erupZWe39fKC7xb6aHL+rkz1/i7+wo+qss4f4jP7
         xX7s/bigCKyJT7JI/y65HxopNBWKIrSUjaqo0pps=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+8881b478dad0a7971f79@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: option: add interface-number sanity check
 to flag handling
Message-ID: <X9CsfckIiLGSrK/o@kroah.com>
References: <0000000000004c471e05b60312f9@google.com>
 <20201209104221.13223-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209104221.13223-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 11:42:21AM +0100, Johan Hovold wrote:
> Add an interface-number sanity check before testing the device flags to
> avoid relying on undefined behaviour when left shifting in case a device
> uses an interface number greater than or equal to BITS_PER_LONG (i.e. 64
> or 32).
> 
> Reported-by: syzbot+8881b478dad0a7971f79@syzkaller.appspotmail.com
> Fixes: c3a65808f04a ("USB: serial: option: reimplement interface masking")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
