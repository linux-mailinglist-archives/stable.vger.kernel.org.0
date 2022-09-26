Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633615EAC03
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbiIZQGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235201AbiIZQFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:05:50 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4305BC9946;
        Mon, 26 Sep 2022 07:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664204010; x=1695740010;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YnYP1DFOPSmCyCXerirl1obZPEKjXPiA+/DOpoVk/+U=;
  b=TbzsQOjhutV0P9XHbaYG8sq3Q+w9LBksepHa4FUMHNR+RJivua5xsZIJ
   u+vTFukQECi6clRyVk+/Y/F388JdTD806LmyVRdErN7v0b/aebyMvey7e
   KiMk5j7XFgBf3kxehlvBGVQenp1jkWeIP3AAyr3DIfRmUIlvkFoTPU4S8
   w8TnkXuXVJ+/0D1m7VX55mKbUiGLzqCzqaQfcoJDZwTZHZQNflydaHVeU
   PObrgei2jrBS4iowdRBA7bFgtxp/VlsfjHoAUi86L8kNUz9gy/l10+Zgc
   KXhqL6SrGbq7UG1Jkl8iFcokhp2ewPtbcI2zuPjxs++DtP8mK1BKPZEie
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="327398685"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="327398685"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 07:53:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="621083508"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="621083508"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 26 Sep 2022 07:53:03 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id CD703101; Mon, 26 Sep 2022 17:53:21 +0300 (EEST)
Date:   Mon, 26 Sep 2022 17:53:21 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mehta Sanju <Sanju.Mehta@amd.com>, stable@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] thunderbolt: Explicitly enable lane adapter hotplug
 events at startup
Message-ID: <YzG84WEuVdXxclJB@black.fi.intel.com>
References: <20220926143351.11483-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926143351.11483-1-mario.limonciello@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mario,

On Mon, Sep 26, 2022 at 09:33:50AM -0500, Mario Limonciello wrote:
> Software that has run before the USB4 CM in Linux runs may have disabled
> hotplug events for a given lane adapter.
> 
> Other CMs such as that one distributed with Windows 11 will enable hotplug
> events. Do the same thing in the Linux CM which fixes hotplug events on
> "AMD Pink Sardine".
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Looks good to me now. Since we are pretty late in the rc and this is not
trivial fix anymore, would it be OK for you if I apply this to my next
branch with stable tag? Then it gets slightly more exposure before it
ends up in any of the stable trees.
