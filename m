Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6D33CDBF
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 15:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391533AbfFKN5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 09:57:03 -0400
Received: from mout.gmx.net ([212.227.15.19]:54903 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391441AbfFKN5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 09:57:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1560261397;
        bh=rsCR40mf9mMX9OTUE4hY/u3f5j6qDwzHYmeBLXwW+0g=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=HdY/iNQYnqKPicbc36sCCLzN+LM7RDe1pnQtbvyNen0SjTexa87bULPQidahyaNzN
         UJCzipRVMDPQk9ZboyAYhUtKyw4Cf95pgTocT/Shb1Tbbn7MUXfTTog7aYXoKnZSPH
         3BtpibEhz317zFHIcyCYBtpbY8MueeP3+DAYouco=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.203.76.133]) by mail.gmx.com
 (mrgmx003 [212.227.17.190]) with ESMTPSA (Nemesis) id
 0Ld1CS-1gsWpB0NPs-00iABJ; Tue, 11 Jun 2019 15:56:37 +0200
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 0D69E800A7; Tue, 11 Jun 2019 15:56:36 +0200 (CEST)
From:   Sven Joachim <svenjoac@gmx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: Linux 5.1.9 build failure with CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n
Date:   Tue, 11 Jun 2019 15:56:35 +0200
Message-ID: <87k1dsjkdo.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:MEHJRB92VqgtkP2e0+LD/esP6/ueg059df1Gfd1uVdqOvA+/8Gj
 1ZPGL7mIOKjl2y0RPP2Q+fJlGkdxnAz46ii3N8Io8Js0e3OHLSi+ne5zR6FKa3CH0xfMtop
 qP+58jVB8XO6N/SJnZvn4/1vJSZ6KqyYsiNB3f2symgSgxYYWpSmnhk/VOcVNE9S4ztJISa
 oxhx+4a45oyjIM2w9k3Gw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:J8yHe74HEXM=:MssKmKylzaI2d/SNYn2tIQ
 pZ3GIpz94eHr8SVEatBV1Y+s0hTn3zwAcSAFuzO1jsET93qH1H9i8iWlYlz63sHO/r/Kpj4dB
 cSkK5gYGhndtnDB2i82AhGM8qk6HmueWWB1AkPnTT8jNE5s/Qwal5tmrFPypeUnQYBtC1C6v9
 M9ot6LYTM43t32KKOS859PcLyZN9phIAVvwuLCDs71M9baPo8JFfgDa9A3MLKE+wEiXej/hEm
 VwTf8cTW3bRicyYJERa6CnFfOIU/O9j5VxCfpKTRVa23db6V3RdUHQT8dMAeCbYGR3Ta+Pi5T
 NTG5rXKyoWoYT5hQZx9CGDqILsy3emMzW4+OvZ8HbNBRoK0D1+l9Ic0wmrPb4KumlvQJq9bab
 YmyKY1PJlUfzL1WeUz35FnwTtiw0yIt5Ksiu5SbTtHiX7NpGrmOl6A6XvUuPD0xrP9d6Zxddz
 7hecvni5CTU9jbq8iaqh15+6t3UC1woa6WGYqb6bPoHonYBZmWAP/WABEOLhOAqeIuJwxdPSd
 zNqFY6YMFevjLTCZgyPNDibFG0mgywb8tFCHhGGNXhDhOaOVdbBspSHvba0fMA95NgapuYftp
 HXv1rKVI90SKN3L9mpA6ghFm4zo0AieRRPXAqFiYHZGNfsqlswV9bHeNJcKMrZd19T6W352PB
 FLQzjYaoQvWmkjwQdF4mLiNL4AO7WvwGje7y2NK31zVFYyaQvkK116/difhGBPzFkhGyfZspv
 XnLjmByM7v3fv4UP560MaFzINyvxVfY4iLP5QhHngfxuFPFj+Fo0Hb6WtRyaN6GKaRaWqSkye
 MMEzrAVEWrdx01cC8L1P7aL2qL4yYQiBvo7TZBKmSKVei85EHHV1ZtRfxyfODv6rTaEcjJJSW
 0RLEKbbBr8j/h6h0CCqhMH3eioRurVVO98DR+28jjSjfDr0cAA0xoQY81Q5cnlhUIHCw8+hEf
 5bP9eGPH5UTgcFovVK8x1B/051i4aBnAgUN3+PdO2OMMkng6WWzjY
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 1e07d63749 ("drm/nouveau: add kconfig option to turn off nouveau
legacy contexts. (v3)") has caused a build failure for me when I
actually tried that option (CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n):

,----
| Kernel: arch/x86/boot/bzImage is ready  (#1)
|   Building modules, stage 2.
|   MODPOST 290 modules
| ERROR: "drm_legacy_mmap" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
| scripts/Makefile.modpost:91: recipe for target '__modpost' failed
`----

Upstream does not have that problem, as commit bed2dd8421 ("drm/ttm:
Quick-test mmap offset in ttm_bo_mmap()") has removed the use of
drm_legacy_mmap from nouveau_ttm.c.  Unfortunately that commit does not
apply in 5.1.9.

Most likely 4.19.50 and 4.14.125 are also affected, I haven't tested
them yet.

Cheers,
       Sven
