Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FA06E2AFD
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 22:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjDNUMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 16:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDNUL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 16:11:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9EC86AC;
        Fri, 14 Apr 2023 13:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681503087; x=1713039087;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=txQBj+uPv9CCQ0lRxOJiNx7JcuLzKrZA9FMcmU4aqsc=;
  b=k3NTlKdXdHYYpd8tyVy5CS63h43tnnwnyVszcMYdfKZMBVTzYM8f0FXj
   F8kOivotSmq23Qdtr8vlIKvz3ED8Dqe1eelUfTE2A4IlU4q5319TsG9VZ
   JDYCdh0G6sWRA4lRD0dZvbJVROD2Wd2FP5x5pQDuz+fgwdn/JSjEpo3qI
   fiz4Ea3CuhADxpxZLMDSHChsOyltnoAjAa7FHKSIOum3wfNGaJ66O6XGm
   p6okHWMHxhJcEzkjHqJJrgHU2uCSYIuaD2UpiXAO0+ycdr8ErekfWEWxU
   2z3ANMD9u9odAQmluq5SYfmxVed3N2L9DX7iEukTGzNY42G0vAj2zZKsO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="409769095"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="409769095"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 13:11:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="833680251"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="833680251"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.22.80])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 13:11:15 -0700
Date:   Fri, 14 Apr 2023 13:11:13 -0700
From:   Alison Schofield <alison.schofield@intel.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-cxl@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] cxl/hdm: Fail upon detecting 0-sized decoders
Message-ID: <ZDmzYe1MAr2yC/GB@aschofie-mobl2>
References: <168149842935.792294.13212627946146993066.stgit@dwillia2-xfh.jf.intel.com>
 <168149843516.792294.11872242648319572632.stgit@dwillia2-xfh.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168149843516.792294.11872242648319572632.stgit@dwillia2-xfh.jf.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 14, 2023 at 11:53:55AM -0700, Dan Williams wrote:
> Decoders committed with 0-size lead to later crashes on shutdown as
> __cxl_dpa_release() assumes a 'struct resource' has been established in
> the in 'cxlds->dpa_res'. Just fail the driver load in this instance
> since there are deeper problems with the enumeration or the setup when
> this happens.
> 
> Fixes: 9c57cde0dcbd ("cxl/hdm: Enumerate allocated DPA")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>


Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> 
snip

