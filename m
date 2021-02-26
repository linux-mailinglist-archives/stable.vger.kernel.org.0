Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB6E325EAA
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 09:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhBZILB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 03:11:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhBZILB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 03:11:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BADC64DA1;
        Fri, 26 Feb 2021 08:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614327020;
        bh=TvA7vyiVM0bLyF5Qq7ZBe/zg0912yztcwGaKAYOb5DQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E3/pTLdyC+GnmDDu9XKthk5PkL6vXstIFJRH6B06uXfLdeKk/ynJe4Np/unppkAnx
         MOHcXewAScAzn8XT8gLa/OqgF7xBaCw7Rd14DbsySeOj2AB/3+89zmrj1J5ZbbjUPf
         R4P+EkU0oSMhpGOwG64F0PaRQgzw1F3rThcXIi90=
Date:   Fri, 26 Feb 2021 09:10:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        hdegoede@redhat.com, sean@poorly.run, noralf@tronnes.org,
        stern@rowland.harvard.edu, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <YDis6iHVzBJs9d+p@kroah.com>
References: <20210224092304.29932-1-tzimmermann@suse.de>
 <ab79a3a7-2659-2dd2-889d-e2356a1b8176@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab79a3a7-2659-2dd2-889d-e2356a1b8176@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 26, 2021 at 08:59:50AM +0100, Thomas Zimmermann wrote:
> Greg, do you have comments on this patch?

I'll defer to Alan's comments so far, I would like to see that
addressed.

thanks,

greg k-h
