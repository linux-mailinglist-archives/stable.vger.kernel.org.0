Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1961D3B29D1
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 10:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhFXIFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 04:05:35 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35458 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhFXIFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 04:05:35 -0400
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id B52CB1F41509;
        Thu, 24 Jun 2021 09:03:07 +0100 (BST)
Date:   Thu, 24 Jun 2021 10:03:04 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org, Icecream95 <ixn@keemail.me>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 01/12] drm/panfrost: Make sure MMU context lifetime
 is not bound to panfrost_priv
Message-ID: <20210624100304.152ea818@collabora.com>
In-Reply-To: <20210621133907.1683899-2-boris.brezillon@collabora.com>
References: <20210621133907.1683899-1-boris.brezillon@collabora.com>
        <20210621133907.1683899-2-boris.brezillon@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Jun 2021 15:38:56 +0200
Boris Brezillon <boris.brezillon@collabora.com> wrote:

> Jobs can be in-flight when the file descriptor is closed (either because
> the process did not terminate properly, or because it didn't wait for
> all GPU jobs to be finished), and apparently panfrost_job_close() does
> not cancel already running jobs. Let's refcount the MMU context object
> so it's lifetime is no longer bound to the FD lifetime and running jobs
> can finish properly without generating spurious page faults.
> 
> Reported-by: Icecream95 <ixn@keemail.me>
> Fixes: 7282f7645d06 ("drm/panfrost: Implement per FD address spaces")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>

Queued this patch to drm-misc-next. I'll respin the rest of this series.
