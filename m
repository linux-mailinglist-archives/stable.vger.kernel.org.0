Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108EC3166F9
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 13:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhBJMmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 07:42:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:3119 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231274AbhBJMlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 07:41:21 -0500
IronPort-SDR: CN7WfTFZNZdfE8/0g+hBvLmARu/6HqUS8euNJpLqtjs1rp7l0Q/Mxtph+ZEGSqAhHJIJ1e1cmG
 4gFnfL7lcMhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9890"; a="169189329"
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="169189329"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 04:40:31 -0800
IronPort-SDR: /OOriOnbA9GvacZvRk+hMmUhkhITDx/8m8sBFH2KgomCoHdCBjN0xHmfMvJR9mR7RtdKPz1rdC
 r01tpTBj2idg==
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="396693394"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 04:40:28 -0800
Date:   Wed, 10 Feb 2021 14:40:24 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lyude Paul <lyude@redhat.com>,
        Ville Syrjala <ville.syrjala@intel.com>,
        dri-devel@lists.freedesktop.org,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH 5.10 078/120] drm/dp/mst: Export
 drm_dp_get_vc_payload_bw()
Message-ID: <20210210124024.GA65741@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20210208145818.395353822@linuxfoundation.org>
 <20210208145821.517331268@linuxfoundation.org>
 <20210210122517.GA27201@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210122517.GA27201@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Feb 10, 2021 at 01:25:17PM +0100, Pavel Machek wrote:
> Hi!
> 
> > commit 83404d581471775f37f85e5261ec0d09407d8bed upstream.
> > 
> > This function will be needed by the next patch where the driver
> > calculates the BW based on driver specific parameters, so export it.
> > 
> > At the same time sanitize the function params, passing the more natural
> > link rate instead of the encoding of the same rate.
> 
> > Cc: <stable@vger.kernel.org>
> 
> This adds exports, but there's no user of the export, neither in
> 5.10-stable nor in linux-next. What is the plan here?

the export is used by the upstream 
commit 882554042d138dbc6fb1a43017d0b9c3b38ee5f5
Author: Imre Deak <imre.deak@intel.com>
Date:   Mon Jan 25 19:36:36 2021 +0200

    drm/i915: Fix the MST PBN divider calculation

which I can also see now applied to 5.10.15:

commit 0fe98e455784a6c11e0dd48612acd343f4a46fce
Author:     Imre Deak <imre.deak@intel.com>
AuthorDate: Mon Jan 25 19:36:36 2021 +0200
Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitDate: Wed Feb 10 09:29:18 2021 +0100

    drm/i915: Fix the MST PBN divider calculation

    commit 882554042d138dbc6fb1a43017d0b9c3b38ee5f5 upstream.

--Imre
