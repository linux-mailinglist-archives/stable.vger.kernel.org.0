Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F154511769
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 14:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbiD0MpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 08:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbiD0MpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 08:45:23 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486B52ED51
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 05:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651063333; x=1682599333;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7BAMJHEu/uZpWQqW4zjmnovM1Ybd5i/f2rUSryqnHoU=;
  b=lJeWsA4wtFqTNJzncMt2rqJDX2+MoYcU0Fi6otCrKhNUfwObj/D8AP1C
   t1Xau55j3VGvQtJBhRHe8beklBNEvuIQbgOs2V31SEvb+gmiFqRLf0cao
   Etsk7eSQv4VhkHuJ6vcxFM2SlJ8dnt78kdiPLvG91gk4xQgKSI1DM25pQ
   oZ7+MqAla/TlE6meBzptt/2e2ySnqZYN/51flpXoUflfgqM318MX1zpf8
   q0CuogArkA+v2pB8Zy9utC9U8Id9fYrzHY7c+efpNN8S+HWtBq6Zd3msi
   6PpSg8nJCFMrZBAEJ0UEoTl6a8VCKqbwdrSe0VnQN9EVt/jrSx2HPu4z/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="247845185"
X-IronPort-AV: E=Sophos;i="5.90,293,1643702400"; 
   d="scan'208";a="247845185"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 05:42:12 -0700
X-IronPort-AV: E=Sophos;i="5.90,293,1643702400"; 
   d="scan'208";a="580573257"
Received: from brutrata-mobl.ger.corp.intel.com (HELO intel.com) ([10.252.33.100])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 05:42:11 -0700
Date:   Wed, 27 Apr 2022 14:42:08 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Anusha Srivatsa <anusha.srivatsa@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/dmc: Add MMIO range restrictions
Message-ID: <Ymk6ICgcRio8zE4g@intel.intel>
References: <20220427003509.267683-1-anusha.srivatsa@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427003509.267683-1-anusha.srivatsa@intel.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[...]

> +	if (!dmc_mmio_addr_sanity_check(dmc, mmioaddr, mmio_count, dmc_header->header_ver, dmc_id))
> +		drm_err(&i915->drm, "DMC firmware has Wrong MMIO Addresses\n");
> +		return 0;
> +

mh? :)
