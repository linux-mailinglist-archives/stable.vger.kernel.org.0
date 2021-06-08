Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8E539FAF6
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 17:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbhFHPir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 11:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232263AbhFHPiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 11:38:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D09B60FDB;
        Tue,  8 Jun 2021 15:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623166602;
        bh=K5xIDCJcfbM60pOfKATwe/BYNQCkPCiUZMXSUuGYCiI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g6zMSc22IHL4ChS6G1iyFlo0F9v26NJzyGT9rhoJD8LP+306xB4d/to/nTTOcxAjZ
         2zs12kNi6D4y3YGve7vdmhb3oMHtoqu8bWL+jYEukyOftSy0ySLwoOnB7OYsfH0uh8
         7BkroMDh5ADbRruANEq2GIXvKeISOzfFBy+2CWKU=
Date:   Tue, 8 Jun 2021 17:36:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     anand.jain@oracle.com, dsterba@suse.com, fdmanana@suse.com,
        lists@colorremedies.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: fix unmountable seed device after
 fstrim" failed to apply to 5.10-stable tree
Message-ID: <YL+Oh/K+EzzVstOq@kroah.com>
References: <1620999891925@kroah.com>
 <YL5/a+ngsCX28uPz@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL5/a+ngsCX28uPz@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 07, 2021 at 09:19:55PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Fri, May 14, 2021 at 03:44:51PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backported patch, will also apply to all branches till 4.19-stable.

Now queued up, thanks.

greg k-h
