Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4DCD126E0C
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfLSTjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:39:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfLSTjD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 14:39:03 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF46C227BF;
        Thu, 19 Dec 2019 19:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576784343;
        bh=uJm4jvux9MuuNbHKtwxAPbxkxjWoPXqWjllj1M32RjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZbLazEACfPBAOHrYpCHQeXom0uBE7xt9sHfwefIGotmi/OGyzl2JI8metT64wkYBK
         sKQ7XcHenPRlDV7RVBc31L/OBklaSENRaH8Umi2qZLdJFeL8D8aoNiXwMUjMlVL+TU
         pTc3j2CjLiUe9Lj7HhBTMHSWjfpu4NxyGitKs+fs=
Date:   Thu, 19 Dec 2019 14:39:01 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Lyude Paul <lyude@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Juston Li <juston.li@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>, Harry Wentland <hwentlan@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 5.4 143/350] drm/nouveau: Resume hotplug
 interrupts earlier
Message-ID: <20191219193901.GO17708@sasha-vm>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-104-sashal@kernel.org>
 <90e9126b9692ce6a1b0fcd85a4d0327bf818e58a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <90e9126b9692ce6a1b0fcd85a4d0327bf818e58a.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 04:29:54PM -0500, Lyude Paul wrote:
>huh? Not sure how this got put in the stable queue, but this probably should
>be dropped. this was prepatory work for some MST functionality that got added
>recently, not a fix.

Dropped, thanks!

-- 
Thanks,
Sasha
