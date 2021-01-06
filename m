Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C2F2EC194
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 17:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbhAFQ4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 11:56:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbhAFQ4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 11:56:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17CAF23118;
        Wed,  6 Jan 2021 16:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609952173;
        bh=qYmHKMdwWugWqRJdcH43mljt3nd1JKr4sRTV0GSRvII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WZcGMnHzg9+i9yMtLZbRs8hSaT30XXGmHsLytnEUXfHNtGILEO9xwbP8pnwaP0weB
         ydhKlf3/6mgTLlYQ3NM1hublFQUtju1P8Xq5kUXDq5TRicMIHEP/By4KjM95BldODp
         AmRJsRfo9JFMNYE4ZuLOU1Wb5Txi/m6LemNXh2Sk=
Date:   Wed, 6 Jan 2021 17:57:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org
Subject: Re: request for 5.10-stable: a31489d2a368 ("Bluetooth: Fix
 attempting to set RPA timeout when unsupported")
Message-ID: <X/Xr/683AkQfQVqZ@kroah.com>
References: <20210104162641.7tbu7xjjaiscrue3@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104162641.7tbu7xjjaiscrue3@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 04:26:41PM +0000, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> This was not marked for stable but looks like it should be in 5.10-stable.
> Please apply to your queue.

Now applied, thanks.

greg k-h
