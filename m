Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624673BE832
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhGGMuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231510AbhGGMuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:50:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BC7261CB2;
        Wed,  7 Jul 2021 12:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625662057;
        bh=ZqXQlSjAm7cqqV/arwmOtPgLf/xwWshR0vWS+077ml8=;
        h=From:To:Cc:Subject:Date:From;
        b=bHCE2+B9ACj4df+1S52kaOWEA/o//g6k8lQ2uFrgNv8AqMk1hW+JfOvnjkCYXReWs
         ba5tONVw5U3aHB8juWWvUK8dqxiaYK/IHJa6NPo8u9DoTgouV+12YCNs3KxlzD7ug0
         ylgdjCuqzQtQhffkc7woX5vf8RTgJX26On7IrD1Lfy6Qdy5iB+E0XWcF2gk8GZ3LQY
         CWyCONKJQI/Az8S6XxQF5ZlByL+ltDlH2WBLfzRd2BN1G0WAlDlhpfqn35vjbe2aFr
         5d83+EVr1tJKnbjue7uOsKPXGqA/DNrPOkozXImq6HFpUwapoiPTLiVinsj1TaJVYB
         6vU1oqBHFgr5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 5.13.1
Date:   Wed,  7 Jul 2021 08:47:34 -0400
Message-Id: <20210707124735.2443267-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 5.13.1 kernel.

All users of the 5.13 kernel series must upgrade.

The updated 5.13.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.13.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha

- ------------


 Makefile                        | 2 +-
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu/mmu.c          | 1 +
 mm/page_alloc.c                 | 2 +-
 4 files changed, 4 insertions(+), 2 deletions(-)

Mel Gorman (1):
      mm/page_alloc: correct return value of populated elements if bulk array is populated

Sasha Levin (1):
      Linux 5.13.1

Sean Christopherson (1):
      Revert "KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmDlolkACgkQ3qZv95d3
LNyHdw//Yv2YwPIPDRntmmSPZE2E0MwOZu+W2B+OoKJHJ8MJeYpMwoNwObwqoa7u
7oxHuiUgQ7iTBcvDdvwLCDAKZkIa6sm5WAb3x5qzmvQNYIAWsQrsHo42A1yhMLIT
YMuo7GQkn5E9WNs+aOGrI38Ea91Ckdd5GcwsKRcXuY30phvnzTEVoXKdLzFJFOWk
O/8nbDT1X+msLxndzwW/Vl4AAiaYbnQpzSyhFiswD4r0jYL5yg1jc2UaWUxSP+yj
mbgZ2QQAHh1dvE4rzPyl6tmFhVDg+yiT6UO1f7tont8FA4dUdJ4sJDW2QINKXRxf
RwEY6fsU9kcpH2IfZa25Fi2E+kesKEeT0a/uCGJOYmZZkXfPtnlNHE4FVlKdtlRh
q761ApqR5JGOXSE08iSxTMXJNsbyGxG4CYP8vbUhYm/wIJbOqBCF9DOkH7sr5MA4
TyWuG4uexfmE00dWfljuAma07Sd4F+mILsC/55O9lQt80aiSRUsuoFM6e7FQmBgj
g7uSEzm476z/4B+v1ewjPfT6gw4KGahV9a6EfSztm/JdvotFaImkjdYneGuSkmaF
56rt3ZF+7LD05mK9/nQd713F2hOD6yVzyIiWiSzO9250qRMb3SR0xjaUC9iKpuQb
/VkcKU+yMLbZnZwoBONedk/gfnKpvjzo/9EBBWOLyln0FWVuBdA=
=QsF8
-----END PGP SIGNATURE-----
