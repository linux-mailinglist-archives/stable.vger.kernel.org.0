Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1300912FF16
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 00:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgACX0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 18:26:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:41666 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbgACX0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 18:26:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 15:26:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,392,1571727600"; 
   d="scan'208";a="421570748"
Received: from hkarray-mobl.ger.corp.intel.com ([10.252.22.101])
  by fmsmga006.fm.intel.com with ESMTP; 03 Jan 2020 15:26:34 -0800
Message-ID: <0257b88752b4acdb8715da2fa1c5dfbf9fb1b34b.camel@linux.intel.com>
Subject: Re: [PATCH V2] tpm: Don't make log failures fatal
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Garrett <matthewgarrett@google.com>,
        linux-integrity@vger.kernel.org
Cc:     Matthew Garrett <mjg59@google.com>, stable@vger.kernel.org
In-Reply-To: <20200102215518.148051-1-matthewgarrett@google.com>
References: <20200102215518.148051-1-matthewgarrett@google.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160
 Espoo
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Sat, 04 Jan 2020 00:53:55 +0200
User-Agent: Evolution 3.34.1-2 
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-01-02 at 13:55 -0800, Matthew Garrett wrote:
> If a TPM is in disabled state, it's reasonable for it to have an empty
> log. Bailing out of probe in this case means that the PPI interface
> isn't available, so there's no way to then enable the TPM from the OS.
> In general it seems reasonable to ignore log errors - they shouldn't
> interfere with any other TPM functionality.
> 
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

