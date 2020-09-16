Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4AC26BDA4
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 09:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgIPHEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 03:04:45 -0400
Received: from verein.lst.de ([213.95.11.211]:51216 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbgIPHEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 03:04:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CFFD668BEB; Wed, 16 Sep 2020 09:04:36 +0200 (CEST)
Date:   Wed, 16 Sep 2020 09:04:36 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        christian.koenig@amd.com
Subject: Re: [PATCH] Revert "drm/radeon: handle PCIe root ports with
 addressing limitations"
Message-ID: <20200916070436.GA9392@lst.de>
References: <20200915184607.84435-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915184607.84435-1-alexander.deucher@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 02:46:07PM -0400, Alex Deucher wrote:
> This change breaks tons of systems.

Did you do at least some basic root causing on why?  Do GPUs get
fed address they can't deal with?  Any examples?

Bug 1 doesn't seem to contain any analysis and was reported against
a very old kernel that had all kind of fixes since.

Bug 2 seems to imply a drm kthread is accessing some structure it
shouldn't, which would imply a mismatch between pools used by radeon
now and those actually provided by the core.  Something that should
be pretty to trivial to fix for someone understanding the whole ttm
pool maze.

Bug 3: same as 1, but an even older kernel.

Bug 4: looks like 1 and 3, and actually verified to work properly
in 5.9-rc.  Did you try to get the other reporters test this as well?

All over not a very useful changelog.

