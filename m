Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90D632EEDA
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 16:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhCEPbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 10:31:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229651AbhCEPbF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 10:31:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E71FA65015;
        Fri,  5 Mar 2021 15:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614958265;
        bh=ZQzwJu/bYmNTEwTZkUYIuu/Lr0Odt6abjBFclZMt0fE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SRd9EGlUdUnVu/uG/yIv7e4JawZAUCJFL9sX25G3E3y4QF+D4SZe6KbKFwxJKE2g/
         0Y7/8Uv5PNudgrfGF5/k7CdRmFvyK4Tff2MoJRhFf8t8WrFHNnvZU5A3sbp9IGA+6A
         KBSsNyQURnhM5ibeRvhtHUtwK5E1perAI5VF6um9mN0/PX1FPLhJYcD4xcScYHyoVE
         9+EJTihnjsijMP0t8539u7ag5vCZzrWFiD62OeH1ZsaluJ4WXiY9ofnA4PQ1vWRj1o
         BxZE7XN9ZUkPnZpm1gtXtH0DevDCa7j2LK/EUyP4DDVkWQFWImZXoxGfbxLGBC1Msv
         YIYyqY63798qg==
Date:   Fri, 5 Mar 2021 10:31:03 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "Koenig, Christian" <Christian.Koenig@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Das, Nirmoy" <Nirmoy.Das@amd.com>
Subject: Re: [PATCH 5.11 079/104] drm/amdgpu: enable only one high prio
 compute queue
Message-ID: <YEJOt6KXCzNb5y+x@sashalap>
References: <20210305120903.166929741@linuxfoundation.org>
 <20210305120907.039431314@linuxfoundation.org>
 <23197f54-020a-691c-5733-45ce7e624fec@amd.com>
 <MW3PR12MB44918AD858505706809367F3F7969@MW3PR12MB4491.namprd12.prod.outlook.com>
 <9f12d4c6-35c8-7466-f1bc-bee31957e11b@amd.com>
 <MW3PR12MB4491E72712027DCBB8486E59F7969@MW3PR12MB4491.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <MW3PR12MB4491E72712027DCBB8486E59F7969@MW3PR12MB4491.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 03:27:00PM +0000, Deucher, Alexander wrote:
>Not sure if Sasha picked that up or not.  Would need to check that.  If it's not, this patch should be dropped.

Yes, it went in via autosel. I can drop it if it's not needed.

-- 
Thanks,
Sasha
