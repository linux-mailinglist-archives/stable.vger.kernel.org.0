Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6298318995B
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgCRKbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCRKbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:31:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D52682076C;
        Wed, 18 Mar 2020 10:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584527478;
        bh=tJ4oKEOOtpPOFz1OYzH8DIDwy/jLLY6VQW/bPkvikXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nmD4queGKXREyQnnNBB4xY9Kzm2KXu3vZXW1/m9XTBQNE+3ejS2KAIR6/g1lBI8/v
         SUogO04+x/h/+WI/EUZ8TY82R5oG/o2c/oMduIBn3G2oKIqgxficse1g4g73opzIrJ
         0HPwuRwacTTPCb9Y8kkIzGLFuVRRu5w2k5C/dWq0=
Date:   Wed, 18 Mar 2020 11:31:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [GIT PULL 5/6] intel_th: Fix user-visible error codes
Message-ID: <20200318103116.GC2183221@kroah.com>
References: <20200317062215.15598-1-alexander.shishkin@linux.intel.com>
 <20200317062215.15598-6-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317062215.15598-6-alexander.shishkin@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 17, 2020 at 08:22:14AM +0200, Alexander Shishkin wrote:
> There are a few places in the driver that end up returning ENOTSUPP to
> the user, replace those with EINVAL.
> 
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Fixes: ba82664c134ef ("intel_th: Add Memory Storage Unit driver")
> Cc: stable@vger.kernel.org # v4.4+
> ---
>  drivers/hwtracing/intel_th/msu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Same here, for 5.6
