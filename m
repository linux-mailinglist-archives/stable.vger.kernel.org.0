Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2B413A283
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 09:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgANIKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 03:10:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:60214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728992AbgANIKJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 03:10:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BBF12084D;
        Tue, 14 Jan 2020 08:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578989408;
        bh=Xm43GzlWspHDBj1+BIXZ7aB2+zNGUrtVvz86BsfGY/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BVugPcnu8yAROa6h2qt2cyHMe27JGL6Na4OpJ+UxIFU1nFUZICuPbaJOBSW0748LR
         VF1BTSlORqBGGj88Wp3fmlGKpM2CDQYB3rJMKulHzAuuuky8iFIn0fhhFZlXNQu0Mk
         XjiaLNUOBQswGeqbpBmLLooJcx0xzCFtBo7AJaLc=
Date:   Tue, 14 Jan 2020 09:10:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [5.4-stable] Driver memory fixes
Message-ID: <20200114081005.GA1001568@kroah.com>
References: <d91f97da6e3a36c9b2d1ec8a9c613ffcc2391cbe.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d91f97da6e3a36c9b2d1ec8a9c613ffcc2391cbe.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 13, 2020 at 11:02:29PM +0000, Ben Hutchings wrote:
> Please pick the following commits for 5.4-stable:
> 
> 3d94a4a8373b mwifiex: fix possible heap overflow in mwifiex_process_country_ie()
> bbe692e349e2 rpmsg: char: release allocated memory
> db8fd2cde932 mwifiex: pcie: Fix memory leak in mwifiex_pcie_alloc_cmdrsp_buf
> 0e62395da2bd scsi: bfa: release allocated memory in case of error
> a2cdd07488e6 rtl8xxxu: prevent leaking urb
> b8d17e7d93d2 ath10k: fix memory leak
> 
> They all apply and build cleanly.

Thanks for all of these, now queued up.

greg k-h
