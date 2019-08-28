Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 770B7A00CC
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 13:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfH1Lhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 07:37:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:34917 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbfH1Lhn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 07:37:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 04:37:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="scan'208";a="197536638"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.157])
  by fmsmga001.fm.intel.com with SMTP; 28 Aug 2019 04:37:38 -0700
Received: by lahna (sSMTP sendmail emulation); Wed, 28 Aug 2019 14:37:38 +0300
Date:   Wed, 28 Aug 2019 14:37:38 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org, Daniel Drake <drake@endlessm.com>,
        Ian W MORRISON <ianwmorrison@gmail.com>
Subject: Re: [PATCH v2] gpiolib: acpi: Add
 gpiolib_acpi_run_edge_events_on_boot option and blacklist
Message-ID: <20190828113738.GW3177@lahna.fi.intel.com>
References: <20190827202835.213456-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827202835.213456-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 10:28:35PM +0200, Hans de Goede wrote:
> Another day; another DSDT bug we need to workaround...
> 
> Since commit ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events
> at least once on boot") we call _AEI edge handlers at boot.
> 
> In some rare cases this causes problems. One example of this is the Minix
> Neo Z83-4 mini PC, this device has a clear DSDT bug where it has some copy
> and pasted code for dealing with Micro USB-B connector host/device role
> switching, while the mini PC does not even have a micro-USB connector.
> This code, which should not be there, messes with the DDC data pin from
> the HDMI connector (switching it to GPIO mode) breaking HDMI support.
> 
> To avoid problems like this, this commit adds a new
> gpiolib_acpi.run_edge_events_on_boot kernel commandline option, which
> allows disabling the running of _AEI edge event handlers at boot.
> 
> The default value is -1/auto which uses a DMI based blacklist, the initial
> version of this blacklist contains the Neo Z83-4 fixing the HDMI breakage.
> 
> Cc: stable@vger.kernel.org
> Cc: Daniel Drake <drake@endlessm.com>
> Cc: Ian W MORRISON <ianwmorrison@gmail.com>
> Reported-by: Ian W MORRISON <ianwmorrison@gmail.com>
> Suggested-by: Ian W MORRISON <ianwmorrison@gmail.com>
> Fixes: ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events at least once on boot")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
