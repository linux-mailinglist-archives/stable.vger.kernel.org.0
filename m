Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C632EC3B9
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 20:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbhAFTKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 14:10:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:14642 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbhAFTKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 14:10:40 -0500
IronPort-SDR: zS75/0vibJHmRuIqh6zNFntWHpj+Svj+omP7cmKrU4znQ0oGp5SLQabnFYRXDcJkvjzwGeHrAJ
 XifMcCybg5+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="177423069"
X-IronPort-AV: E=Sophos;i="5.79,327,1602572400"; 
   d="scan'208";a="177423069"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 11:09:50 -0800
IronPort-SDR: Ao3rT7Dz9YpNqB2XTjOQD9TVPcY+HQ9cLOsgq9E/i8Qyg6WwhBDk7n7mgLEX5fhMahQpHlKzxE
 svL72pT6ke1Q==
X-IronPort-AV: E=Sophos;i="5.79,327,1602572400"; 
   d="scan'208";a="379391290"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 11:09:48 -0800
Date:   Wed, 6 Jan 2021 21:09:45 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>
Subject: Re: v5.10 stable backport request
Message-ID: <20210106190945.GA213231@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20210106175301.GB202232@ideak-desk.fi.intel.com>
 <X/X7umSYEeKCZ0Dw@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/X7umSYEeKCZ0Dw@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 06, 2021 at 07:04:42PM +0100, Greg KH wrote:
> On Wed, Jan 06, 2021 at 07:53:01PM +0200, Imre Deak wrote:
> > Stable team, please backport the upstream commit
> > 
> > 8f329967d596 ("drm/i915/tgl: Fix Combo PHY DPLL fractional divider for 38.4MHz ref clock")
> > 
> > to the v5.10 stable kernel.
> 
> I see no such commit id in Linus's kernel :(

Sorry, the commit id correctly is

0e2497e334de42dbaaee8e325241b5b5b34ede7e

--Imre
