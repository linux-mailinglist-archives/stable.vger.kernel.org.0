Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E8E1398D6
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 19:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgAMSZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 13:25:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgAMSZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jan 2020 13:25:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8DA020661;
        Mon, 13 Jan 2020 18:25:48 +0000 (UTC)
Date:   Mon, 13 Jan 2020 19:25:46 +0100
From:   Greg KH <greg@kroah.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>,
        Martin Jansen <martin.jansen@opticon.com>
Subject: Re: [PATCH] USB: serial: opticon: fix control-message timeouts
Message-ID: <20200113182546.GF411698@kroah.com>
References: <20200113172213.30869-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113172213.30869-1-johan@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 13, 2020 at 06:22:13PM +0100, Johan Hovold wrote:
> The driver was issuing synchronous uninterruptible control requests
> without using a timeout. This could lead to the driver hanging
> on open() or tiocmset() due to a malfunctioning (or malicious) device
> until the device is physically disconnected.
> 
> The USB upper limit of five seconds per request should be more than
> enough.
> 
> Fixes: 309a057932ab ("USB: opticon: add rts and cts support")
> Cc: stable <stable@vger.kernel.org>     # 2.6.39
> Cc: Martin Jansen <martin.jansen@opticon.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
