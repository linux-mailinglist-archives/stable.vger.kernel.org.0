Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BAE26BD2C
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 08:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgIPGc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 02:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgIPGc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 02:32:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F7B0206A5;
        Wed, 16 Sep 2020 06:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600237945;
        bh=wRtARHe2LKkE2nHSoQVtqIGXlzPYT4T/Rf9r1//fVC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KNuL53mmpCgivYk8/Ekcnpr4cCgcJhha4/zMX2JhQwHAI9bPQ+9b2Xc2HXSW31eVE
         2nlIErWqRfPzvRVEzA8RRoXQFMvD5dLPGYTE5vPOs6QzCWIgWVljFaQLmm1SmdYDBg
         R/FXWzWVtRrUgZ1C0Gj93HDZHsysIbmqJoAEW5fo=
Date:   Wed, 16 Sep 2020 08:33:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        christian.koenig@amd.com
Subject: Re: [PATCH] Revert "drm/radeon: handle PCIe root ports with
 addressing limitations"
Message-ID: <20200916063300.GJ142621@kroah.com>
References: <20200915184607.84435-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915184607.84435-1-alexander.deucher@amd.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 02:46:07PM -0400, Alex Deucher wrote:
> This change breaks tons of systems.

Very vague :(

This commit has also been merged for over a year, why the sudden
problem now?

> This reverts commit 33b3ad3788aba846fc8b9a065fe2685a0b64f713.

You mean "33b3ad3788ab ("drm/radeon: handle PCIe root ports with
addressing limitations")"?

That's the proper way to reference commits in changelogs please.  It's
even documented that way...

> 
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=206973
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=206697
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=207763
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1140
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1287
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: christian.koenig@amd.com

Fixes: 33b3ad3788ab ("drm/radeon: handle PCIe root ports with addressing limitations")

as well?

thanks,

greg k-h
