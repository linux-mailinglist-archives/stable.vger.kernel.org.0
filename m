Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC1413C677
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 15:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgAOOr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 09:47:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbgAOOr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 09:47:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0F59214AF;
        Wed, 15 Jan 2020 14:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579099677;
        bh=CqsgkQ8t+Rx/KaPl32tWcSn54H3bhS+DOz+lw8jj0gg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kAiQvgh29/wjVDYC5aVzdiu/hFnY7OWIPQsaorKdYSnIx/BcM5T71mOeG+SU+f84U
         Vd7UFc0vgcvPWd+qGKu3brtswJxsam2jxW/xuZBUFMrFqvMr+/06I98Au5llMaiolj
         8TTHtIZIqzfmGD1oSEqZEJaniXxrz/rPFAFvysMk=
Date:   Wed, 15 Jan 2020 15:47:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.19-stable] Mostly securit y fixes
Message-ID: <20200115144753.GA3680618@kroah.com>
References: <1eaa745218d25ab3c5c61361ae0d9b0601f1d99f.camel@codethink.co.uk>
 <41577104e06f774691365564d0a74b46e16b50e5.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41577104e06f774691365564d0a74b46e16b50e5.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 14, 2020 at 05:50:35PM +0000, Ben Hutchings wrote:
> On Tue, 2020-01-14 at 14:47 +0000, Ben Hutchings wrote:
> > Some more fixes that required backporting for 4.19.  All these fixes
> > are related to CVEs though some of them don't seem to have any security
> > impact.
> 
> The last of these (for dccp) should probably go to you via David
> Miller, though.

As they are not needed in 5.4, they usually will not show up on his
radar so I can gladly take them directly.

thanks,

greg k-h
