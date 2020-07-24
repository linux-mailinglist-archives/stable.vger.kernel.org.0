Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFAD22C53C
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 14:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgGXMeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 08:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgGXMeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 08:34:23 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08190C0619D3;
        Fri, 24 Jul 2020 05:34:23 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B18DF7DD; Fri, 24 Jul 2020 14:34:21 +0200 (CEST)
Date:   Fri, 24 Jul 2020 14:34:20 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Koba Ko <koba.ko@canonical.com>, Jun Miao <jun.miao@windriver.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] iommu/vt-d: Skip TE disabling on quirky gfx
 dedicated iommu
Message-ID: <20200724123420.GU27672@8bytes.org>
References: <20200723013437.2268-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723013437.2268-1-baolu.lu@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 23, 2020 at 09:34:37AM +0800, Lu Baolu wrote:
> The VT-d spec requires (10.4.4 Global Command Register, TE field) that:
> 
> Hardware implementations supporting DMA draining must drain any in-flight
> DMA read/write requests queued within the Root-Complex before completing
> the translation enable command and reflecting the status of the command
> through the TES field in the Global Status register.
> 
> Unfortunately, some integrated graphic devices fail to do so after some
> kind of power state transition. As the result, the system might stuck in
> iommu_disable_translation(), waiting for the completion of TE transition.
> 
> This provides a quirk list for those devices and skips TE disabling if
> the qurik hits.
> 
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=208363
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=206571
> Tested-by: Koba Ko <koba.ko@canonical.com>
> Tested-by: Jun Miao <jun.miao@windriver.com>
> Cc: Ashok Raj <ashok.raj@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Applied for v5.9, thanks.

