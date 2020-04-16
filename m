Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD6F1AC21C
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894840AbgDPNMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:12:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:1040 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894763AbgDPNMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:12:39 -0400
IronPort-SDR: 5Zfvf1wSn4KCJETYIKw+gY027jL/gqKXOyikMsRIKLUrlWIh24TiHIXq01dj0pOr6i3qo/lkUm
 6cFVkD+bfB7Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 06:12:37 -0700
IronPort-SDR: gTHXxefBpEEtZe5hcneQRTrzUQKqy9+Fv6lTlydRCvnKMAzxg5D2QjzIJucEOdvEQ3tIK44PAQ
 blsX1bKnaX2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,391,1580803200"; 
   d="scan'208";a="277023127"
Received: from otazetdi-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.42.128])
  by orsmga008.jf.intel.com with ESMTP; 16 Apr 2020 06:12:35 -0700
Date:   Thu, 16 Apr 2020 16:12:34 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     shuah <shuah@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Nikita Sobolev <Nikita.Sobolev@synopsys.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 04/66] Kernel selftests: tpm2: check for tpm
 support
Message-ID: <20200416131234.GA65786@linux.intel.com>
References: <20200303024615.8889-1-sashal@kernel.org>
 <20200303024615.8889-4-sashal@kernel.org>
 <8954e808-6dd9-dd71-e2d7-7dc90c9d66b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8954e808-6dd9-dd71-e2d7-7dc90c9d66b3@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 10:04:40AM -0600, shuah wrote:
> On 3/2/20 7:45 PM, Sasha Levin wrote:
> > From: Nikita Sobolev <Nikita.Sobolev@synopsys.com>
> > 
> > [ Upstream commit b32694cd0724d4ceca2c62cc7c3d3a8d1ffa11fc ]
> > 
> > tpm2 tests set fails if there is no /dev/tpm0 and /dev/tpmrm0
> > supported. Check if these files exist before run and mark test as
> > skipped in case of absence.
> > 
> > Signed-off-by: Nikita Sobolev <Nikita.Sobolev@synopsys.com>
> > Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   tools/testing/selftests/tpm2/test_smoke.sh | 13 +++++++++++--
> >   tools/testing/selftests/tpm2/test_space.sh |  9 ++++++++-
> >   2 files changed, 19 insertions(+), 3 deletions(-)
> > 
> 
> Let's drop this unless it already made it into stables.
> Jarkko Sakkinen found regressions and send in a revert
> for this patch.
> 
> thanks,
> -- Shuah

Thanks, can ack this.

/Jarkko
