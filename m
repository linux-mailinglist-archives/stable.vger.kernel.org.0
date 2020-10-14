Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96D728E2E2
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 17:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbgJNPNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 11:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgJNPNI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 11:13:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B963920714;
        Wed, 14 Oct 2020 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602688387;
        bh=3i5dhUIVAy4nbl1V3WKqV1+5PF4u0kkQVmgry44PdW4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gzuO+r6W7qZ91N2av8n7cDiJfqvdzzX0Uxet1DjP0Yb+jG2gMQ7tIkr4vBi1TDDxs
         uDrbp8rf55Q547yyfMenJUUEZH1KtXXuJ6rOOUar/kY35JoRXL7H2Nlb58n289xUyV
         kC8PuMo4SVtLa6g6oqYHuVvILNHMMRZcWwneEOI4=
Date:   Wed, 14 Oct 2020 17:13:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 5.8+ regression fix 0/1] i2c: core: Restore
 acpi_walk_dep_device_list() getting called after registering the ACPI i2c
 devs
Message-ID: <20201014151341.GB3761660@kroah.com>
References: <20201014144158.18036-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014144158.18036-1-hdegoede@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 14, 2020 at 04:41:57PM +0200, Hans de Goede wrote:
> Hi All,
> 
> I am afraid that commit 21653a4181ff ("i2c: core: Call
> i2c_acpi_install_space_handler() before i2c_acpi_register_devices()")
> which is in 5.9 and was also added to 5.8.13 (and possible other
> stable series releases) causes a regression on some devices including
> on the Microsoft Surface Go 2 (and possibly also the Go 1) where the
> system no longer boots.

That commit is also in the following stable releases:
	4.9.238 4.14.200 4.19.149 5.4.69 5.8.13

so it would need to fixed in all of those places :)

thanks,

greg k-h
