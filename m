Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B5F3B8358
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 15:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbhF3NnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 09:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235025AbhF3NnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 09:43:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B53676143B;
        Wed, 30 Jun 2021 13:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625060451;
        bh=6P41aEE/i+PbzC+0zXyPMHL0zMrcKnbl0Jg7BPn+eos=;
        h=From:To:Cc:Subject:Date:From;
        b=AioGx2nrcHQ33ysvD/CXxmm4Bzjy6Y3XDceTUrnJrwHG4iRFVv44cJr+HhMZwDHHm
         Td/QFXI0VjQysR33ORi4f9XT0kmLCiCI6QlTfphtiTo3S3vuA8ERNuPnlB/StVfaLR
         ZZa7x3t8rH0GkOaSGKRAFxgY2FuKlFMeInrylHccAExMEaKrMNNchhDnO8REqks0O8
         ge3iEPCqBMb4WE7gtU/CLMOgyhl98LAN9gDE0VHu3tgwH34PqfACdnUvazKGkzYafs
         rPIkOjN7vYHGwNrC5+QwGtdBA+B+DrqNsgcKAHxo5mWdjR089rehQz2jxksB/2jTf5
         DAR87hP96Ihzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 4.19.196
Date:   Wed, 30 Jun 2021 09:40:48 -0400
Message-Id: <20210630134049.478440-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 4.19.196 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha



-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmDcdF8ACgkQ3qZv95d3
LNyFdxAAnB9VMQ9XCMIW0KFIuc84l34tHe7bexocQHEGxWFhsJEnyNzGGcZxlY7G
XKlHXzh7QWPWuf82jt7fNSrctyAO6Kun3VF5ucGsixgCStb+0byHHL6F4N9eEdPH
v2h8HA46OTGShHBLsMsFsLLVY335WNSz+YnI3tXmHuMcgckUPDYoS2Zh0GFJTrsF
jW4YCheGMtcJHU80D8pUyEucb4GdyasNHkwW2d5vn7PhKNtr4Tv2rRjF2/EHWdog
RZ18hHzJRI/DwGrVwLXy8hcaVG8qp7b1Se5lRIZIFaYxRjXs7vpqFngabXoq8K1l
Q2OaQNvlKVDNBJnnSumu1mFxZgWdixQ3i9qLVhSvS+yAilP45cHZkkGee+6uchJE
vJc4WVV08NTfUTbPBMdCkHCfLRai06qdkOxf9l4YX5Phs86gi6SCbaKZMA5mUpWr
bw9KJi5UgQLYfETzagJmncCm+BqGEnVzMGn98kUgAcxLWIMerEg7AaIL0Jul0Gig
GElwsTo1O4byu8Ee0sF9nppW6iB+FlBqOVepwy+d7RocaihKyssm87Gwvoy+Py8b
4yH1MGFGP2Un0SyKGUz7t3RY/hD8glmILHs/l+1UTeb8RkgZDy3iw+Cbrcu0CWQq
JM86nlanh0UyklQ2lM51DIZqSWs5J6BHyJyuGNs6CrbjltlGbHo=
=TGQ2
-----END PGP SIGNATURE-----
