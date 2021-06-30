Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3283B8352
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 15:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbhF3NnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 09:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234986AbhF3NnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 09:43:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 925446142C;
        Wed, 30 Jun 2021 13:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625060436;
        bh=Yg/r5yd+HEwut3JSCt2oS4nf6XqfQ6sO3BuW7f5M4vQ=;
        h=From:To:Cc:Subject:Date:From;
        b=jGblHpgW1dRx6kKDNLbDkQGUo22wWyxZ0qScAaHFGyorqwONv/Mx+Wh9VwvyXCijN
         GtZ7DmqL/036rBdOxUdXpX+3PzGdf/MwDh329eYcxfHZznHuTJDihOMdCDFerFV5d/
         jVekSXzNghPVaonzGdbeOTkZuwxABLlq3QmHCaWvWNZ9y18VgTZtKPeGoVx/Nhfh/d
         ineNdfWjJDMfBV6ii3jy0jc8CS/3m5OdbxrgDHt4vAOtB/NQl2ecEZNdvkwHRUe8oO
         GMUPCJ0/07LR670zCb4BlFulWHw7uR8tRpO4/NIdTAJ19i7L9QVHxY1j6eiAKXGHsQ
         /3J88sbQrq11A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 5.4.129
Date:   Wed, 30 Jun 2021 09:40:33 -0400
Message-Id: <20210630134034.478351-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 5.4.129 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha



-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAmDcdE8ACgkQ3qZv95d3
LNwMew/9HLxjRRYhe6jCrc66+H2ekkh7TqhkWrgr4zEzYg2k4Xb34MKsq6/jowkw
BuAQdY2R1Hrg3UgjmXMnYw6aCVOyOFbbsmK1A07CjW36a4IFrKaKLmdL0nKJl5Vr
V+y2v8f9uJfJ9ceN6VdUR7hH1bJLRuoTv0klKOBcGEvvInZiZ2qxzLujVCWYD8CF
a8xwvtzt/QWAsPrfMFPa6voLZkLPfNu5sYiqJsboXyt7a9XJYQZ1sJBDfb3HK+uo
c0rPcrbQTthmjYmmfFpU6EfBpRBqHui3aWPOCR4OFRtw/1KcB3NIUqkNyTLXxIWB
7OSfLESDXTKCd+RX+tctOCaIaMtRWT/o7RqQy/knI6VXpJk42o/w9tmMVxIU1zr3
v+kqJd7wQ/B03zei4XhZBTnPhT2tOFNtMFzYvagGyJXR9u0UjDK4Jf8i8ppFOJD5
USkl54p8xzHqnoSHV4SidmiQr6adUlnZhJFcr/0ODTd74+7+08KjhIiNbO+HY0lx
EKrW7lmcXCbr5zvHHJMODbYkgYf0iQ/RawRxU/VZ4GQzFT+92ep0qKENDcDTmE8F
9OBIgdOw6kt7p41LM/H6XxHQMLRnVne/2btUxmg7nWfESTyn+2iPp749X2qhuPeW
ufUQVGqajlQIklGVVcG0sHxfOFjvZEqNQfqEdcP5mK3g0RoIhPw=
=k7Vi
-----END PGP SIGNATURE-----
