Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6909D2EC2CF
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 18:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbhAFRxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 12:53:47 -0500
Received: from mga06.intel.com ([134.134.136.31]:63983 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbhAFRxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 12:53:47 -0500
IronPort-SDR: cWeTPe27NYouG/u3RTOwd1tK4V+pvEjKfQaqdY5O+H6XEYegfL/5FU9iQsQLB+NdtBeF4DkfmT
 98MIBEjgykLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="238859951"
X-IronPort-AV: E=Sophos;i="5.79,327,1602572400"; 
   d="scan'208";a="238859951"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 09:53:06 -0800
IronPort-SDR: I0l4BAY3WeUOzL+UWeX8h3xo+FzPDXemqAlVuKAqu0DgWIlcu3i9SgzP0pDccvPzuSdAQt7JVs
 GKyzkquUWVfw==
X-IronPort-AV: E=Sophos;i="5.79,327,1602572400"; 
   d="scan'208";a="379367038"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 09:53:05 -0800
Date:   Wed, 6 Jan 2021 19:53:01 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     stable@vger.kernel.org
Cc:     intel-gfx@lists.freedesktop.org,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>
Subject: v5.10 stable backport request
Message-ID: <20210106175301.GB202232@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stable team, please backport the upstream commit

8f329967d596 ("drm/i915/tgl: Fix Combo PHY DPLL fractional divider for 38.4MHz ref clock")

to the v5.10 stable kernel.

Thanks,
Imre
