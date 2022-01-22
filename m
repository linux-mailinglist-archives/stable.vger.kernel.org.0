Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45088496D9D
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 20:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiAVTWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 14:22:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44496 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiAVTWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 14:22:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6714A60EB8;
        Sat, 22 Jan 2022 19:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6D1C004E1;
        Sat, 22 Jan 2022 19:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642879370;
        bh=ksJzJXNdFRTsXkalxn9MXIV8DbS4/fp38QoHu36pbT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RjPivVnMNen4DruSHzJ5p1YoY9KfCfs7Vaf8VpY6WTZ1MOuBLAM2y7SytFIz5aZIs
         uhAPVS3Zla6Apwf+TuLNr8uy/SrlK05eNP1b4/6kziPthl1bnr1I1fvV+pRfYjZzaU
         XH8jvY3dSjeNPRDptFAHKjVEIbfKJNr7qb5AavUFh/akQHEZwxGl3S8jKBdm1FBuOc
         iR3Opef3bBSkasG77xNbB5IHVnvVD+W0WTQo+2/Uja3YfSRJOV6UPdIStQzbkm+uA0
         k0Jhl9sZ33WnQrrkISDmIQbwyP6Jv3e98Xwsaht3VCymfLtrsZwXjcwnTz0O9Ji7aK
         J3YlMuxu0WEYQ==
Date:   Sat, 22 Jan 2022 14:22:49 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Laurent GUERBY <laurent@guerby.net>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 116/116] ext4: allow to change
 s_last_trim_minblks via sysfs
Message-ID: <YexZiWQiBELTsl81@sashalap>
References: <20220118024007.1950576-1-sashal@kernel.org>
 <20220118024007.1950576-116-sashal@kernel.org>
 <20220118090346.nw4ckd5smuvui2rp@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220118090346.nw4ckd5smuvui2rp@work>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 10:03:46AM +0100, Lukas Czerner wrote:
>Why was this selected? It is a new feature not a fix, it's not marked
>for a stable kernel and moreover it's incomplete
>(2327fb2e23416cfb2795ccca2f77d4d65925be99 is a prerequisite).
>
>I have the same question for the patches for 5.15 and 5.16.
>
>I think we should either drop it, or at the very least include the above
>mentioned commit as well.

I can drop it from everywhere, thanks!

-- 
Thanks,
Sasha
