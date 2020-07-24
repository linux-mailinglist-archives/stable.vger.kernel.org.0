Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6812122C28A
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 11:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGXJqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 05:46:04 -0400
Received: from mga12.intel.com ([192.55.52.136]:22380 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgGXJqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 05:46:04 -0400
IronPort-SDR: 0b+r5yupytBzSV1tZbLsmLcuqFGkV81rOS+XfXui3LFk6srVPCtXp21mh6zcVkpk4dm+Nk9gK7
 +YgnQU3zIUOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="130244735"
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="130244735"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 02:46:04 -0700
IronPort-SDR: 0W7kPpD+LfSUd2OBQCiLv/DSF0MjTVzgBDWMkMeSSngz8E3BWq1Cmobqy3u/ZKOD5+Nc/V88Bp
 nd8Wp3v4+A3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="328860333"
Received: from ahershco-mobl1.ger.corp.intel.com (HELO [10.254.144.190]) ([10.254.144.190])
  by orsmga007.jf.intel.com with ESMTP; 24 Jul 2020 02:46:02 -0700
Subject: Re: [PATCH] drm/i915: Filter wake_flags passed to
 default_wake_function
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200723195110.11540-1-chris@chris-wilson.co.uk>
From:   Matthew Auld <matthew.auld@intel.com>
Message-ID: <29ee42c5-ff73-9019-5aae-e246ef684052@intel.com>
Date:   Fri, 24 Jul 2020 10:46:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200723195110.11540-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/07/2020 20:51, Chris Wilson wrote:
> The flags passed to the wait_entry.func are passed onwards to
> try_to_wake_up(), which has a very particular interpretation for its
> wake_flags. In particular, beyond the published WF_SYNC, it has a few
> internal flags as well. Since we passed the fence->error down the chain
> via the flags argument, these ended up in the default_wake_function
> confusing the kernel/sched.
> 
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2110
> Fixes: ef4688497512 ("drm/i915: Propagate fence errors")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: <stable@vger.kernel.org> # v5.4+

Reviewed-by: Matthew Auld <matthew.auld@intel.com>
