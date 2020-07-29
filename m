Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFA9231DB8
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 13:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgG2L4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 07:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgG2L4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 07:56:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5340207FC;
        Wed, 29 Jul 2020 11:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596023766;
        bh=2ziH2nmr/bFq+92fubW5422iXcUzyt5yaJmXwqqxbl8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TUt633T+0G39o5KQsyivhwIE/rVaTLdXPZSSKkb9TSOoXWwpgRvvRAMS0oksrovf9
         jfVTifGobJDvTsCl4pxcAuy7NuxeXlbAlsRI7YjnCHJGTkQJgUgS5lsvN1wn+1UcBL
         7IQuaJ+kW+C4cQpUBs7ipy9JZl3PPt22PDme5EVM=
Date:   Wed, 29 Jul 2020 13:55:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     John Donnelly <John.P.donnelly@oracle.com>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (resend) [PATCH [linux-4.14.y]] dm cache: submit writethrough
 writes in parallel to origin and cache
Message-ID: <20200729115557.GA2799681@kroah.com>
References: <37c5a615-655d-c106-afd0-54e03f3c0eef@oracle.com>
 <20200727150014.GA27472@redhat.com>
 <20200729115119.GB2674635@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729115119.GB2674635@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 29, 2020 at 01:51:19PM +0200, Greg KH wrote:
> On Mon, Jul 27, 2020 at 11:00:14AM -0400, Mike Snitzer wrote:
> > This mail needs to be saent to stable@vger.kernel.org (now cc'd).
> > 
> > Greg et al: please backport 2df3bae9a6543e90042291707b8db0cbfbae9ee9
> 
> Now backported, thanks.

Nope, it broke the build, I need something that actually works :)
