Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2196E371B9E
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhECQrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:47:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:56337 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232183AbhECQpZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:45:25 -0400
IronPort-SDR: 4kpmS/G1CZVtbZvnkFqN2n9DRTb0DIxVOaQr1zjjZck7r0HNnm6e+OCDFY1wjVYiCkWa5PsT0V
 d1JDAEQu0iew==
X-IronPort-AV: E=McAfee;i="6200,9189,9973"; a="194640783"
X-IronPort-AV: E=Sophos;i="5.82,270,1613462400"; 
   d="scan'208";a="194640783"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 09:40:09 -0700
IronPort-SDR: xBsDkAyaoWbRm842wB27FPNqfPS4uUWYgxd73dIG1CrG2r74wT7YyOrqOR5cv9s09jfItlugZa
 rSYOOD67BwaQ==
X-IronPort-AV: E=Sophos;i="5.82,270,1613462400"; 
   d="scan'208";a="432824697"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 09:40:05 -0700
Date:   Mon, 3 May 2021 19:40:01 +0300
From:   Imre Deak <imre.deak@intel.com>
To:     stable@vger.kernel.org
Cc:     Mario =?iso-8859-1?Q?H=FCttel?= <mario.huettel@gmx.net>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        intel-gfx@lists.freedesktop.org
Subject: drm/i915: v5.11 stable backport request
Message-ID: <20210503164001.GE4190280@ideak-desk.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stable team, please backport the upstream commits

7962893ecb85 ("drm/i915: Disable runtime power management during shutdown")

to the v5.11 stable kernel, they fix a system shutdown failure.

References: https://lore.kernel.org/intel-gfx/042237f49ed1fd719126a3407d7c909e49addbea.camel@gmx.net
Reported-and-tested-by: Mario Hüttel <mario.huettel@gmx.net>

Thanks,
Imre
