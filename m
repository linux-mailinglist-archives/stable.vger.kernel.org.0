Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB55E239E11
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 06:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgHCEYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 00:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgHCEYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 00:24:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14161206E2;
        Mon,  3 Aug 2020 04:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596428643;
        bh=sBYO/lTSzl3i5++IDdsqLp1UlfUeeZEXFlj/PSk8zD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l5Kf0eyvk+OkKEmUaxifrtlppIBsqNpKDMq99wWKcO9UFQUJf597JBjKj7CS5kt0R
         qhsvL+kevO+WX7GL6ewotGoemn5n2ermWWnEUXPWKJ72VrNE4Oab0QupDifz/T4+fV
         V7I1q6FiBBcrqnLMsn/HbDSAwv971epI4vCgpBeQ=
Date:   Mon, 3 Aug 2020 06:24:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc:     linux-kernel@vger.kernel.org, mst@redhat.com,
        sudeep.dutt@intel.com, arnd@arndb.de, vincent.whitchurch@axis.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] vop: Add missing __iomem annotation in vop_dc_to_vdev()
Message-ID: <20200803042401.GA570882@kroah.com>
References: <20200802232812.16794-1-ashutosh.dixit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200802232812.16794-1-ashutosh.dixit@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 02, 2020 at 04:28:12PM -0700, Ashutosh Dixit wrote:
> Fix the following sparse warnings in drivers/misc/mic/vop//vop_main.c:
> 
> 551:58: warning: incorrect type in argument 1 (different address spaces)
> 551:58:    expected void const volatile [noderef] __iomem *addr
> 551:58:    got restricted __le64 *
> 560:49: warning: incorrect type in argument 1 (different address spaces)
> 560:49:    expected struct mic_device_ctrl *dc
> 560:49:    got struct mic_device_ctrl [noderef] __iomem *dc
> 579:49: warning: incorrect type in argument 1 (different address spaces)
> 579:49:    expected struct mic_device_ctrl *dc
> 579:49:    got struct mic_device_ctrl [noderef] __iomem *dc
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Sudeep Dutt <sudeep.dutt@intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
> Cc: stable <stable@vger.kernel.org>

Why is this a stable thing?  It doesn't fix a real bug, and sparse
warnings are not needed for stable trees, unless this is the last sparse
warning there.

thanks,

greg k-h
