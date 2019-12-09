Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E1A117653
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 20:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfLITwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 14:52:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:50945 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbfLITwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 14:52:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 11:42:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,296,1571727600"; 
   d="scan'208";a="215198322"
Received: from nshalmon-mobl.ger.corp.intel.com (HELO localhost) ([10.252.8.146])
  by orsmga006.jf.intel.com with ESMTP; 09 Dec 2019 11:42:50 -0800
Date:   Mon, 9 Dec 2019 21:42:48 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Stefan Berger <stefanb@linux.ibm.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 0/2] Revert patches fixing probing of interrupts
Message-ID: <20191209194248.GC19243@linux.intel.com>
References: <20191126131753.3424363-1-stefanb@linux.vnet.ibm.com>
 <20191129223418.GA15726@linux.intel.com>
 <6f6f60a2-3b55-e76d-c11a-4677fcb72c16@linux.ibm.com>
 <20191202185520.57w2h3dgs5q7lhob@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202185520.57w2h3dgs5q7lhob@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 11:55:20AM -0700, Jerry Snitselaar wrote:
> On Sun Dec 01 19, Stefan Berger wrote:
> > On 11/29/19 5:37 PM, Jarkko Sakkinen wrote:
> > > On Tue, Nov 26, 2019 at 08:17:51AM -0500, Stefan Berger wrote:
> > > > From: Stefan Berger <stefanb@linux.ibm.com>
> > > > 
> > > > Revert the patches that were fixing the probing of interrupts due
> > > > to reports of interrupt stroms on some systems
> > > Can you explain how reverting is going to fix the issue?
> > 
> > 
> > The reverts fix 'the interrupt storm issue' that they are causing on
> > some systems but don't fix the issue with the interrupt mode not being
> > used. I was hoping Jerry would get access to a system faster but this
> > didn't seem to be the case. So sending these patches seemed the better
> > solution than leaving 5.4.x with the problem but going back to when it
> > worked 'better.'
> > 
> 
> I finally heard back from IT support, and unfortunately they don't
> have any T490s systems to give out on temp loan. So I can only send
> patched kernels to the end user that had the problem.

At least it is a fact that tpm_chip_stop() is called too early and that
is destined to cause issues.

Should I bake a patch or do you have already something?

/Jarkko
