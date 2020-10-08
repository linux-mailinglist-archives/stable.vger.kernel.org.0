Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8313F28781A
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 17:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgJHPwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 11:52:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:33883 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgJHPw3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Oct 2020 11:52:29 -0400
IronPort-SDR: a4wtjXxrxbj1GpCoB336C2yNA0ZKc0mi8o6jbE0IEPDBNI867VSMEbHYey6wFQ+G/VDPm87mZE
 Ax0cP2BjNvDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="161898962"
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="161898962"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 08:52:28 -0700
IronPort-SDR: y0QEnMHtriMeI1ZXkk7Frx1RjJBYLCw4cRrfTs9QnYaZ7vD7PQJmgJQpP6O/SWd5vCg8Me2Spi
 HfTPSen0a5Hw==
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="528544409"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 08:52:24 -0700
Received: by lahna (sSMTP sendmail emulation); Thu, 08 Oct 2020 18:52:22 +0300
Date:   Thu, 8 Oct 2020 18:52:22 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-gpio@vger.kernel.org,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>
Subject: Re: [PATCH v2] pinctrl: cherryview: Ensure _REG(ACPI_ADR_SPACE_GPIO,
 1) gets called
Message-ID: <20201008155222.GW2495@lahna.fi.intel.com>
References: <20200504145957.480418-1-hdegoede@redhat.com>
 <20200506064057.GU487496@lahna.fi.intel.com>
 <f7ebb693-94ec-fd9f-c0a8-cfe8f9d4e9bf@redhat.com>
 <20200507123025.GR487496@lahna.fi.intel.com>
 <3d7ce79f-6157-8ae0-dae9-ebc940120487@redhat.com>
 <20201008144450.GU2495@lahna.fi.intel.com>
 <1925077c-dc47-bc93-6f7b-b8fdbd6efcd8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1925077c-dc47-bc93-6f7b-b8fdbd6efcd8@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 08, 2020 at 05:37:10PM +0200, Hans de Goede wrote:
> Mika, do you have input wrt always calling _REG for just the
> GpioIoOpRegion type (on top of the existing EC exception) vs
> just simply always calling it for all all/more OpRegion types ?

IMO it is safer to call it only for GPIO (GpioIoOpRegion) now.
