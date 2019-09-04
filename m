Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABBF8A7D73
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 10:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfIDIQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 04:16:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:18348 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfIDIQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 04:16:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 01:16:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="185039381"
Received: from pgarraul-mobl.ger.corp.intel.com ([10.252.2.140])
  by orsmga003.jf.intel.com with ESMTP; 04 Sep 2019 01:16:31 -0700
Message-ID: <a87b70c5e8fdd7d4b9ef3d133dfb3e8cd86625a0.camel@intel.com>
Subject: Re: FAILED: patch "[PATCH] iwlwifi: pcie: handle switching killer
 Qu B0 NICs to C0" failed to apply to 5.2-stable tree
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc:     johannes.berg@intel.com, stable@vger.kernel.org
Date:   Wed, 04 Sep 2019 11:16:30 +0300
In-Reply-To: <20190903205321.GP5281@sasha-vm>
References: <15675370949856@kroah.com> <20190903205321.GP5281@sasha-vm>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-09-03 at 16:53 -0400, Sasha Levin wrote:
> On Tue, Sep 03, 2019 at 08:58:14PM +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.2-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> There are quite a few dependencies here - it looks like a few other
> stable tagged commits didn't make it to 5.2 and this one depends on
> them. I've fixed it up by taking:
> 
> d151b0a2efa12 ("iwlwifi: add new cards for 22000 and fix struct name")
> a976bfb44bdbc ("iwlwifi: add new cards for 22000 and change wrong structs")
> ffcb60a54f245 ("iwlwifi: add new cards for 9000 and 20000 series")
> 658521fc1bf14 ("iwlwifi: change 0x02F0 fw from qu to quz")
> a7d544d631200 ("iwlwifi: pcie: add support for qu c-step devices")
> 17e40e6979aaf ("iwlwifi: pcie: don't switch FW to qnj when ax201 is detected")
> b9500577d3615 ("iwlwifi: pcie: handle switching killer Qu B0 NICs to C0")

Thanks, Sasha!

This list looks good.  There is one or two more patches that need to be
taken to v5.2, but I'll wait till these ones make it into linux-5.2.y
so I can rebase them on top of it.

--
Cheers,
Luca.

