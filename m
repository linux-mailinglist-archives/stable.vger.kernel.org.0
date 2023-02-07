Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E58368D373
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 11:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjBGKCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 05:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbjBGKCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 05:02:24 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975C018176
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 02:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675764137; x=1707300137;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=TPH/kvH69+kVAtkKWuNA/RHAZrYRz8QemNJAveje0WA=;
  b=c9aJYKMkt1QKpeZDGDY1ssawjJEilRdQ02szi/HN0zR1aUpJ8OBiUSY3
   66nhe7pU+Ql/qrUZk8J4KKzLKTQRG/IOAFQKH+S+K1pdZLXv2eQYcf543
   pZdWlw4yqqx1AFJAQl8SM67RxmkkXOuo8Ss1Z1tRG5RXOjRzAb8StvBsw
   JRMuU+su/MhdQn0ogrhm4cKDMcQQP/KiKiYwgkP+9ULVWzV0kXqkBhuLX
   kQYrC0C97qP5QQF7mQ/vaSFsX534Nkz0C1B5ixZrz576ajcjGxoiSnYX5
   FWSzwgWJn6EjztRQXxxePugK1IFJ+PLzo/9MDjrEYACEGdfpPI4CKxtX6
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317486050"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="317486050"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 02:02:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="809462962"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="809462962"
Received: from wgleeso1-mobl1.ger.corp.intel.com (HELO [10.252.3.69]) ([10.252.3.69])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 02:02:15 -0800
Message-ID: <833c56f9-b438-41f7-b37a-be8c0c14a413@linux.intel.com>
Date:   Tue, 7 Feb 2023 12:02:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.1
Subject: Re: FAILED: patch "[PATCH] ASoC: SOF: keep prepare/unprepare widgets
 in sink path" failed to apply to 6.1-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>,
        yung-chuan.liao@linux.intel.com, broonie@kernel.org,
        pierre-louis.bossart@linux.intel.com, rander.wang@intel.com,
        ranjani.sridharan@linux.intel.com, stable@vger.kernel.org
References: <1675756334196160@kroah.com> <Y+IFtYzLerjSCGbF@kroah.com>
Content-Language: en-US
From:   =?UTF-8?Q?P=c3=a9ter_Ujfalusi?= <peter.ujfalusi@linux.intel.com>
In-Reply-To: <Y+IFtYzLerjSCGbF@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 07/02/2023 10:03, Greg KH wrote:
> On Tue, Feb 07, 2023 at 08:52:14AM +0100, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 6.1-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> Possible dependencies:
>>
>> cc755b4377b0 ("ASoC: SOF: keep prepare/unprepare widgets in sink path")
>> 0ad84b11f2f8 ("ASoC: SOF: sof-audio: skip prepare/unprepare if swidget is NULL")
>> 7d2a67e02549 ("ASoC: SOF: sof-audio: unprepare when swidget->use_count > 0")
> 
> Oops, nevermind, I got this to work, sorry for the noise.

I was about to take a look at this to assist you.
Sorry for being late, I guess all is good now?

-- 
Péter
