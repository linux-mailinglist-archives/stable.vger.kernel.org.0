Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED19531EB3E
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 16:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhBRPFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 10:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232257AbhBRMNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Feb 2021 07:13:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF04364E76;
        Thu, 18 Feb 2021 12:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613650355;
        bh=290E0e/Zkro+gyvCvFJ4AdtDkL7+CAvuNYPkSe8iUQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N1DREhqz+PyrRABEP0rPMym15siX9gw5emynX8UocyyV9WDlMnTeGEWqrwu3GbRFG
         HlPlFQFPHLSgLzIha/4+ajLQM8pGSUIsEnul30n5u8oKcf8XR3JuMkAMNW6PtqRb9b
         +FLgoUIEapt5E6qtPZ2oIdeF1GVmKAbERcw7Ehj4=
Date:   Thu, 18 Feb 2021 13:12:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Bohac <jbohac@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pstore: fix compression
Message-ID: <YC5ZsOjBzEVbMunv@kroah.com>
References: <20210218111547.johvp5klpv3xrpnn@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218111547.johvp5klpv3xrpnn@dwarf.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 18, 2021 at 12:15:47PM +0100, Jiri Bohac wrote:
> pstore_compress() and decompress_record() use a mistyped config option
> name ("PSTORE_COMPRESSION" instead of "PSTORE_COMPRESS").
> As a result compression and decompressionm of pstore records is always
> disabled.
> 
> Use the correct config option name.
> 
> Signed-off-by: Jiri Bohac <jbohac@suse.cz>
> Fixes: fd49e03280e596e54edb93a91bc96170f8e97e4a ("pstore: Fix linking when crypto API disabled")
> 
<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
