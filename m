Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EB526AA04
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 18:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbgIOQl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 12:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbgIOQkz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 12:40:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B50FD206B5;
        Tue, 15 Sep 2020 16:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600188055;
        bh=vqR4U0RypZZqGNmeSsxP9GZCUvkd+GiLcAa+DRNFwpg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wakehxfzswARAok6VxyUXnFEy829A5oxb0LSLAw7CFEuYB7cIK6ckMIzhJ7N7iZXh
         rE1XO0urSANx8iVcXid7IYG57GUOF6VehS8T+GlwpE1dDHd8LBe/Pu07dYa3LVQTwu
         Ks4K6LQc1PnzVGAwpJwkXlenqGAYqyIomPWv3+Bc=
Date:   Tue, 15 Sep 2020 18:41:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jordan Crouse <jcrouse@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 131/132] drm/msm: Enable expanded apriv support for
 a650
Message-ID: <20200915164131.GB43543@kroah.com>
References: <20200915140644.037604909@linuxfoundation.org>
 <20200915140650.665454992@linuxfoundation.org>
 <20200915160319.GB22371@jcrouse1-lnx.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915160319.GB22371@jcrouse1-lnx.qualcomm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 10:03:19AM -0600, Jordan Crouse wrote:
> On Tue, Sep 15, 2020 at 04:13:53PM +0200, Greg Kroah-Hartman wrote:
> > From: Jordan Crouse <jcrouse@codeaurora.org>
> > 
> > [ Upstream commit 604234f33658cdd72f686be405a99646b397d0b3 ]
> > 
> > a650 supports expanded apriv support that allows us to map critical buffers
> > (ringbuffer and memstore) as as privileged to protect them from corruption.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
> > Signed-off-by: Rob Clark <robdclark@chromium.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Hi. A bug was reported in this patch with a fix just posted to the list [1].
> Since the RPTR shadow is being disabled universally by f6828e0c4045 ("drm/msm:
> Disable the RPTR shadow") that will address the security concern and we won't
> need the extra protection from this patch. I suggest that you drop it for the
> stable trees and we can merge the fix into 5.9 to re-enable APRIV for newer
> kernels.

Ok, thanks, now dropped from 5.8.y and 5.4.y trees.

greg k-h
