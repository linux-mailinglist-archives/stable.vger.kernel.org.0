Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A7C2143E7
	for <lists+stable@lfdr.de>; Sat,  4 Jul 2020 05:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgGDD4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 23:56:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:33191 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbgGDD4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jul 2020 23:56:22 -0400
IronPort-SDR: O3p4wEfQzumhmv3KdSmawxJEMBSoq2BcHv8z81y4eFTJwO1WD535GMfivP0J0KwjtPOA0owLX0
 trit3OUL9/lQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9671"; a="126832378"
X-IronPort-AV: E=Sophos;i="5.75,310,1589266800"; 
   d="scan'208";a="126832378"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2020 20:56:22 -0700
IronPort-SDR: 4PwYMQsrwNKt0BQPWVg2aGZznq/PxOskNpz4IIfdAj5DpKcAAMPW5zB39K6lzbhTOP93kc7JME
 /buUEOwb4mYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,310,1589266800"; 
   d="scan'208";a="267454037"
Received: from winzenbu-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.41.221])
  by fmsmga008.fm.intel.com with ESMTP; 03 Jul 2020 20:56:17 -0700
Date:   Sat, 4 Jul 2020 06:56:15 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alexey Klimov <aklimov@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm: Define TPM2_SPACE_BUFFER_SIZE to replace the use of
 PAGE_SIZE
Message-ID: <20200704035615.GA157149@linux.intel.com>
References: <20200702225603.293122-1-jarkko.sakkinen@linux.intel.com>
 <20200702235544.4o7dbgvlq3br2x7e@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702235544.4o7dbgvlq3br2x7e@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 02, 2020 at 04:55:44PM -0700, Jerry Snitselaar wrote:
> On Fri Jul 03 20, Jarkko Sakkinen wrote:
> > The size of the buffers for storing context's and sessions can vary from
> > arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
> > maximum for PPC64). Define a fixed buffer size set to 16 kB. This should be
> > enough for most use with three handles (that is how many we allow at the
> > moment). Parametrize the buffer size while doing this, so that it is easier
> > to revisit this later on if required.
> > 
> > Reported-by: Stefan Berger <stefanb@linux.ibm.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

Thank you.

Now only needs tested-by from Stefan.

/Jarkko
