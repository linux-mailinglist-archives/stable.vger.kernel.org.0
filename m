Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668BE107DEB
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 10:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfKWJ1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 04:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbfKWJ1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Nov 2019 04:27:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C817D20719;
        Sat, 23 Nov 2019 09:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574501224;
        bh=Mnf2M58/rhc8aWQSqhoykSytTknTxW16bUn0An3Nr00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NBlkZeAgegxDeezSpfAAicIqkFD2CqFhmm57mNmqlswt9sHBEWvCfaNOBwD5opLOH
         yhEkOCizO72GwuJfMTHzpKv7lPvuNV2gMb+xLJXoCyEtDSiBePO5tcmlunEErmdqvJ
         dxDPai3CI92uCQZrxDgyw/z6PXcf1Kv/HIRUWyxw=
Date:   Sat, 23 Nov 2019 10:27:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bob Funk <bobfunk11@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org
Subject: Re: Bug Report - Kernel Branch 4.4.y - asus-wmi.c
Message-ID: <20191123092701.GA2129125@kroah.com>
References: <33bfa93a-3853-85f5-47f9-8a69ed9c656e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33bfa93a-3853-85f5-47f9-8a69ed9c656e@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 08:33:46PM -0600, Bob Funk wrote:
> Hello,
> 
> I am contacting the stable branch maintainers with a bug report concerning
> the asus-wmi kernel driver in the 4.4 kernel branch. I had initially
> contacted
> maintainers for the specific driver and received a response stating that I
> should contact the stable branch maintainers about the issue instead. Their
> opinion was that the patch in question should be reverted rather than
> debugged. I will append my initial report here and let you decide what to do
> with the bug.

Any reason you can not just use 5.3 or newer for this hardware?  Why are
you stuck on 4.4?

thanks,

greg k-h
