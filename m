Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A328119C32B
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 15:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgDBNwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 09:52:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:13584 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732218AbgDBNwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 09:52:11 -0400
IronPort-SDR: 8d1oCFcDIhQ7pC3OhS7iZWqrBm4Z+x9ESJxxcTof4k7LDdRMeIts7tXfyN3GYM4EIBzzAwKOsZ
 YVmUNlrbreiA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2020 06:52:11 -0700
IronPort-SDR: gu90V5fKQ1jEMgfpYhdFjTO84yNiywf2TnCsKvRIC/ZTxpeykz3+EzWz2Zl/hqAQ63Ec4vXpoG
 mYqyhxuJsoeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,335,1580803200"; 
   d="scan'208";a="360199836"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga001.fm.intel.com with SMTP; 02 Apr 2020 06:52:03 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 02 Apr 2020 16:52:03 +0300
Date:   Thu, 2 Apr 2020 16:52:03 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Giacomo Comes <comes@naic.edu>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] kernel 5.6: baytrail hdmi audio not working
Message-ID: <20200402135203.GV13686@intel.com>
References: <20200401225317.GA13834@monopoli.naic.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200401225317.GA13834@monopoli.naic.edu>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 06:53:17PM -0400, Giacomo Comes wrote:
> Hi,
> on my Intel Compute Stick STCK1 (baytrail hdmi audio) 
> sound is not working with the kernel 5.6
> 
> I have bisected the kernel and I found the commit that introduced the issue:
> 
> commit 58d124ea2739e1440ddd743d46c470fe724aca9a
> Author: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Date:   Thu Oct 31 12:26:04 2019 +0100
> 
>     drm/i915: Complete crtc hw/uapi split, v6.
>     
>     Now that we separated everything into uapi and hw, it's
>     time to make the split definitive. Remove the union and
>     make a copy of the hw state on modeset and fastset.
>     
>     Color blobs are copied in crtc atomic_check(), right
>     before color management is checked.
> 
> If more information is required please let me know.

Should hopefully be fixed with
commit 2bdd4c28baff ("drm/i915/display: Fix mode private_flags
comparison at atomic_check")

Stable folks, please pick that up for 5.6.x stable releases.

-- 
Ville Syrjälä
Intel
