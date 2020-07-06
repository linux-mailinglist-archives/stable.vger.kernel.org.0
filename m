Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5923A2161C2
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 01:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgGFXBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 19:01:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:53616 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbgGFXBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 19:01:25 -0400
IronPort-SDR: NVYg6qBEjCMl/9AnksD1WTDgWxGdYj2ogD+sWTgQhKZmYvAH4IVdr1fqZRZ9OzYJbQQ4IvOv5A
 /WNRTjh8DBSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="127600056"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="127600056"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 16:01:24 -0700
IronPort-SDR: Ca1lz0TL9DHZXw722DiMo0c1ceiUVKLD/0Jer/zbaAVMGxWB4YsJ2l9NU9t+liKZtHykPUZr6r
 GyQteUtUapWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="283192674"
Received: from hartmaxe-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.53.13])
  by orsmga006.jf.intel.com with ESMTP; 06 Jul 2020 16:01:18 -0700
Date:   Tue, 7 Jul 2020 02:01:16 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Stefan Berger <stefanb@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alexey Klimov <aklimov@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm: Define TPM2_SPACE_BUFFER_SIZE to replace the use of
 PAGE_SIZE
Message-ID: <20200706230104.GA20770@linux.intel.com>
References: <20200702225603.293122-1-jarkko.sakkinen@linux.intel.com>
 <20200702235544.4o7dbgvlq3br2x7e@cantor>
 <20200704035615.GA157149@linux.intel.com>
 <4f93bca3-e5c2-1074-f273-628ed603c139@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f93bca3-e5c2-1074-f273-628ed603c139@linux.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 06, 2020 at 02:06:09PM -0400, Stefan Berger wrote:
> On 7/3/20 11:56 PM, Jarkko Sakkinen wrote:
> > On Thu, Jul 02, 2020 at 04:55:44PM -0700, Jerry Snitselaar wrote:
> > > On Fri Jul 03 20, Jarkko Sakkinen wrote:
> > > > The size of the buffers for storing context's and sessions can vary from
> > > > arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
> > > > maximum for PPC64). Define a fixed buffer size set to 16 kB. This should be
> > > > enough for most use with three handles (that is how many we allow at the
> > > > moment). Parametrize the buffer size while doing this, so that it is easier
> > > > to revisit this later on if required.
> > > > 
> > > > Reported-by: Stefan Berger <stefanb@linux.ibm.com>
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
> > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
> > Thank you.
> > 
> > Now only needs tested-by from Stefan.
> 
> 
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>

Thanks. I'll put this eventually to the v5.9 PR.

/Jarkko
