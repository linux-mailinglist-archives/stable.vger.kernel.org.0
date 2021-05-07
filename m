Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCBC376426
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 12:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbhEGLAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 07:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230311AbhEGLAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 07:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF7F061008;
        Fri,  7 May 2021 10:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620385191;
        bh=cpVqxoC1cpXrXhppi6Tzpo5T6Gjjru2B/3/Qjj2uCf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FDftllqITBt3j6LJLBjdHzdw7b0lFOIQgzWYoQDFV37l8qMvOEIMgNbkxtciVQqh4
         wLhDsyLkJUN/2uX2yQ5cDl7ebo9OtZf+j7VogLl4J/aGht8/h/A0T0uQX1jeLGhS+C
         8SMNo+D01M+oaNkcf5ie132ee7NT1Jib3mOWP3mTWHwmFz4OU2bFFs2bMIZGNT9ozK
         kTduP0egsoKpV4fMrt/RQpYrelHrtPN5iJi6tBsFDyQwWyjrTOTlkUtCA28cw2ro+i
         CLfsFZw6dtlHcKz/d+4WDlg7lRknLygGh6kDo94woM8sIGB83YbLeDAY229uOUBev/
         nCWIdAT96Lk3Q==
Date:   Fri, 7 May 2021 06:59:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Lyude Paul <lyude@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Robert Foss <robert.foss@linaro.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 4.9 08/24] drm/bridge/analogix/anx78xx: Setup
 encoder before registering connector
Message-ID: <YJUdpQBx0pMbIPQG@sashalap>
References: <20210503164252.2854487-1-sashal@kernel.org>
 <20210503164252.2854487-8-sashal@kernel.org>
 <59cd454b3a104a3a469a94be95cc860ced7581bd.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <59cd454b3a104a3a469a94be95cc860ced7581bd.camel@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 06, 2021 at 01:14:10PM -0400, Lyude Paul wrote:
>I would drop this patch for all of the stable kernel versions, it doesn't
>really fix any user reported issues.

Will do, thanks!

-- 
Thanks,
Sasha
