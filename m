Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B01711DB0A
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 01:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbfLMARi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 19:17:38 -0500
Received: from mga06.intel.com ([134.134.136.31]:18547 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730882AbfLMARi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 19:17:38 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Dec 2019 16:17:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,307,1571727600"; 
   d="scan'208";a="415463764"
Received: from dwidzins-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.21.195])
  by fmsmga006.fm.intel.com with ESMTP; 12 Dec 2019 16:17:32 -0800
Date:   Fri, 13 Dec 2019 02:17:31 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Guenter Roeck <groeck@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Andrey Pronin <apronin@chromium.org>,
        Duncan Laurie <dlaurie@chromium.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Alexander Steffen <Alexander.Steffen@infineon.com>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 277/350] tpm: Add a flag to indicate TPM
 power is managed by firmware
Message-ID: <20191213001654.GD7854@linux.intel.com>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-238-sashal@kernel.org>
 <CABXOdTdO16V4AtO1t=BwXW2=HAtT6CYoSddmrn5T2qZP9hs0eQ@mail.gmail.com>
 <20191211175651.GK4516@linux.intel.com>
 <CABXOdTcsnAVaPo-492tVPtjOYMbNtu2Zvz4GwSBGcDEHAMGw5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABXOdTcsnAVaPo-492tVPtjOYMbNtu2Zvz4GwSBGcDEHAMGw5Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 10:05:52AM -0800, Guenter Roeck wrote:
> On Wed, Dec 11, 2019 at 9:57 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Tue, Dec 10, 2019 at 01:32:15PM -0800, Guenter Roeck wrote:
> > > On Tue, Dec 10, 2019 at 1:12 PM Sasha Levin <sashal@kernel.org> wrote:
> > > >
> > > > From: Stephen Boyd <swboyd@chromium.org>
> > > >
> > > > [ Upstream commit 2e2ee5a2db06c4b81315514b01d06fe5644342e9 ]
> > > >
> > > > On some platforms, the TPM power is managed by firmware and therefore we
> > > > don't need to stop the TPM on suspend when going to a light version of
> > > > suspend such as S0ix ("freeze" suspend state). Add a chip flag,
> > > > TPM_CHIP_FLAG_FIRMWARE_POWER_MANAGED, to indicate this so that certain
> > > > platforms can probe for the usage of this light suspend and avoid
> > > > touching the TPM state across suspend/resume.
> > > >
> > >
> > > Are the patches needed to support CR50 (which need this patch) going
> > > to be applied to v5.4.y as well ? If not, what is the purpose of
> > > applying this patch to v5.4.y ?
> > >
> > > Thanks,
> > > Guenter
> >
> > Thanks Guenter. I think not.
> >
> Thought so. In that case this patch should be dropped.
> 
> Guenter

I fully agree with you.

/Jarkko
