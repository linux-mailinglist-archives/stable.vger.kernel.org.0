Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2822E9900
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbhADPky convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 4 Jan 2021 10:40:54 -0500
Received: from mail.msweet.org ([173.255.209.91]:33134 "EHLO mail.msweet.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbhADPky (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:40:54 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jan 2021 10:40:54 EST
Received: from [10.0.1.243] (cbl-66-186-76-47.vianet.ca [66.186.76.47])
        by mail.msweet.org (Postfix) with ESMTPSA id 40DD180B3F;
        Mon,  4 Jan 2021 15:33:36 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH] USB: usblp: fix DMA to stack
From:   Michael Sweet <msweet@msweet.org>
In-Reply-To: <X/MwBCt0Z/B1D7vw@hovoldconsulting.com>
Date:   Mon, 4 Jan 2021 10:33:34 -0500
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <15AB8EFA-A534-40D8-95D2-7DCE1E46D431@msweet.org>
References: <20210104145302.2087-1-johan@kernel.org>
 <X/MtNtTd96S39HQL@kroah.com> <X/MwBCt0Z/B1D7vw@hovoldconsulting.com>
To:     Johan Hovold <johan@kernel.org>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Johan/Greg,

Since CUPS uses libusb to communicate with printers these days (well, for over a decade now) so that printing and scanning can coexist, the usblp driver really doesn't get any usage anymore.


> On Jan 4, 2021, at 10:11 AM, Johan Hovold <johan@kernel.org> wrote:
> 
> On Mon, Jan 04, 2021 at 03:59:02PM +0100, Greg Kroah-Hartman wrote:
>> On Mon, Jan 04, 2021 at 03:53:02PM +0100, Johan Hovold wrote:
>>> Stack-allocated buffers cannot be used for DMA (on all architectures).
>>> 
>>> Replace the HP-channel macro with a helper function that allocates a
>>> dedicated transfer buffer so that it can continue to be used with
>>> arguments from the stack.
> 
>> Wow, no one uses this driver anymore it seems, this should have
>> triggered a runtime warning on newer kernels :(
> 
> This helper is only used by the IOCNR_HP_SET_CHANNEL ioctl so perhaps
> it's just that one which isn't used much.
> 
> Johan
> 

________________________
Michael Sweet



