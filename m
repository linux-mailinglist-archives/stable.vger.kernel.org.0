Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C3F10EBDF
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 15:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbfLBOxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 09:53:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727362AbfLBOxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 09:53:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB28B20748;
        Mon,  2 Dec 2019 14:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575298427;
        bh=VJSH0XoYoy1VTeefRi+NWzDgSBXPf8dM3Vr5IvD7cyc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=llfukiCdj4Pac6NqGy8kHq3eSwSA9cr94dWKbe1WL9ENylHnPmA9RdxN6Ga+O/OGL
         YEuEJDJMAlv2Y9+2VgK9pm0o9ud5kJf4Lc176QKuWXSW24Q4d7JCCj6NFtXiiPsyxu
         zWoCLqrRpYWHV/SRIgo0FcqqAJbPuwDH7C82rywA=
Date:   Mon, 2 Dec 2019 15:53:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     stable@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH] crypto: inside-secure: Fix stability issue with
 Macchiatobin
Message-ID: <20191202145345.GA573877@kroah.com>
References: <1575296415-29255-1-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575296415-29255-1-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 03:20:15PM +0100, Pascal van Leeuwen wrote:
> commit b8c5d882c833 upstream
> 
> This patch should have made it into kernel version 5.4 as it fixes some
> major stability issue running on Marvell A7K/A8K, for which it was 
> originally developed, which was introduced by an earlier patch.
> It is identical to the upstream patch, save for some whitespace fixes
> that were removed to not violate the "no trivial fixes" rule.
> Below follows the original patch text as submitted for kernel 5.5.

Now queued up, thanks.

greg k-h
