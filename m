Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD9CED00A
	for <lists+stable@lfdr.de>; Sat,  2 Nov 2019 18:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfKBRwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Nov 2019 13:52:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:30955 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbfKBRwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 Nov 2019 13:52:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Nov 2019 10:52:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,260,1569308400"; 
   d="scan'208";a="195020575"
Received: from nsalant-vm.ger.corp.intel.com ([10.252.27.128])
  by orsmga008.jf.intel.com with ESMTP; 02 Nov 2019 10:52:49 -0700
Message-ID: <c93083f278d810e1bebab40dcb1990e9285ee1f4.camel@intel.com>
Subject: Re: Please backport 12e36d98d3e for 5.1+: iwlwifi: exclude GEO SAR
 support for 3168
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Thomas Deutschmann <whissi@gentoo.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Sat, 02 Nov 2019 19:52:48 +0200
In-Reply-To: <7a5f833a-3183-6a64-cd35-80d131343089@gentoo.org>
References: <7a5f833a-3183-6a64-cd35-80d131343089@gentoo.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,

On Sat, 2019-11-02 at 15:36 +0100, Thomas Deutschmann wrote:
> Hi,
> 
> please backport
> 
> <<<<snip
> From 12e36d98d3e5acf5fc57774e0a15906d55f30cb9 Mon Sep 17 00:00:00 2001
> From: Luca Coelho <luciano.coelho@intel.com>
> Date: Tue, 8 Oct 2019 13:10:53 +0300
> Subject: iwlwifi: exclude GEO SAR support for 3168
> 
> We currently support two NICs in FW version 29, namely 7265D and 3168.
> Out of these, only 7265D supports GEO SAR, so adjust the function that
> checks for it accordingly.
> 
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Fixes: f5a47fae6aa3 ("iwlwifi: mvm: fix version check for
> GEO_TX_POWER_LIMIT support")
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> snap>>>
> 
> This was the first patch of a 2 patch patch series. The second patch,
> aa0cc7dde17 ("iwlwifi: pcie: change qu with jf devices to use qu
> configuration") had "Cc: stable@vger.kernel.org # 5.1+" and was added.
> The first one was missed.

I sent this earlier for stable v5.1, but it's EOL already, so it won't
be merged there anymore.

--
Cheers,
Luca.

