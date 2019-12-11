Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9E611A9C8
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 12:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbfLKLXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 06:23:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:56024 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbfLKLXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 06:23:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 03:22:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="210731486"
Received: from unknown (HELO localhost) ([10.237.50.137])
  by fmsmga008.fm.intel.com with ESMTP; 11 Dec 2019 03:22:54 -0800
Date:   Wed, 11 Dec 2019 13:22:54 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Stefan Berger <stefanb@linux.ibm.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 0/2] Revert patches fixing probing of interrupts
Message-ID: <20191211112254.GC16450@linux.intel.com>
References: <20191126131753.3424363-1-stefanb@linux.vnet.ibm.com>
 <20191129223418.GA15726@linux.intel.com>
 <6f6f60a2-3b55-e76d-c11a-4677fcb72c16@linux.ibm.com>
 <20191202185520.57w2h3dgs5q7lhob@cantor>
 <20191209194248.GC19243@linux.intel.com>
 <20191209215535.pw6ewyetskaet2o6@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209215535.pw6ewyetskaet2o6@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 09, 2019 at 02:55:35PM -0700, Jerry Snitselaar wrote:
> On Mon Dec 09 19, Jarkko Sakkinen wrote:
> > On Mon, Dec 02, 2019 at 11:55:20AM -0700, Jerry Snitselaar wrote:
> > > On Sun Dec 01 19, Stefan Berger wrote:
> > > > On 11/29/19 5:37 PM, Jarkko Sakkinen wrote:
> > > > > On Tue, Nov 26, 2019 at 08:17:51AM -0500, Stefan Berger wrote:
> > > > > > From: Stefan Berger <stefanb@linux.ibm.com>
> > > > > >
> > > > > > Revert the patches that were fixing the probing of interrupts due
> > > > > > to reports of interrupt stroms on some systems
> > > > > Can you explain how reverting is going to fix the issue?
> > > >
> > > >
> > > > The reverts fix 'the interrupt storm issue' that they are causing on
> > > > some systems but don't fix the issue with the interrupt mode not being
> > > > used. I was hoping Jerry would get access to a system faster but this
> > > > didn't seem to be the case. So sending these patches seemed the better
> > > > solution than leaving 5.4.x with the problem but going back to when it
> > > > worked 'better.'
> > > >
> > > 
> > > I finally heard back from IT support, and unfortunately they don't
> > > have any T490s systems to give out on temp loan. So I can only send
> > > patched kernels to the end user that had the problem.
> > 
> > At least it is a fact that tpm_chip_stop() is called too early and that
> > is destined to cause issues.
> > 
> > Should I bake a patch or do you have already something?
> > 
> > /Jarkko
> > 
> 
> This is what I'm currently building:

With a quick skim looks what I had in mind.

/Jarkko
