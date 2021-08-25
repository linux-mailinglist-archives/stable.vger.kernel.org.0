Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C2E3F6D00
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 03:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbhHYBQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 21:16:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhHYBQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 21:16:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76A7A6108D;
        Wed, 25 Aug 2021 01:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629854168;
        bh=WeW4mx+/X2ml4BYG28f+Jlc52d5fjvq+/h4tbKpAaI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nSHwyJj+fme1XdpW2fVqm4xKzeSfGqEIhKlW9/OR75UniXzi5ApLSKR6EkeqbqhdM
         aS7UPVHuBiRRbZAlkoBYGDFkVkaDMkOnbOyNgpPXHVc3oxRlEs3BRLG4lGkcVkbqjd
         4QwIoprg9tGZqkVW4XCVj0DGr3zNxC/PDaA7OP/+s0S1krTkU014CYqRWTiZAeH8Ag
         Ao8VnZ6ltL868LTT9gPZRX5Ve1Uaq0/dgTPevMi9O7Z3rCRV94BFRyzR7/BaRKSkfN
         puk3ojNkwXY/7FVnG5wUf1J07+ikS5rVV+CBCScBVC9/0AX9X2cAjWDzj64T3QXCm5
         Z82W07qA+EcJw==
Date:   Tue, 24 Aug 2021 21:16:07 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH 5.10 10/98] vdpa: Define vdpa mgmt device, ops and a
 netlink interface
Message-ID: <YSWZ1/MosL/pwc2G@sashalap>
References: <20210824165908.709932-1-sashal@kernel.org>
 <20210824165908.709932-11-sashal@kernel.org>
 <20210824185452.GA15995@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210824185452.GA15995@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 08:54:52PM +0200, Pavel Machek wrote:
>Hi!
>
>> From: Parav Pandit <parav@nvidia.com>
>>
>> [ Upstream commit 33b347503f014ebf76257327cbc7001c6b721956 ]
>>
>> To add one or more VDPA devices, define a management device which
>> allows adding or removing vdpa device. A management device defines
>> set of callbacks to manage vdpa devices.
>>
>> To begin with, it defines add and remove callbacks through which a user
>> defined vdpa device can be added or removed.
>
>This looks quite intrusive; is it meant to be in -stable, or is it
>some kind of mistake?

Looks like a mistake: I wanted to try and backport the vdpa patches that
are in 5.13, but gave up and forgot to drop these.

-- 
Thanks,
Sasha
