Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B93B11A555
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 08:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfLKHrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 02:47:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbfLKHrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 02:47:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EA8D20637;
        Wed, 11 Dec 2019 07:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576050432;
        bh=KUviTnc++2RoPVxBfJZesKqaTS5kmWsSAR63Wx9a8+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ScuhDon13sjlzBQ2Mnv2jTRbGeyu4gNL65rxO10JGilm/8+K69AJ24MtbEPwfmQ+L
         FfB7oyxxYFEb6agKgOYg58dKUTZ6EtLWVDzA6YHxjfwHdpiztZbqPXDkXH0iPdaLqU
         Q+15dioAHKmqIO6kkvvJHywpOfOBDN77rT0I5mbE=
Date:   Wed, 11 Dec 2019 08:47:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ingo Rohloff <ingo.rohloff@lauterbach.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 26/71] usb: usbfs: Suppress problematic bind
 and unbind uevents.
Message-ID: <20191211074710.GF398293@kroah.com>
References: <20191210223316.14988-1-sashal@kernel.org>
 <20191210223316.14988-26-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210223316.14988-26-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 05:32:31PM -0500, Sasha Levin wrote:
> From: Ingo Rohloff <ingo.rohloff@lauterbach.com>
> 
> [ Upstream commit abb0b3d96a1f9407dd66831ae33985a386d4200d ]
> 
> commit 1455cf8dbfd0 ("driver core: emit uevents when device is bound
> to a driver") added bind and unbind uevents when a driver is bound or
> unbound to a physical device.

Again, please drop from here too.

thanks,

greg k-h
