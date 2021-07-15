Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7516D3C9D3C
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 12:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240656AbhGOKvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 06:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238693AbhGOKvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 06:51:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BC9461380;
        Thu, 15 Jul 2021 10:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626346122;
        bh=ulKsHw6GlZ6s1kRpL+Qcq9OClUQjFQtzTWFe+7+Dr3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iLd8sw25g0H+uooHvbjEgSQcRaOlLoo2XDMNS7h7D7sQx1CtmhfrHrtCna0xyLifI
         BQbYp6moOoufSOVfHx10oWgizNnt592jr+iPdzOIidL8pvJzy7zXJspADxgVRwZFEX
         I+WKvPnPN74QqmsgxG6m3uJxqfrsyXkD9B3Toxd8=
Date:   Thu, 15 Jul 2021 12:48:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiaochen Shen <xiaochen.shen@intel.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org, shuah@kernel.org,
        tony.luck@intel.com, fenghua.yu@intel.com,
        reinette.chatre@intel.com, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, pei.p.jia@intel.com
Subject: Re: [PATCH 5.12] selftests/resctrl: Fix incorrect parsing of option
 "-t"
Message-ID: <YPAShFw2BkuYYzlq@kroah.com>
References: <16260087708135@kroah.com>
 <1626076523-924-1-git-send-email-xiaochen.shen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626076523-924-1-git-send-email-xiaochen.shen@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 03:55:23PM +0800, Xiaochen Shen wrote:
> commit 1421ec684a43379b2aa3cfda20b03d38282dc990 upstream.
> 
> Resctrl test suite accepts command line argument "-t" to specify the
> unit tests to run in the test list (e.g., -t mbm,mba,cmt,cat) as
> documented in the help.
> 
> When calling strtok() to parse the option, the incorrect delimiters
> argument ":\t" is used. As a result, passing "-t mbm,mba,cmt,cat" throws
> an invalid option error.
> 
> Fix this by using delimiters argument "," instead of ":\t" for parsing
> of unit tests list. At the same time, remove the unnecessary "spaces"
> between the unit tests in help documentation to prevent confusion.
> 
> Fixes: 790bf585b0ee ("selftests/resctrl: Add Cache Allocation Technology (CAT) selftest")
> Fixes: 78941183d1b1 ("selftests/resctrl: Add Cache QoS Monitoring (CQM) selftest")
> Fixes: ecdbb911f22d ("selftests/resctrl: Add MBM test")
> Fixes: 034c7678dd2c ("selftests/resctrl: Add README for resctrl tests")
> Cc: stable@vger.kernel.org
> Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>  tools/testing/selftests/resctrl/README          | 2 +-
>  tools/testing/selftests/resctrl/resctrl_tests.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 

Both now queued up, thanks.

greg k-h
