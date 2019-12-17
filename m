Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF8E122170
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfLQBZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 20:25:07 -0500
Received: from mga12.intel.com ([192.55.52.136]:43128 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbfLQBZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 20:25:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 17:25:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,323,1571727600"; 
   d="scan'208";a="415280936"
Received: from chauvina-mobl1.ger.corp.intel.com ([10.251.85.48])
  by fmsmga005.fm.intel.com with ESMTP; 16 Dec 2019 17:25:02 -0800
Message-ID: <51dcaf500c7f081ccebf3386884e7f4826d83075.camel@linux.intel.com>
Subject: Re: [PATCH v2] tpm_tis: reserve chip for duration of
 tpm_tis_core_init
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dan Williams <dan.j.williams@intel.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
Date:   Tue, 17 Dec 2019 03:25:01 +0200
In-Reply-To: <CAPcyv4jUz9X-eyf7M78dfS-7pzi4Xqs+LdpUSD=eoeQjd1kxug@mail.gmail.com>
References: <20191211231758.22263-1-jsnitsel@redhat.com>
         <20191211235455.24424-1-jsnitsel@redhat.com>
         <CAPcyv4j_FJ9teSyfodCjXs5Wz2Pj7BjqKX6Mx53OtPnVu0mjGA@mail.gmail.com>
         <CAPcyv4jUz9X-eyf7M78dfS-7pzi4Xqs+LdpUSD=eoeQjd1kxug@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-12-11 at 18:18 -0800, Dan Williams wrote:
> On Wed, Dec 11, 2019 at 6:15 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > On Wed, Dec 11, 2019 at 3:56 PM Jerry Snitselaar <jsnitsel@redhat.com> wrote:
> > > Instead of repeatedly calling tpm_chip_start/tpm_chip_stop when
> > > issuing commands to the tpm during initialization, just reserve the
> > > chip after wait_startup, and release it when we are ready to call
> > > tpm_chip_register.
> > > 
> > > Cc: Christian Bundy <christianbundy@fraction.io>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Cc: Peter Huewe <peterhuewe@gmx.de>
> > > Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > > Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>
> > > Cc: stable@vger.kernel.org
> > > Cc: linux-integrity@vger.kernel.org
> > > Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
> > > Fixes: 5b359c7c4372 ("tpm_tis_core: Turn on the TPM before probing IRQ's")
> > 
> > Ugh, sorry, I guess this jinxed it. This patch does not address the
> > IRQ storm on the platform I reported earlier.
> 
> Are the reverts making their way upstream?

Not yet.

Cannot randomly apply patches without answer to why. Given that
some changes are already landed changes it would be better to
create a patch based on reverts (in the sense of code change)
and commit message what is going on.

/Jarkko

