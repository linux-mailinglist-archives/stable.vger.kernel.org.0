Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7266E3DA
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 12:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfGSKD3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 19 Jul 2019 06:03:29 -0400
Received: from mga18.intel.com ([134.134.136.126]:22981 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfGSKD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 06:03:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 03:03:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,281,1559545200"; 
   d="scan'208";a="170100598"
Received: from jlahtine-desk.ger.corp.intel.com (HELO localhost) ([10.252.3.98])
  by fmsmga007.fm.intel.com with ESMTP; 19 Jul 2019 03:03:23 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
From:   Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
In-Reply-To: <20190718145407.21352-4-chris@chris-wilson.co.uk>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
References: <20190718145407.21352-1-chris@chris-wilson.co.uk>
 <20190718145407.21352-4-chris@chris-wilson.co.uk>
Message-ID: <156353060239.486.9888222648443839351@jlahtine-desk.ger.corp.intel.com>
User-Agent: alot/0.7
Subject: Re: [PATCH 4/4] drm/i915: Flush stale cachelines on set-cache-level
Date:   Fri, 19 Jul 2019 13:03:22 +0300
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2019-07-18 17:54:07)
> Ensure that we flush any cache dirt out to main memory before the user
> changes the cache-level as they may elect to bypass the cache (even after
> declaring their access cache-coherent) via use of unprivileged MOCS.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

Regards, Joonas
