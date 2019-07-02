Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4135CF41
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfGBMQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:16:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:43469 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbfGBMQY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 08:16:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jul 2019 05:16:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,443,1557212400"; 
   d="scan'208";a="315221883"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2019 05:16:23 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id A76975C166E; Tue,  2 Jul 2019 15:16:17 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH v7 2/3] drm/i915: whitelist PS_(DEPTH|INVOCATION)_COUNT
In-Reply-To: <156206601183.2466.7357010939425742878@skylake-alporthouse-com>
References: <20190628120720.21682-1-lionel.g.landwerlin@intel.com> <20190628120720.21682-3-lionel.g.landwerlin@intel.com> <156206601183.2466.7357010939425742878@skylake-alporthouse-com>
Date:   Tue, 02 Jul 2019 15:16:17 +0300
Message-ID: <87zhlw3a3y.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> Quoting Lionel Landwerlin (2019-06-28 13:07:19)
>> CFL:C0+ changed the status of those registers which are now
>> blacklisted by default.
>> 
>> This is breaking a number of CTS tests on GL & Vulkan :
>> 
>>   KHR-GL45.pipeline_statistics_query_tests_ARB.functional_fragment_shader_invocations (GL)
>> 
>>   dEQP-VK.query_pool.statistics_query.fragment_shader_invocations.* (Vulkan)
>> 
>> v2: Only use one whitelist entry (Lionel)
>
> Bspec: 14091

Sometimes we have optionally used References: BSID#0934 to
mark the workaround. But it feels a tad redudant now.

>> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
>> Cc: stable@vger.kernel.org
> Acked-by: Chris Wilson <chris@chris-wilson.co.uk>

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
