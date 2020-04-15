Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34E91AA3CB
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506131AbgDONMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506124AbgDONMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 09:12:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 780F720775;
        Wed, 15 Apr 2020 13:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586956339;
        bh=+n8P4eX3Gq5ddkEFWUNTVaGdvjE6oAz0upU0TwdxGt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cBCotnngAvbMa94YB7R4aAXgxUaPqL0oGpIbjGRrdpcNO2UwCxQVn03T8xrJLRl5z
         xXAZWrOWh/gUNVILTTdysIdMcZPJ+VFWyDSW6OIgLQ0hlTkhSonsvzVTAf44Nc6WRj
         9YQjsCK60IyPptOg/jlfFhwJvanQv6G0elFPACmA=
Date:   Wed, 15 Apr 2020 15:12:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Merlijn B.W. Wajer" <merlijn@archive.org>
Cc:     bvanassche@acm.org, arnd@arndb.de, martin.petersen@oracle.com,
        stable@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: sr: Fix sr_block_release()" failed
 to apply to 5.6-stable tree
Message-ID: <20200415131217.GA3439691@kroah.com>
References: <1586949568154118@kroah.com>
 <d16dfd1f-6b30-04e4-0e01-461b6c00e965@archive.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d16dfd1f-6b30-04e4-0e01-461b6c00e965@archive.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 02:51:43PM +0200, Merlijn B.W. Wajer wrote:
> Hi,
> 
> On 15/04/2020 13:19, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.6-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This patch should apply fine on top of commit
> 51a858817dcdbbdee22cb54b0b2b26eb145ca5b6 [1].
> 
> Which wasn't mailed to stable@, but should have been. So if
> 51a858817dcdbbdee22cb54b0b2b26eb145ca5b6 is included, then this patch
> should apply fine as well.

That worked, thanks!

greg k-h
