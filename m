Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AA5256E46
	for <lists+stable@lfdr.de>; Sun, 30 Aug 2020 16:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgH3OCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 10:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgH3OBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Aug 2020 10:01:43 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4332B206FA;
        Sun, 30 Aug 2020 14:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598796103;
        bh=GrKjwqbB36PFlv+VL52hfanxgYYv7g3LAQMJiKNqP/w=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=uOB3n3GKWoKVKWYRTVqqnjOp2qLuWQDzW5mmE0x7mph9frOBGx1euNBwGDZtShsQl
         u4wTsiXJrj4eyWLPYYRbn+GmoWjX0PMXV1NbH3EpDrGLLIViAEzeiXL6jTZ2C8znuE
         331VErKe0UhREDfYDnpJctj0/dfZ0C8qySQxkkPM=
Date:   Sun, 30 Aug 2020 14:01:42 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] fat: Avoid oops when bdi->io_pages==0
In-Reply-To: <87ft85osn6.fsf@mail.parknet.co.jp>
References: <87ft85osn6.fsf@mail.parknet.co.jp>
Message-Id: <20200830140143.4332B206FA@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.5, v5.4.61, v4.19.142, v4.14.195, v4.9.234, v4.4.234.

v5.8.5: Build OK!
v5.4.61: Failed to apply! Possible dependencies:
    898310032b96 ("fat: improve the readahead for FAT entries")
    a090a5a7d73f ("fat: fix fat_ra_init() for data clusters == 0")

v4.19.142: Failed to apply! Possible dependencies:
    898310032b96 ("fat: improve the readahead for FAT entries")
    a090a5a7d73f ("fat: fix fat_ra_init() for data clusters == 0")

v4.14.195: Failed to apply! Possible dependencies:
    898310032b96 ("fat: improve the readahead for FAT entries")
    a090a5a7d73f ("fat: fix fat_ra_init() for data clusters == 0")
    f663b5b38fff ("fat: add FITRIM ioctl for FAT file system")

v4.9.234: Failed to apply! Possible dependencies:
    898310032b96 ("fat: improve the readahead for FAT entries")
    a090a5a7d73f ("fat: fix fat_ra_init() for data clusters == 0")
    f663b5b38fff ("fat: add FITRIM ioctl for FAT file system")

v4.4.234: Failed to apply! Possible dependencies:
    898310032b96 ("fat: improve the readahead for FAT entries")
    8992de4cec12 ("fat: constify fatent_operations structures")
    a090a5a7d73f ("fat: fix fat_ra_init() for data clusters == 0")
    f663b5b38fff ("fat: add FITRIM ioctl for FAT file system")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
