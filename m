Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F8532D46E
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhCDNpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:45:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238751AbhCDNo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 08:44:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5687664F39;
        Thu,  4 Mar 2021 13:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614865457;
        bh=M+CNzzABx03+XwuPMjUhgAEfV3MnkUoXGG6tO10yYbE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=piJD45auJNCTDzOSziAJkFmbIELMzutt0CYrfZFpC9rR4euFE7ieqVVgXUe1lvf1l
         +oip08edqbrPFISwqp54IEZmbS9CbakFQjWwXEndOHcIvW4eXFYm0gvwqIV+ZJ36oe
         Xc0AIeGrXrRAmHbKFW+eBiiCtiYBtyvSiZKdg740=
Date:   Thu, 4 Mar 2021 14:44:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     YunQiang Su <syq@debian.org>
Cc:     stable@vger.kernel.org
Subject: Re: backport binfmt_misc: pass binfmt_misc flags to the interpreter
Message-ID: <YEDkL87VdNM/BP6b@kroah.com>
References: <CAKcpw6Xo9ZsDFP40PH1h9zETwD8MFY=aZ7gDCqV4s4Ld9UVViw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKcpw6Xo9ZsDFP40PH1h9zETwD8MFY=aZ7gDCqV4s4Ld9UVViw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 04:02:22PM +0800, YunQiang Su wrote:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.12-rc1&id=2347961b11d4079deace3c81dceed460c08a8fc1
> This patch can be apply to 5.10 and 5.11 directly.
> 
> binfmt_misc: pass binfmt_misc flags to the interpreter
> 
> It can be useful to the interpreter to know which flags are in use.
> 
> For instance, knowing if the preserve-argv[0] is in use would allow to
> skip the pathname argument.
> 
> This patch uses an unused auxiliary vector, AT_FLAGS, to add a flag to
> inform interpreter if the preserve-argv[0] is enabled.
> 
> Note by Helge Deller:
> The real-world user of this patch is qemu-user, which needs to know if
> it has to preserve the argv[0]. See Debian bug #970460.
> 
> Signed-off-by: Laurent Vivier <laurent@vivier.eu>
> Reviewed-by: YunQiang Su <ysu@wavecomp.com>
> URL: http://bugs.debian.org/970460
> Signed-off-by: Helge Deller <deller@gmx.de>

This feels like a new feature, how does it fit with the stable kernel
rules?

thanks,

greg k-h
