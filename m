Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208B12F1EB1
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 20:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbhAKTKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 14:10:49 -0500
Received: from mga06.intel.com ([134.134.136.31]:4752 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbhAKTKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 14:10:49 -0500
IronPort-SDR: kG12SknC+H94zGH4pMsACZoJBK6brrZ0QPzTpck5PgFMkzUjYbAQjfpi1p/iSY00cbs1CpYNG2
 AF4IsVHfi1iA==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="239461080"
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="239461080"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 11:10:08 -0800
IronPort-SDR: 3PVDINbffg6RI4QqpjO2kLpON+bYM7pQn5R7wt/AQ/7FYNa/P27zjcaxxQ9JhJvRDjwsWRBZOz
 d/vEDYKw7zjw==
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="381116787"
Received: from libresli-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.207.39])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 11:10:06 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     lyude@redhat.com, intel-gfx@lists.freedesktop.org
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/backlight: fix CPU mode backlight takeover on LPT
In-Reply-To: <875z43yemi.fsf@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20210108152841.6944-1-jani.nikula@intel.com> <e5fd2290fae25fc1167ea6fe91e7060840d0db47.camel@redhat.com> <875z43yemi.fsf@intel.com>
Date:   Mon, 11 Jan 2021 21:10:03 +0200
Message-ID: <87bldvwar8.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jan 2021, Jani Nikula <jani.nikula@intel.com> wrote:
> On Fri, 08 Jan 2021, Lyude Paul <lyude@redhat.com> wrote:
>> Reviewed-by: Lyude Paul <lyude@redhat.com>
>>
>> Let me know when you've pushed this upstream and I'll go ahead and send out a
>> rebased version of my backlight series.
>
> Pushed, thanks for the review.
>
> I'm hoping to do more review of the series today, so please hold off on
> actually sending the rebased version for a bit longer.

Done, go ahead!

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
