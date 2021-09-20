Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A73411402
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 14:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhITMND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 08:13:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231792AbhITMND (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 08:13:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CE1C60F50;
        Mon, 20 Sep 2021 12:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632139896;
        bh=/9KAsUhAFrv4V/51F2uDRns7Zfn8jPL7yYYvxwXIvC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oRuPRcoQ/ixN0ftQOOI0XpLUMji0BIx3Wkiy/6CTRRhbPmX4bW/QGBH6204DSCXGS
         h8o5CyLb8H4v7o6zsUm87Mv6xWNyFKial2NXe19KsKcPsgolKdNsWiUDq/V7DQjOTz
         Xqy7Ofid9Ko3v+tHaTDPbW9epeJ3xBtQKfrNJZjw=
Date:   Mon, 20 Sep 2021 14:11:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     bp@suse.de, dave.hansen@intel.com, david@redhat.com,
        jolsa@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/mm: Fix kern_addr_valid() to cope
 with existing but not" failed to apply to 4.4-stable tree
Message-ID: <YUh6dlaQ9djvt0Zm@kroah.com>
References: <163212171511930@kroah.com>
 <YUh4gss5hNFWOdYu@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUh4gss5hNFWOdYu@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 03:03:14PM +0300, Mike Rapoport wrote:
> Hi Greg,
> 
> On Mon, Sep 20, 2021 at 09:08:35AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> The version below applies to both v4.4 and v4.9:

Now queued up, thanks.

greg k-h
