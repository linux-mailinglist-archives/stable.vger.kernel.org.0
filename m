Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184D932FC34
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 18:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhCFRRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 12:17:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229779AbhCFRRK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Mar 2021 12:17:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0013B65005;
        Sat,  6 Mar 2021 17:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615051030;
        bh=hVurEmaGO7eGhA6G/3cCILeLD1F8g4Ut3WbQdHX8dmE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1iuQUOfrkERVJyvTpyiVfh1w3cdr3Wu2rR4Hk1N8aD68bQ/gW0EPrYUjwpdBGuSba
         vTQw4+rIFZOCyLhGVkh1+4l+Huc7Ylm6qxrwEyaIHAIIGb6CEhCulqmNsfIA+n/I1Z
         7R2gU7Rxb9oZYwtfrAQwvlXxpIpokBvXiXOVBEug=
Date:   Sat, 6 Mar 2021 18:17:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nirmoy <nirmodas@amd.com>
Cc:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        "Das, Nirmoy" <Nirmoy.Das@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 5.11 079/104] drm/amdgpu: enable only one high prio
 compute queue
Message-ID: <YEO5EA9rhKfskXp7@kroah.com>
References: <20210305120903.166929741@linuxfoundation.org>
 <20210305120907.039431314@linuxfoundation.org>
 <23197f54-020a-691c-5733-45ce7e624fec@amd.com>
 <MW3PR12MB44918AD858505706809367F3F7969@MW3PR12MB4491.namprd12.prod.outlook.com>
 <9f12d4c6-35c8-7466-f1bc-bee31957e11b@amd.com>
 <MW3PR12MB4491E72712027DCBB8486E59F7969@MW3PR12MB4491.namprd12.prod.outlook.com>
 <YEJOt6KXCzNb5y+x@sashalap>
 <1b5bfcb0-3860-bb81-f0ad-91a522beef0a@amd.com>
 <MW3PR12MB4491C79B8F847B982066A3ABF7969@MW3PR12MB4491.namprd12.prod.outlook.com>
 <489d8a9e-1e24-82b8-7738-5e93aa1aabf4@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489d8a9e-1e24-82b8-7738-5e93aa1aabf4@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 04:57:36PM +0100, Nirmoy wrote:
> 
> On 3/5/21 4:40 PM, Deucher, Alexander wrote:
> > [AMD Public Use]
> > 
> > > -----Original Message-----
> > > From: Koenig, Christian <Christian.Koenig@amd.com>
> > > Sent: Friday, March 5, 2021 10:35 AM
> > > To: Sasha Levin <sashal@kernel.org>; Deucher, Alexander
> > > <Alexander.Deucher@amd.com>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; linux-
> > > kernel@vger.kernel.org; stable@vger.kernel.org; Das, Nirmoy
> > > <Nirmoy.Das@amd.com>
> > > Subject: Re: [PATCH 5.11 079/104] drm/amdgpu: enable only one high prio
> > > compute queue
> > > 
> > > Am 05.03.21 um 16:31 schrieb Sasha Levin:
> > > > On Fri, Mar 05, 2021 at 03:27:00PM +0000, Deucher, Alexander wrote:
> > > > > Not sure if Sasha picked that up or not. Would need to check that. If
> > > > > it's not, this patch should be dropped.
> > > > Yes, it went in via autosel. I can drop it if it's not needed.
> > > > 
> > > IIRC this patch was created *before* the feature which needs it was merged.
> > > So it isn't a bug fix, but rather just a prerequisite for a new feature.
> > > 
> > > Because of this it should only be merged into an older kernel if the new
> > > features is back ported as well.
> > > 
> > > Alex do you agree that we can drop it?
> > I think so, but I don't remember the exact sequence.  @Das, Nirmoy?
> 
> 
> Yes, I agree with Christian. We should not backport it alone.

Ok, now dropped from 5.10 and 5.11 queues.

greg k-h
