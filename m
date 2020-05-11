Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8221F1CE74C
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 23:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgEKVTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 17:19:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:61385 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgEKVTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 17:19:24 -0400
IronPort-SDR: Jj2x88ygjMHPXHU7Fdvdcn3u3A1l2n9EY3GH3QJGdM6BCc5cotiwCb5Bfk/l/o1Dk+uOA+pR4G
 f5Yrje+6ddXA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 14:19:24 -0700
IronPort-SDR: QrWKwN1WJ1d5vWIdXIw/cMlQnab15fPk/RRQoKnJLJdx0l5V8hQlNFlGHSXHuXsYOMIHqlaP7T
 PIDukjQwa5OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="340675658"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga001.jf.intel.com with ESMTP; 11 May 2020 14:19:22 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@intel.com>)
        id 1jYFpd-0063NI-Cm; Tue, 12 May 2020 00:19:25 +0300
Date:   Tue, 12 May 2020 00:19:25 +0300
From:   Andy Shevchenko <andriy.shevchenko@intel.com>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-drivers-review@eclists.intel.com" 
        <linux-drivers-review@eclists.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [linux-drivers-review] [PATCH] x86/mm: Fix boot with some memory
 above MAXMEM
Message-ID: <20200511211925.GQ185537@smile.fi.intel.com>
References: <20200511163706.41619-1-kirill.shutemov@linux.intel.com>
 <4db011da-35b4-c6c0-aa35-54a28776169b@intel.com>
 <20200511170419.a53lgasfxd33nrk7@black.fi.intel.com>
 <5f95e4c2-66fe-42a0-f09f-cb902cd6db9a@intel.com>
 <3908561D78D1C84285E8C5FCA982C28F7F61FEF4@ORSMSX115.amr.corp.intel.com>
 <20200511184330.fbxjbnho4tzkukry@black.fi.intel.com>
 <3908561D78D1C84285E8C5FCA982C28F7F6200F3@ORSMSX115.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7F6200F3@ORSMSX115.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 06:58:21PM +0000, Luck, Tony wrote:
> >> > +		pr_err("%lldMB of physical memory is not addressable in the paging mode\n",
> >> > +		       not_addressable >> 20);
> >> 
> >> Is "MB" the right unit for this. The problem seems to happen for systems with >64TB ... I doubt
> >> the unaddressable memory is just a couple of MBbytes
> >
> > Change it to GB?
> 
> I think it would be more readable.
> 
> [Maybe Linux needs a magic %p{something} that does auto-sizing to print in the most appropriate out of KB, MB, GB, TB, PB?]

We have one in string_helpers.c.

-- 
With Best Regards,
Andy Shevchenko


