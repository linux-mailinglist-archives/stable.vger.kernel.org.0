Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855582406AA
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 15:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgHJNiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 09:38:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbgHJNiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 09:38:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFB67206E9;
        Mon, 10 Aug 2020 13:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597066704;
        bh=0hKMW1r8RE+/VI3a32pWMTWKQcO+bvS3Pt/gCHPUuFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0zSGoSB1f569O0Dr7JTAHQqF2iZAgkuXT0mquWnIZ4iMRQPOoNxjfMYLeP1mfT1UO
         gBYejoqyaa62q31Ksuw3O2WiSQyRUZPjWnEeDK1MUfTRIuJ0+Rxcq72dNmdyVRClK3
         3PWsq+VItKQmAsC9PEra7FqASVrP0P50u+/jAn4M=
Date:   Mon, 10 Aug 2020 15:38:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     stable@vger.kernel.org, aleksandr.loktionov@intel.com
Subject: Re: [PATCH stable 0/4] i40e fixes for stable
Message-ID: <20200810133835.GA3491228@kroah.com>
References: <20200807205517.1740307-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807205517.1740307-1-jesse.brandeburg@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 07, 2020 at 01:55:13PM -0700, Jesse Brandeburg wrote:
> These stable fixes were not correctly noted as fixes when
> originally submitted for 5.2-rc1. We are addressing the internal
> gap that led to this miss.
> 
> Please consider these patches for all stable kernels older than
> 5.2.0, I tried on 4.19 and 3 out of 4 apply cleanly with a cherry
> pick from Linus' tree, but one of them I had to rebase, so I'm
> just sending the whole series.
> 
> If you'd rather I send one at a time in the format specified at
> option 2) of the stable documentation, please just let me know.

This works,, all queued up for 4.19.y now.

thanks,

greg k-h
