Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4072D5D28
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgLJOIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:08:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730907AbgLJOIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:08:14 -0500
Date:   Thu, 10 Dec 2020 15:08:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607609253;
        bh=UIiJ2Wyo3bh77f9HieiqlUzIrWpYz4qyDmcB1Vsm9n0=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=aE+IUSt6RMdx8roJ24rAFP6vPleaRXnCmB16XGFk86WPpeBd/+aFnyxz3mbj3C3OU
         vEtzLehnRrRhzErohWfQXeq6iSz9ibQZ9KxnccyqeUnPNqQvaxhVhEaJR+vpXhGlQ8
         qNoQ9qERKArRJlrMPfIKUf1xaQ+AmhIyfO1oBgJY=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     mhiramat@kernel.org, bp@suse.de, keescook@chromium.org,
        srikar@linux.vnet.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/uprobes: Do not use prefixes.nbytes
 when looping over" failed to apply to 4.4-stable tree
Message-ID: <X9Ir7yOwLY4fxhaM@kroah.com>
References: <1607506453129233@kroah.com>
 <20201210132907.rdiix6xynfl72ghz@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210132907.rdiix6xynfl72ghz@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 01:29:07PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Dec 09, 2020 at 10:34:13AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Thanks for all 3, now queued up.

greg k-h
