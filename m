Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1961346060A
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 13:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357257AbhK1MKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 07:10:01 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41043 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357404AbhK1MIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 07:08:00 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 88AF95C00DB;
        Sun, 28 Nov 2021 07:04:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 28 Nov 2021 07:04:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=8
        1is5qu9wmGdO72+qitPkiibe0Tf0e22l+clQA/Z8Y0=; b=kUIxgdNLOQd+UbrR1
        zOt8xYLJVFQuFgLka4cMc7GNCEh/LqnRnV8MLWhvpybfe6Y6M4TJmMbHb73n4D3a
        QXIBiOmkwIdjZJmfN8rzMDtldzaRMoCgFm05AC/aMaDXj7yTSDj9ddTXSr964O5h
        OXGmWjXo6eloQXsp2VxDWnulBTYzzRcu6uGRFY8XER8LAWfsZjim1JLzFKR2THRI
        PaR3lgoZmBea3w+LfmaolALWXf3HaHOTs+A3zDetoG6qeHdqpIqVcKBtc/T5qb9N
        p3qPPbbdY2IWSc6Ur2wTq9EHhgeKZlwQ9znLQ1jkwFa00Mjo1z+6rFDjcik5y3cx
        7TICQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=81is5qu9wmGdO72+qitPkiibe0Tf0e22l+clQA/Z8
        Y0=; b=ERQDZWVCUp1gQVgF0MfavcHg0CBBY4Z0wtr6c3w3waNCPbdaYypFjvMbL
        sw/1F/o2zpcOLcEMXe7MAGrHggmzW0Wy5PuaOkxhSCCYHKK25lVpmjYkuvXrac6u
        YN+y0HBAHLlzC0k8knuh9gMAOzZ32EcVLMLKUHXYeot7okvOd/yN2Xd5vvYAwLWw
        4+6davC/G1hbFK0RXqAMt7ktS9fWNkIz6ReLIV9aML2Te/kCcsExHRtLCo/sQd9j
        iopJvoJut9w8em27/zQJlUmmkWUn1c/kEG3WWPtZNWmGYzSqQfkKdjea7hKY+unA
        XNK7+fIcDtiHurwzlAbUbrflt7Mww==
X-ME-Sender: <xms:XHCjYdbFKNviCh3KujSmwyiKxaadIQx1Vm2a1YtmeddOSxwHH3ypxg>
    <xme:XHCjYUacWC9VNxl_7htpgp9r-p6o8RMSd-03HaDWS0F8K2b9F-V-EmX6uKNayUhRJ
    naNPy17QjqWbg>
X-ME-Received: <xmr:XHCjYf_FCYHUjR3F1Ss7epKbHzA3Au83InBcTqmmc-fnqsvWY9VQzpgnjDLUBJHQ_MKYUAq0gS71FB3S4iWUXFdmtJa9urMB>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrheeigdefjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeejheegff
    egheevhffftdfhvedvleehfedvueetveegvddvleeffedtheffgfdvhfenucffohhmrghi
    nheprhgvugguihhtrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:XHCjYbrTA6fn0VGtA2VLjBLXaZFfast31r4iiholn8TbI1vYGXrokQ>
    <xmx:XHCjYYoGlkQqkFfM8EmOjvbr2jgeXypRWKnBnGMs2jTFNUnNFsdVMQ>
    <xmx:XHCjYRRh3zG8X3S3KzBtWqh1Jh2jH_jrY28LyVlmhZTkOab2DBL_6A>
    <xmx:XHCjYUcsQmZ_Yn2wmGuuD0-_pZjqChPI0hfgSFKMSNqFcm2ZYgonkA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 28 Nov 2021 07:04:43 -0500 (EST)
Date:   Sun, 28 Nov 2021 13:04:37 +0100
From:   Greg KH <greg@kroah.com>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org, Roman Li <Roman.Li@amd.com>,
        Samuel =?utf-8?B?xIxhdm9q?= <samuel@cavoj.net>,
        Jasdeep Dhillon <Jasdeep.Dhillon@amd.com>
Subject: Re: [PATCH] drm/amd/display: Fix OLED brightness control on eDP
Message-ID: <YaNwVTKK46Kf46b7@kroah.com>
References: <20211124180122.2736457-1-alexander.deucher@amd.com>
 <YaNwL0/drhNurJnG@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YaNwL0/drhNurJnG@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 28, 2021 at 01:03:59PM +0100, Greg KH wrote:
> On Wed, Nov 24, 2021 at 01:01:22PM -0500, Alex Deucher wrote:
> > From: Roman Li <Roman.Li@amd.com>
> > 
> > [Why]
> > After commit ("drm/amdgpu/display: add support for multiple backlights")
> > number of eDPs is defined while registering backlight device.
> > However the panel's extended caps get updated once before register call.
> > That leads to regression with extended caps like oled brightness control.
> > 
> > [How]
> > Update connector ext caps after register_backlight_device
> > 
> > Fixes: 7fd13baeb7a3a4 ("drm/amdgpu/display: add support for multiple backlights")
> > Link: https://www.reddit.com/r/AMDLaptops/comments/qst0fm/after_updating_to_linux_515_my_brightness/
> > 
> > Signed-off-by: Roman Li <Roman.Li@amd.com>
> > Tested-by: Samuel Čavoj <samuel@cavoj.net>
> > Acked-by: Alex Deucher <alexander.deucher@amd.com>
> > Reviewed-by: Jasdeep Dhillon <Jasdeep.Dhillon@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Cc: stable@vger.kernel.org
> > (cherry picked from commit dab60582685aabdae2d4ff7ce716456bd0dc7a0f)
> 
> Now queued up for 5.10 and 5.15, thanks.

Oops, only for 5.15, not for 5.10, sorry.

greg k-h
