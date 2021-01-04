Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9652E94A7
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 13:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbhADMTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 07:19:40 -0500
Received: from mail-02.mail-europe.com ([51.89.119.103]:46844 "EHLO
        mail-02.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbhADMTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 07:19:40 -0500
Date:   Mon, 04 Jan 2021 12:18:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1609762694; bh=QT+sTrOHmzw/IEhK4TpbxVslGv1eZAC9MAiDIkeRbwc=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=BmkAZgu6mvqIpaVT+KnbmBJsJL9ZQ8DxHQ8q9EMg+zxUSml7YCs2/v5Qm4vuImBjs
         HMixK0no6LXT5zZ7U4YUlATCsuOG8UjDXeF515RIFfmOOoa4HUBN6NVdLKx70ozBGG
         uXxcwDBeaNc4Y3pwQo8hxNF/qwOnLWRpL3f7mJciYMBNaX+HmdT32MvdbgzlylyIJ4
         KqtQf4ww8efE7GEHgNuE0d23x435gn31SODZyGgwOHnmXJAwbFTEuAAPECgBrurht7
         WiFgdAkRN67hl8Qelt+phwJEV3fBuRWF5re/8Q7ad38WP75N4K1BpXnrztCFqnBWTg
         xl/TJM3zR39UQ==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Alex Smith <alex.smith@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH mips-next 0/4] MIPS: vmlinux.lds.S sections fix & cleanup
Message-ID: <20210104121729.46981-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series hunts the problems discovered after manual enabling of
ARCH_WANT_LD_ORPHAN_WARN, notably the missing PAGE_ALIGNED_DATA()
section affecting VDSO placement (marked for stable).

Compile and runtime tested on MIPS32R2 CPS board with no issues.

Alexander Lobakin (4):
  MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section
  MIPS: vmlinux.lds.S: add ".rel.dyn" to DISCARDS
  MIPS: vmlinux.lds.S: add ".gnu.attributes" to DISCARDS
  MIPS: select ARCH_WANT_LD_ORPHAN_WARN

 arch/mips/Kconfig              | 1 +
 arch/mips/kernel/vmlinux.lds.S | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--=20
2.30.0


