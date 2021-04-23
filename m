Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BE2368E08
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 09:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhDWHmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 03:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229993AbhDWHmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 03:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93372613CC;
        Fri, 23 Apr 2021 07:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619163689;
        bh=xbfW9+nMsr+EbJ1u7f+oV5Mjdc4DYnSoTlX+3kqGAbk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=crTljxvJV7umKvdU2kafFt69fiEhQVvP0k2XW+a+iNcpyWYbPHkyFEpHhu5d3YTJg
         hS4F36NtWFVdmeILDz7mnLtFOKFkd5dqJG5z6xhEQkuBcLDEhqXPhWYwucg6U3+tSq
         CqpYUnJwnSHrZ39aIBPNsJ9uLwG4a4LeSmlTHjMs=
Date:   Fri, 23 Apr 2021 09:41:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manoj Gupta <manojgupta@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>, stable@vger.kernel.org,
        maskray@google.com, llozano@google.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: set retain atrribute on sections
Message-ID: <YIJ6Jl5Lzekk2rzC@kroah.com>
References: <20210422182545.726897-1-manojgupta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422182545.726897-1-manojgupta@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 22, 2021 at 11:25:45AM -0700, Manoj Gupta wrote:
> LLD 13 and GNU ld 2.37 support -z start-stop-gc which allows garbage
> collection of C identifier name sections despite the __start_/__stop_
> references.  Simply set the retain attribute so that GCC 11 (if
> configure-time binutils is 2.36 or newer)/Clang 13 will set the
> SHF_GNU_RETAIN section attribute to prevent garbage collection.
> 
> Without the patch, there are linker errors like the following with -z
> start-stop-gc:
> ld.lld: error: undefined symbol: __stop___cmd
> >>> referenced by iw.c:418
> >>>               iw.o:(__handle_cmd)
> 
> Suggested-by: Fangrui Song <maskray@google.com>
> 
> Signed-off-by: Manoj Gupta <manojgupta@google.com>
> ---
>  iw.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
