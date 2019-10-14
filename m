Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2759CD605E
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 12:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbfJNKiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 06:38:06 -0400
Received: from mga04.intel.com ([192.55.52.120]:47070 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731249AbfJNKiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 06:38:06 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 03:38:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,295,1566889200"; 
   d="scan'208";a="188990196"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.126])
  by orsmga008.jf.intel.com with ESMTP; 14 Oct 2019 03:38:01 -0700
Date:   Mon, 14 Oct 2019 13:38:02 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-stable@vger.kernel.org,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        "open list:TPM DEVICE DRIVER" <linux-integrity@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] tpm: Fix TPM 1.2 Shutdown sequence to prevent
 future TPM operations
Message-ID: <20191014103802.GA12301@linux.intel.com>
References: <20191009212831.29081-1-jarkko.sakkinen@linux.intel.com>
 <20191009212831.29081-4-jarkko.sakkinen@linux.intel.com>
 <20191010082807.GC326087@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010082807.GC326087@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 10:28:07AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Oct 10, 2019 at 12:28:31AM +0300, Jarkko Sakkinen wrote:
> > From: Vadim Sukhomlinov <sukhomlinov@google.com>
> > 
> > commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream
> > 
> > TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> > future TPM operations. TPM 1.2 behavior was different, future TPM
> > operations weren't disabled, causing rare issues. This patch ensures
> > that future TPM operations are disabled.
> > 
> > Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
> > [dianders: resolved merge conflicts with mainline]
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  drivers/char/tpm/tpm-chip.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> This is already in the 4.14.148 4.19.78 5.1.18 5.2.1 5.3 releases.

There was one extra NULL assigment (non op). Nothing critical.

/Jarkko
