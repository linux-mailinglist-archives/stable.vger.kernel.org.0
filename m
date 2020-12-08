Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3572D2FC8
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 17:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgLHQfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 11:35:52 -0500
Received: from mga12.intel.com ([192.55.52.136]:4687 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgLHQfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 11:35:52 -0500
IronPort-SDR: Crc814HfJWqm4bu2z1giovo3oJmSXYhNKYdvMoscH5dRYPtQhhVr3lyzVegFJZAx0XJ/3bMpcU
 7t/E+8oyEU/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9829"; a="153160512"
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="153160512"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2020 08:35:11 -0800
IronPort-SDR: LIn0azVBF/cQ5ac8xtFl/G6n0pLIRNxckAz+813KWPFNoYsmUGuofo5I/OVG5zVI/+K4cxPt6V
 sTHDAlLMw9IA==
X-IronPort-AV: E=Sophos;i="5.78,402,1599548400"; 
   d="scan'208";a="437440577"
Received: from mparames-mobl.amr.corp.intel.com (HELO [10.209.5.123]) ([10.209.5.123])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2020 08:35:10 -0800
Subject: Re: [PATCH 1/3] x86/resctrl: Move setting task's active CPU in a mask
 into helpers
To:     Borislav Petkov <bp@alien8.de>
Cc:     tglx@linutronix.de, fenghua.yu@intel.com, tony.luck@intel.com,
        kuo-lang.tseng@intel.com, shakeelb@google.com,
        valentin.schneider@arm.com, mingo@redhat.com, babu.moger@amd.com,
        james.morse@arm.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <cover.1607036601.git.reinette.chatre@intel.com>
 <77973e75a10bf7ef9b33c664544667deee9e1a8e.1607036601.git.reinette.chatre@intel.com>
 <20201207182912.GF20489@zn.tnic>
 <db6bea7e-b60b-2859-aa35-c3d2d5356eaa@intel.com>
 <20201208094907.GB27920@zn.tnic>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <fa4bb98e-0084-1c45-8999-352f1274b238@intel.com>
Date:   Tue, 8 Dec 2020 08:35:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201208094907.GB27920@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Borislav,

On 12/8/2020 1:49 AM, Borislav Petkov wrote:
> On Mon, Dec 07, 2020 at 01:24:51PM -0800, Reinette Chatre wrote:
>> How about:
>> "Move the setting of the CPU on which a task is running in a CPU mask into a
>> couple of helpers.
>>
>> There is no functional change. This is a preparatory change for the fix in
>> the following patch from where the Fixes tag is copied."
> 
> Almost. Just not call it a "following patch" because once this is
> applied, the following one might be a different one depending on the
> ordering a git command has requested. So a "later patch" would be
> probably better.

Indeed, will do. Thank you.

> 
>> Correct. I will add it. The addition to the commit message above aims to
>> explain a Fixes tag to a patch with no functional changes.
> 
> Yes but you need to tell the stable people somehow that this one is a
> prerequisite and that they should pick it up too.

Right. Thanks for guiding here.

> 
> Unless you can reorg your code this way that you don't need patch 1...

I think that the current organization, with patch 1 containing the 
preparatory work without functional changes, makes the fix in patch 2 
easier to review. I thus plan to keep the code organization as is while 
surely following your suggestion on how to support the stable team.

Thank you very much

Reinette

