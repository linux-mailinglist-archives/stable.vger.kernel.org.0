Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8C0FA01C
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfKMB1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:27:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbfKMB1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:27:40 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16348222CD;
        Wed, 13 Nov 2019 01:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573608460;
        bh=cy+L60Qy7wwfV9YrX33f7ctlru7kjaXSUmLoEaGwNEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cc2ghfxjXaKQIcw3GWki60ue09JYLUyQMWhVkxGSaM77Wpf6rFFZ2K6iJTbL7m2fJ
         yLV5KNAmCMMjQ0+sMzHc7dYp1eI/UyWb9zQKk6JHOhxpu20ZBZjcrfJ5QHfiY0dbki
         bGcMjWCdAPwA6+T6r6n2ULiZ3lLAahwPQxE4QYKE=
Date:   Tue, 12 Nov 2019 20:27:39 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     stable@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org
Subject: Re: Please consider mainline commit 9393c8de628c for stable
Message-ID: <20191113012739.GN8496@sasha-vm>
References: <3bb75710-9e53-4896-b368-a3c5a3fc7fa8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3bb75710-9e53-4896-b368-a3c5a3fc7fa8@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 12, 2019 at 03:52:47PM +1300, Michael Schmitz wrote:
>Dear stable kernel maintainers,
>
>please consider including commit 9393c8de628c ("scsi: core: Handle 
>drivers which set sg_tablesize to zero") for inclusion in stable.
>
>The commit fixes a long standing bug that affects all SCSI low-level 
>drivers setting sg_tablesize to zero, introduced in commit d285203c 
>("scsi: add support for a blk-mq based I/O path.") around kernel 
>version 3.16.
>
>Use of the option use_blk_mq=y in kernel versions prior to 5.1, and 
>any use of such drivers in later kernels, will result in a null 
>pointer dereference from the block layer.
>
>I hadn't expected Martin Petersen to pick my fix over another one 
>submitted by Finn Thain, so I never added CC: or Fixes: tags.

Could you provide a backport for 4.19 and older?

We would need to work around not having 3dccdf53c2f3 ("scsi: core: avoid
preallocating big SGL for data") in older kernels, and I'm not confident
about what I ended up as a backport without ability to test it.

-- 
Thanks,
Sasha
