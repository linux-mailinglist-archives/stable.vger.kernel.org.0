Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC2A3A24BA
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 08:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhFJGvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 02:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhFJGvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 02:51:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A418613CA;
        Thu, 10 Jun 2021 06:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623307749;
        bh=iIkVGEdZ6nVOvPq75U9lbg5Ox4Vh5/72oUnE/OZA/bc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QB4gOl+EsIvP5QsweNEAYkLbiEjI3pWQwjomUchuL2PfwIp/zEtOjKbE9F2hlDdpX
         OmIKO0TbL/jsB/pJK6Oov3SCFutZZ4NqXnSRZ4dnaFVrFBJHMBdUCLS/zT+0IIMZND
         ULdlWuTbv+5ZUMshzIzBvnv4KIlFDhWAaQ+kfJRs=
Date:   Thu, 10 Jun 2021 08:49:06 +0200
From:   'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
To:     linyyuan@codeaurora.org
Cc:     'Felipe Balbi' <balbi@kernel.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: eem: fix command packet transfer issue
Message-ID: <YMG14paBDjYmrxhs@kroah.com>
References: <000201d75dbf$58d1cc40$0a7564c0$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000201d75dbf$58d1cc40$0a7564c0$@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 10, 2021 at 02:10:40PM +0800, linyyuan@codeaurora.org wrote:
> From: Linyu Yuan <linyyuan@codeaurora.com>
> 
> there is following warning,
> [<ffffff8008905a94>] dwc3_gadget_ep_queue+0x1b4/0x1c8
> [<ffffff800895ec9c>] usb_ep_queue+0x3c/0x120
> [<ffffff80089677a0>] eem_unwrap+0x180/0x330
> [<ffffff80089634f8>] rx_complete+0x70/0x230
> [<ffffff800895edbc>] usb_gadget_giveback_request+0x3c/0xe8
> [<ffffff8008901e7c>] dwc3_gadget_giveback+0xb4/0x190
> [<ffffff8008905254>] dwc3_endpoint_transfer_complete+0x32c/0x410
> [<ffffff80089060fc>] dwc3_bh_work+0x654/0x12e8
> [<ffffff80080c63fc>] process_one_work+0x1d4/0x4a8
> [<ffffff80080c6720>] worker_thread+0x50/0x4a8
> [<ffffff80080cc8e8>] kthread+0xe8/0x100
> [<ffffff8008083980>] ret_from_fork+0x10/0x50
> request ffffffc0716bf200 belongs to 'ep0out'
> 
> when gadget receive a eem command packet from host, it need to response,
> but queue usb request to wrong endpoint.
> fix it by queue usb request to eem IN endpoint and allow host read it.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Linyu Yuan <linyyuan@codeaurora.org>
> ---
>  drivers/usb/gadget/function/f_eem.c | 44
> ++++++++++++++++++++++++++++++++-----

Your patch is line-wrapped and can not be applied :(

Please fix your email client to properly send patches correctly.

thanks,

greg k-h
