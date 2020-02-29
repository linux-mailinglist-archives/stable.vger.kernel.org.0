Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 422141744BC
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 04:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgB2DnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 22:43:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgB2DnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 22:43:03 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5700024672;
        Sat, 29 Feb 2020 03:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582947782;
        bh=kehOqU4lwXS3xMCDwNME9IhyL745b193M6N5KV3bkgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oaFkT8ysj9fNTGUX3hw5HggWCF2XaUlIH/Ah6GTnAGZSNPm/c848Ygotk3Q7ohZmq
         qPY8oINxBRl7+Rb2X0n5U1rbH6pxjg05oNiMGEdEXRdPCoYRWM6/NMoqkp60siwdt2
         MKJToNVG8W8fyWRm1zuEDYjtzym2EoA/Ct/FgoT0=
Date:   Fri, 28 Feb 2020 22:43:01 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org,
        Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Subject: Re: 5.5.6 regression (stuck at boot) on devices using the sof_hda
 audio driver + fix
Message-ID: <20200229034301.GG21491@sasha-vm>
References: <e15641c3-2cf8-db66-3eeb-019af4b482db@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e15641c3-2cf8-db66-3eeb-019af4b482db@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 08:39:04PM +0100, Hans de Goede wrote:
>I know that the stable series are partly based on automatically
>picking patches now. I wonder if the scripts doing that could be
>made smarter wrt rejecting patches with a Fixes tag where the
>fixed patch is not present, so where in essence a pre-requisite
>of the patch being added is missing ?

The scripts actually look at the fixes tag and try to do that, but it
looks like they didn't handle the case where the commit id pointed to by
the fixes tag doesn't exist at all.

I'll go fix that, sorry :(

-- 
Thanks,
Sasha
