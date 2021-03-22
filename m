Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F9D343D0B
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 10:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCVJju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 05:39:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:40624 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230047AbhCVJjb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 05:39:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616405969; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uKRtNjTWNGIYGcPOFzt9CirlwN/8xcaWoNlcUFHFyi8=;
        b=lUnvdj/MGc/STcoTtx+PPP3/2WZzwhpIttOpyPWVYhHTdQFtmWtvilPBDEak6wucs31GuY
        JAXoJxrr4aTB9P1hJsA9MwGTfXL2u1nzR+vEv5E/eCll4hNeOknnYDIS4V9lxnSuG9fm43
        cWnuRDyiFyAaYHkdFhClr+JSmXnaJyg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A9C5DAD79;
        Mon, 22 Mar 2021 09:39:29 +0000 (UTC)
Message-ID: <6b5623cc6745139c631048c1cd49707a958f51b4.camel@suse.com>
Subject: Re: [PATCH 2/7] USB: cdc-acm: fix use-after-free after probe failure
From:   Oliver Neukum <oneukum@suse.com>
To:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>
Date:   Mon, 22 Mar 2021 10:39:26 +0100
In-Reply-To: <20210318155202.22230-3-johan@kernel.org>
References: <20210318155202.22230-1-johan@kernel.org>
         <20210318155202.22230-3-johan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Donnerstag, den 18.03.2021, 16:51 +0100 schrieb Johan Hovold:
> If tty-device registration fails the driver would fail to release the
> data interface. When the device is later disconnected, the disconnect
> callback would still be called for the data interface and would go about
> releasing already freed resources.
> 
> Fixes: c93d81955005 ("usb: cdc-acm: fix error handling in acm_probe()")
> Cc: stable@vger.kernel.org      # 3.9
> Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Signed-off-by: Johan Hovold <johan@kernel.org>]
Acked-by: Oliver Neukum <oneukum@suse.com>

