Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CFD2DFAD8
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 11:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgLUKJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 05:09:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgLUKJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Dec 2020 05:09:28 -0500
Date:   Mon, 21 Dec 2020 10:12:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608541894;
        bh=P8V0R523Ttm+uB2if0VRBQkpR2ppqWGaHPiCaqXKIm0=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=f+Mh4DMr/qNFLcjTjAGYAXNTZuxGwwfbD545LC3WGRp4C7ukoQYYeiqHrZFnsHcf6
         ZfFF//qCK6u/oDyfDQdpmIA1UXpyAjlPpe5fboBFNejCmAHsmnVX7+wcPFE88Tapwh
         lTCPlm4vM6GLkbuKzBIFu4A6B5QZWEtqDAWXVrAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Xiaogang.Chen" <chenxiaogang888@gmail.com>
Cc:     xiaogang.chen@amd.com, Michal Simek <michal.simek@xilinx.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v1 01/14] Revert "serial: uartps: Fix error path when
 alloc failed"
Message-ID: <X+BnES5S9Qd7wBsF@kroah.com>
References: <1608540439-28772-1-git-send-email-xiaogang.chen@amd.com>
 <1608540439-28772-2-git-send-email-xiaogang.chen@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1608540439-28772-2-git-send-email-xiaogang.chen@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 02:47:06AM -0600, Xiaogang.Chen wrote:
> From: Michal Simek <michal.simek@xilinx.com>
> 
> commit b6fd2dbbd649b89a3998528994665ded1e3fbf7f upstream.
> 
> This reverts commit 32cf21ac4edd6c0d5b9614368a83bcdc68acb031.
> 
> As Johan says, this driver needs a lot more work and these changes are
> only going in the wrong direction:
>   https://lkml.kernel.org/r/20190523091839.GC568@localhost
> 
> Reported-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Cc: stable <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/46cd7f039db847c08baa6508edd7854f7c8ff80f.1585905873.git.michal.simek@xilinx.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/tty/serial/xilinx_uartps.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 

Why are you sending us our own patches again?

What are we to do with these?  Do you want them applied to a stable
kernel tree?  If so, what one?

confused,

greg k-h
