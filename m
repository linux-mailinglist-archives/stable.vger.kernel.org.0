Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D8713D5F0
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 09:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgAPI3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 03:29:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgAPI33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 03:29:29 -0500
Received: from localhost (static-140-208-78-212.thenetworkfactory.nl [212.78.208.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B446720748;
        Thu, 16 Jan 2020 08:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579163369;
        bh=Is/4yOIEOq1JdRcq2iPJJ/1pJLKK/Qtrld0DqF3s0IE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hMCO0Id+6jBDHe5Wpq+G2quQe4keTGcxOHqbM9xATnZKkd1tHkDrGTfRx34Is7zjZ
         P4pun88/JoKEw/u5eTfIyLWHNdQ68kISIBpPQWFFnJp+KMOsrhA/7kOTSE1Gmg3YrU
         7nkiqZ0AqivF6glEcb9uhkd6M16t3gFx0Ylj5MfI=
Date:   Thu, 16 Jan 2020 09:28:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: missing backports for x86 syscall function prototype cleanups
Message-ID: <20200116082848.GA2359@kroah.com>
References: <202001151737.F00EC408@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202001151737.F00EC408@keescook>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 05:41:07PM -0800, Kees Cook wrote:
> Hi!
> 
> Sami pointed out to me that 4 of 6 patches in Linus's tree that were
> cleaning up the x86 syscall function prototypes didn't make it into
> -stable.
> 
> These were backported:
> 
> 8661d769ab77 ("syscalls/x86: Use the correct function type in SYSCALL_DEFINE0")
> 	(as e79138ba8e0ec84f3ab5daa4761e4d534bbc682d)
> f53e2cd0b8ab ("x86/mm: Use the correct function type for native_set_fixmap()")
> 	(as a823d762a57519adeb33f5f12f761d636e42d32e)
> 
> But these are missing, leading to some confusion when working with v5.4
> under CFI:
> 
> cf3b83e19d7c928e05a5d193c375463182c6029a
> 00198a6eaf66609de5e4de9163bb42c7ca9dd7b7
> f48f01a92cca09e86d46c91d8edf9d5a71c61727
> 6e4847640c6aebcaa2d9b3686cecc91b41f09269
> 
> Can these get added please?

I've queued them up now.  But for 4.19, are these also needed?  If so,
f48f01a92cca ("syscalls/x86: Use the correct function type for
sys_ni_syscall") needs a backport for it to work properly.

thanks,

greg k-h
