Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3C129EA3D
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 12:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgJ2LNJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 29 Oct 2020 07:13:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:64167 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726789AbgJ2LNI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 07:13:08 -0400
IronPort-SDR: rNhyr2ex4RG+8+e4O9RwW1XDxhKFKojmsYrKIHuPxPJ8d4OC5empL0HTp0cSg6KfqaGkkj+Hdb
 C356Qs+RL4MA==
X-IronPort-AV: E=McAfee;i="6000,8403,9788"; a="164915602"
X-IronPort-AV: E=Sophos;i="5.77,429,1596524400"; 
   d="scan'208";a="164915602"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 04:13:08 -0700
IronPort-SDR: kOURXJIUux9fb2F1N/52IyY64/0hjAb65lkeFEZElsUy8+mvr2bTIFDzWkrQmVbXzVR+bGFFrM
 rPAEUDisUDdg==
X-IronPort-AV: E=Sophos;i="5.77,429,1596524400"; 
   d="scan'208";a="526697289"
Received: from rsexton-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.5.42])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 04:13:04 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     linux-fbdev@vger.kernel.org, b.zolnierkie@samsung.com,
        daniel.vetter@ffwll.ch, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gustavoars@kernel.org,
        dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        akpm@linux-foundation.org, rppt@kernel.org
Subject: Re: [PATCH 1/1] video: fbdev: fix divide error in fbcon_switch
In-Reply-To: <20201029110326.GC3840801@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20201021235758.59993-1-saeed.mirzamohammadi@oracle.com> <ad87c5c1-061d-8a81-7b2c-43a8687a464f@suse.de> <3294C797-1BBB-4410-812B-4A4BB813F002@oracle.com> <20201027062217.GE206502@kroah.com> <2DA9AE6D-93D6-4142-9FC4-EEACB92B7203@oracle.com> <20201029110326.GC3840801@kroah.com>
Date:   Thu, 29 Oct 2020 13:13:01 +0200
Message-ID: <874kmdi8ua.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Oct 2020, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Oct 27, 2020 at 10:12:49AM -0700, Saeed Mirzamohammadi wrote:
>> Hi Greg,
>> 
>> Sorry for the confusion. I’m requesting stable maintainers to cherry-pick this patch into stable 5.4 and 5.8.
>> commit cc07057c7c88fb8eff3b1991131ded0f0bcfa7e3
>> Author: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
>> Date:   Wed Oct 21 16:57:58 2020 -0700
>> 
>>     video: fbdev: fix divide error in fbcon_switch
>
> I do not see that commit in Linus's tree, do you?

It's in drm-misc-next, IIUC heading for Linus' tree in the next merge
window in 6-8 weeks. Which is to say this should probably have been
applied to drm-misc-fixes branch heading for v5.10-rcX, with a Cc:
stable tag, to begin with.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
