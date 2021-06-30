Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8103B835C
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 15:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhF3Nnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 09:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235088AbhF3Nnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 09:43:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDB8761427;
        Wed, 30 Jun 2021 13:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625060462;
        bh=3MWyFVu4VSNOc7aTpbwM6lBabgwvLOuLPrGXgnQuN/Y=;
        h=From:To:Cc:Subject:Date:From;
        b=Tj7a9EEEr8o3XnFZwmpnypKZiSu8gsgdzAQ4waDgdQTUfrgiaim/3IXeE0vQPoobV
         LV7Tv3jGM8eahvF84pwJhT+Nr+IutY5bza5N5nr0Vz8lUw5l7CX3bSzMr4Gsz0Nahc
         f85lykjNBTsiZ8nAPhOOmzH0+0V+M+KpDVuaagSjQQgKhKDqDNLcxKihekb0Gz224a
         H2OR6IuzUGQbCjHtHLcny1pGqPg2DWDAsjoePjHacOqnVDNhLmlh6XNZFsSh23Sfdz
         wCHmsvlvUYgX57v9Wt7lzXq3yQ0FOnE+R0GuOs9QJTcXmE+NW7kZy5eUh2ncdGb4Lv
         xtmUV7eAoBwig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 4.14.238
Date:   Wed, 30 Jun 2021 09:40:59 -0400
Message-Id: <20210630134100.478528-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 4.14.238 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha



-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmDcdGkACgkQ3qZv95d3
LNycCg/+KmyrChXSyZIUeUT5UVNeEEaR1zjJLORWvuHehW9Q4hcnvRlXuEGO7q5g
U+8XHm8H+hIjkwfpLmim1Jn6hMTx9P8fZ0t45YXkkXmPBoMCSySEiPpAKMaDQPxs
EU5ULrkNtTXiengdR6w13ayuSMSIacPyXFmY20OdzAnhtiXwgv5s9HgRDkcDZomh
M/Fqux6b16fXDS12qUdI7RbNUyJnWkBOm9KpE/zAzyMQlj0r/NUs1T02JS8/gWww
SfwgECLfvoFPNuxXI2Y9WEKQ40xx6Hb/Fzatvs18WjwLC+SvUfwPKlOyP6sogq+N
2kn7eFygkZzyDCL8GYv3ZVd/O8Km4kMWWthehJ/SD6MEzbIVlZmjCISivYA9fZVf
rLqWAdymiRDhJqak1pwsW8fVOBxJJYLMUJy3tv5Zjcg1bBWPrE4VufsntZt9YVdr
evpLVKeOU8p6aCdy7FwN+b/dBPriZt6oesNkhO3OMfW73FBesp8bgdH4Rhs9ISkv
lXb0mjYmE2ZJ6S+vKnRuHVDoiOc8u9fZnQqrCwNzI0QFltCYU9AZGI3cbmVH5a/h
/1TFCC0uVpwWquFuszkfvyItjFRpZhhjYsMZOB7jzCR/EDJakx2S5qsCMNW3bdQt
W5emHwENNkmlLEuRQwuoAbwfOPqV8IK9nO5goh0Sg4G45OzXU20=
=KrR2
-----END PGP SIGNATURE-----
