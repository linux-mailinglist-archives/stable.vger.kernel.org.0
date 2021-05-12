Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A008937BF64
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhELOI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230018AbhELOI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:08:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59AD761407;
        Wed, 12 May 2021 14:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620828468;
        bh=rIYWxyJ1pi03Ay32u169MRrM4Cp/QiTVoHL6MiTZBKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lqubggtylfH8N4qFDSiz+e7mYvgjhKrzcUpN6RWeetuVE91jcJI3tDBFioMaqqy3R
         LBnH4rllabpt2eeH4c7mMOOva91zUbXgbMf503WqeINKlFGOIGBfx8VLr3EuQEi5Tj
         UenYTd2wIy+Suyb+bQJ9b2MU7wc/J44o5EO0Au3g=
Date:   Wed, 12 May 2021 16:07:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Quentin Perret <qperret@google.com>
Cc:     stable@vger.kernel.org, alexandre.torgue@foss.st.com,
        robh+dt@kernel.org, f.fainelli@gmail.com, ardb@kernel.org,
        sashal@kernel.org
Subject: Re: Revert memblock backports with missing dependencies
Message-ID: <YJvhMv/RLDIgA4IC@kroah.com>
References: <20210512122853.3243417-1-qperret@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512122853.3243417-1-qperret@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 12:28:51PM +0000, Quentin Perret wrote:
> Hi all,
> 
> A breakage in 5.4.102 has been reported [1] due to the backport of the
> two following upstream commits:
> 
>   8a5a75e5e9e5 ("of/fdt: Make sure no-map does not remove already reserved regions")
>   86588296acbf ("fdt: Properly handle "no-map" field in the memory region")
> 
> As Alexandre noted in the original thread, the backport missed
> dependencies. But since these patches were not really fixes in the first
> place, it seems preferable to simply revert them from 5.4 and earlier.
> 
> [1] https://lore.kernel.org/linux-arm-kernel/CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com/
> 
> Quentin Perret (2):
>   Revert "of/fdt: Make sure no-map does not remove already reserved
>     regions"
>   Revert "fdt: Properly handle "no-map" field in the memory region"
> 
>  drivers/of/fdt.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)

All now queued up, thanks.

greg k-h
