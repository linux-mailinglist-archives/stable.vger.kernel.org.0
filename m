Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFA5228455
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 17:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgGUP5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 11:57:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:46592 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728064AbgGUP5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 11:57:03 -0400
IronPort-SDR: NbHloJBIYbcHtWRDy0gP0QrsdJwNTNdLV6Ag6WQWfeJnrSRIkchdM9o/6Z5HrD1bkliFdQHfqW
 9sFC3YRLBEfA==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="168304769"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="168304769"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 08:56:44 -0700
IronPort-SDR: DM820xt1Gq3OZz664oUikIE/NHcfCrPPnVekc0Nhd8eBTXqXCJhs6hfdHSZ0TlWwNKAeHyYJ8k
 6zOW7D5GQ0qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="487663827"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga006.fm.intel.com with ESMTP; 21 Jul 2020 08:56:43 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jxudH-0035x4-Fa; Tue, 21 Jul 2020 18:56:43 +0300
Date:   Tue, 21 Jul 2020 18:56:43 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Michael J. Ruhl" <michael.j.ruhl@intel.com>
Cc:     dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH v1] io-mapping: Indicate mapping failure
Message-ID: <20200721155643.GM3703480@smile.fi.intel.com>
References: <20200721153426.81239-1-michael.j.ruhl@intel.com>
 <20200721153426.81239-2-michael.j.ruhl@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721153426.81239-2-michael.j.ruhl@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 11:34:26AM -0400, Michael J. Ruhl wrote:

Thanks for an update, my comments below.

> The !ATOMIC_IOMAP version of io_maping_init_wc will always return
> success, even when the ioremap fails.
> 
> Since the ATOMIC_IOMAP version returns NULL when the init fails, and
> callers check for a NULL return on error this is unexpected.
> 
> Return NULL on ioremap failure.
> 
> Fixes: cafaf14a5d8f ("io-mapping: Always create a struct to hold metadata about the io-mapping"

Missed parenthesis.

Still not visible why Fixes tag.
Provide also couple of lines of crash and add a paragraph about it.

-- 
With Best Regards,
Andy Shevchenko


