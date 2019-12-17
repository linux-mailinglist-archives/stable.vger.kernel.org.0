Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7760D1220EE
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfLQA7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:59:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:52178 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbfLQA7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 19:59:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 16:59:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,323,1571727600"; 
   d="scan'208";a="217607748"
Received: from chauvina-mobl1.ger.corp.intel.com ([10.251.85.48])
  by orsmga003.jf.intel.com with ESMTP; 16 Dec 2019 16:59:02 -0800
Message-ID: <5aef0fbe28ed23b963c53d61445b0bac6f108642.camel@linux.intel.com>
Subject: Re: [PATCH v2] tpm_tis: reserve chip for duration of
 tpm_tis_core_init
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jerry Snitselaar <jsnitsel@redhat.com>,
        linux-kernel@vger.kernel.org
Cc:     Christian Bundy <christianbundy@fraction.io>,
        Dan Williams <dan.j.williams@intel.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org
Date:   Tue, 17 Dec 2019 02:58:56 +0200
In-Reply-To: <20191211235455.24424-1-jsnitsel@redhat.com>
References: <20191211231758.22263-1-jsnitsel@redhat.com>
         <20191211235455.24424-1-jsnitsel@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-12-11 at 16:54 -0700, Jerry Snitselaar wrote:
> Instead of repeatedly calling tpm_chip_start/tpm_chip_stop when
> issuing commands to the tpm during initialization, just reserve the
> chip after wait_startup, and release it when we are ready to call
> tpm_chip_register.
> 
> Cc: Christian Bundy <christianbundy@fraction.io>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Peter Huewe <peterhuewe@gmx.de>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>
> Cc: stable@vger.kernel.org
> Cc: linux-integrity@vger.kernel.org
> Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
> Fixes: 5b359c7c4372 ("tpm_tis_core: Turn on the TPM before probing IRQ's")
> Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>

I pushed to my master with minor tweaks and added my tags.

Please check before I put it to linux-next.

/Jarkko

