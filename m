Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6459D6BA374
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 00:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjCNXN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 19:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbjCNXNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 19:13:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2A84C28
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 16:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678835603; x=1710371603;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mwl78McMLb3TAbzLAJbgo3w6GjlL3Iab3mFhiDFIKIY=;
  b=Th0hfUCYkJ44UdlQwAWXNVzOWPkXEaZ09QYMSiZ5WROritxRDTdP4PRS
   CFBHAeWsJBh74R957ElaqMca522yEZpd2MCkylanjRGryMuomI7wsqeIQ
   2pdYVx//pajboRAVUu7kUaHv7/ZCGbBdW9ft1YpBeN7x8UxzDqFHyHTOf
   CWMISj5owFPabPoHuILoquQbk0q4/YJDzZd1obo76fvMSvDKPWUW94/Nl
   AwHhJ5mxKReFHP1hmmEqRqkw3cnu8PSfwMQh9Wc47AJUlrjXXUvf6Rujq
   Nq/xbX5EgXX3rqiF/dVVNUUsStdHhPe8a3tuhCRrBaTdZs98wnx5+aEvN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="400145601"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="400145601"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 16:13:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="711698172"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="711698172"
Received: from ranerica-svr.sc.intel.com ([172.25.110.23])
  by orsmga001.jf.intel.com with ESMTP; 14 Mar 2023 16:13:21 -0700
Date:   Tue, 14 Mar 2023 16:23:30 -0700
From:   Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To:     x86@kernel.org
Cc:     Ricardo Neri <ricardo.neri@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Chen Yu <yu.c.chen@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/cacheinfo: Define per-CPU num_cache_leaves
Message-ID: <20230314232330.GA30287@ranerica-svr.sc.intel.com>
References: <20230314231519.30119-1-ricardo.neri-calderon@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314231519.30119-1-ricardo.neri-calderon@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 14, 2023 at 04:15:19PM -0700, Ricardo Neri wrote:
> Make num_cache_leaves a per-CPU variable. Otherwise, populate_cache_
> leaves() fails on systems with asymmetric number of subleaves in CPUID
> leaf 0x4. Intel Meteor Lake is an example of such a system.

Please disregard this patch sent privately by mistake. I resent the same
patch publicly. I apologize for the noise.

Thanks and BR,
Ricardo
