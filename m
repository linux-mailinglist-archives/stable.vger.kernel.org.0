Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1FB1EE21B
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 12:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgFDKJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 06:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgFDKJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jun 2020 06:09:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C042206DC;
        Thu,  4 Jun 2020 10:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591265371;
        bh=xXdPu38YWyQ73+Cyeb82ZqZQ/k4huUSorcV6nbvvIF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uxo+/g3E0JbZ1R+1cfAAT1tiZFkisPupkDO9oEuZy+pgva0KnZNVcgOaM6qjo6h+K
         aTm1BYtZWSvZYPtuvueFfvgACvvXm57NE6Wkv7EEaFVi84xGdwOOIQA/e2SZGwaxnj
         GVmu2nchUOTCQBImm07CKQqty6x1ThqjA6K+SXg8=
Date:   Thu, 4 Jun 2020 12:09:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Patches to apply to stable releases [6/3/2020]
Message-ID: <20200604100929.GA550434@kroah.com>
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
> Upstream commit 0e0bf1ea1147 ("perf stat: Zero all the 'ena' and 'run' array slot stats for interval mode")
>   upstream: ToT
>     Fixes: 51fd2df1e882 ("perf stat: Fix interval output values")
>       in linux-4.4.y: 7629c7ef5291
>       upstream: v4.5-rc4
>     Affected branches:
>       linux-4.4.y
>       linux-4.9.y
>       linux-4.14.y
>       linux-4.19.y
>       linux-5.4.y
>       linux-5.6.y
>       Presumably also linux-5.7.y but not checked/tested

You are starting to catch patches that are now in Linus's tree, but have
not shown up in a -rc release yet.  We really should wait for these
until they do show up in a real release, unless there is a specific need
otherwise.

Usually I require the maintainer of the subsystem to ask me to merge
those patches, as it gives me someone to blame if things go wrong :)

So can you hold off on these types of patches until they show up in a
-rc release?

thanks,

greg k-h
