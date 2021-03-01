Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70C3327DF3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhCAMMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233158AbhCAMMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 07:12:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 774AF64E31;
        Mon,  1 Mar 2021 12:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614600685;
        bh=f5YbgPgY4PYtnfDdijnli6OebH1Ccj+UNEdMCfDeur4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dje1ZBWWxfmHS/s+cnlFWz5pjIO6Jj8UFpl9T8ExHq3CR7yC0QYUp8xFx8AeHkPq8
         MRJDBDdPkGZXbElFZD0tjFQPu+NPyWTGxW4JIkQ+JbiMyAxYwTsofZYQg5ojDLYtxw
         0jE7IZoiQx3vlQddv7Ub83k+736PxsZPkIl/O9co=
Date:   Mon, 1 Mar 2021 13:11:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     stable@vger.kernel.org, efremov@linux.com, kurt@garloff.de,
        wim@djo.tudelft.nl
Subject: Re: FAILED: patch "[PATCH] floppy: reintroduce O_NDELAY fix" failed
 to apply to 5.4-stable tree
Message-ID: <YDzZ6qaeq78LfgOA@kroah.com>
References: <1614597396146166@kroah.com>
 <nycvar.YFH.7.76.2103011256400.12405@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.2103011256400.12405@cbobk.fhfr.pm>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 12:59:26PM +0100, Jiri Kosina wrote:
> On Mon, 1 Mar 2021, gregkh@linuxfoundation.org wrote:
> 
> > The patch below does not apply to the 5.4-stable tree. If someone wants 
> > it applied there, or to any other stable or longterm tree, then please 
> > email the backport, including the original git commit id to 
> > <stable@vger.kernel.org>.
> 
> Below is a backport of upstream commit 8a0c014cd20516a taken from SUSE 
> kernel tree.

Thanks, now queued up.

greg k-h
