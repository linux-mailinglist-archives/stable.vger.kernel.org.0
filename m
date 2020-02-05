Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C599E153A8E
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 22:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgBEV6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 16:58:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:57372 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbgBEV6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 16:58:00 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 13:58:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="231848039"
Received: from gtobin-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.85.85])
  by orsmga003.jf.intel.com with ESMTP; 05 Feb 2020 13:57:57 -0800
Date:   Wed, 5 Feb 2020 23:57:56 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     zohar@linux.ibm.com, James.Bottomley@HansenPartnership.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/8] tpm: Initialize crypto_id of allocated_banks to
 HASH_ALGO__LAST
Message-ID: <20200205215756.GA24468@linux.intel.com>
References: <20200205103317.29356-1-roberto.sassu@huawei.com>
 <20200205103317.29356-2-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205103317.29356-2-roberto.sassu@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 11:33:10AM +0100, Roberto Sassu wrote:
> chip->allocated_banks, an array of tpm_bank_info structures, contains the
> list of TPM algorithm IDs of allocated PCR banks. It also contains the
> corresponding ID of the crypto subsystem, so that users of the TPM driver
> can calculate a digest for a PCR extend operation.
> 
> However, if there is no mapping between TPM algorithm ID and crypto ID, the
> crypto_id field of tpm_bank_info remains set to zero (the array is
> allocated and initialized with kcalloc() in tpm2_get_pcr_allocation()).
> Zero should not be used as value for unknown mappings, as it is a valid
> crypto ID (HASH_ALGO_MD4).
> 
> Thus, initialize crypto_id to HASH_ALGO__LAST.
> 
> Fixes: 879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR read")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reviewed-by: Petr Vorel <pvorel@suse.cz>
> Cc: stable@vger.kernel.org

Cc should be first.

/Jarkko
