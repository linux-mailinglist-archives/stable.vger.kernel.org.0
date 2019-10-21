Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AAFDF205
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 17:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbfJUPtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 11:49:46 -0400
Received: from mga17.intel.com ([192.55.52.151]:19694 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727607AbfJUPtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 11:49:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 08:49:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,324,1566889200"; 
   d="scan'208";a="203365583"
Received: from cweir2-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.9.177])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Oct 2019 08:49:43 -0700
Date:   Mon, 21 Oct 2019 18:49:42 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Switch to platform_get_irq_optional()
Message-ID: <20191021154942.GB4525@linux.intel.com>
References: <20191019094528.27850-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191019094528.27850-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 19, 2019 at 11:45:28AM +0200, Hans de Goede wrote:
> Since commit 7723f4c5ecdb ("driver core: platform: Add an error message to
> platform_get_irq*()"), platform_get_irq() will call dev_err() on an error,
> as the IRQ usage in the tpm_tis driver is optional, this is undesirable.
> 
> Specifically this leads to this new false-positive error being logged:
> [    5.135413] tpm_tis MSFT0101:00: IRQ index 0 not found
> 
> This commit switches to platform_get_irq_optional(), which does not log
> an error, fixing this.
> 
> Cc: <stable@vger.kernel.org> # 5.4.x

Incorrect format (should be wo '<' and '>').

Also, not sure why this should be backported to stable kernel anyway.

/Jarkko
