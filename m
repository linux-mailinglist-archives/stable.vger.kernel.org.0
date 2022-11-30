Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B3163E551
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 00:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiK3XSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 18:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiK3XR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 18:17:27 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBE397921
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 15:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669849925; x=1701385925;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/ba6N6sJhkZs3RsBTFFGU0cA0NJsF0/wqYAnxprauYE=;
  b=T0fhbkCiJPslXaoga2jVJdvAZhEs8JZHwsCs7wFAcLa3CDCUUOkZRJEU
   ij4BLoYb1KK4Kwwh9MvVOCMX2cyImVVpzC8UngrVuK7VeFAU1wErF2GdF
   VF6eWp4dj77MhFpibR7zVuFdNLxiVj98Jduzaea5u3gzQkcCjkgZA1r0o
   uDqrpahZqkgTFJn3SNuGQvEgF6z7EPgsEgSxzPQKpYZbjclko+iCmCZTU
   mToe29U7AN9yg06MJLJEdOcUPeJTutddpc23nKDz92B2vOZ0/OtNefRxJ
   pJQEcB2B+amYC7+2EI0ATFmkRfiL9PmPFmStCJv5ii97sdy7pLt+WtZab
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="401809431"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="401809431"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 15:11:11 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="973289725"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="973289725"
Received: from subhadee-mobl.amr.corp.intel.com (HELO desk) ([10.251.3.232])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 15:11:11 -0800
Date:   Wed, 30 Nov 2022 15:11:09 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     bp@suse.de, dave.hansen@linux.intel.com, hdegoede@redhat.com,
        rafael.j.wysocki@intel.com, stable@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/pm: Add enumeration check before spec
 MSRs save/restore" failed to apply to 5.10-stable tree
Message-ID: <20221130231109.ohdusribjld4t4f5@desk>
References: <1669811516103161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1669811516103161@kroah.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 30, 2022 at 01:31:56PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.10-stable tree.

Patch is applying cleanly on v5.10.156. Is it not where it should be
applied?

Same observation for failed patch on 5.4.
