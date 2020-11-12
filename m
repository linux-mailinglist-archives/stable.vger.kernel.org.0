Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7298D2B01C8
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 10:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbgKLJLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 04:11:08 -0500
Received: from mga06.intel.com ([134.134.136.31]:36665 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbgKLJLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 04:11:07 -0500
IronPort-SDR: SydBFi2Yn+4QWf9K2eifNSsvl9k+192XT/cTT0p7jP9nyVtw/NG/1Q8ohrR+fOOnqlJQYZCFKh
 3xVU/N//dDOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="231900731"
X-IronPort-AV: E=Sophos;i="5.77,471,1596524400"; 
   d="scan'208";a="231900731"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 01:11:05 -0800
IronPort-SDR: XbZOsfG3/k/idtcNTrwCREXO3/DZNHsva/VDOwO8FZwAjBMha6GtRQKHIG/SO4UU8+Jz2svoza
 09kwZ8JJUfeA==
X-IronPort-AV: E=Sophos;i="5.77,471,1596524400"; 
   d="scan'208";a="542187125"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 01:11:03 -0800
Received: by lahna (sSMTP sendmail emulation); Thu, 12 Nov 2020 11:11:00 +0200
Date:   Thu, 12 Nov 2020 11:11:00 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Evan Green <evgreen@chromium.org>
Cc:     Andy Shevchenko <andy@kernel.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: intel: Fix Jasperlake HOSTSW_OWN offset
Message-ID: <20201112091100.GZ2495@lahna.fi.intel.com>
References: <20201111151650.v2.1.I54a30ec0a7eb1f1b791dc9d08d5e8416a1e8e1ef@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111151650.v2.1.I54a30ec0a7eb1f1b791dc9d08d5e8416a1e8e1ef@changeid>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 11, 2020 at 03:17:28PM -0800, Evan Green wrote:
> GPIOs that attempt to use interrupts get thwarted with a message like:
> "pin 161 cannot be used as IRQ" (for instance with SD_CD). This is because
> the HOSTSW_OWN offset is incorrect, so every GPIO looks like it's
> owned by ACPI.
> 
> Fixes: e278dcb7048b1 ("pinctrl: intel: Add Intel Jasper Lake pin controller support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Evan Green <evgreen@chromium.org>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
