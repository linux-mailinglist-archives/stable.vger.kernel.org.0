Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362D31D4E53
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 15:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgEONCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 09:02:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:57551 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbgEONCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 09:02:14 -0400
IronPort-SDR: TAB7X/M2p1NMLJkZr06UiYbNCL4PsPZ/DEa0mRaAwd9IcvMK4nVxpS/VWH88wU5uZtD4jn+LcM
 EXdGHyHG08DA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 06:02:13 -0700
IronPort-SDR: y7GuVHMejwsKqWh9wYwdcohj9WvwDwAg8Nz7kS7ufzuTbtnitBDCQnJaR5i/BZ2H7Vm2PCi7ML
 3iPy9uixgJkw==
X-IronPort-AV: E=Sophos;i="5.73,395,1583222400"; 
   d="scan'208";a="438307223"
Received: from ideak-desk.fi.intel.com ([10.237.72.183])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 06:02:11 -0700
Date:   Fri, 15 May 2020 16:02:06 +0300
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>
Cc:     Lyude Paul <lyude@redhat.com>, Sean Paul <sean@poorly.run>,
        stable@vger.kernel.org, Wayne Lin <Wayne.Lin@amd.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: =?utf-8?B?4pyTIEZpLkNJLklHVDogc3VjY2Vz?= =?utf-8?Q?s?= for
 drm/dp_mst: Fix timeout handling of MST down messages
Message-ID: <20200515130206.GB663@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20200513103155.12336-1-imre.deak@intel.com>
 <158938082943.25404.8961145281393887980@emeril.freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158938082943.25404.8961145281393887980@emeril.freedesktop.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 02:40:29PM +0000, Patchwork wrote:
> == Series Details ==
> 
> Series: drm/dp_mst: Fix timeout handling of MST down messages
> URL   : https://patchwork.freedesktop.org/series/77216/
> State : success

Patch pushed to drm-misc-next, thanks for the review.

> 
> == Summary ==
> 
> CI Bug Log - changes from CI_DRM_8472_full -> Patchwork_17643_full
> ====================================================
> 
> Summary
> -------
> 
>   **SUCCESS**
> 
>   No regressions found.
> 
>   
> 
> New tests
> ---------
> 
>   New tests have been introduced between CI_DRM_8472_full and Patchwork_17643_full:
> 
> ### New IGT tests (123) ###
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-128x128-offscreen:
>     - Statuses : 7 pass(s)
>     - Exec time: [2.97, 4.97] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-128x128-onscreen:
>     - Statuses : 8 pass(s)
>     - Exec time: [1.73, 2.92] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-128x128-random:
>     - Statuses : 8 pass(s)
>     - Exec time: [2.74, 4.76] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-128x128-rapid-movement:
>     - Statuses : 8 pass(s)
>     - Exec time: [0.19, 1.11] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-128x128-sliding:
>     - Statuses : 8 pass(s)
>     - Exec time: [2.59, 4.28] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-128x42-offscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.96] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-128x42-onscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 2.89] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-128x42-random:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.46] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-128x42-sliding:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.28] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-256x256-offscreen:
>     - Statuses : 8 pass(s)
>     - Exec time: [2.97, 4.94] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-256x256-onscreen:
>     - Statuses : 8 pass(s)
>     - Exec time: [1.73, 2.90] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-256x256-random:
>     - Statuses : 1 fail(s) 7 pass(s)
>     - Exec time: [0.44, 4.41] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-256x256-rapid-movement:
>     - Statuses : 7 pass(s)
>     - Exec time: [0.29, 1.14] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-256x256-sliding:
>     - Statuses : 8 pass(s)
>     - Exec time: [2.61, 4.30] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-256x85-offscreen:
>     - Statuses : 1 fail(s) 6 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.97] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-256x85-onscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 2.87] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-256x85-random:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.43] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-256x85-sliding:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.26] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-512x170-offscreen:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-512x170-onscreen:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-512x170-random:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-512x170-sliding:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-512x512-offscreen:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-512x512-onscreen:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-512x512-random:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-512x512-rapid-movement:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-512x512-sliding:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-64x21-offscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.96] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-64x21-onscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 2.89] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-64x21-random:
>     - Statuses : 1 fail(s) 6 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.45] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-64x21-sliding:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.74] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-64x64-offscreen:
>     - Statuses : 8 pass(s)
>     - Exec time: [2.95, 4.96] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-64x64-onscreen:
>     - Statuses : 8 pass(s)
>     - Exec time: [1.76, 3.29] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-64x64-random:
>     - Statuses : 8 pass(s)
>     - Exec time: [2.69, 4.51] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-64x64-rapid-movement:
>     - Statuses : 8 pass(s)
>     - Exec time: [0.18, 1.13] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-64x64-sliding:
>     - Statuses : 8 pass(s)
>     - Exec time: [2.64, 4.67] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-alpha-opaque:
>     - Statuses : 8 pass(s)
>     - Exec time: [0.26, 1.11] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-alpha-transparent:
>     - Statuses : 8 pass(s)
>     - Exec time: [0.27, 1.08] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-dpms:
>     - Statuses : 8 pass(s)
>     - Exec time: [0.83, 4.46] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-size-change:
>     - Statuses : 8 pass(s)
>     - Exec time: [0.49, 1.89] s
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-suspend:
>     - Statuses : 8 pass(s)
>     - Exec time: [2.05, 5.28] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-128x128-offscreen:
>     - Statuses : 8 pass(s)
>     - Exec time: [4.10, 5.89] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-128x128-onscreen:
>     - Statuses : 8 pass(s)
>     - Exec time: [2.26, 4.06] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-128x128-random:
>     - Statuses : 8 pass(s)
>     - Exec time: [3.71, 5.48] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-128x128-rapid-movement:
>     - Statuses : 8 pass(s)
>     - Exec time: [0.28, 2.23] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-128x128-sliding:
>     - Statuses : 8 pass(s)
>     - Exec time: [3.60, 5.36] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-128x42-offscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.89] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-128x42-onscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.03] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-128x42-random:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.92] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-128x42-sliding:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.36] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-256x256-offscreen:
>     - Statuses : 8 pass(s)
>     - Exec time: [4.09, 5.89] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-256x256-onscreen:
>     - Statuses : 8 pass(s)
>     - Exec time: [2.25, 3.97] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-256x256-random:
>     - Statuses : 8 pass(s)
>     - Exec time: [3.73, 5.49] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-256x256-rapid-movement:
>     - Statuses : 8 pass(s)
>     - Exec time: [0.26, 2.23] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-256x256-sliding:
>     - Statuses : 8 pass(s)
>     - Exec time: [3.59, 5.36] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-256x85-offscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.88] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-256x85-onscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.45] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-256x85-random:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.50] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-256x85-sliding:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.36] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-512x170-offscreen:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-512x170-onscreen:
>     - Statuses : 7 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-512x170-random:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-512x170-sliding:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-512x512-offscreen:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-512x512-onscreen:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-512x512-random:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-512x512-rapid-movement:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-512x512-sliding:
>     - Statuses : 7 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-64x21-offscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.90] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-64x21-onscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.02] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-64x21-random:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.49] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-64x21-sliding:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.33] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-64x64-offscreen:
>     - Statuses : 8 pass(s)
>     - Exec time: [4.08, 6.38] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-64x64-onscreen:
>     - Statuses : 8 pass(s)
>     - Exec time: [2.30, 4.51] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-64x64-random:
>     - Statuses : 8 pass(s)
>     - Exec time: [3.72, 5.50] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-64x64-rapid-movement:
>     - Statuses : 8 pass(s)
>     - Exec time: [0.26, 2.27] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-64x64-sliding:
>     - Statuses : 8 pass(s)
>     - Exec time: [3.59, 5.35] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-alpha-opaque:
>     - Statuses : 8 pass(s)
>     - Exec time: [0.37, 2.21] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-alpha-transparent:
>     - Statuses : 8 pass(s)
>     - Exec time: [0.42, 2.20] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-dpms:
>     - Statuses : 8 pass(s)
>     - Exec time: [0.78, 5.30] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-size-change:
>     - Statuses : 8 pass(s)
>     - Exec time: [0.52, 2.35] s
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-suspend:
>     - Statuses : 8 pass(s)
>     - Exec time: [1.86, 6.19] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-128x128-offscreen:
>     - Statuses : 1 fail(s) 6 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.41] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-128x128-onscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.44] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-128x128-random:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.95] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-128x128-rapid-movement:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 2.23] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-128x128-sliding:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.32] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-128x42-offscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.88] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-128x42-onscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 3.98] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-128x42-random:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.46] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-128x42-sliding:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.75] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-256x256-offscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.88] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-256x256-onscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.01] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-256x256-random:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.46] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-256x256-rapid-movement:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 2.24] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-256x256-sliding:
>     - Statuses : 6 pass(s) 1 skip(s)
>     - Exec time: [0.0, 6.68] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-256x85-offscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 6.67] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-256x85-onscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 3.98] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-256x85-random:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.42] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-256x85-sliding:
>     - Statuses : 1 fail(s) 6 pass(s) 1 skip(s)
>     - Exec time: [0.0, 4.86] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-512x170-offscreen:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-512x170-onscreen:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-512x170-random:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-512x170-sliding:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-512x512-offscreen:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-512x512-onscreen:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-512x512-random:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-512x512-rapid-movement:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-512x512-sliding:
>     - Statuses : 8 skip(s)
>     - Exec time: [0.0] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-64x21-offscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.92] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-64x21-onscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 3.97] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-64x21-random:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.49] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-64x21-sliding:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.35] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-64x64-offscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.87] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-64x64-onscreen:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 3.97] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-64x64-random:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.48] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-64x64-rapid-movement:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 2.27] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-64x64-sliding:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.80] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-alpha-opaque:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 2.64] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-alpha-transparent:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 2.21] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-dpms:
>     - Statuses : 6 pass(s) 1 skip(s)
>     - Exec time: [0.0, 5.33] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-size-change:
>     - Statuses : 7 pass(s) 1 skip(s)
>     - Exec time: [0.0, 2.33] s
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-suspend:
>     - Statuses : 1 incomplete(s) 6 pass(s) 1 skip(s)
>     - Exec time: [0.0, 6.39] s
> 
>   
> 
> Known issues
> ------------
> 
>   Here are the changes found in Patchwork_17643_full that come from known issues:
> 
> ### IGT changes ###
> 
> #### Issues hit ####
> 
>   * igt@gem_workarounds@suspend-resume-fd:
>     - shard-apl:          [PASS][1] -> [DMESG-WARN][2] ([i915#180])
>    [1]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_8472/shard-apl1/igt@gem_workarounds@suspend-resume-fd.html
>    [2]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_17643/shard-apl4/igt@gem_workarounds@suspend-resume-fd.html
> 
>   * igt@kms_cursor_crc@pipe-c-cursor-256x85-sliding (NEW):
>     - shard-skl:          [PASS][3] -> [FAIL][4] ([i915#54])
>    [3]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_8472/shard-skl2/igt@kms_cursor_crc@pipe-c-cursor-256x85-sliding.html
>    [4]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_17643/shard-skl3/igt@kms_cursor_crc@pipe-c-cursor-256x85-sliding.html
> 
>   * igt@kms_cursor_legacy@short-flip-before-cursor-toggle:
>     - shard-snb:          [PASS][5] -> [SKIP][6] ([fdo#109271]) +1 similar issue
>    [5]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_8472/shard-snb4/igt@kms_cursor_legacy@short-flip-before-cursor-toggle.html
>    [6]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_17643/shard-snb4/igt@kms_cursor_legacy@short-flip-before-cursor-toggle.html
> 
>   * igt@kms_plane_alpha_blend@pipe-a-coverage-7efc:
>     - shard-skl:          [PASS][7] -> [FAIL][8] ([fdo#108145] / [i915#265]) +1 similar issue
>    [7]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_8472/shard-skl3/igt@kms_plane_alpha_blend@pipe-a-coverage-7efc.html
>    [8]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_17643/shard-skl7/igt@kms_plane_alpha_blend@pipe-a-coverage-7efc.html
> 
>   * igt@kms_psr@psr2_cursor_mmap_cpu:
>     - shard-iclb:         [PASS][9] -> [SKIP][10] ([fdo#109441]) +3 similar issues
>    [9]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_8472/shard-iclb2/igt@kms_psr@psr2_cursor_mmap_cpu.html
>    [10]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_17643/shard-iclb1/igt@kms_psr@psr2_cursor_mmap_cpu.html
> 
>   
> #### Possible fixes ####
> 
>   * igt@gem_eio@in-flight-suspend:
>     - shard-skl:          [INCOMPLETE][11] ([i915#69]) -> [PASS][12]
>    [11]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_8472/shard-skl4/igt@gem_eio@in-flight-suspend.html
>    [12]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_17643/shard-skl2/igt@gem_eio@in-flight-suspend.html
> 
>   * igt@gem_softpin@noreloc-s3:
>     - shard-kbl:          [DMESG-WARN][13] ([i915#180]) -> [PASS][14]
>    [13]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_8472/shard-kbl4/igt@gem_softpin@noreloc-s3.html
>    [14]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_17643/shard-kbl3/igt@gem_softpin@noreloc-s3.html
> 
>   * igt@gen9_exec_parse@allowed-all:
>     - shard-apl:          [DMESG-WARN][15] ([i915#1436] / [i915#716]) -> [PASS][16]
>    [15]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_8472/shard-apl4/igt@gen9_exec_parse@allowed-all.html
>    [16]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_17643/shard-apl3/igt@gen9_exec_parse@allowed-all.html
> 
>   * igt@i915_selftest@live@execlists:
>     - shard-skl:          [INCOMPLETE][17] ([i915#1874]) -> [PASS][18]
>    [17]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_8472/shard-skl6/igt@i915_selftest@live@execlists.html
>    [18]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_17643/shard-skl7/igt@i915_selftest@live@execlists.html
> 
>   * {igt@kms_flip@flip-vs-suspend-interruptible@c-dp1}:
>     - shard-apl:          [DMESG-WARN][19] ([i915#180]) -> [PASS][20] +2 similar issues
>    [19]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_8472/shard-apl8/igt@kms_flip@flip-vs-suspend-interruptible@c-dp1.html
>    [20]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_17643/shard-apl7/igt@kms_flip@flip-vs-suspend-interruptible@c-dp1.html
> 
>   * igt@kms_psr@psr2_primary_blt:
>     - shard-iclb:         [SKIP][21] ([fdo#109441]) -> [PASS][22]
>    [21]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_8472/shard-iclb8/igt@kms_psr@psr2_primary_blt.html
>    [22]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_17643/shard-iclb2/igt@kms_psr@psr2_primary_blt.html
> 
>   
> #### Warnings ####
> 
>   * igt@kms_content_protection@lic:
>     - shard-apl:          [FAIL][23] ([fdo#110321]) -> [TIMEOUT][24] ([i915#1319]) +1 similar issue
>    [23]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_8472/shard-apl8/igt@kms_content_protection@lic.html
>    [24]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_17643/shard-apl7/igt@kms_content_protection@lic.html
> 
>   
>   {name}: This element is suppressed. This means it is ignored when computing
>           the status of the difference (SUCCESS, WARNING, or FAILURE).
> 
>   [fdo#108145]: https://bugs.freedesktop.org/show_bug.cgi?id=108145
>   [fdo#109271]: https://bugs.freedesktop.org/show_bug.cgi?id=109271
>   [fdo#109441]: https://bugs.freedesktop.org/show_bug.cgi?id=109441
>   [fdo#110321]: https://bugs.freedesktop.org/show_bug.cgi?id=110321
>   [i915#1319]: https://gitlab.freedesktop.org/drm/intel/issues/1319
>   [i915#1436]: https://gitlab.freedesktop.org/drm/intel/issues/1436
>   [i915#180]: https://gitlab.freedesktop.org/drm/intel/issues/180
>   [i915#1874]: https://gitlab.freedesktop.org/drm/intel/issues/1874
>   [i915#265]: https://gitlab.freedesktop.org/drm/intel/issues/265
>   [i915#54]: https://gitlab.freedesktop.org/drm/intel/issues/54
>   [i915#69]: https://gitlab.freedesktop.org/drm/intel/issues/69
>   [i915#716]: https://gitlab.freedesktop.org/drm/intel/issues/716
> 
> 
> Participating hosts (11 -> 11)
> ------------------------------
> 
>   No changes in participating hosts
> 
> 
> Build changes
> -------------
> 
>   * CI: CI-20190529 -> None
>   * Linux: CI_DRM_8472 -> Patchwork_17643
> 
>   CI-20190529: 20190529
>   CI_DRM_8472: 57acc5ba2cfb81691917a3da729573a99c893e5a @ git://anongit.freedesktop.org/gfx-ci/linux
>   IGT_5651: e54e2642f1967ca3c488db32264607df670d1dfb @ git://anongit.freedesktop.org/xorg/app/intel-gpu-tools
>   Patchwork_17643: 211186b681ff1bc9c2f4f70d495e1072ae5ee0b4 @ git://anongit.freedesktop.org/gfx-ci/linux
>   piglit_4509: fdc5a4ca11124ab8413c7988896eec4c97336694 @ git://anongit.freedesktop.org/piglit
> 
> == Logs ==
> 
> For more details see: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_17643/index.html
