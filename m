Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1207C2B714
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 15:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfE0N4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 09:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfE0N4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 May 2019 09:56:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C4F120665;
        Mon, 27 May 2019 13:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558965362;
        bh=7nAEx+NEYoct6Lsn//YELk+M+9k47SCsZD+tBmiWwMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q2r+HchmvjCQjRXjqu8bFPd9MoncBBHw0AleyBNg9uXe8iQrDSIpoAWV8EWjdmYbo
         pMgwCkPxoAMMMWXgu47XTb2H1Zan7nMkrLl/gLDzS76teyVMk2i1d7w1upsCwT4eao
         GQPNL1n1GYa29nLlbeHCXWP454EVBUTnc+j0zYl8=
Date:   Mon, 27 May 2019 15:56:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc:     stable@vger.kernel.org, will.deacon@arm.com,
        catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH stable 4.9] arm64: Save and restore OSDLR_EL1 across
 suspend/resume
Message-ID: <20190527135600.GA7659@kroah.com>
References: <155809593723029@kroah.com>
 <20190523152733.28069-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523152733.28069-1-jean-philippe.brucker@arm.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 04:27:33PM +0100, Jean-Philippe Brucker wrote:
> commit 827a108e354db633698f0b4a10c1ffd2b1f8d1d0 upstream
> 
> When the CPU comes out of suspend, the firmware may have modified the OS
> Double Lock Register. Save it in an unused slot of cpu_suspend_ctx, and
> restore it on resume.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
> Modified for v4.9 backport: 623b476fc815 and 6d99b68933fb are missing in
> v4.9, but the conflict is easily resolved.
> 
> Tested on Juno with cpuidle.

Now queued up, thanks.

greg k-h
