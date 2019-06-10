Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94DFB3B21D
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 11:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388236AbfFJJ3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 05:29:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:12719 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388216AbfFJJ3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 05:29:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 02:29:38 -0700
X-ExtLoop1: 1
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.150])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jun 2019 02:29:34 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Paul Wise <pabs3@bonedaddy.net>, Daniel Vetter <daniel@ffwll.ch>
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Ilpo =?utf-8?Q?J=C3=A4rvinen?= <ilpo.jarvinen@cs.helsinki.fi>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Harish Chegondi <harish.chegondi@intel.com>
Subject: Re: [PATCH 2/2] drm: add fallback override/firmware EDID modes workaround
In-Reply-To: <0667fc81810f2da5110c7da00963c93da90a6cd7.camel@bonedaddy.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20190607110513.12072-1-jani.nikula@intel.com> <20190607110513.12072-2-jani.nikula@intel.com> <20190607151021.GJ21222@phenom.ffwll.local> <24d1a13799ae7e0331ff668d9b170c4920d7d762.camel@bonedaddy.net> <0667fc81810f2da5110c7da00963c93da90a6cd7.camel@bonedaddy.net>
Date:   Mon, 10 Jun 2019 12:32:30 +0300
Message-ID: <87blz5zsy9.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 08 Jun 2019, Paul Wise <pabs3@bonedaddy.net> wrote:
> On Sat, 2019-06-08 at 13:10 +0800, Paul Wise wrote:
>
>> I've tested these two patches on top of Linux v5.2-rc3 and the EDID
>> override works correctly on an Intel Ironlake GPU with a monitor that
>> lost its EDID a while ago.
>
> While testing I noticed a couple of things:
>
> While everything the GUI is the correct resolution, GNOME is unable to
> identify the monitor vendor or model. This is a regression from the
> previous edid override functionality. It looks like this is because the
> edid file in /sys is not populated with the EDID override data.

Right, I've added a call to drm_connector_update_edid_property() in v2
to address this issue.

> I got a crash due to null pointer dereference at one point, I'll try to
> track down when this happens.

Can't think of why this would happen; the backtrace might offer clues.

Thanks for testing!

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Graphics Center
