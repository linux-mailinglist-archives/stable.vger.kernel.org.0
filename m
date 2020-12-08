Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37062D2C0B
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 14:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgLHNcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 08:32:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728723AbgLHNcA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 08:32:00 -0500
Date:   Tue, 8 Dec 2020 08:31:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607434279;
        bh=IbD4Gbw5kQ4j7riiEpzl8xO9o50Kk+dCfuXoKBqmO/E=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bs3vpvwRoSAWUH7vXYuVQYqYhNW5FMFZbAGq3xmBV7Mz71dBcd1xbBbXfOx9jQx1b
         k1l3pL3V73tn2p1mGlricO+UkdsCzJ9ZM4oU6v4B0+aYMw7wxbkJVj768JXxNVVpie
         6K8XYl0g8+fLuz6r2Q6f7pBqLAkG6kqXU3SdwBGJbjTNgcioOd7EkUZg5jy/x4xWIM
         SBSipVjBlXQw8iDCkVeLuZaOdtQ6kD1/5fFTYOeiPMSSUWeBhqAE8JOudDaP34ErC9
         8ZP3ckARoTN4Vdu76NCLWiSE7LpddL/eX721XQS+LkpLz/biS3iqax3zkQznWPoSf+
         F6Qlc+vY7ZDDw==
From:   Sasha Levin <sashal@kernel.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     gregkh@linuxfoundation.org, josef@toxicpanda.com, dsterba@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: sysfs: init devices outside of the
 chunk_mutex" failed to apply to 4.9-stable tree
Message-ID: <20201208133118.GG643756@sasha-vm>
References: <1604411571222140@kroah.com>
 <20201208130031.dxffwwpu5p2lbvjh@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201208130031.dxffwwpu5p2lbvjh@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 08, 2020 at 01:00:31PM +0000, Sudip Mukherjee wrote:
>Hi Greg,
>
>On Tue, Nov 03, 2020 at 02:52:51PM +0100, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 4.9-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>
>Here is the backport, will also apply to 4.4-stable.

Queued up, thanks!

-- 
Thanks,
Sasha
