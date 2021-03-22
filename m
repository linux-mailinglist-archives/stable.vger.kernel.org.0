Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F4E343CFE
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 10:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhCVJjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 05:39:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:40182 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhCVJi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 05:38:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616405935; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yDiK3BJ44B/QmRByko9f8KxGaROCchGg9jmSpDbr26Q=;
        b=gg8IiSMRnpMXekJBPXoDGsI9GhgiSwpjBypWSBOZi1jSVr1EK808w4VJcBte9Wo0Io3LKX
        0AAf5NAGwt3jgMMnRFRNJs0E0AXXceSqGXPuglbQH6oqC1aQgLexXMAvz5HPnljWxrVjah
        HwWkHoA3/fvZ4tV1EKM2LlO/VJMc7OU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2F6B8AD38;
        Mon, 22 Mar 2021 09:38:55 +0000 (UTC)
Message-ID: <666092069a37e8c545f0c441a6d66622501cfa6f.camel@suse.com>
Subject: Re: [PATCH 1/7] USB: cdc-acm: fix double free on probe failure
From:   Oliver Neukum <oneukum@suse.com>
To:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jaejoong Kim <climbbb.kim@gmail.com>
Date:   Mon, 22 Mar 2021 10:38:51 +0100
In-Reply-To: <20210318155202.22230-2-johan@kernel.org>
References: <20210318155202.22230-1-johan@kernel.org>
         <20210318155202.22230-2-johan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Donnerstag, den 18.03.2021, 16:51 +0100 schrieb Johan Hovold:
> If tty-device registration fails the driver copy of any Country
> Selection functional descriptor would end up being freed twice; first
> explicitly in the error path and then again in the tty-port destructor.
> 
> Drop the first erroneous free that was left when fixing a tty-port
> resource leak.
> 
> Fixes: cae2bc768d17 ("usb: cdc-acm: Decrement tty port's refcount if probe() fail")
> Cc: stable@vger.kernel.org      # 4.19
> Cc: Jaejoong Kim <climbbb.kim@gmail.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>

