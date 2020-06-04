Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFFA1EE229
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 12:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgFDKMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 06:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgFDKMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jun 2020 06:12:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EECF1206DC;
        Thu,  4 Jun 2020 10:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591265571;
        bh=peEtLId/tUqo98LxopCo0O0NM/erk0V6Sk2Ce6Saamc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2Q/3I9dv5LHslQuew4qFeMPGhdpAGwFe1rEVG6+Y7yOsAQz7NTuQTAOJdIWmXFSJR
         /wAyJz4ZTyWbcCkEKcuA/vUrGz/BObQfPrMnyEWdjN9RDciQnkWBz4602JN65GlFhD
         asR9x6cVEWkrr6ehqnSp6FMeAfFYHjFBAqpBLiIU=
Date:   Thu, 4 Jun 2020 12:12:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Patches to apply to stable releases [6/3/2020]
Message-ID: <20200604101249.GB550434@kroah.com>
References: <20200603202135.78725-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603202135.78725-1-linux@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 03, 2020 at 01:21:35PM -0700, Guenter Roeck wrote:
> Hi,
> 
> Please consider applying the following patches to the listed stable
> releases.
> 
> The following patches were found to be missing in stable releases by the
> Chrome OS missing patch robot. The patches meet the following criteria.
> - The patch includes a Fixes: tag
>   Note that the Fixes: tag does not always point to the correct upstream
>   SHA. In that case the correct upstream SHA is listed below.
> - The patch referenced in the Fixes: tag has been applied to the listed
>   stable release
> - The patch has not been applied to that stable release
> 
> All patches have been applied to the listed stable releases and to at least
> one Chrome OS branch. Resulting images have been build- and runtime-tested
> (where applicable) on real hardware and with virtual hardware on
> kerneltests.org.
> 
> Thanks,
> Guenter
> 
> ---


> Upstream commit e2abfc0448a4 ("x86/cpu/amd: Make erratum #1054 a legacy erratum")
>   upstream: ToT
>     Fixes: 21b5ee59ef18 ("x86/cpu/amd: Enable the fixed Instructions Retired counter IRPERF")
>       in linux-4.19.y: f28ec250579c
>       in linux-5.4.y: e0253c422024
>       upstream: v5.6-rc3
>     Affected branches:
>       linux-4.19.y
>       linux-5.4.y
>       linux-5.6.y
>       Presumably also linux-5.7.y but not checked/tested

I didn't queue this one up either, but all others I have now, thanks.

greg k-h
