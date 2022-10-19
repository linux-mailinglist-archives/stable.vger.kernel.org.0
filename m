Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45104604D89
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 18:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiJSQjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 12:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiJSQjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 12:39:11 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174CC1C97CC;
        Wed, 19 Oct 2022 09:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666197548; x=1697733548;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=RzoV/sXA1lnNSRuZHUDeu2oqDvaDnWm7/KZazZklHHw=;
  b=Uf+bp7ZJ/VoI+Qrcx2yr0vn/JdEwxFg6gy9dZ9jr8eoefU5BUyoOMp2X
   BurCtf0XIX32nSAfDUqpPBDhuRaM3MEJrEpam+3xhuWxT/RHtT04mwvTc
   Y/2BJ+Tx9cqv5VHwzd0x0R1Prln8g0Kk/3+ApT9dvEGfgIgHr4EG26nty
   tiGYBm7W3fIfsycD5wRcd/PAsfgxFjea57xiMBDWummqXJwb6EiSFDiGQ
   lzFCCAdwrHKRI4MzhwqRscyTieB3Id1e4yFU9qcLe+AeDp7nbGlt/Vy8a
   i3g8TvvZcYLnU4yG7Pxd6FH+7tsmAqqYKhYdtiaKhpw2DQ1rNHFUtCLVZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="286186489"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="286186489"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 09:39:07 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="629339629"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="629339629"
Received: from mosermix-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.50.2])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 09:39:05 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        ville.syrjala@linux.intel.com
Subject: Re: v5.19 & v6.0 stable backport request
In-Reply-To: <Y0+h++6NReFAZhrv@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <87k04xiedr.fsf@intel.com> <Y0+fex0i0vmBL6QX@kroah.com>
 <Y0+h++6NReFAZhrv@kroah.com>
Date:   Wed, 19 Oct 2022 19:39:02 +0300
Message-ID: <87pmenhiop.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Oct 2022, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Wed, Oct 19, 2022 at 08:55:55AM +0200, Greg Kroah-Hartman wrote:
>> On Tue, Oct 18, 2022 at 02:02:08PM +0300, Jani Nikula wrote:
>> > 
>> > Hello stable team, please backport these two commits to stable kernels
>> > v5.19 and v6.0:
>> > 
>> > 4e78d6023c15 ("drm/i915/bios: Validate fp_timing terminator presence")
>> 
>> Does not apply to 5.19.y, can you provide a working backport?
>> 
>> > d3a7051841f0 ("drm/i915/bios: Use hardcoded fp_timing size for generating LFP data pointers")
>> 
>> Queued up to both trees now, thanks.
>
> No, wait, that breaks the build!
>
> How did you test this?  I'm dropping both of these now.
>
> Please resubmit a set of tested patches if you wish to have them applied
> to the tree.  These were obviously not even attempted, which just wastes
> all of our time :(

Apologies, misunderstanding on my part about them being applicable
as-is.

Ville has provided the backports. Thanks!


BR,
Jani.

-- 
Jani Nikula, Intel Open Source Graphics Center
