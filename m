Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721D32A3F3A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 09:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgKCIpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 03:45:47 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45552 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCIpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 03:45:47 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 44B9D1F45357;
        Tue,  3 Nov 2020 08:45:46 +0000 (GMT)
Date:   Tue, 3 Nov 2020 09:45:43 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>
Subject: Re: [PATCH] drm/panfrost: Fix a deadlock between the shrinker and
 madvise path
Message-ID: <20201103094543.69e5fd45@collabora.com>
In-Reply-To: <12019a24-239e-6d51-316c-b5438e5af892@arm.com>
References: <20201101174016.839110-1-boris.brezillon@collabora.com>
        <12019a24-239e-6d51-316c-b5438e5af892@arm.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2 Nov 2020 08:42:49 +0000
Steven Price <steven.price@arm.com> wrote:

> On 01/11/2020 17:40, Boris Brezillon wrote:
> > panfrost_ioctl_madvise() and panfrost_gem_purge() acquire the mappings
> > and shmem locks in different orders, thus leading to a potential
> > the mappings lock first.
> > 
> > Fixes: bdefca2d8dc0 ("drm/panfrost: Add the panfrost_gem_mapping concept")
> > Cc: <stable@vger.kernel.org>
> > Cc: Christian Hewitt <christianshewitt@gmail.com>
> > Reported-by: Christian Hewitt <christianshewitt@gmail.com>
> > Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>  
> 
> Reviewed-by: Steven Price <steven.price@arm.com>

Queued to drm-misc-fixes.

Thanks,

Boris
