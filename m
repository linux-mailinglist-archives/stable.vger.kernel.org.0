Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BD8D3893
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 06:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfJKEzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 00:55:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbfJKEzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 00:55:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A35521A4C;
        Fri, 11 Oct 2019 04:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570769740;
        bh=hftfiU+kT/TNnyZlpbWqbcWjHwMH/AuUzvwYRGoeIrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IGW7X5RKK+E5PPLsG99qOox9BuVtajtNtii1IGzZym8RutGfZFgb+RcDS8UGCFFyN
         VrVH5C3Zock7eKa8N2YgIkV4rpdGbOjzhg0n/e9Z4RXFGggo+thdDj79SQ0+wwa1rE
         F03tXu4ChnuNG+Y6KlOTZZ02eLdWtndUdVRY/XiM=
Date:   Fri, 11 Oct 2019 06:55:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com
Subject: Re: [PATCH] arm64: cpufeature: Fix truncating a feature value
Message-ID: <20191011045538.GA977916@kroah.com>
References: <20191010122922.GA720144@kroah.com>
 <20191010131943.26822-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010131943.26822-1-suzuki.poulose@arm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 02:19:43PM +0100, Suzuki K Poulose wrote:
> A signed feature value is truncated to turn to an unsigned value
> causing bad state in the system wide infrastructure. This affects
> the discovery of FP/ASIMD support on arm64. Fix this by making sure
> we cast it properly.
> 
> This was inadvertently fixed upstream in v4.6 onwards with the following :
> commit 28c5dcb22f90113dea ("arm64: Rename cpuid_feature field extract routines")

What prevents us from just taking that commit instead?  You did not
document that here at all, which I thought I asked for.

Also, you only need 12 digits for a sha1, 28c5dcb22f90 ("arm64: Rename
cpuid_feature field extract routines") would be just fine :)

thanks,

greg k-h
