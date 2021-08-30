Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E588B3FBE98
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 23:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhH3V4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 17:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237167AbhH3V4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 17:56:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7994E60ED8;
        Mon, 30 Aug 2021 21:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630360507;
        bh=W3FLU8gKLc9GCcD7kgJR6yhTYKb+vrDK6w3Axm758MA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YZR0pdRppx4wUEaNfzSf7iTfZVQD1Tfoe3bH0ibMgfO12yGf29NeVQFwta5YFgPPq
         lIqOPOUohjBVuxc9y2AIRLtSGvV8o6EpeJQrEFwqctMFBsXZxOiaD7rk3D1pQ/IdRy
         UG6Dpn1k0nXeGpUY7vitD/jBjoccq7nN7l3bBXyIoCRTNmOR4cGZTXS+99W6tlBN4K
         MBnI/w5SYgssZBRonBlmkJGNgsaNq7vwFuCUxyo5++me0EtwYD+y8Ca9jhSlqQ7P3j
         hxX0fj19CGwlRXcnl36YQV+S2lCY7M0IolCEl2qyrvRCimJTy6QiFSHymReJnPBTMG
         CwwND/xBZggNg==
Date:   Mon, 30 Aug 2021 17:55:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Lyude Paul <lyude@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 5.13 20/26] drm/nouveau: recognise GA107
Message-ID: <YS1TuuepU+VpVvcp@sashalap>
References: <20210824005356.630888-1-sashal@kernel.org>
 <20210824005356.630888-20-sashal@kernel.org>
 <6607dde4207eb7ad1666b131c86f60a57a2a193c.camel@redhat.com>
 <YSzMR4FnrnT5gjbe@sashalap>
 <c0e64fb9332b03c920de05be4c4c27f916ff6534.camel@redhat.com>
 <0777c34ddbd22ae247d293cf013cb763947b0b50.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0777c34ddbd22ae247d293cf013cb763947b0b50.camel@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 30, 2021 at 01:09:24PM -0400, Lyude Paul wrote:
>oops-except for "drm/nouveau: block a bunch of classes from userspace" of
>course. the rest are fine though

Yup, that one is gone :)

-- 
Thanks,
Sasha
