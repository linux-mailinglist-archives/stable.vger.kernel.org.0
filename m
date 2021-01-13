Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFA52F516F
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 18:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbhAMRwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 12:52:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:60840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbhAMRwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 12:52:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1602230F9;
        Wed, 13 Jan 2021 17:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610560282;
        bh=MXxzlmq314WXudt2hfVeTvxMIGc9fi+WWwYzwHJ/PNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i/oP7hgxQAoBwtBhZN2ufX+c6gUHaqMIYLI9cqmFMv0Ey2IryBHSTwwj0+2mAEx5e
         rN0qtMA92F1S6zWD/1I3EwuPvF93+vF2RzZ2AKzUL5YEe6P3e1o+YzIBDyDpWIo8RN
         jsG9usmfhmbU7iWxdI1EFm/wk5S24yt/5w0HDlYDLQexqmIRkgCUjr37PXjbSxA093
         yAsg/ILjywi7ZEHyw4wkoWgFaSc7d86gEkBNyKtGgqpJT9/cDykTgNa9EPmowtyTUL
         NVoZVXmpWzYbMj/QVliFeFrLcQBviM2AyyUMfHzVfg94Hp6BJHROapitpsTYUUUpF6
         xYEyqVCZe8D5A==
Date:   Wed, 13 Jan 2021 12:51:20 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     stable@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com
Subject: Re: [PATCH] Request backport of a vfio patch for 5.4 stable
Message-ID: <20210113175120.GU4035784@sasha-vm>
References: <1610386288-26220-1-git-send-email-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1610386288-26220-1-git-send-email-mjrosato@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 12:31:27PM -0500, Matthew Rosato wrote:
>Upstream commit 7d6e1329652e ("vfio iommu: Add dma available capability")
>should probably have been identified as a stable candidate originally, as
>without this available in a KVM host QEMU guests on at least s390x can
>end up with broken PCI passthrough devices, as the guest is unaware of the
>vfio DMA limit and can easily overrun it.
>
>The commit in question won't fit cleanly to 5.4, so I've included a
>proposed backport patch.

Queued up, thanks!

-- 
Thanks,
Sasha
