Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7324D3B8365
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 15:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbhF3Now (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 09:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235184AbhF3NoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 09:44:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7523F6141C;
        Wed, 30 Jun 2021 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625060492;
        bh=WyfkpHMTdnYoP7+u7JISZs1x32PIha9AkIc6fChPD14=;
        h=From:To:Cc:Subject:Date:From;
        b=QwESRFYsjg9ulbIe8GPgHuIOnMui4KPf8ChV5k0iI3GCk+PQQIogckEvHtAUtrpjg
         2dvwYQIpSXk4+RrwAb0KwhgLFud5ezJyJZfKH0UzwhWhH9Jg08CAcoOpeuoq404RyX
         8msMzM6pSrQbkEAQxPy0Nl/6AdrzI9LkY+mHibCHI74m7PDpeRmJCYnh59Jb7FMnRl
         rSmU02utQZ6NYncU73eGs1KA5anlHCQ2CqEiZs25dVRpgNwNom7eapeTu+SwGzAzGH
         FNkG+bw4pq6Bjn2doRqDuWz+luG+JVboUMqUXlUPh4b5wzhP7vFwl4s8GL3K0Px/Aw
         TlYpBPXuolbRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 4.9.274
Date:   Wed, 30 Jun 2021 09:41:29 -0400
Message-Id: <20210630134130.478617-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 4.9.274 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha



-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmDcdIgACgkQ3qZv95d3
LNwY3A/+PUro+6tW4eV+l/s2KhV16XpQeyj4d3r4rA3CxNNS7vRfe36EE2c57Y7y
ij+qHzrSphoA8WVfWbTVwRwxX0WLaOsNRD2UKHzg9Ngnd3EVnEks/g0Cu3FIKaEK
v4GSwNZCUB+TjS/i/VGPdbDMGYNA+S13A4qLf1cX9ZZcbZzX8cQuLO8UBIzeCFzX
M/IajOd+Z8vocrXcThGlXnsVcDGGg7wTd7D5jq2m14xsTYzt8XiS1Bk5a1kBVvrH
XjMhB2k7XaPd8cydK2lg7MQSPqEJzUEssyJKl1odkFcP5h+MrcN7FbBREbZhD3L4
ivvEx0zJnityqdS3av7UQC/OFpL8giSb560hHI3/K+Pe6Ww/DnwqEgNM6SuxmSyX
8ee7DDvUmEOsFIPJPG7zfesowGy1OVFZGPFQtRlb4wUncWJdWrbO1bSez3Kh/2Oa
VaGtmzgRWDaYOvHroVQqAFOXKG01geVgatRojLUCoo0SDKDcF5gCLhUkHVlhSuLG
oZJpboUuAfQcvU9fMFTSn6AuNa1MX9u820/jC3sG8cFh4rH9CKQMBtMDs8D5bxd+
Gp5uPd+KSHY3S2xfSzmXSX5XlOHXDep/4JRwZOZpH/pcv7bzC5qfh9veRjZoIo+a
qcjW8xJ/VqL/+Y/RMYXJAV4lQTsAkQkJK62Stj/Lz0Z5sPxfNkw=
=pF1+
-----END PGP SIGNATURE-----
