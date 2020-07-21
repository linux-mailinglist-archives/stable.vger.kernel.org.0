Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D6122829E
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 16:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgGUOrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 10:47:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:64981 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728127AbgGUOrZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 10:47:25 -0400
IronPort-SDR: C4ae06x0tqxzPrO6ylPUwQId/thJ4l5CO1BW7Rg7Ckvd2LH19juxjiky2owF8aCSQthB7Egax/
 v+kNcNc951zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="148074676"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="148074676"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 07:47:24 -0700
IronPort-SDR: SG/ADZdzeO+eYGeJdkwxR3/AzidikjdTwMUhffXRLWe1zQ0R0O6VOeMmB6qE6lyrPVP/nZshlR
 UQHE1VnpYQlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="283881421"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga003.jf.intel.com with ESMTP; 21 Jul 2020 07:47:22 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jxtYA-0035K1-TY; Tue, 21 Jul 2020 17:47:22 +0300
Date:   Tue, 21 Jul 2020 17:47:22 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Michael J. Ruhl" <michael.j.ruhl@intel.com>
Cc:     dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] io-mapping: Indicate mapping failure
Message-ID: <20200721144722.GH3703480@smile.fi.intel.com>
References: <20200721141641.81112-1-michael.j.ruhl@intel.com>
 <20200721141641.81112-2-michael.j.ruhl@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721141641.81112-2-michael.j.ruhl@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 10:16:41AM -0400, Michael J. Ruhl wrote:
> Sometimes it is good to know when your mapping failed.

Can you elaborate...

> Fixes: cafaf14a5d8f ("io-mapping: Always create a struct to hold metadata about the io-mapping"

...especially taking into account that Fixes implies regression / bug?

-- 
With Best Regards,
Andy Shevchenko


