Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B91516634C
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 17:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgBTQkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 11:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728090AbgBTQkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 11:40:03 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EFDE207FD;
        Thu, 20 Feb 2020 16:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582216802;
        bh=PqIjxGt93AjPELMvVrU2wYetUIUHuYPZgdc3HCIgm3k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H4j8QyF/I0J6liLlhOQF7i+TJe+fnAR9AOelLlYOgFf9aMhnhS8+ZHGbNtogrpEJ2
         Og9Qk1IZiQSugdI+6weBt8zE3GT7ui+HqCZHRwYRUwJKJJeJcu7Imez1kZ5/1kNHwW
         NTdKgGYOj28UpU3emLOrJ+Udzya/NyJijlVU4IwY=
Date:   Thu, 20 Feb 2020 11:40:01 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>, rsiddoji@codeaurora.org,
        selinux@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 190/542] selinux: ensure we cleanup the
 internal AVC counters on error in avc_insert()
Message-ID: <20200220164001.GD1734@sasha-vm>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-190-sashal@kernel.org>
 <64b56666-4e4a-10e0-0a1d-60ee28615d23@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <64b56666-4e4a-10e0-0a1d-60ee28615d23@tycho.nsa.gov>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 11:07:37AM -0500, Stephen Smalley wrote:
>On 2/14/20 10:43 AM, Sasha Levin wrote:
>>From: Paul Moore <paul@paul-moore.com>
>>
>>[ Upstream commit d8db60cb23e49a92cf8cada3297395c7fa50fdf8 ]
>>
>>Fix avc_insert() to call avc_node_kill() if we've already allocated
>>an AVC node and the code fails to insert the node in the cache.
>>
>>Fixes: fa1aa143ac4a ("selinux: extended permissions for ioctls")
>>Reported-by: rsiddoji@codeaurora.org
>>Suggested-by: Stephen Smalley <sds@tycho.nsa.gov>
>>Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
>>Signed-off-by: Paul Moore <paul@paul-moore.com>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>You should also apply 030b995ad9ece9fa2d218af4429c1c78c2342096 
>("selinux: ensure we cleanup the internal AVC counters on error in 
>avc_update()") which fixes one additional instance of the same kind of 
>bug not addressed by this patch.

I took that patch as well, thank you.

-- 
Thanks,
Sasha
