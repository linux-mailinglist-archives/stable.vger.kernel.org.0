Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEB32D5ADD
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 13:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732802AbgLJMu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 07:50:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728557AbgLJMuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 07:50:19 -0500
Date:   Thu, 10 Dec 2020 13:50:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607604567;
        bh=B//hIslrDWa9+mx5fGtKvFudspcjyAvb72prZ+gtdV8=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=h88e8X11feqkDl7BDlwjpEEFvpZR4epINIR+OPJVZ95bPR1VVO0wQwUOSEIP0yEAf
         Y/xZSwBsVDwuadni/VWrlW0Pjig2EyDkTOYkd14XBzSQ2CV7m81JYzInhwV8s1hpYt
         /0rZ/oYKOf5pfnWdq9pPf9JQyGDLKxKHY5brknQI=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: cleanup cow block on error" failed
 to apply to 4.4-stable tree
Message-ID: <X9IZoUvRKBUadbRF@kroah.com>
References: <1604411844243166@kroah.com>
 <20201201171113.cvycv34hlpd2d22p@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201171113.cvycv34hlpd2d22p@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 01, 2020 at 05:11:13PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Tue, Nov 03, 2020 at 02:57:24PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Now applied, thanks.

greg k-h
