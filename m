Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430263372DC
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 13:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhCKMid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 07:38:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:60284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233393AbhCKMiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 07:38:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D86464FE5;
        Thu, 11 Mar 2021 12:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615466287;
        bh=LTVGUTo1kseudAS3KUobgetn5yp4eRHLobTIAJRUq44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YmL2d8oOuFvQR1QXDvY9n86naqBjJuZj+ENs/8Xt75L6gv+4Vgmb0J44nYBp4rGU9
         RtVV2Ow9Y0wov13cn+/JYBf1+WnVmQmYBQ7QL0QpGRGNbTbSq+YDZi0yOMF/bsBJhr
         Ia0dhVbd5rhudGjjQbL7z9HVfIX4N13pefboCA94=
Date:   Thu, 11 Mar 2021 13:38:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     rudi@heitbaum.com
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/47] 5.10.23-rc2 review
Message-ID: <YEoPLJeDavaNmzJ+@kroah.com>
References: <20210310182834.696191666@linuxfoundation.org>
 <20210311113923.GA1770046@cd5f4d36aa95>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311113923.GA1770046@cd5f4d36aa95>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 11:39:23AM +0000, rudi@heitbaum.com wrote:
> On Wed, Mar 10, 2021 at 07:29:23PM +0100, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 5.10.23 release.
> > There are 47 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> The following patch is still missing Pavell's identified missing line
> - patch @ https://lore.kernel.org/lkml/20210310200458.GA12122@amd/

It needs to be submitted and accepted upstream properly and then I can
backport it to the stable tree.  As it is, this patch is correctly
mirroring what is in 5.11.

thanks,

greg k-h
