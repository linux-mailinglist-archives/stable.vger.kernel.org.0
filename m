Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B040662F29C
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 11:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241601AbiKRKc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 05:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241540AbiKRKcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 05:32:55 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD5C922EE;
        Fri, 18 Nov 2022 02:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668767574; x=1700303574;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VprPqlQZldVRfkBs0m7Woq09gEfOOZdMpUS2KxmRKTo=;
  b=P8worfkLqfIjeVk+6mpPJhLDbPPLtWqxdV+puWiJYwRQ7Ke9RHMQDAbw
   eCseo660ZdPWiP0QVe0u7r2Fp6aAopm36CzkbHF/6cwf/XC+H4DeqpPrY
   dyff5Kkg+EQBc/+h7c71dgW0pxrlIjElwy6U1FqHa+QHEoNhIBBlZ5OcZ
   xoSQXaEstuC5maDMFKuQ7mzfiDfFtTqYT4FhWQLPn3UMxgHhXIJmg+bXw
   ulR/RJPc5ih2YJSQ7AGI6AZP45Tp1Ko+rj3FTgelmt+pyzKbI8W7/NKbC
   zdKXl+ryC2g8HPKzLtzXE1HFIMY7Ye+ZT3GaG+107u0KLhvyOTyHIMW/h
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="296471057"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="296471057"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 02:32:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="642465575"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="642465575"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga007.fm.intel.com with ESMTP; 18 Nov 2022 02:32:50 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ovyft-00DzrU-1g;
        Fri, 18 Nov 2022 12:32:45 +0200
Date:   Fri, 18 Nov 2022 12:32:45 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ferry Toth <ftoth@exalondelft.nl>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Ferry Toth <fntoth@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 0/2] usb: dwc3: core: defer probe on ulpi_read_id
 timeout
Message-ID: <Y3dfTUNKx5jkhL32@smile.fi.intel.com>
References: <20221117205411.11489-1-ftoth@exalondelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117205411.11489-1-ftoth@exalondelft.nl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 17, 2022 at 09:54:09PM +0100, Ferry Toth wrote:
> v3:
> - Correct commit message (Greg)

> - Add fixes (Greg)

Not sure what this means. I believe Greg asked for Fixes: tags in the
patch(es).

-- 
With Best Regards,
Andy Shevchenko


