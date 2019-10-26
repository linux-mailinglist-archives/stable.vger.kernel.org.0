Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49252E5DEA
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 17:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfJZP34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 11:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfJZP34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 11:29:56 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 775FA20663;
        Sat, 26 Oct 2019 15:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572103795;
        bh=7bDy0tt9zpS5NCLVgX24iEPWYoUYIoqUv866wtEpd/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h1Mo0hA83F+IruKPal8A7Xt3eFcA0MqHKmxIQ5j2hA5QUG7QM9FDJyOcc8jzXeIhE
         vnsEE3AwlW3Q9GlEz/p0jpZc3xXDTgDWKE48aPhKIiAENNcVc2fl06cKuP0S9pTBgK
         icQMuLGggXG/AnD4PWMorLAK9+KPgbJyZIGj/zD4=
Date:   Sat, 26 Oct 2019 11:29:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Micah Morton <mortonm@chromium.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Please pick ("LSM: SafeSetID: Stop releasing uninitialized
 ruleset") to 5.3 stable
Message-ID: <20191026152954.GI31224@sasha-vm>
References: <CAD=FV=Uui+a6TS85VNv3XVApq7xYifd8m_ZTmShTC2jeGEO4jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAD=FV=Uui+a6TS85VNv3XVApq7xYifd8m_ZTmShTC2jeGEO4jg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 25, 2019 at 09:44:09AM -0700, Doug Anderson wrote:
>If you're still taking things for 5.3 stable, I humbly request picking
>up commit 21ab8580b383 ("LSM: SafeSetID: Stop releasing uninitialized
>ruleset").  While bisecting other problems this crash tripped me up
>and I would have been able to bisect faster had the fix been in
>linux-stable.  Only kernel 5.3 is affected.

Queued up, thanks!

-- 
Thanks,
Sasha
