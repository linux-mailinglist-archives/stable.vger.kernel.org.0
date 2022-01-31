Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E064A4D5C
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 18:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350309AbiAaRf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 12:35:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37122 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245413AbiAaRf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 12:35:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDEA0B82BD0
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 17:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3D2C340ED;
        Mon, 31 Jan 2022 17:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643650556;
        bh=Nhg9nwCc/svXBa8vLPdcFbAMBRvoHcfXkLMxYPvczec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k9xo5TcQwchyA87EIYeFkDLOYdvTLWZl+E8OZgrk4jDiiyZ38U/a8Cn/QAWJ57qkx
         08ztXgXFEZWKC6szTBFaEAk3dxULGkrY6ByA5oeigqV5EC/nuQHqT0k9jfxrA/f0tv
         B+lRFp6xw4ipLoNH8fJQSRS+a+SSKX3SiUlGbX34=
Date:   Mon, 31 Jan 2022 18:35:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     ailin.xu@intel.com, bp@suse.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/cpu: Add Xeon Icelake-D to list of
 CPUs that support PPIN" failed to apply to 5.10-stable tree
Message-ID: <Yfgd+nHcTbNcSHY0@kroah.com>
References: <164354605382174@kroah.com>
 <YfgZaKupZpQobmiA@agluck-desk2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfgZaKupZpQobmiA@agluck-desk2.amr.corp.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 09:16:24AM -0800, Luck, Tony wrote:
> >From 72a73811c4bd53e0ec8284c12180068468d7c733 Mon Sep 17 00:00:00 2001
> From: Tony Luck <tony.luck@intel.com>
> Date: Mon, 31 Jan 2022 09:00:41 -0800
> Subject: [PATCH] x86/cpu: Add Sapphire Rapids and Icelake-D to list of CPUs that support PPIN
> 
> commit a331f5fdd36dba1ffb0239a4dfaaf1df91ff1aab upstream
> commit e464121f2d40eabc7d11823fb26db807ce945df4 upstream
> 
> Add Sapphire Rapids and Icelake-D to list of CPUs that support PPIN
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> 
> Failed to backport because the sapphire rapids CPU model number
> patch had not been backported.  Bundled both together here. But if
> that breaks stable rules or scripts, I can redo as two patches one
> for each upstream commit.

Two patches please.

thanks,

greg k-h
