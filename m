Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD5B47D18B
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 13:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240141AbhLVMNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 07:13:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50124 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbhLVMNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 07:13:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEDB9618AC
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 12:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A542FC36AE8;
        Wed, 22 Dec 2021 12:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640175185;
        bh=Q6CRuRPVnGUIHaZmtwLDd7UoQrWJfTxen0sFQDmC5x4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X1grTQoDbT+z6tGByEvHA3bbsREbQXNq4Aq9drzzXEUU8cdu49V1G28HbzrtmiPrD
         4FHQghbttuHpddDkm9K9GQ7AtMoDehSCpx1DqvdpU5E12z9kqOBYghNv0BFdbC/3Z7
         ODTI2avLg2C7jygcGfmGFXKfaXsEGZOWR5nlBi1g=
Date:   Wed, 22 Dec 2021 13:13:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Howells <dhowells@redhat.com>
Cc:     jefflexu@linux.alibaba.com, jlayton@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] netfs: fix parameter of cleanup()" failed
 to apply to 5.15-stable tree
Message-ID: <YcMWTgAEslW1Vg57@kroah.com>
References: <163913443334205@kroah.com>
 <292330.1639150575@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <292330.1639150575@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 10, 2021 at 03:36:15PM +0000, David Howells wrote:
> <gregkh@linuxfoundation.org> wrote:
> 
> > -			ops->cleanup(netfs_priv, folio_file_mapping(folio));
> > +			ops->cleanup(folio_file_mapping(folio), netfs_priv);
> 
> Is it page->mapping or page_mapping(page) instead of folio_file_mapping()?  If
> so, you can switch that to the other side instead, e.g.:
> 
> -			ops->cleanup(netfs_priv, page_mapping(page));
> +			ops->cleanup(page_mapping(page), netfs_priv);
> 
> David
> 

Ok, can you or someone send me a fixed up patch like this so that I can
apply it?

thanks,

greg k-h
