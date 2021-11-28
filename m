Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37920460609
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 13:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243136AbhK1MJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 07:09:31 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41201 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244112AbhK1MHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 07:07:31 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id BCB545C00F4;
        Sun, 28 Nov 2021 07:04:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 28 Nov 2021 07:04:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=f
        GD0pf08Cqy8SSrDA4zx049WkT/wkgy4g77jjT41+IM=; b=mu+4CzC/VeewUIzvJ
        f2oLBXytppM+NlWIjCnbKncduZ5LIDWZjrfkx+I75c1ugK3bWvLGR16g/D4cR8Vu
        M4ES2nD8o5ZYPbg43YO+9482nVka/wEnzdJcs4X+GybfuSRBCBBWQBiE30XxtGna
        VX5WUS4EZvWrmG5/yubJDr1BBhszUWHJDs1qEmVvD40pklXVkVJeXOEcvlqhYhvv
        nz6SLvdq/bG8Gc1I3Zhd0FI4jmshw0jdwgr8g9HhJTPalgyHu7e8ZqUMHuWTe+wO
        Pj15o9pmGvCgvjqmdi7kxicIgXT9fy/lAnIzGHxVCzm7lCuWEunI6Z3kQ6SNGN/h
        ntepQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=fGD0pf08Cqy8SSrDA4zx049WkT/wkgy4g77jjT41+
        IM=; b=DvRbJIBVHCvlwVe3A6XYuDpylXLLaF+cTTKNevn1ANVfDkJBa67Ey5Xo6
        Bmxjv4IVVeZSg3ZWsc0/GTLm0bvBiczcXfvnuR8TsPppuadcT3QiA7WzSiJdfVPl
        wfR0mCBTN5Rhwv5e3EIKhXjo9/xmzwmt3rdCmU/rmbGhpKcu/m+TtP+p6Ru+ST08
        gyVtsU2NlYZXct6Guc5bVVynSyYS1TdkgsdAaahwM6/bXHCnLpIoLtlWkSivTqMY
        Zi6tsQlt6e3uK+m9ZGyncXIDTUy06N/rWOsCT8CtjFFdeQS1SRRcwSDKGScmQgwe
        1HSuaAMSHotbCcUSFaVaKqaAaf3tg==
X-ME-Sender: <xms:PHCjYQ2_KFKOjPcku4zva3zr68iixu9RcIzQixhEzv9GLLm_W5QkOg>
    <xme:PHCjYbEi8URVzyIoY4cnEA311UN-XVk3MlmA17MLJVTxCWrTZsgJI0FalRE4VuMN2
    BUJI9PYmT3UvQ>
X-ME-Received: <xmr:PHCjYY4jY3DrLSAUIPi_a4k6Fpxnso40iASC9Wc2IFW-4nV4MTahWIUA9rC7XgJZP14rreKL2OJ0q2RvzNHc9WEd_B83w_Q1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrheeigdefjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeejheegff
    egheevhffftdfhvedvleehfedvueetveegvddvleeffedtheffgfdvhfenucffohhmrghi
    nheprhgvugguihhtrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:PHCjYZ0j8xurJBOKPmVpWawVRSc6lJvEkN2J7iQx5QT5YXpND3_f0Q>
    <xmx:PHCjYTH8hI8OWw_FexDMEdIEOkkWLgGOMM88ozUAwMW-sLvyOR5L-g>
    <xmx:PHCjYS8DRhLbzVpY1J5txcLMCVB4Cyrm-HUvufeJPjMiSmM9iP7JGw>
    <xmx:PHCjYZYLeuNyZFCHJjbEuOBh9vcoUiWkpCTbl8ypkhJSOoiaWFDuVA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 28 Nov 2021 07:04:12 -0500 (EST)
Date:   Sun, 28 Nov 2021 13:03:59 +0100
From:   Greg KH <greg@kroah.com>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org, Roman Li <Roman.Li@amd.com>,
        Samuel =?utf-8?B?xIxhdm9q?= <samuel@cavoj.net>,
        Jasdeep Dhillon <Jasdeep.Dhillon@amd.com>
Subject: Re: [PATCH] drm/amd/display: Fix OLED brightness control on eDP
Message-ID: <YaNwL0/drhNurJnG@kroah.com>
References: <20211124180122.2736457-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211124180122.2736457-1-alexander.deucher@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 01:01:22PM -0500, Alex Deucher wrote:
> From: Roman Li <Roman.Li@amd.com>
> 
> [Why]
> After commit ("drm/amdgpu/display: add support for multiple backlights")
> number of eDPs is defined while registering backlight device.
> However the panel's extended caps get updated once before register call.
> That leads to regression with extended caps like oled brightness control.
> 
> [How]
> Update connector ext caps after register_backlight_device
> 
> Fixes: 7fd13baeb7a3a4 ("drm/amdgpu/display: add support for multiple backlights")
> Link: https://www.reddit.com/r/AMDLaptops/comments/qst0fm/after_updating_to_linux_515_my_brightness/
> 
> Signed-off-by: Roman Li <Roman.Li@amd.com>
> Tested-by: Samuel Čavoj <samuel@cavoj.net>
> Acked-by: Alex Deucher <alexander.deucher@amd.com>
> Reviewed-by: Jasdeep Dhillon <Jasdeep.Dhillon@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org
> (cherry picked from commit dab60582685aabdae2d4ff7ce716456bd0dc7a0f)

Now queued up for 5.10 and 5.15, thanks.

greg k-h
