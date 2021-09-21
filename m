Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AA9412E67
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 07:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbhIUF5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 01:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhIUF5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 01:57:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0E8F61090;
        Tue, 21 Sep 2021 05:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632203739;
        bh=80vjryW1wC+XSN92QuzCTRcS2JNVNDR4NBHlhByCMyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wcJSrcve5TJHB+Fa3QLfb+hDPIsSHgaZmfn3PoPElEven3uzuUP63DnFyCjmbETV6
         6jWU0vZH6GevMTPodGXr+/ojyGOKlsLhR+TH3XDX4+0/3EiTzvjqCdiQaUapzCzqb1
         TUbpLsDUWjJFKXWdO2et9KV9bvMj5gZ4FaLvZPD8=
Date:   Tue, 21 Sep 2021 07:55:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: fix for core dumping of a process getting oom-killed
Message-ID: <YUlzwDt3IWFzOSCU@kroah.com>
References: <9aec4002-754c-ca6d-7caf-9de6e8c31dd7@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9aec4002-754c-ca6d-7caf-9de6e8c31dd7@apple.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 11:38:40PM -0500, Vishnu Rangayyan wrote:
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 3224dee44d30..187813704533 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -54,6 +54,7 @@
> 
>  int core_uses_pid;
>  unsigned int core_pipe_limit;
> +unsigned int core_sync_bytes = 131072; /* sync core file every so many
> bytes */
>  char core_pattern[CORENAME_MAX_SIZE] = "core";
>  static int core_name_size = CORENAME_MAX_SIZE;

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch is malformed (tabs converted to spaces, linewrapped, etc.)
  and can not be applied.  Please read the file,
  Documentation/email-clients.txt in order to fix this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
