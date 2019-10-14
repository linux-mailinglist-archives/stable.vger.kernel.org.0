Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B4BD69ED
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 21:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387889AbfJNTL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 15:11:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:46355 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732490AbfJNTL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 15:11:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 12:11:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="395289832"
Received: from kridax-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.7.178])
  by fmsmga005.fm.intel.com with ESMTP; 14 Oct 2019 12:11:52 -0700
Date:   Mon, 14 Oct 2019 22:11:50 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Ken Goldman <kgold@linux.ibm.com>,
        "Safford, David (GE Global Research, US)" <david.safford@ge.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Message-ID: <20191014191150.GB15552@linux.intel.com>
References: <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
 <20191004182711.GC6945@linux.intel.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
 <20191007000520.GA17116@linux.intel.com>
 <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
 <20191008234935.GA13926@linux.intel.com>
 <20191008235339.GB13926@linux.intel.com>
 <20191009073315.GA5884@linux.intel.com>
 <20191009074133.GA6202@linux.intel.com>
 <MN2PR20MB2973CDE87E4EC25CA21DD2C8CA950@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973CDE87E4EC25CA21DD2C8CA950@MN2PR20MB2973.namprd20.prod.outlook.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 08:09:29AM +0000, Pascal Van Leeuwen wrote:
> There's certification and certification. Not all certificates are
> created equally. But if it matches your specific requirements, why not.
> There's a _lot_ of HW out there that's not x86 though ...
> 
> And: is RDRAND certified for _all_ x86 processors? Or just Intel?
> Or perhaps even only _specific (server) models_ of CPU's?
> I also know for a fact that some older AMD processors had a broken
> RDRAND implementation ...
> 
> So the choice really should be up to the application or user.

I'm not seriously suggesting to move rdrand here. I'm trying find the
logic how to move forward with trusted keys with multiple backends (not
only TPM).

AKA we have a kernel rng in existence but no clear policy when it should
be used and when not. This leads to throwing a dice with the design
choices. Even it TPM RNG is the right choice in tpm_asym.c, the choice
was not based on anything (otherwise it would have been documented).

/Jarkko
