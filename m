Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A453182070
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 19:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbgCKSKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 14:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730468AbgCKSKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 14:10:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D51E9206BE;
        Wed, 11 Mar 2020 18:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583950251;
        bh=7O660q3RwjCgBY9WqCX9aItV5KFsyT+RF1lpgKaTQMs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u21//3ycvNsNd3it9gY9yPrZIFCWwPMR8ENPH1lnXHw7XPHAdaxOK0hj5wZD+jff3
         6WdMoTAc6uIIhPtTZTpoa4X4Q4LFFwFjW5Gzcn6Wc/1bKP+nzK5KjiYCNFNXMTqj5k
         X15ALsvfmDKMUelnQLOCs5lly2XOEVqQj6gJ5wmQ=
Date:   Wed, 11 Mar 2020 19:10:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Subject: Re: [PATCH 5.5 000/189] 5.5.9-stable review
Message-ID: <20200311181048.GB3970258@kroah.com>
References: <20200310123639.608886314@linuxfoundation.org>
 <da0afb1f-1045-d7c2-cf34-bb357fdce15e@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da0afb1f-1045-d7c2-cf34-bb357fdce15e@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 09:02:19AM -0700, Guenter Roeck wrote:
> On 3/10/20 5:37 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.9 release.
> > There are 189 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 12 Mar 2020 12:34:10 +0000.
> > Anything received after that time might be too late.
> > 
> 
> block/bfq-wf2q.c: In function 'bfq_forget_entity':
> ./include/linux/kernel.h:987:51: error: 'struct bfq_group' has no member named 'entity'
>   987 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
> 
> Guess this is the same problem that is also seen with v5.4.25-rc1.

Thanks for the report, I should have that now fixed up for 5.5.y and
5.4.y.

greg k-h
