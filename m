Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41B911411
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 09:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfEBHWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 03:22:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:12074 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbfEBHWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 03:22:09 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 00:22:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,420,1549958400"; 
   d="scan'208";a="342704860"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by fmsmga006.fm.intel.com with ESMTP; 02 May 2019 00:22:05 -0700
Date:   Thu, 2 May 2019 10:22:05 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jonas Witschel <diabonas@gmx.de>
Cc:     Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
        Tadeusz Struk <tadeusz.struk@intel.com>, grawity@gmail.com,
        James.Bottomley@hansenpartnership.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] tpm: fix an invalid condition in tpm_common_poll
Message-ID: <20190502072205.GF14532@linux.intel.com>
References: <155371155820.17863.10580533125620125669.stgit@tstruk-mobl1.jf.intel.com>
 <20190328123428.GF7094@linux.intel.com>
 <b29aaf62-2ea0-d6c6-32ee-44bc3fe8f03f@intel.com>
 <20190408120138.GA951@gandi.net>
 <20190409134421.GD9759@linux.intel.com>
 <e9cfa3db-42d7-4e1c-a371-2c810f911dab@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9cfa3db-42d7-4e1c-a371-2c810f911dab@gmx.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 23, 2019 at 10:54:47PM +0200, Jonas Witschel wrote:
> On 2019-04-09 15:44, Jarkko Sakkinen wrote:
> > On Mon, Apr 08, 2019 at 02:01:38PM +0200, Thibaut Sautereau wrote:
> >> [...]
> >> What's the status of this patch now? It's needed in linux-5.0.y as TPM
> >> 2.0 support is currently broken with those stable kernels without this
> >> commit.
> > 
> > part of a PR.
> > 
> > https://lore.kernel.org/linux-integrity/20190329115544.GA27351@linux.intel.com/
> 
> It appears that the final version of the patch that was merged to
> Linus's tree [1] does not include the "Cc: stable@vger.kernel.org" tag.
> If I understand correctly, this means that the patch will not be
> automatically included in the -stable tree without further action. Is
> there a specific reason not to apply this patch to 5.0.x, or did the tag

It is my mistake. What I can do is to post it manually to stable.
I promise to do it as soon as it reaches the mainline.

/Jarkko
