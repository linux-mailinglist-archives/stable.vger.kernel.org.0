Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80ED43B833F
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 15:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbhF3Ni6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 09:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234784AbhF3Ni5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 09:38:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30E4B61261;
        Wed, 30 Jun 2021 13:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625060188;
        bh=EsSA8nDL9f657eIBKK4X8XbDPoLd5F1gqU+0NOOfMrQ=;
        h=From:To:Cc:Subject:Date:From;
        b=eF2Vps5VPAHeAW3McuSmaEclLmiqDXCbMKo9/yr1plkVxauih+YYogshH2uQD8rvo
         30GkTtjibHbrj0597PSr1NloH2BEsbTo5NqZyIU8OvFRH3j8ceckfBfEEaghZAX7TX
         aA3jMiDNuxwST9p6br6Lo0u9iZsq74nK5CjdDrhvXVZKuEAn6gfFW+6KhwfFZRlkYw
         HxnPGBdxIZIGK48/tHkOHhBgI9GABOXgIQN9JpsCnU2ahD1GCfx2p5OzfAURGqFKxG
         Vkhvl+PMetLsairYjPXAE6hMY7aFB9e6EToH+GDpVwB0iJZmu+8mhjmg16Kwjw0wtJ
         bZ3d6uDiXZobA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 5.12.14
Date:   Wed, 30 Jun 2021 09:36:25 -0400
Message-Id: <20210630133626.478045-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 5.12.14 kernel.

All users of the 5.12 kernel series must upgrade.

The updated 5.12.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.12.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha



-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmDcc0QACgkQ3qZv95d3
LNwH5w//TFlFjU8wQBo9akQQjQguKKAiuIa6Mw21rWbl7kJbQpANN34+CiSF8IKS
zlDmuAcAGASQttQ5Ud0TgF7wkrSFdDEwGKXeqrAmHTL2ux+1dTImBSeFAlIuEPYH
dcZdhrHcrPnQGcOwrh9oE0DBJRRVyztPgqAZXXKtvraPJQnCmr5UryI31C7t2ZjQ
vvtwMXNuYAzmqe9tsWYdEY4zk1cqMLWKjK1a4ePhvknnq+NSolzmv9WYJER1gjxN
j5BXKms2RUZjbWql456rP0k2gRxsL2A2ZEnUzxDMgbwQASSEcQzLjpZIjrZWrteM
kunUw8Qyq6FHLnmavE/l4g1tY6wPDljw6Y80Yijlr9yYgCEOvaBuKNMpeUoiwNhb
WyeebAFDycuguwjpE1Fds+Qb8LgVKyzrXWgHMU75H9+VFRPIShXWgyll77DsJL8s
9Fgt8IVUCC0IyPKERsgkJ7xfWa6K5Icrhlf5jpymIZjGMfhv9G/C86CdAkBwRB9f
oD6lHy/CPffzzUPuI1eSiGEv3RXHlJwrs0GWrkDJfoObli2lTXR6olNblhJwGh2y
bZ26x4NU88oHUBuizMkmCiL9NK/usMfWQZdlDJ7rfPrLiHjQ+Xdf7+ORCCa35ahE
DRGxrF7EpIxMjgq4LEKTlKbvT6AqsAjdw+mhjpoQoE1W6WcebkM=
=Q/ui
-----END PGP SIGNATURE-----
