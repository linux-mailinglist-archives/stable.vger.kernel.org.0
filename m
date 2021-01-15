Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F3C2F75D4
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 10:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbhAOJti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 04:49:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728971AbhAOJth (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 04:49:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF16F2339D;
        Fri, 15 Jan 2021 09:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610704146;
        bh=hw8Ibfu6xRgTkjKKIJfmXLQiEMDEpz8SV9y9eDkFHz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q6m+fIgxP0xxItZSozmXqf6V66XHavXpEvfgJ0dwG2rBCdINEqDWDIn3g8/zazomn
         IKxfLiy73AbO5ZCYsiDWzw+c5s/icbqGDjBkX45XCVW/CXYEorp8NO59MBND+C8fpg
         ex1rz+9vhK9HzYmOeJtXLU/ujouzGCpexUxCbZI8=
Date:   Fri, 15 Jan 2021 10:49:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     chris@chris-wilson.co.uk, cq.tang@intel.com, jani.nikula@intel.com,
        matthew.auld@intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/i915: Fix mismatch between misplaced
 vma check and vma" failed to apply to 4.19-stable tree
Message-ID: <YAFlDyDYyQrWu2fl@kroah.com>
References: <1609152444157128@kroah.com>
 <20210113195156.zqfrut4vnsodd7wk@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113195156.zqfrut4vnsodd7wk@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 13, 2021 at 07:51:56PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Dec 28, 2020 at 11:47:24AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will also apply to 4.14-stable.

All now applied, thanks.

greg k-h
