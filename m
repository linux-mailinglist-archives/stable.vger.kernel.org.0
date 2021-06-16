Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29AB3AA136
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 18:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbhFPQ1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 12:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231511AbhFPQ1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 12:27:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84D2461166;
        Wed, 16 Jun 2021 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623860740;
        bh=3rm1yisCz+w5kvH2G+XwKuhXIJ7uDzoxfjoz9UFaiZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vHc5vCjMmmHoVmjgdUBCdmaCQMm3+byZDmUw7Jgv6JTQcTWYs6Uj/WuVD+3RufKgn
         1VnzsBXXNs7VwqyLaSaVcclHj0M3qMrmnn72orutiiH8Ibq1ZGUp4uyp69eLQyjZJx
         iQhIyBvWb7mf43vLHOb9xpWU66k2LBq5WJWAA0y0=
Date:   Wed, 16 Jun 2021 18:25:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Harry Wentland <harry.wentland@amd.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Tianci.Yin" <tianci.yin@amd.com>,
        Nicholas Choi <nicholas.choi@amd.com>,
        Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Mark Yacoub <markyacoub@google.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 24/28] drm/amd/display: Fix overlay validation by
 considering cursors
Message-ID: <YMomAl5cM6LDJDQC@kroah.com>
References: <20210616152834.149064097@linuxfoundation.org>
 <20210616152834.918209675@linuxfoundation.org>
 <4a5a8ca2-0080-8576-a9f5-0e054c93bfea@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a5a8ca2-0080-8576-a9f5-0e054c93bfea@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 11:59:55AM -0400, Harry Wentland wrote:
> Hi Greg
> 
> Please drop this from 5.4, 5.10, or 5.12 stable kernels as it's apt to break any userspace that is using the legacy cursor IOCTL, which is most userspace.
> 
> We are in the process of reverting this on amd-staging-drm-next. Siqueira will send a patch.

Dropped from all 3 trees now, thanks!

greg k-h
