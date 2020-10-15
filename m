Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E917C28EC93
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 07:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgJOFOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 01:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgJOFOy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Oct 2020 01:14:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1462822247;
        Thu, 15 Oct 2020 05:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602738893;
        bh=eXbiU/gOYfKzJXaZ9RIM/MKxffQp5ZR957Zg+v8e2lE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B/n5LNGDfqPS4DXftMJVZBWpfJsphcEMsDwltChAlHtxB0ajnr64Bn9hTilNbS5Gz
         VQbWfK84yBL+2Q2JcgryfMutEkqMcziEJlX52tSx5L3Vx1A1qlQz2glzgUMCazL7FE
         nEqoLXaPie/XXS2ltjUjbc3iRDvzqhLZOB62/uhk=
Date:   Thu, 15 Oct 2020 07:14:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs
 handlers"
Message-ID: <20201015051451.GA405484@kroah.com>
References: <20201014202836.240347-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014202836.240347-1-alexander.deucher@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 14, 2020 at 04:28:36PM -0400, Alex Deucher wrote:
> This regressed some working configurations so revert it.  Will
> fix this properly for 5.9 and backport then.

What do you mean "backport then"?

> 
> This reverts commit 38e0c89a19fd13f28d2b4721035160a3e66e270b.
> 
> This needs to be applied to 5.9 as well.  -next (5.10) has this
> already, but 5.9 missed it.

What is the real fix for this?  Is it in Linus's tree and I can just
backport that fix?

thanks,

greg k-h
