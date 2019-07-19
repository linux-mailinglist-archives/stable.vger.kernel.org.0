Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550FD6E67A
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 15:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfGSNb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 09:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728996AbfGSNbr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 09:31:47 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E594D2184E;
        Fri, 19 Jul 2019 13:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563543106;
        bh=rJNsY6WFBMfUMhkdZP87ZW6Yf+2uj2nXGax5chzQhC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ucoj0coKxe0PGz9qcRNIpLr6jpv6W5s/eNvbRoOGfXNVrwDg+npRcn1U/oMlbuRQc
         dGeJPKdj9Ul7ojYr0Ran7FlT3CB/al6tOxnpRbWBZV4I9nr/JdVcKXB85jS63Nme4a
         A3u46lKf7LGDPJXgSAEBFNrLwXwUL25MhuNulIU4=
Date:   Fri, 19 Jul 2019 09:31:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Thierry Reding <treding@nvidia.com>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 41/60] PCI: tegra: Enable Relaxed Ordering
 only for Tegra20 & Tegra30
Message-ID: <20190719133144.GE4240@sasha-vm>
References: <20190719041109.18262-1-sashal@kernel.org>
 <20190719041109.18262-41-sashal@kernel.org>
 <838a6940-2a37-b91b-d522-8b154f3c71d7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <838a6940-2a37-b91b-d522-8b154f3c71d7@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 09:33:11AM +0100, Jon Hunter wrote:
>Hi Lorenzo,
>
>We have not requested that this is added to stable yet, however, has
>been picked up. Do we wish to let it soak in mainline for a release
>first? If so maybe we can ask Sasha to drop this for now.

Note that there are about two weeks between this mail and the point
where it actually appears in a stable tree.

AUTOSEL patches follow a much slower pace than ones marked for stable
exactly for the reason you've mentioned.

--
Thanks,
Sasha
