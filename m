Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732B244D1FE
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 07:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhKKGw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 01:52:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhKKGw0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Nov 2021 01:52:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E63A461037;
        Thu, 11 Nov 2021 06:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636613377;
        bh=/H+tvhYq/Hb6oKmLMsy0l8RX4DNT7vwq4UUQIVoptBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1sgDHu0zEv88Vl7mh9rmoswSBujIZA45rLiZe6Ddk1Ta2lkUSH959GQo5ub/LOHgb
         ZKLqrhGqN9K2YmgqIvin3ZfuCD7xlQbLYaTncosIzOC9rEnTLCSZnyzzb31MTegM+l
         CxoggFNJdYevpTy0ElAoCLAZiYcPdwmrnxN72VV4=
Date:   Thu, 11 Nov 2021 07:49:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH] drm/amd/display: Look at firmware version to determine
 using dmub on dcn21
Message-ID: <YYy8/ffHyM7LKSmU@kroah.com>
References: <20211110232554.2190-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110232554.2190-1-mario.limonciello@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 05:25:54PM -0600, Mario Limonciello wrote:
> Newer DMUB firmware on Renoir and Green Sardine do not need to disable dmcu
> and this actually causes problems with DP-C alt mode for a number of machines.
> 
> Backport the fix from this from mainline.  It's a hand modified backport because
> mainline switched to IP version checking which doesn't exist in linux-stable.
> 
> BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1772
> BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1735
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> ---
> Resend, also pick up Alex's tag from last submission
> This was previously sent to stable@kernel.org not stable@vger.kernel.org.
>


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
