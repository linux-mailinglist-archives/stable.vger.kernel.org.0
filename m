Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905955E68C1
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 18:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiIVQou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 12:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiIVQos (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 12:44:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25A92E69E;
        Thu, 22 Sep 2022 09:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663865085; x=1695401085;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4uE7sNidb9Paf5GPXLz1sBYwKBlJQu6D2h8Uty+X/i4=;
  b=jDdvhHkc0pAfJfuJ65xk/JisdibVo/xwx03LdVuZQZD8PDhrXLe3x8UI
   ipo+KEBUUriuN9iAlB07kmyTSByTYGDDy32jSr3r+13QBc87eheLbcs7e
   k2S9fL0KQNslxwRmw/s0lagzOSU2u0GL5AvR2i0lV09/1Okb6etrog2kU
   WRe67Qirc147hpszzcaQZuH/5PSYhgkHD5A4cZgs7ncfv33SQKcjZe23r
   mjXHnrLIYHJdBkpwsgC0Vwq0e3cT/PhD9210LrwiluApDzZ3zKvi4+C5K
   v6zIfMV8TzAg4RzQS8fNHLxzA0qvM1eN2052FxG7D2x4+4caQmLCUdxNn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="301205760"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="301205760"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 09:44:45 -0700
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="682292605"
Received: from sponnura-mobl1.amr.corp.intel.com (HELO [10.209.58.200]) ([10.209.58.200])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 09:44:43 -0700
Message-ID: <20e78a49-25df-c83d-842e-1d624655cfd7@intel.com>
Date:   Thu, 22 Sep 2022 09:44:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Content-Language: en-US
To:     K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-kernel@vger.kernel.org
Cc:     rafael@kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, dave.hansen@linux.intel.com,
        bp@alien8.de, tglx@linutronix.de, andi@lisas.de, puwen@hygon.cn,
        mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220921063638.2489-1-kprateek.nayak@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/22 23:36, K Prateek Nayak wrote:
> Cc: stable@vger.kernel.org
> Cc: regressions@lists.linux.dev

*Is* this a regression?
