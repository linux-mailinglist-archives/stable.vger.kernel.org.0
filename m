Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAA7CE7A72
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 21:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfJ1Ur7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 16:47:59 -0400
Received: from mga18.intel.com ([134.134.136.126]:8366 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbfJ1Ur7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 16:47:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Oct 2019 13:47:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,241,1569308400"; 
   d="scan'208";a="400924825"
Received: from shrehore-mobl1.ti.intel.com (HELO localhost) ([10.251.82.5])
  by fmsmga006.fm.intel.com with ESMTP; 28 Oct 2019 13:47:55 -0700
Date:   Mon, 28 Oct 2019 22:47:53 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] tpm: Switch to platform_get_irq_optional()
Message-ID: <20191028204753.GF8279@linux.intel.com>
References: <20191025091448.4424-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025091448.4424-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 25, 2019 at 11:14:48AM +0200, Hans de Goede wrote:
> platform_get_irq() calls dev_err() on an error. As the IRQ usage in the
> tpm_tis driver is optional, this is undesirable.
> 
> Specifically this leads to this new false-positive error being logged:
> [    5.135413] tpm_tis MSFT0101:00: IRQ index 0 not found
> 
> This commit switches to platform_get_irq_optional(), which does not log
> an error, fixing this.
> 
> Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to platform_get_irq*()"
> Cc: <stable@vger.kernel.org> # 5.4.x
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
