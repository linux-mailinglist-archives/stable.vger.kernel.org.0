Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E42F4570B1
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 15:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbhKSOei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 09:34:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235496AbhKSOei (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 09:34:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC6DE60E9B;
        Fri, 19 Nov 2021 14:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637332296;
        bh=0UcX3m8NrqD/AVaEpjX9fgujrcEMZTuWebQ9Dq0Xd2E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vKoWxqG9g2WmNbBDEB2eXEwc3G0cRQ1qgO9sFyal3M5sC+Bj4I/e14yAqHoKl7FEZ
         vxcwofjuO3WzQb7dhpjUUfb20BuuyFopzpVByfHDDfGYlV50JF/O5zxnwXY2wCmOAu
         RBMXpfZWEWfqHiB3Rt2LM4K7gasX1jAbUccbDgqA=
Date:   Fri, 19 Nov 2021 15:31:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Greg Thelen <gthelen@google.com>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: Re: STABLE REQUEST: perf/core: Avoid put_page() when GUP fails
Message-ID: <YZe1RlVuseJi1M1T@kroah.com>
References: <xr9335nxwc5y.fsf@gthelen2.svl.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xr9335nxwc5y.fsf@gthelen2.svl.corp.google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 09:39:53AM -0800, Greg Thelen wrote:
> The patch titled ("perf/core: Avoid put_page() when GUP fails") has been
> merged into linus/master as commit
> 4716023a8f6a0f4a28047f14dd7ebdc319606b84.
> 
> The patch fixes an issue present in all v4.14+ kernels that can cause
> page reference count underflow, which can lead to unintentional page
> sharing.
> 
> The patch did not have cc: stable footer, so I'm manually requesting
> -stable inclusion into v4.14+.
> 
> There are some trivial conflicts in older kernels. I'd be happy to
> review/test, if that's useful.

Please provide working versions for 4.14, 4.19, and 5.4.  The others
kernels applied just fine.

thanks,

greg k-h
