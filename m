Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A582E2907E2
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 17:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409691AbgJPPAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 11:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409647AbgJPPAv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 11:00:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AD1920723;
        Fri, 16 Oct 2020 15:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602860450;
        bh=TEAxZVfzMG97y3JJIpprAPSKkn81FsIP9eEX67kGF0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zBlNaX6i0wYRNtzczBpwVEyNrvblCCAcpBdmKoRMzHD2X6sE029FrpaDVrHoL2gV3
         4BCZbFi+q46a4TH4j45k5HSFAToJIW1ec9d9Y+TvV67wIUHCKnNDOnUkGEK+dsepSs
         ++L3RLBIm3F6fhpaPtVRj6iWr6A79+962Cx1/ui8=
Date:   Fri, 16 Oct 2020 17:01:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Burgener <dburgener@linux.microsoft.com>
Cc:     stable@vger.kernel.org, stephen.smalley.work@gmail.com,
        paul@paul-moore.com, selinux@vger.kernel.org, jmorris@namei.org,
        sashal@kernel.org
Subject: Re: [PATCH v5.4 v2 0/4] Update SELinuxfs out of tree and then
 swapover
Message-ID: <20201016150120.GB1807231@kroah.com>
References: <20201016134835.1886478-1-dburgener@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016134835.1886478-1-dburgener@linux.microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 09:48:31AM -0400, Daniel Burgener wrote:
> v2: Include all commits from original series, and include commit ids
> 
> This is a backport for stable of my series to fix a race condition in
> selinuxfs during policy load:

Has this race condition always been present, or is this a regression
that is being fixed from previously working kernels?

If it's always been present, why not just use 5.9 to solve it?

thanks,

greg k-h
