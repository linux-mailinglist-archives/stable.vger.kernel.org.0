Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9DD30B889
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 08:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhBBHUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 02:20:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhBBHUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 02:20:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8225B64ED9;
        Tue,  2 Feb 2021 07:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612250366;
        bh=2Y/vqLKHVS6caxliklOtYKJGF7UsazuC5RtVqDVH+Go=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=biMagxr5xcyutxx/t7P98Qr1ghIYppYYTjXxphPHX7DufIE/XCBMVS/LzrZ2hHMOq
         rKfpH0jaOM0SSDTIiKXM+lHavb+mSXFoPjyjkO2JTYDxmyxTfyFwhtflUitzTNlBR9
         mG5a0m7tYruOs919sYDyehmrW3Hn+wmvk0D11Sew=
Date:   Tue, 2 Feb 2021 08:19:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Moritz Fischer <mdf@kernel.org>
Cc:     stable@vger.kernel.org, moritzf@google.com
Subject: Re: Backport of a1df829ead587 ("ACPI/IORT: Do not blindly trust DMA
 masks from firmware")
Message-ID: <YBj8+wINK9LWLYXc@kroah.com>
References: <YBhajBbI3J3+O9CP@epycbox.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBhajBbI3J3+O9CP@epycbox.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 11:46:20AM -0800, Moritz Fischer wrote:
> Hi Greg, Sasha,
> 
> Please consider backporting a1df829ead5877d4a1061e976a50e2e665a16f24
> ("ACPI/IORT: Do not blindly trust DMA masks from firmware").
> 
> It should apply all the way back to 5.5 and addresses an issue that
> affects one of my machines with broken firmware.

There are no "active" kernel trees from 5.5-5.9 at the moment, so 5.10
is the only one to apply it to, which Sasha already did!

thanks,

greg k-h
