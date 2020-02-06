Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C753F1546E0
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 15:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgBFOyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 09:54:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:15814 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgBFOyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 09:54:49 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 06:53:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="255108112"
Received: from dgbrowne-mobl.ger.corp.intel.com (HELO localhost) ([10.252.14.106])
  by fmsmga004.fm.intel.com with ESMTP; 06 Feb 2020 06:53:28 -0800
Date:   Thu, 6 Feb 2020 16:53:28 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Alexander Steffen <Alexander.Steffen@infineon.com>
Cc:     linux-integrity@vger.kernel.org,
        Andrey Pronin <apronin@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Stuebner <heiko@sntech.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm: Revert tpm_tis_spi_mod.ko to tpm_tis_spi.ko.
Message-ID: <20200206145328.GB8148@linux.intel.com>
References: <20200205203818.4679-1-jarkko.sakkinen@linux.intel.com>
 <f865a01e-83a1-b0e2-a9ca-45f874d86b4c@infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f865a01e-83a1-b0e2-a9ca-45f874d86b4c@infineon.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 01:54:11PM +0100, Alexander Steffen wrote:
> Works for me, thank you very much :)

Apologies for having bad judgement with this in the first place :-)

I'll send another PR for the next kernel release as soon as v5.6-rc1 is
out.

/Jarkko
