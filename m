Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEA8B15A4
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 22:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfILU7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 16:59:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:16448 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbfILU7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Sep 2019 16:59:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 13:59:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="269209602"
Received: from jjiang35-mobl1.ger.corp.intel.com (HELO [10.252.53.130]) ([10.252.53.130])
  by orsmga001.jf.intel.com with ESMTP; 12 Sep 2019 13:58:57 -0700
Subject: Re: [Intel-gfx] [PATCH 01/23] drm/i915/dp: Fix dsc bpp calculations.
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     Sasha Levin <sashal@kernel.org>, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
References: <20190912130109.5873-1-maarten.lankhorst@linux.intel.com>
 <20190912143415.D8F552081B@mail.kernel.org>
 <db913560-ee38-71e0-39e8-28bc75bbdc5e@linux.intel.com>
 <20190912180524.GA1208@intel.com>
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <395f8c15-25fd-7168-f00c-22f30db2ce25@linux.intel.com>
Date:   Thu, 12 Sep 2019 22:58:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190912180524.GA1208@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Op 12-09-2019 om 20:05 schreef Ville Syrjälä:
> On Thu, Sep 12, 2019 at 06:01:57PM +0200, Maarten Lankhorst wrote:
>> Hey,
>>
>> Op 12-09-2019 om 16:34 schreef Sasha Levin:
>>> Hi,
>>>
>>> [This is an automated email]
>>>
>>> This commit has been processed because it contains a "Fixes:" tag,
>>> fixing commit: d9218c8f6cf4 drm/i915/dp: Add helpers for Compressed BPP and Slice Count for DSC.
>>>
>>> The bot has tested the following trees: v5.2.14.
>>>
>>> v5.2.14: Failed to apply! Possible dependencies:
>>>     Unable to calculate
>>>
>>>
>>> NOTE: The patch will not be queued to stable trees until it is upstream.
>>>
>>> How should we proceed with this patch?
>>>
>>> --
>>> Thanks,
>>> Sasha
>> Why is this bot asking for patches on the trybot mailing list?
> Did you forget --suppress-cc=all ?
>
Ah that's it, thanks! :)

~Maarten

