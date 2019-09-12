Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A696B143E
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 20:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfILSF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 14:05:29 -0400
Received: from mga18.intel.com ([134.134.136.126]:15232 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfILSF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Sep 2019 14:05:29 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 11:05:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,498,1559545200"; 
   d="scan'208";a="200793479"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga001.fm.intel.com with SMTP; 12 Sep 2019 11:05:25 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 12 Sep 2019 21:05:25 +0300
Date:   Thu, 12 Sep 2019 21:05:24 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc:     Sasha Levin <sashal@kernel.org>, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 01/23] drm/i915/dp: Fix dsc bpp calculations.
Message-ID: <20190912180524.GA1208@intel.com>
References: <20190912130109.5873-1-maarten.lankhorst@linux.intel.com>
 <20190912143415.D8F552081B@mail.kernel.org>
 <db913560-ee38-71e0-39e8-28bc75bbdc5e@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db913560-ee38-71e0-39e8-28bc75bbdc5e@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 12, 2019 at 06:01:57PM +0200, Maarten Lankhorst wrote:
> Hey,
> 
> Op 12-09-2019 om 16:34 schreef Sasha Levin:
> > Hi,
> >
> > [This is an automated email]
> >
> > This commit has been processed because it contains a "Fixes:" tag,
> > fixing commit: d9218c8f6cf4 drm/i915/dp: Add helpers for Compressed BPP and Slice Count for DSC.
> >
> > The bot has tested the following trees: v5.2.14.
> >
> > v5.2.14: Failed to apply! Possible dependencies:
> >     Unable to calculate
> >
> >
> > NOTE: The patch will not be queued to stable trees until it is upstream.
> >
> > How should we proceed with this patch?
> >
> > --
> > Thanks,
> > Sasha
> 
> Why is this bot asking for patches on the trybot mailing list?

Did you forget --suppress-cc=all ?

-- 
Ville Syrjälä
Intel
