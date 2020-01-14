Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA7F13A91D
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 13:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgANMTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 07:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgANMTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 07:19:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2BF52465A;
        Tue, 14 Jan 2020 12:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579004340;
        bh=vWTsIebNaYX6NTJlgNH63C+3WVnQJwm7AuT/hv4kC4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FOWf3y7KFALW7cPYkvzKZz1XHfkZFf/0cvz6L61nS8LLn7IBChyqxKqHIyo1UDU5L
         VUZxCcEeaOEh0yqXsCf2igYqsXLHS0rF/i/YfFOzEzbusm6BBrXlt3WKOVq252TEsx
         yu01JP+Qa/ttAQl+0Fo8hBUfla9bw2vuTZY50Cc0=
Date:   Tue, 14 Jan 2020 13:18:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] USB: serial: opticon: stop all I/O on close()
Message-ID: <20200114121857.GB1503960@kroah.com>
References: <20200114110146.5929-1-johan@kernel.org>
 <20200114110146.5929-2-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114110146.5929-2-johan@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 14, 2020 at 12:01:46PM +0100, Johan Hovold wrote:
> Make sure to stop any submitted write URBs on close(). This specifically
> avoids a NULL-pointer dereference or use-after-free in case of a late
> completion event after driver unbind.
> 
> Fixes: 648d4e16567e ("USB: serial: opticon: add write support")
> Cc: stable <stable@vger.kernel.org>	# 2.6.30: xxx: USB: serial: opticon: add chars_in_buffer() implementation
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
