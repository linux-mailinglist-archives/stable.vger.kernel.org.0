Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A491517A821
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 15:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgCEOwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 09:52:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgCEOwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 09:52:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 865FC20732;
        Thu,  5 Mar 2020 14:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583419922;
        bh=b3+JFLkZ6vcp4pzQhkXCAbgg9XJb+w2v77GsD2/Sotc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qVotdRTvp/AYf0WKIbBVywqCH4uqSPWXDLT90qzd8pTJ1xbsNjnqMbIyT1j+pHTP4
         2BIcXk5nDDjV7S/Re7TL6IXjAYjDYr3ki+/KgOayA8tXC3EZL3hctTpQU6X3S/iJnS
         pUpgcueLTtak6NchIfTySrpA8YEsiuGHSI3GnbvE=
Date:   Thu, 5 Mar 2020 15:51:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [BUGFIX PATCH] tools: Let O= makes handle a relative path with
 -C option
Message-ID: <20200305145159.GB1950999@kroah.com>
References: <9e7beb31-b41f-9e95-c92b-1829e420af77@infradead.org>
 <158338818292.25448.7161196505598269976.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158338818292.25448.7161196505598269976.stgit@devnote2>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 05, 2020 at 03:03:03PM +0900, Masami Hiramatsu wrote:
> When I compiled tools/bootconfig from top directory with
> -C option, the O= option didn't work correctly if I passed
> a relative path.
> 
>   $ make O=./builddir/ -C tools/bootconfig/
>   make: Entering directory '/home/mhiramat/ksrc/linux/tools/bootconfig'
>   ../scripts/Makefile.include:4: *** O=./builddir/ does not exist.  Stop.
>   make: Leaving directory '/home/mhiramat/ksrc/linux/tools/bootconfig'
> 
> The O= directory existence check failed because the check
> script ran in the build target directory instead of the
> directory where I ran the make command.
> 
> To fix that, once change directory to $(PWD) and check O=
> directory, since the PWD is set to where the make command
> runs.
> 
> Fixes: c883122acc0d ("perf tools: Let O= makes handle relative paths")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>  tools/scripts/Makefile.include |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
