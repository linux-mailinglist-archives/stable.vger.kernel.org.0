Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF473D56B3
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 11:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhGZIzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 04:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232482AbhGZIzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 04:55:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69FCC60F42;
        Mon, 26 Jul 2021 09:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627292171;
        bh=/VjjRQqib0WPx6hw7MyyYPiYuQl2h/RPUxAVPkY9SNU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UcWreaqb39g0Sy3WLUkhGpVtfXLLimUvMOpUj8aQP7XV8ogtehdcd4cFgopQHwsIK
         mxam84Q0NeawBS/TJa4XbRGFbWjgCgdVq5wc+STWL++PWYKYep8cBwvOfyvgLQsOaw
         D09b5uj9lXuDyRibRKgKerM0bbF/9EbPSNEYyi1M=
Date:   Mon, 26 Jul 2021 11:34:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     evan.quan@amd.com, alexander.deucher@amd.com, bhelgaas@google.com,
        kw@linux.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: Mark AMD Navi14 GPU ATS as broken"
 failed to apply to 5.10-stable tree
Message-ID: <YP6BtHuj2pe+3Znd@kroah.com>
References: <1624272159224240@kroah.com>
 <YPsicJu7+dXobhdI@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPsicJu7+dXobhdI@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 23, 2021 at 09:11:28PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jun 21, 2021 at 12:42:39PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will apply till 4.19-stable.

Applied, thanks!

greg k-h
