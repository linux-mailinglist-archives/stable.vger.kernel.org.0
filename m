Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597F22BA4B5
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 09:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgKTIdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 03:33:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgKTIdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 03:33:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C59D822249;
        Fri, 20 Nov 2020 08:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605861199;
        bh=ArPI4k4DYZZ+9TqL5bIC9RkaWMrIJ24te09S91MV7gI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SeEV0i043VBpXTQu4565aYbQdj2s2QmDHRYfhWn9GWYv/SVoqRmZRiGwQGGH/leKZ
         BDN23xvIxjP66+uvLhfy3JfRVTjT8fcp3zr0JezQEhp0PcZ8LWYW+33a7FMwSLiTMu
         mCjiz93kHJtdLJ4x1pjLkxKHnRjrAKT9Zshp2oDc=
Date:   Fri, 20 Nov 2020 09:34:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Tor Jeremiassen <tor@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] Revert "perf cs-etm: Move definition of 'traceid_list'
 global variable from header file"
Message-ID: <X7d/eXs+iFTJA5mD@kroah.com>
References: <20201120073909.357536-1-carnil@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120073909.357536-1-carnil@debian.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 08:39:09AM +0100, Salvatore Bonaccorso wrote:
> This reverts commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.
> (but only from 4.19.y)

Thanks for this, now queued up.

greg k-h
