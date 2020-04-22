Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71CD1B3428
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 02:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgDVAuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 20:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgDVAuI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 20:50:08 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 087D02070B;
        Wed, 22 Apr 2020 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587516608;
        bh=bF7X9h26ISAZy0y8EdjOKnsOs24egAoS183uGUzNkmw=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=FHKSEzZYJriFNaeXlgiLofnNxLG2IBj7Y9yYcZbdKeX0pJ5Kg13MuZPPih3jeRgWT
         L52QEt9VbtHWQuRPpT/r9Jc6+tNVwpodXMREih72C0twWl2KdifAQddOp4hEjASf+i
         g4tyJwyHpZCNzF7xBGwqMiFTTzr6CwQIZviWIFEM=
Date:   Tue, 21 Apr 2020 20:50:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.6 051/129] btrfs: handle NULL roots in
 btrfs_put/btrfs_grab_fs_root
Message-ID: <20200422005006.GU1809@sasha-vm>
References: <20200415113445.11881-1-sashal@kernel.org>
 <20200415113445.11881-51-sashal@kernel.org>
 <20200415132224.GB5920@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200415132224.GB5920@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 03:22:24PM +0200, David Sterba wrote:
>On Wed, Apr 15, 2020 at 07:33:26AM -0400, Sasha Levin wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> [ Upstream commit 4cdfd93002cb84471ed85b4999cd38077a317873 ]
>>
>> We want to use this for dropping all roots, and in some error cases we
>> may not have a root, so handle this to make the cleanup code easier.
>> Make btrfs_grab_fs_root the same so we can use it in cases where the
>> root may not exist (like the quota root).
>
>This is another patch from the preparatory series, not needed for
>stable. Please drop it, thanks.

Dropped, thanks!

-- 
Thanks,
Sasha
