Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB3F1BEEDD
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 06:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgD3EAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 00:00:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:17334 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgD3EAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 00:00:48 -0400
IronPort-SDR: yj8TmLWwsReHG7GSMisHqz8qQxN9UgmsjVFCm+9i+ITXNwGI2Ia98G1veCLs3In1ea1CLkgAfz
 10eAswiE8XXw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 21:00:48 -0700
IronPort-SDR: sNz80AeppAXBoljxGVY/kL4RfiCytDXDWrKQuUVh9PAEvJaIEdaCuxfnhhn2s0EOSt9Ims/Xg0
 xJgVnmF7tD2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,333,1583222400"; 
   d="scan'208";a="432812986"
Received: from aanderso-mobl3.amr.corp.intel.com (HELO localhost) ([10.252.52.101])
  by orsmga005.jf.intel.com with ESMTP; 29 Apr 2020 21:00:39 -0700
Date:   Thu, 30 Apr 2020 07:00:38 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Dave Young <dyoung@redhat.com>, Lukas Wunner <lukas@wunner.de>,
        Lyude Paul <lyude@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Peter Jones <pjones@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Talbert <swt@techie.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi/tpm: fix section mismatch warning
Message-ID: <20200430040038.GD31820@linux.intel.com>
References: <20200429190119.43595-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429190119.43595-1-arnd@arndb.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 29, 2020 at 09:01:08PM +0200, Arnd Bergmann wrote:
> Building with gcc-10 causes a harmless warning about a section mismatch:
> 
> WARNING: modpost: vmlinux.o(.text.unlikely+0x5e191): Section mismatch in reference from the function tpm2_calc_event_log_size() to the function .init.text:early_memunmap()
> The function tpm2_calc_event_log_size() references
> the function __init early_memunmap().
> This is often because tpm2_calc_event_log_size lacks a __init
> annotation or the annotation of early_memunmap is wrong.
> 
> Add the missing annotation.
> 
> Fixes: e658c82be556 ("efi/tpm: Only set 'efi_tpm_final_log_size' after successful event log parsing")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
