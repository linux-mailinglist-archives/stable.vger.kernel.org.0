Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C731226C8F9
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 21:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgIPTBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 15:01:38 -0400
Received: from verein.lst.de ([213.95.11.211]:52812 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbgIPRuE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 13:50:04 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A06F668B05; Wed, 16 Sep 2020 16:36:28 +0200 (CEST)
Date:   Wed, 16 Sep 2020 16:36:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        christian.koenig@amd.com
Subject: Re: [PATCH v2] Revert "drm/radeon: handle PCIe root ports with
 addressing limitations"
Message-ID: <20200916143628.GA6894@lst.de>
References: <20200916132017.1221927-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916132017.1221927-1-alexander.deucher@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 09:20:17AM -0400, Alex Deucher wrote:
> This causes screen corruption when using the GPU which makes the
> system unusable.

You have not addressed any of my questions, especially if the commit
that fixed one of the reports (the only one with a recent kernel)
fixed most of the others as well.  Nor that fact that the crash
one really looks like the symptom of an underlying issue that absolutely
needs to be fixed first.
