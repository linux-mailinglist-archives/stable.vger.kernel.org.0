Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB2C65BDCD
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 11:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbjACKO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 05:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbjACKOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 05:14:15 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BA2DF17;
        Tue,  3 Jan 2023 02:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672740854; x=1704276854;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=xw8JnN6F63QyJgk8X/TvL3FEwMeXYZpiYY8Fgt5s4O8=;
  b=T1XvZ881rr7Tl87C3QmVPgb0Wf9kipDy2n36JdRNf5IfX+rJi+egceBF
   iYUu3SVxIMU2KiRqDHWuoPSnoMrxeOeTK76CvR+3KdEqcc94F4XhCXuGR
   zEQuY5uVwx5QWkhML2LMmeT3f5cqcB/YP+HY+U4ru9du7qr5SSZ0ZYIal
   Kun8+ey4FsPZvhAGiS+uRMMOV+7QybJrmBJ5JzpjmlPEAoNpvBrNR+onp
   jVuMA6Xu2b5O7M6L0u8+FbyCDrL8qr2UR+khU5mWGMpqyboRh6qSFLTGW
   jx2zCTv3JWt3/ROJm82BuXOKNDUgfiK+maFosUIAqXXgcHbVGvn8+9s3C
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10578"; a="322862907"
X-IronPort-AV: E=Sophos;i="5.96,296,1665471600"; 
   d="scan'208";a="322862907"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 02:14:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10578"; a="632403047"
X-IronPort-AV: E=Sophos;i="5.96,296,1665471600"; 
   d="scan'208";a="632403047"
Received: from jwilkin1-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.24.132])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 02:14:05 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Alexey Lukyachuk <skif@skif-web.ru>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@gmail.com>
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: dell wyse 3040 shutdown fix
In-Reply-To: <20230102165649.2b8e69e3@alexey-Swift-SF314-42>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221225184413.146916-1-skif@skif-web.ru>
 <20221225185507.149677-1-skif@skif-web.ru> <Y6sfvUJmrb73AeJh@intel.com>
 <20221227204003.6b0abe65@alexey-Swift-SF314-42>
 <20230102165649.2b8e69e3@alexey-Swift-SF314-42>
Date:   Tue, 03 Jan 2023 12:14:02 +0200
Message-ID: <87a630ylg5.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 02 Jan 2023, Alexey Lukyachuk <skif@skif-web.ru> wrote:
> Regarding to your question about fdo gitlab, I went to do it.

What's the URL for the issue?

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Graphics Center
