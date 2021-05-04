Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6818037268B
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 09:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhEDH0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 03:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhEDH0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 03:26:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F15C611C0;
        Tue,  4 May 2021 07:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620113159;
        bh=EYv+QTPloo3CU7rifYUF2is6rqP967IJMX2jdX6iIDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tBnOAf/NUQyTwYcuRMpmPOZK2jOcueEnmM6U/76Vbt4D7cyO2ls1YyH61TfDsykPj
         S3IMBZSb8+nw0xx9Fepe7AfKqkpRWPRi346NcClpaDRHWPTMKabB1qXhrTz7qXk7t0
         eSxz4bxgpIFGl6mrzjfEZ0oAbquiuoDvIdRQNfUw=
Date:   Tue, 4 May 2021 09:25:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org, Romain Naour <romain.naour@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: backport of 1d7ba0165d82 ("mips: Do not include hi and lo in
 clobber list for R6") for 4.19-stable
Message-ID: <YJD3BW7BVuz/mjuX@kroah.com>
References: <YI8yCa3zqHTmm25V@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YI8yCa3zqHTmm25V@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 03, 2021 at 12:13:13AM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> Attached is the backport of 1d7ba0165d82 ("mips: Do not include hi and
> lo in clobber list for R6") for 4.19-stable.

All now queued up, thanks!

greg k-h
