Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415861456C4
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgAVNaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:30:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728816AbgAVNaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:30:24 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C8AF205F4;
        Wed, 22 Jan 2020 13:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699824;
        bh=7/IarjpvtkIplo6XH8qLYAeV/fHXtmgiOSSe+fT9/Yk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1S9Xvklo8fRXA4DYxW5AKzkPm1cySl2dzhyOwnR5MY+Zn4elVv8iVF8yTvdDkdr0c
         vXl74+yMC48iKXPt3BQ7Nx+KWrLvQctaXQvZrPJ3mwIZV3bOParP09T28BUOl69sqv
         kHAUQBHuE2vg5FbVp1fONo9RGp1zj4/Qr0Vpw7JU=
Date:   Wed, 22 Jan 2020 14:25:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/5] USB: serial: ir-usb: add missing endpoint sanity
 check
Message-ID: <20200122132505.GB3580@kroah.com>
References: <20200122101530.29176-1-johan@kernel.org>
 <20200122101530.29176-2-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122101530.29176-2-johan@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 11:15:26AM +0100, Johan Hovold wrote:
> Add missing endpoint sanity check to avoid dereferencing a NULL-pointer
> on open() in case a device lacks a bulk-out endpoint.
> 
> Note that prior to commit f4a4cbb2047e ("USB: ir-usb: reimplement using
> generic framework") the oops would instead happen on open() if the
> device lacked a bulk-in endpoint and on write() if it lacked a bulk-out
> endpoint.
> 
> Fixes: f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
