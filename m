Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2203D205
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 18:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405448AbfFKQRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 12:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405444AbfFKQRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 12:17:43 -0400
Received: from localhost (unknown [216.243.17.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D82321721;
        Tue, 11 Jun 2019 16:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560269862;
        bh=SWVECJtPFEvqQO8yMuYNIoOw/mE4FzHyMzRH3Ntn/ak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LqeMCTAtnX2fcO8tlSSDzvk3Q9Sctw9zZiq+k0n2Wg6dC03xvhxbWuulQ+3gCQwYS
         4qAVdxLAshS7kVPc1MrQPDdkJDJ5einybJhwwYxDGiRY4ooWJXHeu4xX8GrnvxbBl/
         PnyYVM6O4NnlioiIqF9qIVcfoj1GDzGB2k/RS5Go=
Date:   Tue, 11 Jun 2019 12:17:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     stable <stable@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@amd.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: 5.1 backport request
Message-ID: <20190611161742.GA1513@sasha-vm>
References: <CAKMK7uHXF-ZyVjz1UTOZvSn_TxXMFwjiDz8cYGmwzzpWHNcTyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKMK7uHXF-ZyVjz1UTOZvSn_TxXMFwjiDz8cYGmwzzpWHNcTyw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 11:05:52AM +0200, Daniel Vetter wrote:
>Hi stable team,
>
>Please backport dbb92471674a ("Revert "drm: allow render capable
>master with DRM_AUTH ioctls"") to 5.1, we accidentally forgot the Cc:
>stable and Fixes: line for that revert. Thanks to Michel for spotting
>this.
>
>Dave, for next time around there's $ dim fixes $broken_sha1
>
>Thanks, Daniel

Queued up for 5.1, thank you!

--
Thanks,
Sasha
