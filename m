Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CE2338D2C
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhCLMgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:36:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:10876 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhCLMgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 07:36:31 -0500
IronPort-SDR: BJP4qlnYgXDkCIaAa8PHGgnMzZw+Mg255LwYhs49sJOA+JPxzWwkIxff4QOL5j/FzSgr9sEqo3
 ArFLEODmbTVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="175948534"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="175948534"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:36:30 -0800
IronPort-SDR: jUCEUWVTlri38/0oOYarcpO2Ka0ZFyGtzWANG5tyYz27TngpRN89/DxxMYLYRLVhl6Na75Y8ne
 LnYOXHlUSOZA==
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="370887147"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:36:29 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lKh1m-00Bqmh-N3; Fri, 12 Mar 2021 14:36:26 +0200
Date:   Fri, 12 Mar 2021 14:36:26 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     linus.walleij@linaro.org, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpio: pca953x: Set IRQ type when handle
 Intel Galileo Gen 2" failed to apply to 5.4-stable tree
Message-ID: <YEtgSo8tWfIdNDUr@smile.fi.intel.com>
References: <1615552026254228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615552026254228@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 01:27:06PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Same here, it applies clean, compilation requires patch in the middle [1].

[1]: https://lore.kernel.org/stable/20210312121542.67389-1-andriy.shevchenko@linux.intel.com/T/#u

-- 
With Best Regards,
Andy Shevchenko


