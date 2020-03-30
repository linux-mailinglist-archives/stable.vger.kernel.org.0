Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFE919771A
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 10:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbgC3Izp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 04:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729595AbgC3Izo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 04:55:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB9D420733;
        Mon, 30 Mar 2020 08:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585558544;
        bh=yXshj78rpaaE/6TjH9D+wtcX/U1jdeG+yeIzWu7eJnk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T/kcVoZ0tSnb/HjnMiZ5ckFC8tSuGotqfEoOR28NLZuC/T3J4X/xgn0JglDoE8EY7
         beMkqir7k9N8ZiEQZQ2MtYXf+rcm7Xda6ajiKrC0eRJXZibF3x+Yck07phGLfam3B4
         gWFM5Bce8bzipkyWn1P6vrFiLW+XQ6XvK3pve/LE=
Date:   Mon, 30 Mar 2020 10:55:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Patches for v4.14.y
Message-ID: <20200330085540.GD239298@kroah.com>
References: <20200329213322.GA23871@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200329213322.GA23871@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 29, 2020 at 02:33:22PM -0700, Guenter Roeck wrote:
> Hi,
> 
> Please consider applying the following patches to v4.14.y.
> 
> The following patches were found to be missing in v4.14.y by the ChromeOS
> missing patch robot. The patches meet the following criteria.
> - The patch includes a Fixes: tag
> - The patch referenced in the Fixes: tag has been applied to v4.14.y
> - The patch has not been applied to v4.14.y
> 
> All patches have been applied to v4.14.y and chromeos-4.14. Resulting images
> have been build- and runtime-tested on real hardware with chromeos-4.14
> and with virtual hardware on kerneltests.org.
> 
> Upstream commit 76fc52bd07d3 ("arm64: ptrace: map SPSR_ELx<->PSR for compat tasks")
> 	Fixes: 7206dc93a58fb764 ("arm64: Expose Arm v8.4 features")
> 	in v4.14.y: 053cdffad3dd

Now queued up.

> Upstream commit 25dc2c80cfa3 ("arm64: compat: map SPSR_ELx<->PSR for signals")
> 	Fixes: 7206dc93a58fb764 ("arm64: Expose Arm v8.4 features")
> 	in v4.14.y: 053cdffad3dd

Now queued up.

> Upstream commit 93a64ee71d10 ("MAINTAINERS: Remove deleted file from futex file pattern")
> 	Fixes: 04e7712f4460 ("y2038: futex: Move compat implementation into futex.c")
> 	in v4.14.y: 0c08f1da992d
> 	Notes:
> 		Also applies to v4.19.y.
> 		This is an example for a patch which isn't really necessary
> 		(it doesn't fix a bug, only an entry in the the MAINTAINERS file),
> 		but automation won't be able to know that. Please let me know
> 		what to do with similar patches in the future.

Just drop it, there will always be these types of "fixes" that don't
make sense for stable trees.

> Upstream commit 074376ac0e1d ("ftrace/x86: Anotate text_mutex split between ftrace_arch_code_modify_post_process() and ftrace_arch_code_modify_prepare()")
> 	Fixes: 39611265edc1a ("ftrace/x86: Add a comment to why we take text_mutex in ftrace_arch_code_modify_prepare()")
> 	Fixes: d5b844a2cf507 ("ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()")
> 	in v4.14.y: 0c0b54770189 (upstream d5b844a2cf507)
> 	Notes:
> 		Also applies to v4.19.y.

This only affects running sparse on the code, which for 4.14 I doubt
anyone is doing anymore.  But I'll take it as it might make things
easier for some people auditing 4.19 at the moment.

thanks,

greg k-h
