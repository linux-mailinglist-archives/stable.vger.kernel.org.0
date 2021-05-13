Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B5737F570
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 12:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhEMKQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 06:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231204AbhEMKQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 06:16:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85D8F61184;
        Thu, 13 May 2021 10:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620900898;
        bh=ju6HFje7lysc28xbgTh5cB284DnvE0Gku/qKzexuuEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LpahGk3SBnZ/ZvXp4UKuCOguwJ4Gr2j+PltT3CjI0fKxVZT51NAAmyl+QioRy2Eb+
         XKWiqfEivx/f0OUzjPeTveyN1kqtw+DT4sK92sSBqebgVKH9sdb9cmO2uMeY4ocHTb
         u78ulDnqwMvDV6hUx6FTvjdeGzGDWS5KZjC4MXZc=
Date:   Thu, 13 May 2021 12:14:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 5.10 052/530] MIPS: Reinstate platform `__div64_32 handler
Message-ID: <YJz8H1IGj+7ucUtO@kroah.com>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144821.451207008@linuxfoundation.org>
 <YJzncHQfODFWvZt2@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJzncHQfODFWvZt2@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 09:46:40AM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, May 12, 2021 at 04:42:42PM +0200, Greg Kroah-Hartman wrote:
> > From: Maciej W. Rozycki <macro@orcam.me.uk>
> > 
> > commit c49f71f60754acbff37505e1d16ca796bf8a8140 upstream.
> 
> This is breaking the mips build of malta_qemu_32r6_defconfig. Reverting
> the patch fixes the build.

It's now dropped, thanks.

greg k-h
