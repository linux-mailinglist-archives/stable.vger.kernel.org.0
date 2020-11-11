Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5432AF073
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 13:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgKKMXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 07:23:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgKKMXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Nov 2020 07:23:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68A29206FB;
        Wed, 11 Nov 2020 12:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605097393;
        bh=dB3C+pbAxC26oa1kJHnTBGqDGVVqzPNJ2KfvsNJXl8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R3gcWOTz1EV4hgfGeO3obh5JVS4ir0xZfUeSEzfXZCKbc37h0+6h7G8gOJ0gf4oJT
         uYIhry8ov4mZO4siOiFZmUj0UyzeF+b6DztqqZU3yifUPig5HQ59tZ6DVVluYmt+GL
         1EUEDfJrbU0c6FYNl8WdBS+lZQM2ZC0xIBoCOjW0=
Date:   Wed, 11 Nov 2020 13:24:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Anand K. Mistry" <amistry@google.com>
Cc:     stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: Requesting stable merge for commit
 1978b3a53a74e3230cd46932b149c6e62e832e9a
Message-ID: <X6vX7rJmlgjQqvlA@kroah.com>
References: <CAATStaPeE+SEXGNU0kcrsNgqRZgg6+9j1fw5KqLPUoCGjUP=qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAATStaPeE+SEXGNU0kcrsNgqRZgg6+9j1fw5KqLPUoCGjUP=qQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 11, 2020 at 11:09:13PM +1100, Anand K. Mistry wrote:
> Hi,
> 
> I'm requesting a stable merge for commit
> 1978b3a53a74e3230cd46932b149c6e62e832e9a
> ("x86/speculation: Allow IBPB to be conditionally enabled on CPUs with
> always-on STIBP")
> into the stable branch for 5.4. Note, the commit is already queued for
> inclusion into the next 5.9 stable release
> (https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.9/x86-speculation-allow-ibpb-to-be-conditionally-enabl.patch).
> 
> The patch fixes an issue where a Spectre-v2-user mitigation could not
> be enabled via prctl() on certain AMD CPUs. The issue was introduced
> in commit 21998a351512eba4ed5969006f0c55882d995ada
> ("x86/speculation: Avoid force-disabling IBPB based on STIBP and
> enhanced IBRS.")
> which was merged into the 5.4 stable branch as commit
> 6d60d5462a91eb46fb88b016508edfa8ee0bc7c8. This commit also exists in
> 4.19, 4.14, 4.9, and 4.4, so those kernels are also likely affected by
> this bug.

As I asked when I sent out a "FAILED:" message for this patch, if
someone wants it backported to older kernels, they will need to provide
the backported versions of it, as the patch does not apply cleanly
as-is.

Can you please do that?

thanks,

greg k-h
