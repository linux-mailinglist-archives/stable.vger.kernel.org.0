Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 347CA175527
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 09:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgCBID7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 03:03:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727173AbgCBID6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 03:03:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2A97246B4;
        Mon,  2 Mar 2020 08:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136238;
        bh=c1yiLdMqLi4KqmYnpelgVsih3ng6Om7JOUW7LadwldM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o4l33z2bkSfTSwsTUn39q33FzQbB78MQLz4uPx9nIELOS03Zia+vWuDKrGUuLdxPT
         Qbq5Ymtda0HeWw40CivpXgWCLPHXUWztx7Mp65m5NEAVwRz4RPCkAHoi0JkpS3VtMG
         D0DllxCuM9DwLe0iU4ETCDfnKRMopUGl/Uf7IDtM=
Date:   Mon, 2 Mar 2020 09:03:53 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: LTS "sysrq: Restore original console_loglevel when sysrq
 disabled"
Message-ID: <20200302080353.GA1893929@kroah.com>
References: <563356cd76b666048db40743c169152f4b6efb53.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <563356cd76b666048db40743c169152f4b6efb53.camel@nokia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 02, 2020 at 07:42:55AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> Hi Greg, Sasha,
> 
> Can you cherry-pick these two sysrq patches to LTS kernels?
> They're introduced in v5.1-rc1 and should go to all prior LTS versions.
> 
> 
> commit 075e1a0c50f59ea210561d0d0fedbd945615df78
> Author: Petr Mladek <pmladek@suse.com>
> Date:   Fri Jan 11 13:45:15 2019 +0100
> 
>     sysrq: Restore original console_loglevel when sysrq disabled
>     
>     The sysrq header line is printed with an increased loglevel
>     to provide users some positive feedback.
>     
>     The original loglevel is not restored when the sysrq operation
>     is disabled. This bug was introduced in 2.6.12 (pre-git-history)
>     by the commit ("Allow admin to enable only some of the Magic-Sysrq
>     functions").
> 
> 
> commit c3fee60908db4a8594f2e4a2131998384b8fa006
> Author: Petr Mladek <pmladek@suse.com>
> Date:   Fri Jan 11 17:20:37 2019 +0100
> 
>     sysrq: Remove duplicated sysrq message
>     
>     The commit 97f5f0cd8cd0a0544 ("Input: implement SysRq as a separate
> input
>     handler") added pr_fmt() definition. It caused a duplicated message
>     prefix in the sysrq header messages, for example:
>     
>     [  177.053931] sysrq: SysRq : Show backtrace of all active CPUs
>     [  742.864776] sysrq: SysRq : HELP : loglevel(0-9) reboot(b) crash(c)
>     
>     Fixes: 97f5f0cd8cd0a05 ("Input: implement SysRq as a separate input
> handler")
> 

Both now queued up, thanks.

greg k-h
