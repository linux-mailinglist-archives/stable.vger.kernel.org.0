Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1FB1CE365
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 20:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731263AbgEKS6Y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 11 May 2020 14:58:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:45507 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731027AbgEKS6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 14:58:24 -0400
IronPort-SDR: 4FLVMJqdqDjMsRQowd7Egmq6b/cEEh/iwES0GPCyMEz9j4btSRWdEoR0RYZHHUouDamA0sBd0D
 7nWzywJx20PA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 11:58:22 -0700
IronPort-SDR: WA3eHNmJQ12PWFmQrDthDl2D90TsazRnBsGM5ftuuVhFMO+fWfm3QVz/bdZ4k5NblwKuwTxy9P
 tYR5hAdtKSMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,381,1583222400"; 
   d="scan'208";a="463270188"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga005.fm.intel.com with ESMTP; 11 May 2020 11:58:22 -0700
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 11 May 2020 11:58:22 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.83]) by
 ORSMSX157.amr.corp.intel.com ([169.254.9.116]) with mapi id 14.03.0439.000;
 Mon, 11 May 2020 11:58:21 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-drivers-review@eclists.intel.com" 
        <linux-drivers-review@eclists.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [linux-drivers-review] [PATCH] x86/mm: Fix boot with some
 memory above MAXMEM
Thread-Topic: [linux-drivers-review] [PATCH] x86/mm: Fix boot with some
 memory above MAXMEM
Thread-Index: AQHWJ7Jv8WCvxf88Sku1+ELiZ2f0TqijjI4AgAAF0ICAAAFmgP//mw+wgAB/QgD//44B4A==
Date:   Mon, 11 May 2020 18:58:21 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7F6200F3@ORSMSX115.amr.corp.intel.com>
References: <20200511163706.41619-1-kirill.shutemov@linux.intel.com>
 <4db011da-35b4-c6c0-aa35-54a28776169b@intel.com>
 <20200511170419.a53lgasfxd33nrk7@black.fi.intel.com>
 <5f95e4c2-66fe-42a0-f09f-cb902cd6db9a@intel.com>
 <3908561D78D1C84285E8C5FCA982C28F7F61FEF4@ORSMSX115.amr.corp.intel.com>
 <20200511184330.fbxjbnho4tzkukry@black.fi.intel.com>
In-Reply-To: <20200511184330.fbxjbnho4tzkukry@black.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> > +		pr_err("%lldMB of physical memory is not addressable in the paging mode\n",
>> > +		       not_addressable >> 20);
>> 
>> Is "MB" the right unit for this. The problem seems to happen for systems with >64TB ... I doubt
>> the unaddressable memory is just a couple of MBbytes
>
> Change it to GB?

I think it would be more readable.

[Maybe Linux needs a magic %p{something} that does auto-sizing to print in the most appropriate out of KB, MB, GB, TB, PB?]

-Tony
