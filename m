Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D3925D85E
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 14:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgIDMFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 08:05:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:33081 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgIDMFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 08:05:34 -0400
IronPort-SDR: Ju0KreGYWFFL87G/YAV/nGa7lqEDj3rxWJqjHqPJ3efMmm0gtG1uB2zP2i8C/qTDoit/J5ee9x
 /f+PJ6tjclig==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="157738833"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="157738833"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 05:05:33 -0700
IronPort-SDR: zIVelP0L5mIO0bybKxgt9WWbvKFfvMWQkdJui8TeEBshbzmjkmdfiQ8N8N8pdBAee9B1A1WIeD
 E6xbpZstYuDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="326649457"
Received: from pipper-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.56.104])
  by fmsmga004.fm.intel.com with ESMTP; 04 Sep 2020 05:05:29 -0700
Date:   Fri, 4 Sep 2020 15:05:29 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>
Subject: Re: [PATCH for-4.14] tpm: Unify the mismatching TPM space buffer
 sizes
Message-ID: <20200904120529.GD39023@linux.intel.com>
References: <20200831185849.2696852-1-stefanb@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831185849.2696852-1-stefanb@linux.vnet.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 31, 2020 at 02:58:49PM -0400, Stefan Berger wrote:
> From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> The size of the buffers for storing context's and sessions can vary from
> arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
> maximum for PPC64). Define a fixed buffer size set to 16 kB. This should be
> enough for most use with three handles (that is how many we allow at the
> moment). Parametrize the buffer size while doing this, so that it is easier
> to revisit this later on if required.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Stefan Berger <stefanb@linux.ibm.com>
> Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
> Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Thank you for doing this.

You are missing one thing from this.

You need to have this line before the long description:

  "commit <original commit ID> upstream"

It is documented over here:

   https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

/Jarkko
