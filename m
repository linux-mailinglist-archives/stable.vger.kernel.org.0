Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221B9371E2B
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhECRNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 13:13:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:16785 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231538AbhECRLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 13:11:40 -0400
IronPort-SDR: JKfXG9gyUbyRBbYoh7T4pF0zvUAUd5In4HPwiNdsjAqJK5FYdjKTYqez5LYSU3pYkqg6/s1LW5
 l4htbvj9cO6w==
X-IronPort-AV: E=McAfee;i="6200,9189,9973"; a="197885518"
X-IronPort-AV: E=Sophos;i="5.82,270,1613462400"; 
   d="scan'208";a="197885518"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 10:10:45 -0700
IronPort-SDR: Y15+UH0xaptjRshlfWgFjPSrOaBx6o6rnFL0BOe6Rbkt92AMPEP5bZ1Mh49uGhfl6X7BRDg5Wb
 dno2OF5b+FTQ==
X-IronPort-AV: E=Sophos;i="5.82,270,1613462400"; 
   d="scan'208";a="468140585"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 10:10:42 -0700
Date:   Mon, 3 May 2021 20:10:38 +0300
From:   Imre Deak <imre.deak@intel.com>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org,
        Mario =?iso-8859-1?Q?H=FCttel?= <mario.huettel@gmx.net>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        intel-gfx@lists.freedesktop.org
Subject: Re: drm/i915: v5.11 stable backport request
Message-ID: <20210503171038.GF4190280@ideak-desk.fi.intel.com>
References: <20210503164001.GE4190280@ideak-desk.fi.intel.com>
 <YJAql6Vstj7wY5Wg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YJAql6Vstj7wY5Wg@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 03, 2021 at 06:53:43PM +0200, Greg KH wrote:
> On Mon, May 03, 2021 at 07:40:01PM +0300, Imre Deak wrote:
> > Stable team, please backport the upstream commits
> > 
> > 7962893ecb85 ("drm/i915: Disable runtime power management during shutdown")
> > 
> > to the v5.11 stable kernel, they fix a system shutdown failure.
> > 
> > References: https://lore.kernel.org/intel-gfx/042237f49ed1fd719126a3407d7c909e49addbea.camel@gmx.net
> > Reported-and-tested-by: Mario Hüttel <mario.huettel@gmx.net>
> 
> You also need this in 5.12.y, right?

Yes missed that, thanks for catching it.

> thanks,
> 
> greg k-h
