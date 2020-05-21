Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B955D1DC6AB
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 07:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgEUFnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 01:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgEUFnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 01:43:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 339392070A;
        Thu, 21 May 2020 05:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590039819;
        bh=P13cLDbdk4eb5zb9NPNGDplnI/plZ8TrRLArj/PfNPk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lJPEpk6iimFsD76/tN4NWDB27UFNiO4WgdcRs3wgGGl3kiozurOLL433NsD0NZ20g
         gUzxY60HbYwPuD6m7pgloovZTg9+lKBJzk6FxaTCn05B7cMhhQ/MZ8Ou5G2uiU5k94
         pGw5ExzyJeRmqGQRwUBoDJeBRuy2n03Tptlf77Xw=
Date:   Thu, 21 May 2020 07:43:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.14-stable] Security fixes
Message-ID: <20200521054336.GA2295294@kroah.com>
References: <5b5c9da70a78bd84900199153a417dba43ba3c32.camel@codethink.co.uk>
 <c0dbc0d6efc535eefbc8812aced29786595864ad.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0dbc0d6efc535eefbc8812aced29786595864ad.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 08:32:27PM +0100, Ben Hutchings wrote:
> On Tue, 2020-05-12 at 15:26 +0100, Ben Hutchings wrote:
> > Here are some fixes that required backporting for 4.14.  All of them
> > are already present in later stable branches.
> 
> There's one fix I thought I had included in this, but didn't:
> 
> commit af133ade9a40794a37104ecbcc2827c0ea373a3c
> Author: Shijie Luo <luoshijie1@huawei.com>
> Date:   Mon Feb 10 20:17:52 2020 -0500
> 
>     ext4: add cond_resched() to ext4_protect_reserved_inode
> 
> This should apply cleanly.  It has already been applied to all other
> stable branches.

Now applied, thanks.

greg k-h
