Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6591830BF07
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhBBNGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230025AbhBBNGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:06:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 983B164ECE;
        Tue,  2 Feb 2021 13:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612271163;
        bh=KM0KT0cdbHaokOLzky22H4IPGsao3/ThvFXM3UQLRMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KXq2Mihleo0pBqQh1rp6D00oJ25+fs0Ugqwt7ekshjakATSHPIJ/w6ejyHlQ1HW0N
         /dxIEzgcGXbVdUs05TaC5s3agjz/l5f3Y6CaHXfhB/gud6vKF5c855DlnN8Op1V7/V
         nFLZrqfrFltJ9lGvFY8BvN/xi+MWes/IsN2XRm+A=
Date:   Tue, 2 Feb 2021 14:05:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [stable-5.10.y] Pick up "x86/entry: Remove put_ret_addr_in_rdi
 THUNK macro argument"
Message-ID: <YBlONpmGoM0/qG7R@kroah.com>
References: <CA+icZUVysDKMQxw4Fxp5SzBxau1Rpy7rra-a09TY-nzwgh54SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVysDKMQxw4Fxp5SzBxau1Rpy7rra-a09TY-nzwgh54SQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 08:50:52PM +0100, Sedat Dilek wrote:
> Hi,
> 
> you have in Linux 5.10.13-rc1:
> 
> "x86/entry: Emit a symbol for register restoring thunk"
> 
> While that discussion Boris and Peter recommended to remove unused code via:
> 
> "x86/entry: Remove put_ret_addr_in_rdi THUNK macro argument"
> ( upstream commit 0bab9cb2d980d7c075cffb9216155f7835237f98 )
> 
> OK, this has no CC:stable but I have both as a series in my local Git
> and both were git-pulled from [1].
> What do you think?

What bug is this fixing that requires this in 5.10?

thanks,

greg k-h
