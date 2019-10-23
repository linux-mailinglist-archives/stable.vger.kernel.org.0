Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB8BE191C
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 13:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404935AbfJWLdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 07:33:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:47664 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404612AbfJWLdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Oct 2019 07:33:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 04:32:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,220,1569308400"; 
   d="scan'208";a="398013206"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.121])
  by fmsmga005.fm.intel.com with ESMTP; 23 Oct 2019 04:32:48 -0700
Date:   Wed, 23 Oct 2019 14:32:48 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Peter Huewe <peterhuewe@gmx.de>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Switch to platform_get_irq_optional()
Message-ID: <20191023113248.GA21973@linux.intel.com>
References: <20191019094528.27850-1-hdegoede@redhat.com>
 <20191021140502.GA25178@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021140502.GA25178@ziepe.ca>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 21, 2019 at 11:05:02AM -0300, Jason Gunthorpe wrote:
> On Sat, Oct 19, 2019 at 11:45:28AM +0200, Hans de Goede wrote:
> > Since commit 7723f4c5ecdb ("driver core: platform: Add an error message to
> > platform_get_irq*()"), platform_get_irq() will call dev_err() on an error,
> > as the IRQ usage in the tpm_tis driver is optional, this is undesirable.
> 
> This should have a fixes line for the above, or maybe the commit that
> addtion the _optional version..

Is this fixing something?

/Jarkko
