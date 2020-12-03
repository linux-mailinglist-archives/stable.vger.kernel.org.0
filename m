Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141972CD276
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 10:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbgLCJYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 04:24:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728664AbgLCJYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 04:24:35 -0500
Date:   Thu, 3 Dec 2020 10:25:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606987435;
        bh=OPHa3hpYhOVHFQT+rzppZmmCVL1HYAlnF8Zna8/OOtA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=1lrp3FF4JUivmboIzQdFfxeGJWg/wy83LxzThplEB5pQoqhoGZs5FzJm67wJB2/0Y
         2C7G5yISp81XE5QpgZSxDDEPd9Xh1dQnaTejufYwVBaIQ5akdjMJs8H4GjYk3/u27N
         ARUeOkU5lEDtFcBPTaouKFnviKk3hklBkor3sUns=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: ch341: sort device-id entries
Message-ID: <X8iu7y5GjmhmeWdH@kroah.com>
References: <20201203091159.12896-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203091159.12896-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 03, 2020 at 10:11:59AM +0100, Johan Hovold wrote:
> Keep the device-id entries sorted to make it easier to add new ones in
> the right spot.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
