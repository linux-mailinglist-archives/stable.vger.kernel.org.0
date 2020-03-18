Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E97189958
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgCRKa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCRKa7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:30:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 514AF20770;
        Wed, 18 Mar 2020 10:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584527458;
        bh=nj/jLZZHOOOJUXo1zWQ7d+XGDlHaiLLoMgYY0nA8iOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fYJy+wPWdO+83Bed2XRnHuci+/J2Oytcx5aQjrh5gsUOGMT3NvY5JToBlh4EZbeRf
         Z0ZkmA+fvcse12hxHzv2Cxnpmn83jynvp0dCRh2n98jp6pCQ3bMDQQyI1y7g6gI/4n
         /uZGzlMOVId3Yj1IKSGY1wN9simFJpOJx7cprENY=
Date:   Wed, 18 Mar 2020 11:30:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [GIT PULL 4/6] intel_th: msu: Fix the unexpected state warning
Message-ID: <20200318103056.GB2183221@kroah.com>
References: <20200317062215.15598-1-alexander.shishkin@linux.intel.com>
 <20200317062215.15598-5-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317062215.15598-5-alexander.shishkin@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 17, 2020 at 08:22:13AM +0200, Alexander Shishkin wrote:
> The unexpected state warning should only warn on illegal state
> transitions. Fix that.
> 
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Fixes: 615c164da0eb4 ("intel_th: msu: Introduce buffer interface")
> Cc: stable@vger.kernel.org # v5.4+
> ---
>  drivers/hwtracing/intel_th/msu.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

I'll add this to the 5.6-final pile...

