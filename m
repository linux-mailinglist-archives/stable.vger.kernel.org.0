Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742B75A713B
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 01:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiH3XAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 19:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiH3XAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 19:00:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9212AE0D;
        Tue, 30 Aug 2022 16:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661900410; x=1693436410;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=snlO9+PIZi6VhvlaPIhpKNuiJA6J1a/AssLGfCUxwkc=;
  b=Tr2TEF+h8SYAqPh+AytLRBh4xrWP7sCLEYRXKmyHT25i4kZ44K6NIW1l
   PyCQsrQVLuU0oK4PRquYXRyXlE4z0R7xMlwZoeHOQXeZIMfe9fqLaZfrc
   1W+TZ7oHAqwh5OW1O+fRbIhqDgBIKQHJK55jmdiqUmr6DwvAzozaNsVnS
   6exIqnxj/tE4tUjfkkp7Ktd1c1TfXPMmc/yaH7lj+g97pXdOrMSNmEaFT
   kC0RlkQE/bPlNwMT+MfJCqMLOuPDd5ODc7tOmQH+X0AE5etqxFgA8yQMd
   dsLpiCsLzkzkZYwkVi1y+8nDoT0sPKp0q6lNzsDxSjb80vlSZTVbk4yMC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295329341"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="295329341"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 16:00:10 -0700
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="701174958"
Received: from skanpuri-mobl1.amr.corp.intel.com (HELO desk) ([10.212.18.137])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 16:00:10 -0700
Date:   Tue, 30 Aug 2022 16:00:08 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, andrew.cooper3@citrix.com, bp@suse.de,
        tony.luck@intel.com, antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14 1/2] x86/cpu: Add Tiger Lake to Intel family
Message-ID: <20220830230008.uvkdp2r54uexpwbz@desk>
References: <ec31e22b4f3b079d0da6b60f5899ffcd79d9bea0.1661899117.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec31e22b4f3b079d0da6b60f5899ffcd79d9bea0.1661899117.git.pawan.kumar.gupta@linux.intel.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 03:43:25PM -0700, Pawan Gupta wrote:
> From: Gayatri Kammela <gayatri.kammela@intel.com>
> 
> [ Upstream commit 6e1c32c5dbb4b90eea8f964c2869d0bde050dbe0 ]
> 
> Add the model numbers/CPUIDs of Tiger Lake mobile and desktop to the
> Intel family.
> 
> Suggested-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rahul Tanwar <rahul.tanwar@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lkml.kernel.org/r/20190905193020.14707-2-tony.luck@intel.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

I just realized that my sign-off was missing. I can resend the patch if
required.

Thanks,
Pawan
