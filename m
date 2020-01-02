Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0ECC12E48F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 10:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgABJri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 04:47:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:28471 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgABJrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 04:47:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2020 01:47:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,386,1571727600"; 
   d="scan'208";a="224734068"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 02 Jan 2020 01:47:34 -0800
Received: by lahna (sSMTP sendmail emulation); Thu, 02 Jan 2020 11:47:34 +0200
Date:   Thu, 2 Jan 2020 11:47:34 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Boyan Ding <boyan.j.ding@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: sunrisepoint: Add missing Interrupt Status
 register offset
Message-ID: <20200102094734.GD465886@lahna.fi.intel.com>
References: <20200101204120.5873-1-boyan.j.ding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200101204120.5873-1-boyan.j.ding@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 01, 2020 at 12:41:20PM -0800, Boyan Ding wrote:
> Commit 179e5a6114cc ("pinctrl: intel: Remove default Interrupt Status
> offset") removes default interrupt status offset of GPIO controllers, 
> with previous commits explicitly providing the previously default
> offsets. However, the is_offset value in SPTH_COMMUNITY is missing,
> preventing related irq from being properly detected and handled.
> 
> Fixes: f702e0b93cdb ("pinctrl: sunrisepoint: Provide Interrupt Status register offset")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=205745
> Cc: stable@vger.kernel.org
> Signed-off-by: Boyan Ding <boyan.j.ding@gmail.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
