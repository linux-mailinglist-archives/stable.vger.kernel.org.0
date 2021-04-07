Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28A73568ED
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 12:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350623AbhDGKGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 06:06:04 -0400
Received: from 8bytes.org ([81.169.241.247]:33840 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350639AbhDGKFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 06:05:07 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 005BD2A6; Wed,  7 Apr 2021 12:04:56 +0200 (CEST)
Date:   Wed, 7 Apr 2021 12:04:55 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Alexander Monakov <amonakov@ispras.ru>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tj <ml.linux@elloe.vision>,
        Shuah Khan <skhan@linuxfoundation.org>,
        David Coe <david.coe@live.co.uk>,
        iommu@lists.linux-foundation.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] Revert "iommu/amd: Fix performance counter
 initialization"
Message-ID: <YG2Dx3cZyfh6yfFo@8bytes.org>
References: <20210303121156.76621-1-pmenzel@molgen.mpg.de>
 <a803de32-eec8-a0b1-69e6-43259ba5c656@amd.com>
 <alpine.LNX.2.20.13.2103031648190.15170@monopod.intra.ispras.ru>
 <0a910a80-5783-1f3d-a8ea-5e10cba0e206@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a910a80-5783-1f3d-a8ea-5e10cba0e206@molgen.mpg.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

On Thu, Mar 18, 2021 at 10:20:16AM +0100, Paul Menzel wrote:
> Jörg, I know you are probably busy, but the patch was applied to the stable
> series (v5.11.7). There are still too many question open regarding the
> patch, and Suravee has not yet addressed the comments. It’d be great, if you
> could revert it.

We are currently discussing the next steps here. Maybe the retry logic
can be removed entirely.

Regards,

	Joerg
