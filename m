Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75689156C88
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 22:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbgBIVJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 16:09:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:17871 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727416AbgBIVJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 16:09:55 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Feb 2020 13:09:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,422,1574150400"; 
   d="scan'208";a="221361012"
Received: from jradtke-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.22.75])
  by orsmga007.jf.intel.com with ESMTP; 09 Feb 2020 13:09:51 -0800
Date:   Sun, 9 Feb 2020 23:09:51 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     linux-integrity@vger.kernel.org,
        Andrey Pronin <apronin@chromium.org>, stable@vger.kernel.org,
        Alexander Steffen <Alexander.Steffen@infineon.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm: Revert tpm_tis_spi_mod.ko to tpm_tis_spi.ko.
Message-ID: <20200209210951.GA31002@linux.intel.com>
References: <20200205203818.4679-1-jarkko.sakkinen@linux.intel.com>
 <5e3c6784.1c69fb81.34ded.0a42@mx.google.com>
 <20200209210133.GA3702@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200209210133.GA3702@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 11:01:33PM +0200, Jarkko Sakkinen wrote:
> On Thu, Feb 06, 2020 at 11:22:44AM -0800, Stephen Boyd wrote:
> > Quoting Jarkko Sakkinen (2020-02-05 12:38:18)
> > > Revert tpm_tis_spi_mod.ko back to tpm_tis_spi.ko as the rename could break
> > > the build script. This can be achieved by renaming tpm_tis_spi.c as
> > 
> > Do you mean userspace scripts?
> 
> Yes. I'll fix the commit message before merging.
> 
> Thanks for the review.

The commit message is now fixed in my master:

git://git.infradead.org/users/jjs/linux-tpmdd.git

I also added your and Alexander's tags.

I'll send a PR after rc1 is out. Thank you.

/Jarkko
