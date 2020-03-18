Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 107EE18994A
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgCRK2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727355AbgCRK2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:28:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3A382077B;
        Wed, 18 Mar 2020 10:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584527292;
        bh=8TrFsKaw1wUkDd17zR74BGVBK8m94dnMM6nYkLcyLao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vxtd4WI1dEKNqlGvBGgcAr5wqCExHadAN5DbNB0LG4dNCnYkZEDvN5HFozs16m5ej
         vHC7eeJpb/w0WXBQW6nHPIkmiiRdgh3Yz+Eh6vlL87vIrstUpI0DZqsBLLmLhca9cl
         VFYiq9ffH8BoEHotpsm4+EueGHCCipGR3033JWmM=
Date:   Wed, 18 Mar 2020 11:28:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [GIT PULL 2/6] stm class: sys-t: Fix the use of time_after()
Message-ID: <20200318102810.GA2172609@kroah.com>
References: <20200317062215.15598-1-alexander.shishkin@linux.intel.com>
 <20200317062215.15598-3-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317062215.15598-3-alexander.shishkin@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 17, 2020 at 08:22:11AM +0200, Alexander Shishkin wrote:
> The operands of time_after() are in a wrong order in both instances in
> the sys-t driver. Fix that.
> 
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Fixes: 39f10239df75 ("stm class: p_sys-t: Add support for CLOCKSYNC packets")
> Fixes: d69d5e83110f ("stm class: Add MIPI SyS-T protocol support")
> Cc: stable@vger.kernel.org # v4.20+
> ---
>  drivers/hwtracing/stm/p_sys-t.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

This should go to 5.6-final, right?

Don't mix and match patches in a series if possible...

greg k-h
