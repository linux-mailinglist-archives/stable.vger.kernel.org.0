Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFDDCADCA
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 20:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfJCSCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 14:02:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:26933 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730386AbfJCSCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 14:02:08 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 11:02:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="191340299"
Received: from jvalevi1-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.93.117])
  by fmsmga008.fm.intel.com with ESMTP; 03 Oct 2019 11:02:02 -0700
Date:   Thu, 3 Oct 2019 21:02:01 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Message-ID: <20191003180201.GC19679@linux.intel.com>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
 <1570024819.4999.119.camel@linux.ibm.com>
 <20191003114119.GF8933@linux.intel.com>
 <1570107752.4421.183.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1570107752.4421.183.camel@linux.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 09:02:32AM -0400, Mimi Zohar wrote:
> That isn't a valid justification for changing the original definition
> of trusted keys.  Just as the kernel supports different methods of
> implementing the same function on different architectures, trusted
> keys will need to support different methods of generating a random
> number.   

This is completely incorrect deduction. The random number generator
inside the kernel is there to gather entropy from different sources.
You would exploit trusted keys to potential weaknesses of a single
entropy source by doing that.

Of course in TEE platform, TEE can be one of the entropy sources but
there is no reason to weaken the security by using it as the only
sources.

/Jarkko
