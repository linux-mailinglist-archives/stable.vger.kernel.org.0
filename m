Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D61EAC8DE
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 20:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394476AbfIGSzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 14:55:22 -0400
Received: from mga18.intel.com ([134.134.136.126]:50138 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393429AbfIGSzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Sep 2019 14:55:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Sep 2019 11:55:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,478,1559545200"; 
   d="scan'208";a="186096982"
Received: from bemmett-mobl.amr.corp.intel.com ([10.249.37.206])
  by orsmga003.jf.intel.com with ESMTP; 07 Sep 2019 11:55:19 -0700
Message-ID: <f2224c094836a4b8989c1cd6243a0b7ad1261a87.camel@linux.intel.com>
Subject: Re: [PATCH AUTOSEL 4.19 126/167] tpm: Fix TPM 1.2 Shutdown sequence
 to prevent future TPM operations
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sasha Levin <sashal@kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        linux-integrity@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Date:   Sat, 07 Sep 2019 21:55:18 +0300
In-Reply-To: <20190903194335.GG5281@sasha-vm>
References: <20190903162519.7136-1-sashal@kernel.org>
         <20190903162519.7136-126-sashal@kernel.org>
         <CAD=FV=W0YodeoOCiCv9zmv+-gswuU8U_XgrBnesE=wynTbDBiA@mail.gmail.com>
         <20190903165346.hwqlrin77cmzjiti@cantor> <20190903194335.GG5281@sasha-vm>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-09-03 at 15:43 -0400, Sasha Levin wrote:
> Right. I gave a go at backporting a few patches and this happens to be
> one of them. It will be a while before it goes in a stable tree
> (probably way after after LPC).

It *semantically* depends on

db4d8cb9c9f2 ("tpm: use tpm_try_get_ops() in tpm-sysfs.c.")

I.e. can cause crashes without the above patch. As a code change your
patch is fine but it needs the above patch backported to work in stable
manner.

So... either I can backport that one (because ultimately I have
responsibility to do that as the maintainer) but if you want to finish
this one that is what you need to backport in addition and then it
should be fine.

/Jarkko

