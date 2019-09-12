Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74591B128C
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 18:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733151AbfILQCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 12:02:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:2739 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbfILQCB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Sep 2019 12:02:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 09:02:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="187545724"
Received: from jpanina-mobl.ger.corp.intel.com (HELO [10.249.35.93]) ([10.249.35.93])
  by orsmga003.jf.intel.com with ESMTP; 12 Sep 2019 09:01:58 -0700
Subject: Re: [PATCH 01/23] drm/i915/dp: Fix dsc bpp calculations.
To:     Sasha Levin <sashal@kernel.org>, intel-gfx@lists.freedesktop.org
Cc:     Manasi Navare <manasi.d.navare@intel.com>, stable@vger.kernel.org
References: <20190912130109.5873-1-maarten.lankhorst@linux.intel.com>
 <20190912143415.D8F552081B@mail.kernel.org>
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <db913560-ee38-71e0-39e8-28bc75bbdc5e@linux.intel.com>
Date:   Thu, 12 Sep 2019 18:01:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190912143415.D8F552081B@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey,

Op 12-09-2019 om 16:34 schreef Sasha Levin:
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: d9218c8f6cf4 drm/i915/dp: Add helpers for Compressed BPP and Slice Count for DSC.
>
> The bot has tested the following trees: v5.2.14.
>
> v5.2.14: Failed to apply! Possible dependencies:
>     Unable to calculate
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>
> --
> Thanks,
> Sasha

Why is this bot asking for patches on the trybot mailing list?

~Maarten

