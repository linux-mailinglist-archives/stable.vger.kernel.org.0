Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9125A12B181
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 06:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfL0Fm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 00:42:26 -0500
Received: from mga07.intel.com ([134.134.136.100]:60664 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbfL0Fm0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 00:42:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Dec 2019 21:42:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,361,1571727600"; 
   d="scan'208";a="250560953"
Received: from psklarow-mobl.ger.corp.intel.com ([10.252.31.109])
  by fmsmga002.fm.intel.com with ESMTP; 26 Dec 2019 21:42:21 -0800
Message-ID: <0f355936c954847089d9e8fb579e30bf8ca43a0e.camel@linux.intel.com>
Subject: Re: [PATCH v2] tpm_tis: reserve chip for duration of
 tpm_tis_core_init
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
Date:   Fri, 27 Dec 2019 07:42:21 +0200
In-Reply-To: <f0406ed23a9a64bd7c5dc0e0b403151d6157a8cf.camel@linux.intel.com>
References: <20191211231758.22263-1-jsnitsel@redhat.com>
         <20191211235455.24424-1-jsnitsel@redhat.com>
         <5aef0fbe28ed23b963c53d61445b0bac6f108642.camel@linux.intel.com>
         <CAPcyv4h60z889bfbiwvVhsj6MxmOPiPY8ZuPB_skxkZx-N+OGw@mail.gmail.com>
         <20191217020022.knh7uxt4pn77wk5m@cantor>
         <CAPcyv4iepQup4bwMuWzq6r5gdx83hgYckUWFF7yF=rszjz3dtQ@mail.gmail.com>
         <5d0763334def7d7ae1e7cf931ef9b14184dce238.camel@linux.intel.com>
         <20191217171844.huqlj5csr262zkkk@cantor>
         <37f4ed0d6145dbe1e8724a5d05d0da82b593bf9c.camel@linux.intel.com>
         <CAPcyv4h8sK+geVvBb1534V9CgdvOnkpPeStV3B8Q1Qdve3is0A@mail.gmail.com>
         <20191219100747.fhbqmzk7xby3tt3l@cantor>
         <f0406ed23a9a64bd7c5dc0e0b403151d6157a8cf.camel@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-12-27 at 07:09 +0200, Jarkko Sakkinen wrote:
> On Thu, 2019-12-19 at 03:07 -0700, Jerry Snitselaar wrote:
> > > These patches take a usable system and make it unusable:
> > > 
> > > 1ea32c83c699 tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts
> > > 5b359c7c4372 tpm_tis_core: Turn on the TPM before probing IRQ's
> > > 
> > > ...they need to be reverted, or the regression needs to be fixed, but
> > > asserting that you fixed something else unrelated does not help.
> > > 
> > 
> > Reverting 1ea32c83c699 ("tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before
> > probing for interrupts") would at least allow people impacted by this
> > to boot their systems without disabling the tpm, or blacklisting the
> > module while we figure this out. From what I can tell the tpm_tis code
> > was operating in that state since 570a36097f30 ("tpm: drop 'irq' from
> > struct tpm_vendor_specific") until Stefan's patch.
> 
> I'll formalize a fix based on the reverts.
> 
> Sorry for the holiday latency.

OK, have a branch now for the PR:

for-linus-v5.5-rc4

Note: now contains the first revert but I'll add another patch if required.

/Jarkko

