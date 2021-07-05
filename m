Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6EE3BB794
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 09:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhGEHQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 03:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhGEHQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 03:16:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 151B2613E1;
        Mon,  5 Jul 2021 07:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625469230;
        bh=BCNSfe7pDOpKXgbu1jFyiIwbNvw48jmLXMGdSrQj6xg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t9oCCBET/2rYC1HOTAc+5KHWeqKHNrli/oGc2ruHDCSSUMMiAjRNfBPWZsgVO9F6S
         S6N7LuFxuCIqPKewkuMwK6UG8wquWjahjQHSUTbO7Jv8C/SIqQu5n1HMftXZUOlDMF
         e5Kbpy+m2pqCdGEbqjC11584ybJQdZ9vUg36K+3k=
Date:   Mon, 5 Jul 2021 09:13:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     mbloch@nvidia.com, jgg@nvidia.com, leonro@nvidia.com,
        maorg@nvidia.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] RDMA/mlx5: Block FDB rules when not in
 switchdev mode" failed to apply to 5.10-stable tree
Message-ID: <YOKxLPPQMl+nr/+v@kroah.com>
References: <1623589674120109@kroah.com>
 <YNo+Kyd8bbGB6uAM@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNo+Kyd8bbGB6uAM@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 10:24:59PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sun, Jun 13, 2021 at 03:07:54PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Both backports now queued up, thanks!

greg k-h
