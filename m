Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85545CD89C
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfJFSZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 14:25:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:9088 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbfJFSZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 14:25:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Oct 2019 11:25:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,265,1566889200"; 
   d="scan'208";a="204853184"
Received: from dnlarsen-mobl4.amr.corp.intel.com (HELO localhost) ([10.252.3.159])
  by orsmga002.jf.intel.com with ESMTP; 06 Oct 2019 11:25:26 -0700
Date:   Sun, 6 Oct 2019 21:25:25 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, stefanb@linux.ibm.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tpm_tis_core: Set TPM_CHIP_FLAG_IRQ
 before probing for" failed to apply to 4.9-stable tree
Message-ID: <20191006182525.GA21092@linux.intel.com>
References: <1570088789234154@kroah.com>
 <20191003123246.GC10614@linux.intel.com>
 <20191003132517.GX17454@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003132517.GX17454@sasha-vm>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 09:25:17AM -0400, Sasha Levin wrote:
> On Thu, Oct 03, 2019 at 03:32:46PM +0300, Jarkko Sakkinen wrote:
> > On Thu, Oct 03, 2019 at 09:46:29AM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 4.9-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Inspecting next week.
> 
> It looks to me like it's not relevant for 4.19 and older because it
> needs 5b359c7c43727 ("tpm_tis_core: Turn on the TPM before probing
> IRQ's"), which isn't present in 4.19.

Thanks. I'll take no action.

/Jarkko
