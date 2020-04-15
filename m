Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5071A9C1C
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896935AbgDOLYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:24:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:15066 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896897AbgDOLY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:24:26 -0400
IronPort-SDR: btYc4EKxm7AZ3pGAKYLy/IrGTxlIUKrZdT2fFULDUxJFFcM/ls5CinyNatLKRk+n3br4Am/mtQ
 o2mjuX08z5Ew==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 04:24:21 -0700
IronPort-SDR: GlQM2AYNhbo9+7tYDnarSoJfFjHnvrpcfnZ6lQIRjOyIwohaKJmiqiukTt8wh8UTwUms8+aVnf
 a4GSWWwuyZjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,386,1580803200"; 
   d="scan'208";a="298967963"
Received: from lbrannix-mobl.ger.corp.intel.com (HELO intel.com) ([10.251.93.149])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Apr 2020 04:24:19 -0700
Date:   Wed, 15 Apr 2020 14:24:18 +0300
From:   Andi Shyti <andi.shyti@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Francisco Jerez <currojerez@riseup.net>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gt: Update PMINTRMSK holding fw
Message-ID: <20200415112418.GE50947@intel.intel>
References: <20200415075018.7636-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415075018.7636-1-chris@chris-wilson.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chris,

On Wed, Apr 15, 2020 at 08:50:18AM +0100, Chris Wilson wrote:
> If we use a non-forcewaked write to PMINTRMSK, it does not take effect
> until much later, if at all, causing a loss of RPS interrupts and no GPU
> reclocking, leaving the GPU running at the wrong frequency for long
> periods of time.
> 
> Reported-by: Francisco Jerez <currojerez@riseup.net>
> Suggested-by: Francisco Jerez <currojerez@riseup.net>
> Fixes: 35cc7f32c298 ("drm/i915/gt: Use non-forcewake writes for RPS")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Francisco Jerez <currojerez@riseup.net>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Andi Shyti <andi.shyti@intel.com>
> Cc: <stable@vger.kernel.org> # v5.6+

Reviewed-by: Andi Shyti <andi.shyti@intel.com>

Andi
