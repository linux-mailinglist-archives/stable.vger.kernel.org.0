Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA49421D59B
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 14:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgGMMPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 08:15:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:4240 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729649AbgGMMPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jul 2020 08:15:41 -0400
IronPort-SDR: 9JTJf7O01sjjFBQ3EY9y86y9Vh7QkewfIe8SJnqccS2QVnS8cVE77KmqSsCmkgzXQEWrqfgvUG
 IH1/HbQGh4mQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9680"; a="147715734"
X-IronPort-AV: E=Sophos;i="5.75,347,1589266800"; 
   d="scan'208";a="147715734"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 05:15:41 -0700
IronPort-SDR: wls6kdOqmRMKaSoWBdQCFYzloZioI42U3yIAPfwrOkgeouwtG9t5zErRm9VjSPNIlWQFWDG+Zj
 hKcQxEVay2Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,347,1589266800"; 
   d="scan'208";a="485460617"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jul 2020 05:15:40 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id EFC505C0D4C; Mon, 13 Jul 2020 15:15:19 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Free stale request on destroying the virtual engine
In-Reply-To: <20200713120437.4442-1-chris@chris-wilson.co.uk>
References: <20200713120437.4442-1-chris@chris-wilson.co.uk>
Date:   Mon, 13 Jul 2020 15:15:19 +0300
Message-ID: <87k0z7392g.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> Since preempt-to-busy, we may unsubmit a request while it is still on
> the HW and completes asynchronously. That means it may be retired and in
> the process destroy the virtual engine (as the user has closed their
> context), but that engine may still be holding onto the unsubmitted
> compelted request. Therefore we need to potentially cleanup the old

completed.
-Mika
