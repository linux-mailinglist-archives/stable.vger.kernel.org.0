Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C387B53E
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 23:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387405AbfG3Vsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 17:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387818AbfG3Vsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 17:48:53 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A644C206E0;
        Tue, 30 Jul 2019 21:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564523332;
        bh=Gkgsgkc+pagnnDyvApbeJ+bgOv+hO1UoqiR4qAYPhkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kvKmYr04b4/dk0cI4cZDA34aJY67y7difyG6hWeCjteBWGdG27tBrq/Af/GHFWHAa
         3XV7KGD8ymJ8JzhGEpYbjTQ40ilfnlUyUwxPdFUYj36j9R0rn+bnI4WGEMSvyFsedw
         zmgowBbkcs6/Vts+ugiVY+dvua54Sx0wH9eTUiiw=
Date:   Tue, 30 Jul 2019 17:48:51 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Rodrigo Vivi <rodrigo.vivi@gmail.com>
Cc:     Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/vbt: Fix VBT parsing for the PSR
 section
Message-ID: <20190730214851.GF29162@sasha-vm>
References: <20190717223451.2595-1-dhinakaran.pandiyan@intel.com>
 <20190719004526.B0CC521850@mail.kernel.org>
 <CABVU7+sbS8mw+4O1Ct8EY_5cj+fnmNFzyd6_=v2_RmCgBRA13g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CABVU7+sbS8mw+4O1Ct8EY_5cj+fnmNFzyd6_=v2_RmCgBRA13g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 30, 2019 at 01:42:45PM -0700, Rodrigo Vivi wrote:
>Hi Sasha,

Hello!

>On Thu, Jul 18, 2019 at 5:45 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> Hi,
>>
>> [This is an automated email]
>
>Where did you get this patch from? Since stable needs patches merged

This bot grabs them from various mailing lists.

>on Linus tree,
>shouldn't your scripts run to try backporting only patches from there?

There's a note a few lines down that says:

    "NOTE: The patch will not be queued to stable trees until it is upstream."

Otherwise, no, there's no rule that says we can't look at patches before
they are upstream. We can't queue them up, but we sure can poke them.

The reasoning behind this is that it's easier to get replies (and
backports) from folks who are actively working on the patch now, rather
than a few weeks later when Greg sends his "FAILED:" mails and gets
ignored because said folks have moved on.

--
Thanks,
Sasha
