Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A72F2A2656
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 09:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgKBIpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 03:45:24 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58552 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbgKBIpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 03:45:24 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id F08051F44A7F;
        Mon,  2 Nov 2020 08:45:22 +0000 (GMT)
Date:   Mon, 2 Nov 2020 09:45:20 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] drm/panfrost: Move the GPU reset bits outside the
 timeout handler
Message-ID: <20201102094520.66f62b2a@collabora.com>
In-Reply-To: <7c840f9f-a6cb-af80-0c21-da5608e00fbb@arm.com>
References: <20201030105336.764009-1-boris.brezillon@collabora.com>
        <7c840f9f-a6cb-af80-0c21-da5608e00fbb@arm.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 30 Oct 2020 14:29:32 +0000
Robin Murphy <robin.murphy@arm.com> wrote:

> On 2020-10-30 10:53, Boris Brezillon wrote:
> [...]
> > +	/* Schedule a reset if there's no reset in progress. */
> > +	if (!atomic_cmpxchg(&pfdev->reset.pending, 0, 1))  
> 
> Nit: this could just be a simple xchg with 1 - you don't need the 
> compare aspect, since setting it to true when it was already true is 
> still harmless ;)

Yep, I'll post a new version using atomic_xchg() here.

Thanks,

Boris

