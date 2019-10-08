Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFB6D046E
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 01:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbfJHXtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 19:49:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:8641 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbfJHXtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 19:49:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 16:49:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="197846974"
Received: from jhogan1-mobl.ger.corp.intel.com (HELO localhost) ([10.252.2.221])
  by orsmga006.jf.intel.com with ESMTP; 08 Oct 2019 16:49:36 -0700
Date:   Wed, 9 Oct 2019 02:49:35 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Ken Goldman <kgold@linux.ibm.com>
Cc:     "Safford, David (GE Global Research, US)" <david.safford@ge.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Message-ID: <20191008234935.GA13926@linux.intel.com>
References: <1570024819.4999.119.camel@linux.ibm.com>
 <20191003114119.GF8933@linux.intel.com>
 <1570107752.4421.183.camel@linux.ibm.com>
 <20191003175854.GB19679@linux.intel.com>
 <1570128827.5046.19.camel@linux.ibm.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
 <20191004182711.GC6945@linux.intel.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
 <20191007000520.GA17116@linux.intel.com>
 <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 06:13:01PM -0400, Ken Goldman wrote:
> The TPM library specification states that the TPM must comply with NIST
> SP800-90 A.
> 
> https://trustedcomputinggroup.org/membership/certification/tpm-certified-products/
> 
> shows that the TPMs get third party certification, Common Criteria EAL 4+.
> 
> While it's theoretically possible that an attacker could compromise
> both the TPM vendors and the evaluation agencies, we do have EAL 4+
> assurance against both 1 and 2.

Certifications do not equal to trust.

/Jarkko
