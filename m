Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A16432E5E6
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 11:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCEKOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 05:14:11 -0500
Received: from mga17.intel.com ([192.55.52.151]:53960 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229615AbhCEKOE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 05:14:04 -0500
IronPort-SDR: Dz3oZdWzs7pJxj/b6pwCJ9GEomoMsiEd3m5XUqUSxjvnUrqud1q7W6AnGzILkqJv0uY0VKVXAg
 vdbt2/2CBC9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="167515690"
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="167515690"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 02:14:04 -0800
IronPort-SDR: LNw8CNhiMCCPn3wedL38XeTN8TaXnoQ4D11YrjNpCqL4/TZYMgYgmfnCJGoG/eYJwNIwe6anc7
 N79Vb2yq9f2A==
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="587079188"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 02:14:02 -0800
Received: from paasikivi.fi.intel.com (localhost [127.0.0.1])
        by paasikivi.fi.intel.com (Postfix) with SMTP id EE2D32011C;
        Fri,  5 Mar 2021 12:13:29 +0200 (EET)
Date:   Fri, 5 Mar 2021 12:13:29 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     arnd@arndb.de, arnd@kernel.org, hverkuil-cisco@xs4all.nl,
        laurent.pinchart@ideasonboard.com, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] media: v4l: ioctl: Fix memory leak in
 video_usercopy" failed to apply to 4.4-stable tree
Message-ID: <20210305101329.GP3@paasikivi.fi.intel.com>
References: <1614597440191109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614597440191109@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Mar 01, 2021 at 12:17:20PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I've manually backported patches for the stable trees as there have been
changes in the upstream between the stable trees and the fix. Small changes
were also needed between different stable kernels.

-- 
Kind regards,

Sakari Ailus
