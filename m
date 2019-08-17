Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD4CA91012
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 12:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbfHQKhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 06:37:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51572 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725832AbfHQKhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 06:37:18 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hyw5E-0008PJ-G3; Sat, 17 Aug 2019 11:37:16 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1hyw5E-0005oh-9m; Sat, 17 Aug 2019 11:37:16 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Sat, 17 Aug 2019 11:35:11 +0100
Message-ID: <lsq.1566038111.397675943@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 0/4] 3.16.73-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.73 release.
There are 4 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Aug 19 20:00:00 UTC 2019.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Ben Hutchings (1):
      tcp: Clear sk_send_head after purging the write queue
         [not upstream; fixes bug specific to stable]

Jason A. Donenfeld (1):
      siphash: implement HalfSipHash1-3 for hash tables
         [1ae2324f732c9c4e2fa4ebd885fa1001b70d52e1]

Zhangyi (2):
      ext4: brelse all indirect buffer in ext4_ind_remove_space()
         [674a2b27234d1b7afcb0a9162e81b2e53aeef217]
      ext4: cleanup bh release code in ext4_ind_remove_space()
         [5e86bdda41534e17621d5a071b294943cae4376e]

 Documentation/siphash.txt |  75 +++++++++++
 Makefile                  |   4 +-
 fs/ext4/indirect.c        |  43 ++++---
 include/linux/siphash.h   |  57 +++++++-
 include/net/tcp.h         |   3 +
 lib/siphash.c             | 321 +++++++++++++++++++++++++++++++++++++++++++++-
 lib/test_siphash.c        |  98 +++++++++++++-
 7 files changed, 573 insertions(+), 28 deletions(-)

-- 
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

