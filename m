Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42FB177FF6
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 17:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfG1PE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 11:04:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfG1PE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jul 2019 11:04:28 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2376A2077C;
        Sun, 28 Jul 2019 15:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564326267;
        bh=mT7Z7O7O45mTYtMbjcLI7Ljm8CqwfPH60X45YZtD8i0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pn/Xyv0U9G3kXdbCQeF5Uermkji3a+M1UdIOqG1dxTDAH9iVMdTcuZtQ33BNGKcpn
         kql7xsbJbdZbd1EmoFDuwVeP1cmamFWjyQU9V0T4DsepM/zTSHPfvZjGein5fUyBHn
         5ugnexsn1M4Rhxnu2bWS5i1P+lW5Pal8c7P3uu28=
Date:   Sun, 28 Jul 2019 11:04:25 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Qian Lu <luqia@amazon.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        bfields@redhat.com, ctracy@engr.scu.edu
Subject: Re: Request for inclusion on linux-4.14.y
Message-ID: <20190728150425.GD8637@sasha-vm>
References: <20190726213635.GB1900@dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190726213635.GB1900@dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 02:36:35PM -0700, Qian Lu wrote:
>Hello Greg,
>
>Can you please consider including the following patches in the stable
>linux-4.14.y branch?
>
>An NFS server accepts only a limited number of concurrent v4.1+ mounts. Once
>that limit is reached, on the affected client side, mount.nfs appears to hang to
>keep reissuing CREATE_SESSION calls until one of them succeeds. This is to bump
>the limit, also return smaller ca_maxrequests as the limit approaches instead of
>waiting till we have to fail CREATE_SESSION completely.
>
>44d8660d3bb0("nfsd: increase DRC cache limit")
>de766e570413("nfsd: give out fewer session slots as limit approaches")
>c54f24e338ed("nfsd: fix performance-limiting session calculation")

I've queued these 3 for 4.14 and older.

Note that c54f24e338ed has a fix: 3b2d4dcf71c4a ("nfsd: Fix overflow
causing non-working mounts on 1 TB machines") which was queued as well.

--
Thanks,
Sasha
