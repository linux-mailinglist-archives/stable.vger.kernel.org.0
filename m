Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC104388B0
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhJXLwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXLwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:52:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6F0761002;
        Sun, 24 Oct 2021 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635076212;
        bh=ywaQfwTgTWoV+2mMimVw/CeGgClkCrRfF+W0SYSuYuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YlPGprI+CSRfUClnDM5XvqMhqWFAUjHI1t4VtGv5Y67ovY+odcSxSv4OUvSpmxPGR
         ipT+mgo7hTHRVwof7SpUDG0+hs2L3l3gFSlmYd1rSnbULM6PhoAClTH2BU24ovRE74
         2XlILDKV5zLuvKt02g99dWmEKdOf1wyO8tB2rXAs=
Date:   Sun, 24 Oct 2021 13:49:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: Stable backport request
Message-ID: <YXVILOXgE9u/UOpM@kroah.com>
References: <87zgqzbcx6.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgqzbcx6.fsf@mpe.ellerman.id.au>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 24, 2021 at 09:21:09AM +1100, Michael Ellerman wrote:
> Hi Greg,
> 
> Please backport the following commit to v5.4 and v5.10:
> 
>   73287caa9210ded6066833195f4335f7f688a46b
>   ("powerpc64/idle: Fix SP offsets when saving GPRs")
> 
> 
> And please backport the following commits to v5.4, v5.10 and v5.14:
> 
>   9b4416c5095c20e110c82ae602c254099b83b72f
>   ("KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()")
> 
>   cdeb5d7d890e14f3b70e8087e745c4a6a7d9f337
>   ("KVM: PPC: Book3S HV: Make idle_kvm_start_guest() return 0 if it went to guest")
> 
>   496c5fe25c377ddb7815c4ce8ecfb676f051e9b6
>   ("powerpc/idle: Don't corrupt back chain when going idle")

All now queued up, thanks!

greg k-h
