Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7087EC9D2D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 13:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbfJCLYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 07:24:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:12616 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729741AbfJCLYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 07:24:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 04:24:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,251,1566889200"; 
   d="scan'208";a="198502951"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.161])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Oct 2019 04:24:42 -0700
Date:   Thu, 3 Oct 2019 14:24:42 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-stabley@vger.kernel.org,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "open list:TPM DEVICE DRIVER" <linux-integrity@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tpm: Fix TPM 1.2 Shutdown sequence to prevent future
 TPM operations
Message-ID: <20191003112442.GA8933@linux.intel.com>
References: <20191002131445.7793-1-jarkko.sakkinen@linux.intel.com>
 <20191002131445.7793-4-jarkko.sakkinen@linux.intel.com>
 <20191002135758.GA1738718@kroah.com>
 <20191002151751.GP17454@sasha-vm>
 <20191002153123.wcguist4okoxckis@cantor>
 <20191002154204.me4lzgx2l4r6zkpy@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002154204.me4lzgx2l4r6zkpy@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 08:42:04AM -0700, Jerry Snitselaar wrote:
> On Wed Oct 02 19, Jerry Snitselaar wrote:
> > On Wed Oct 02 19, Sasha Levin wrote:
> > > On Wed, Oct 02, 2019 at 03:57:58PM +0200, Greg KH wrote:
> > > > On Wed, Oct 02, 2019 at 04:14:44PM +0300, Jarkko Sakkinen wrote:
> > > > > From: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > > > 
> > > > > commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream
> > > > > 
> > > > > TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> > > > > future TPM operations. TPM 1.2 behavior was different, future TPM
> > > > > operations weren't disabled, causing rare issues. This patch ensures
> > > > > that future TPM operations are disabled.
> > > > > 
> > > > > Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > > > [dianders: resolved merge conflicts with mainline]
> > > > > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > > > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > > ---
> > > > > drivers/char/tpm/tpm-chip.c | 5 +++--
> > > > > 1 file changed, 3 insertions(+), 2 deletions(-)
> > > > 
> > > > What kernel version(s) is this for?
> > > 
> > > It would go to 4.19, we've recently reverted an incorrect backport of
> > > this patch.
> > > 
> > > Jarkko, why is this patch 3/3? We haven't seen the first two on the
> > > mailing list, do we need anything besides this patch?
> > > 
> > > --
> > > Thanks,
> > > Sasha
> > 
> > It looks like there was a problem mailing the earlier patchset, and patches 1 and 2
> > weren't cc'd to stable, but patch 3 was.
> 
> Is linux-stabley@vger.kernel.org a valid address?
> 

No, did a resend :-(

/Jarkko
