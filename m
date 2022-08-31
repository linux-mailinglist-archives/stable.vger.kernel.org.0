Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1525A7C77
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 13:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiHaLue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 07:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiHaLuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 07:50:32 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8207FC00FB;
        Wed, 31 Aug 2022 04:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661946630; x=1693482630;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6Z4iCYPaLyNFfr0BTtbO3qkVhAStjkbrGYsE40CIfr0=;
  b=Rpja3NiaQXYlApAvJInxPx7r05UIr8TaqtcCbMVsJDmLDQg3g/TSx1X3
   agUSdRll9BT9RmJZj7G0JeXyRxny7L+4bQepDKRs99YGlwnLCH4yGfgTr
   d7r7moamzfETTPG9wYb3RxSSn/obP3AJEMTvqMzl2R5PGShNo62+k7bVL
   HBYJ9mB2WIJOmhIk67xMxAdvvCTzXEf6Tt5S2Giles47FO/ZVahcn2RU9
   2DDmwrSseEW4OCbtXCW9Ioa/PjQ4GNPC9IzH5mXlUtw7uWBv/osfOYLh8
   sMrVI61o62BZ+bgwfVkfUsr9WXcERpuNKoRZaaKyZEQ0WPcE0eR/BZuxv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="275831363"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="275831363"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 04:50:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="738081709"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 04:50:28 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oTMEk-006MKj-0c;
        Wed, 31 Aug 2022 14:50:26 +0300
Date:   Wed, 31 Aug 2022 14:50:25 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jean Delvare <jdelvare@suse.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 01/33] firmware: dmi: Use the proper
 accessor for the version field
Message-ID: <Yw9LAbjrzoseziT7@smile.fi.intel.com>
References: <20220830171825.580603-1-sashal@kernel.org>
 <20220830233237.0c08cc7e@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830233237.0c08cc7e@endymion.delvare>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 11:32:37PM +0200, Jean Delvare wrote:
> On Tue, 30 Aug 2022 13:17:52 -0400, Sasha Levin wrote:
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > 
> > [ Upstream commit d2139dfca361a1f5bfc4d4a23455b1a409a69cd4 ]
> > 
> > The byte at offset 6 represents length. Don't take it and drop it
> > immediately by using proper accessor, i.e. get_unaligned_be24().
> > 
> > [JD: Change the subject to something less frightening]
> 
> Nack. This is NOT a bug fix, there's simply no reason to backport
> this to stable kernel trees.

Agree.

-- 
With Best Regards,
Andy Shevchenko


