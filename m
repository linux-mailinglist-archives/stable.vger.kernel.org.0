Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CC933D315
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 12:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbhCPLbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 07:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237163AbhCPLbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 07:31:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB4B564ED2;
        Tue, 16 Mar 2021 11:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615894284;
        bh=/1wbkg2dCZqybDXCZgAdrsXjyaUVO/A5ZZTYvmkn8Ck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fwAx788MXiFEsTW2UdN5X899XiI1QvdHGG+mozrxIlelVHZVlT1j6FtVkhYv1SU5V
         IpU5cgmYCyxXP5ITvP3C8lGm+DEZthd2rkFgKbuHZ/BD9tpnnjz3vrvubnqjI7QNYY
         BrR4UCTh30E7uJZYw9xJY5aMZPUIygo7/L+DZin8=
Date:   Tue, 16 Mar 2021 12:31:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vladimir Murzin <vladimir.murzin@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
        dbrazdil@google.com
Subject: Re: [PATCH][for-stable-v5.11]] arm64: Unconditionally set virtual
 cpu id registers
Message-ID: <YFCXCbKefWH8smpB@kroah.com>
References: <20210316112500.85268-1-vladimir.murzin@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316112500.85268-1-vladimir.murzin@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 11:25:00AM +0000, Vladimir Murzin wrote:
> Commit 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
> reorganized el2 setup in such way that virtual cpu id registers set
> only in nVHE, yet they used (and need) to be set irrespective VHE
> support. Lack of setup causes 32-bit guest stop booting due to MIDR
> stay undefined.
> 
> Fixes: 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
> 
> There is no upstream fix since issue went away due to code there has
> been reworked in 5.12: nVHE comes first, so virtual cpu id register
> are always set.
> 
> Maintainers, please, Ack.

Why not just use the "rework" patch instead that fixes this issue?


that's always preferred instead of one-off patches.

thanks,

greg k-h
