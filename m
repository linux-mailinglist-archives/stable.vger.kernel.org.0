Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 514E61456C2
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgAVNaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:30:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:53254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729058AbgAVNaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:30:21 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3DA9205F4;
        Wed, 22 Jan 2020 13:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699820;
        bh=3UQCfBgP2ba6sY+O8WJldrVt/XdsZIcugL6RN8tGkt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V3HVy72wcST1LoAuV7qNKuZ+5Es29yh1SOuQtcGMgZQgy1ZkGh4EZuyimueOvTiDr
         du+/dkw4YCxdP/17K6vQUMSeMqqCQOd94lK2lEqayJFALANlCg0NEcrypjmuVAvX8K
         MxE1BfX6ghRhOt2aqoNRFHFCa4QpQihqXITWWJbw=
Date:   Wed, 22 Jan 2020 14:24:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>
Subject: Re: [PATCH 2/5] USB: serial: ir-usb: fix link-speed handling
Message-ID: <20200122132450.GA3580@kroah.com>
References: <20200122101530.29176-1-johan@kernel.org>
 <20200122101530.29176-3-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122101530.29176-3-johan@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 11:15:27AM +0100, Johan Hovold wrote:
> Commit e0d795e4f36c ("usb: irda: cleanup on ir-usb module") added a USB
> IrDA header with common defines, but mistakingly switched to using the
> class-descriptor baud-rate bitmask values for the outbound header.
> 
> This broke link-speed handling for rates above 9600 baud, but a device
> would also be able to operate at the default 9600 baud until a
> link-speed request was issued (e.g. using the TCGETS ioctl).

People still use this driver/hardware?  And this wasn't found until now?
wow...

> Fixes: e0d795e4f36c ("usb: irda: cleanup on ir-usb module")
> Cc: stable <stable@vger.kernel.org>     # 2.6.27
> Cc: Felipe Balbi <balbi@kernel.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>


Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
