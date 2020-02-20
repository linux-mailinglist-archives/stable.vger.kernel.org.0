Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2D2166A56
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 23:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgBTW0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 17:26:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:17594 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbgBTW0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 17:26:49 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 14:26:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,466,1574150400"; 
   d="scan'208";a="315870110"
Received: from evieschw-mobl.ger.corp.intel.com (HELO localhost) ([10.251.86.197])
  by orsmga001.jf.intel.com with ESMTP; 20 Feb 2020 14:26:39 -0800
Date:   Fri, 21 Feb 2020 00:26:38 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Garrett <mjg59@google.com>
Cc:     linux-integrity <linux-integrity@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] tpm: Don't make log failures fatal
Message-ID: <20200220222638.GA28411@linux.intel.com>
References: <20200102215518.148051-1-matthewgarrett@google.com>
 <0257b88752b4acdb8715da2fa1c5dfbf9fb1b34b.camel@linux.intel.com>
 <CACdnJuvJyE7u+HSonm7-AcK9EabZobn46vEFVdrTSRcwNvz0_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACdnJuvJyE7u+HSonm7-AcK9EabZobn46vEFVdrTSRcwNvz0_A@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 20, 2020 at 12:29:24PM -0800, Matthew Garrett wrote:
> On Fri, Jan 3, 2020 at 3:26 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Thu, 2020-01-02 at 13:55 -0800, Matthew Garrett wrote:
> > > If a TPM is in disabled state, it's reasonable for it to have an empty
> > > log. Bailing out of probe in this case means that the PPI interface
> > > isn't available, so there's no way to then enable the TPM from the OS.
> > > In general it seems reasonable to ignore log errors - they shouldn't
> > > interfere with any other TPM functionality.
> > >
> > > Signed-off-by: Matthew Garrett <mjg59@google.com>
> > > Cc: stable@vger.kernel.org
> >
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Hi Jarkko,
> 
> Is this queued anywhere? Thanks!

Thanks for reminding. Now is:

git://git.infradead.org/users/jjs/linux-tpmdd.git

/Jarkko
