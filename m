Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754BE327E8C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhCAMqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:46:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235043AbhCAMqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 07:46:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7555F601FE;
        Mon,  1 Mar 2021 12:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614602755;
        bh=wgJHrwDiFJ40+r/kbgx25BHO2vjMlUMTBrPkXaXEUH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MtJvZYD1e8aoR+bRWcjA+tMlFAd0WZadZNrMDUypuotTEUANH97bKOM8zLV7lU1ZH
         Bm8shtMXWqkHBfXwE2EmSpKOk2I9wDwZ7VYEFg4UfAGTUifrQkwoM7IOAMh8rCY9ej
         nf1zJovbqO2k/4fHcCkVcyvIJ6ct+cCss3qO3IJg=
Date:   Mon, 1 Mar 2021 13:45:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     dan.j.williams@intel.com, colyli@suse.com, dave.jiang@intel.com,
        ira.weiny@intel.com, rpalethorpe@suse.com, stable@vger.kernel.org,
        vishal.l.verma@intel.com
Subject: Re: FAILED: patch "[PATCH] libnvdimm/dimm: Avoid race between probe
 and" failed to apply to 4.19-stable tree
Message-ID: <YDziADsARVarJEW7@kroah.com>
References: <1612779897191109@kroah.com>
 <YDgVYCKzK8zNt3Jy@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDgVYCKzK8zNt3Jy@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 09:23:44PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Feb 08, 2021 at 11:24:57AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. Will apply to all branches till 4.4-stable.

thanks, now queued up.

greg k-h
