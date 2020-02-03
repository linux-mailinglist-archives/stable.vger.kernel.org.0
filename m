Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07DDC150341
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 10:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgBCJTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 04:19:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:7704 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbgBCJTN (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 3 Feb 2020 04:19:13 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 01:19:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,397,1574150400"; 
   d="scan'208";a="230952934"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga003.jf.intel.com with ESMTP; 03 Feb 2020 01:19:11 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1iyXsv-0004L7-68; Mon, 03 Feb 2020 11:19:13 +0200
Date:   Mon, 3 Feb 2020 11:19:13 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, leonard.crestez@nxp.com,
        lorenzo.bianconi83@gmail.com
Subject: Re: FAILED: patch "[PATCH] iio: st_gyro: Correct data for LSM9DS0
 gyro" failed to apply to 4.9-stable tree
Message-ID: <20200203091913.GW32742@smile.fi.intel.com>
References: <158037876398197@kroah.com>
 <20200203005842.GH1732@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203005842.GH1732@sasha-vm>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 02, 2020 at 07:58:42PM -0500, Sasha Levin wrote:
> On Thu, Jan 30, 2020 at 11:06:03AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From e825070f697abddf3b9b0a675ed0ff1884114818 Mon Sep 17 00:00:00 2001
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Date: Tue, 17 Dec 2019 19:10:38 +0200
> > Subject: [PATCH] iio: st_gyro: Correct data for LSM9DS0 gyro
> > 
> > The commit 41c128cb25ce ("iio: st_gyro: Add lsm9ds0-gyro support")
> > assumes that gyro in LSM9DS0 is the same as others with 0xd4 WAI ID,
> > but datasheet tells slight different story, i.e. the first scale factor
> > for the chip is 245 dps, and not 250 dps.
> > 
> > Correct this by introducing a separate settings for LSM9DS0.
> > 
> > Fixes: 41c128cb25ce ("iio: st_gyro: Add lsm9ds0-gyro support")
> > Depends-on: 45a4e4220bf4 ("iio: gyro: st_gyro: fix L3GD20H support")
> > Cc: Leonard Crestez <leonard.crestez@nxp.com>
> > Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> > Cc: <Stable@vger.kernel.org>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> I've also grabbed d8594fa22a3f ("iio: gyro: st_gyro: inline per-sensor
> data") for 4.9 to resolve this.

Thank you, Sasha!

-- 
With Best Regards,
Andy Shevchenko


