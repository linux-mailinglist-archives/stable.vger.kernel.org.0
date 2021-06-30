Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2863B8366
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 15:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhF3Nox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 09:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235400AbhF3NoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 09:44:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB7956141C;
        Wed, 30 Jun 2021 13:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625060500;
        bh=bJQvtw+YmElMeSwYRXTd4sXN93zJ/YTQRGnr/ZBMkLQ=;
        h=From:To:Cc:Subject:Date:From;
        b=AVunaaLrnk58Ux50WtwZS17m7+DKCFysCtu42yApQspO8K7W6oSx1r3YND926MZV/
         vGFflvRWyYwP3cQbzId1nulsCeNhKutl+Q04gwfkH0ISK34By86pIfE37a2Iti8CM1
         8FPC5spyoSFZuv2jzbeqMnzHwaSc88UEgf7Dcl9VJrjQK7wrESzvKafulk9RoPihq+
         q8l/kHD3O2OPUsyy3tBc8XDyRe5EyYy2gE06dDugH1DJCqcd/pA4jIfTHwY/l/z1K4
         z1w7GFvTtVQwf3TUH/TCZMthIEXLISS32kok9aD0xW650/PUCnZ7GknDXe3zEKS220
         emcAjLHZTqfBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 4.4.274
Date:   Wed, 30 Jun 2021 09:41:37 -0400
Message-Id: <20210630134138.478707-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 4.4.274 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha



-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmDcdJAACgkQ3qZv95d3
LNy2nw/8DjXdbC/e2QMD0vKWBKmEeJv4IdTEqZ0UFy6TtXYEu5xP6nPjQwFj1QBe
QEjA2/E/OfbVvw03VmkJCYhIJHNjod7+qc2fjwiYqwjuanzaEL1r1bwjvuAWEWir
4Dv7Ld24qGvPIku/9/O6scdEYhCxJD0nmP1PoYi65+qysdKz0Uz9/H8NGMg/4EOL
N0SO402K38PXMpSqNVQO1j/geBhGMEdKYPCCHbYtuTI2HTp+cz24dHuJ3qCnNZvu
6TLienmeqrfSHWZcy5Ylfe4pvac79ZOu2k8R/bOaldoDJEKsGIvhcXkW148u9J2R
344QhW7kf+qyjWbuYUTRT4MCJMU7gmSxOUpKj9uk1k0flC6kQlOmJgxK2tWcI76R
NhokvUXNDMBhD15FkomU2djDTeZlE213UNPerf3rdIvobCzqWKyQRhmf7UuIKA73
gukTSnVr5qW9PpAWsIoIeNVK/MTgqLX/KMTOOVjudPwo9ub+KeGgffWBK5JUBagX
a0THRt0C+bRoSQw5AWc/Wjbk5yd2ZIfmrLWRTjfAxWkEzOmd5k+1xC4BhrDMw/+f
ltsplL3LVFQ4vnUOiRsJfiLxVSPxdHP0xqhdSi/v2BKVyvwooqygv+2E+yCx6ChM
EkmJ7I3Nx+90WUxN4aKS2B4G8yX+r2p3XXzPomXkkqhkoOm5odc=
=dnqU
-----END PGP SIGNATURE-----
