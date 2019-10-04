Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A664CC281
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 20:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfJDSUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 14:20:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:15752 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfJDSUP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 14:20:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 11:20:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,257,1566889200"; 
   d="scan'208";a="205910170"
Received: from nzaki1-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.4.57])
  by fmsmga001.fm.intel.com with ESMTP; 04 Oct 2019 11:20:08 -0700
Date:   Fri, 4 Oct 2019 21:20:07 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     David Safford <david.safford@ge.com>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Message-ID: <20191004182007.GA6945@linux.intel.com>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
 <1570024819.4999.119.camel@linux.ibm.com>
 <20191003114119.GF8933@linux.intel.com>
 <1570107752.4421.183.camel@linux.ibm.com>
 <20191003175854.GB19679@linux.intel.com>
 <1570128827.5046.19.camel@linux.ibm.com>
 <20191003215125.GA30511@linux.intel.com>
 <20191003215743.GB30511@linux.intel.com>
 <1570140491.5046.33.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1570140491.5046.33.camel@linux.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 06:08:11PM -0400, Mimi Zohar wrote:
> > At the time when trusted keys was introduced I'd say that it was a wrong
> > design decision and badly implemented code. But you are right in that as
> > far that code is considered it would unfair to speak of a regression.
> > 
> > asym-tpm.c on the other hand this is fresh new code. There has been
> > *countless* of discussions over the years that random numbers should
> > come from multiple sources of entropy. There is no other categorization
> > than a bug for the tpm_get_random() there.
> 
> This week's LWN article on "5.4 Merge window, part 2" discusses "boot-
> time entropy".  This article couldn't have been more perfectly timed.

Do not see any obvious relation to this dicussion. Are you saying that
you should not use the defacto kernel API's but instead bake your own
hacks because even defacto stuff bumps into issues from time to time?

And BTW, at the time you call tpm_get_random(), TPM driver is already
contributing to the entropy pool (registered as hwrng).

/Jarkko
