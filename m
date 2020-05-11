Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC5E1CE2F3
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 20:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731164AbgEKSne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 14:43:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:55475 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729836AbgEKSne (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 14:43:34 -0400
IronPort-SDR: vDIrVQ0fKn1b4wxjiHY8T3iErR1IvZxQpDw7ujGBBX9ceplViq9FSsndLvF06H0wAvpEbmn9xu
 zDbv5UQGZpBg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 11:43:33 -0700
IronPort-SDR: HjJlGtCthG2JPGjULr3rJ9JAXN3AaIl7AW4E28RWZtTcq2gG4aMOmzJM73BN0XNBXOPHPK4dxG
 k7GMd/Tr3j8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,380,1583222400"; 
   d="scan'208";a="297775315"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2020 11:43:31 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 9F620170; Mon, 11 May 2020 21:43:30 +0300 (EEST)
Date:   Mon, 11 May 2020 21:43:30 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-drivers-review@eclists.intel.com" 
        <linux-drivers-review@eclists.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [linux-drivers-review] [PATCH] x86/mm: Fix boot with some memory
 above MAXMEM
Message-ID: <20200511184330.fbxjbnho4tzkukry@black.fi.intel.com>
References: <20200511163706.41619-1-kirill.shutemov@linux.intel.com>
 <4db011da-35b4-c6c0-aa35-54a28776169b@intel.com>
 <20200511170419.a53lgasfxd33nrk7@black.fi.intel.com>
 <5f95e4c2-66fe-42a0-f09f-cb902cd6db9a@intel.com>
 <3908561D78D1C84285E8C5FCA982C28F7F61FEF4@ORSMSX115.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7F61FEF4@ORSMSX115.amr.corp.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 06:10:12PM +0000, Luck, Tony wrote:
> > +		pr_err("%lldMB of physical memory is not addressable in the paging mode\n",
> > +		       not_addressable >> 20);
> 
> Is "MB" the right unit for this. The problem seems to happen for systems with >64TB ... I doubt
> the unaddressable memory is just a couple of MBbytes

Change it to GB?

-- 
 Kirill A. Shutemov
