Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA01AA72D
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 17:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732238AbfIEPXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 11:23:44 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:44019 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731609AbfIEPXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 11:23:44 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M7ehh-1i4XD309vh-0084hW; Thu, 05 Sep 2019 17:22:24 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-arch@vger.kernel.org, y2038@lists.linaro.org,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Vincent Chen <deanbo422@gmail.com>, stable@vger.kernel.org,
        Greentime Hu <green.hu@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@pku.edu.cn>,
        Stafford Horne <shorne@gmail.com>,
        Jonas Bonn <jonas@southpole.se>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Ley Foon Tan <lftan@altera.com>,
        Richard Kuo <rkuo@codeaurora.org>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <jacquiot.aurelien@gmail.com>,
        Guo Ren <guoren@kernel.org>,
        Christian Brauner <christian@brauner.io>
Subject: [PATCH 1/2] ipc: fix semtimedop for generic 32-bit architectures
Date:   Thu,  5 Sep 2019 17:21:24 +0200
Message-Id: <20190905152155.1392871-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:XxUJwrw3CMdgDWeLKiHcQFwqG5kArJ+fThzxITIBUQnV8GTJRWt
 5s/+x2+IS6LxshP4ageYlrALYSVCMMbn4PLCj6JVtmn07dladMa73O7CfYJKZfYPGAzhpaE
 Pg5AORkHt/hlQHTDkRhl39XOdHBkuqe1JAub8P59iFIHmEoaBgT/xQhHoIlyBmADQH9/9rg
 aSIYL4xMi85ktbTYty2bw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:BqtXUM4orE8=:z5RarZPHyTyTUSIZCnz00G
 BafFSMNtWu5vOpkk7WY2l+3hQiUGyMuMcQiP4S3Mq7sfX3GIG+wzlTy+40cDK6a+U96qePVSI
 dZBfwCA4/hoIVwenR+mHi0Na31lTyJzpRkcXpwiGI4CdKYz2biMZCsQMTrj/EfFt0q/k2nrqe
 AnzO7KWgvVlA1GFvDAN2ufVxcA4bmiSh0uAcIRvU8Uo65fOih3pvc4syPcXuzgUrIRaaMb7zo
 y0ViwslBnFMIDYwCSOBZkLrq+2xyh1tYBNuwjUNjrjSs+ibojKIfXdqg3rPvZSQ+wqvqucKig
 32juvrsEVHPzMVuwzNgP/oF4pVjZvC7UdHWFosZh+5YM969U8OT6Qd+JoN2lfq09JYm8CluZl
 6fjxAdwNfdWUQ0HsQhtXuYcCIq760Cbb1aq293gV3H9Fp81WIUuC3RdL+AA7GZs0AGFz0lyfT
 bmnOLsfnWJThKRD/iFyoZklx2qHHjT/n+f+2Nr9XZMCTrSRIBy7Q1OECrqqey0m9KG8MH8Wlg
 zKjA2K74yZqlPQwMrVYaxDvn00bUo1Y4Lnn9HD5CHTOMR47ME3MZuZiXzh6QvWgRmtFyPsYg0
 +tqba4W0T196wcnCz+EC8FAP4cObPa8KWCrM6xjtnVTPEbmmamuNne73GDf+dLQhFzZWOxv0P
 G1AiXW23hUDg4deXhFfV1Vb2+9Hi+679hl+lRQEK4FDRl35UHAqTuzrRaGNwSWhiwqr2Apjih
 W/lUMDExLP1uhmqmeuMoU4rWD0x5wgkL3jBHgczvJQX2TwotmtJUOPxqgb1ccMRWEwxtr65oM
 qW98ig3lwLo7Q2dIZtrFLGt1Mz3xkqvyw7GX5hDY/opDRGiM0s=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As Vincent noticed, the y2038 conversion of semtimedop in linux-5.1
broke when commit 00bf25d693e7 ("y2038: use time32 syscall names on
32-bit") changed all system calls on all architectures that take
a 32-bit time_t to point to the _time32 implementation, but left out
semtimedop in the asm-generic header.

This affects all 32-bit architectures using asm-generic/unistd.h:
h8300, unicore32, openrisc, nios2, hexagon, c6x, arc, nds32 and csky.

The notable exception is riscv32, which has dropped support for the
time32 system calls entirely.

Reported-by: Vincent Chen <deanbo422@gmail.com>
Cc: stable@vger.kernel.org
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Ley Foon Tan <lftan@altera.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <jacquiot.aurelien@gmail.com>
Cc: Guo Ren <guoren@kernel.org>
Fixes: 00bf25d693e7 ("y2038: use time32 syscall names on 32-bit")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Hi Vincent,

Sorry for the delay since your report. Does this address your
problem?

Anyone else, please note that this patch is required since
5.1 to make sysvipc work on the listed architectures.
---
 include/uapi/asm-generic/unistd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 1be0e798e362..1fc8faa6e973 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -569,7 +569,7 @@ __SYSCALL(__NR_semget, sys_semget)
 __SC_COMP(__NR_semctl, sys_semctl, compat_sys_semctl)
 #if defined(__ARCH_WANT_TIME32_SYSCALLS) || __BITS_PER_LONG != 32
 #define __NR_semtimedop 192
-__SC_COMP(__NR_semtimedop, sys_semtimedop, sys_semtimedop_time32)
+__SC_3264(__NR_semtimedop, sys_semtimedop_time32, sys_semtimedop)
 #endif
 #define __NR_semop 193
 __SYSCALL(__NR_semop, sys_semop)
-- 
2.20.0

