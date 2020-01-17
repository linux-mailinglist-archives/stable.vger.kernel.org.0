Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8DA140BF0
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 15:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgAQOCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 09:02:40 -0500
Received: from fd.dlink.ru ([178.170.168.18]:55756 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728827AbgAQOCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 09:02:40 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 4B7D81B2174D; Fri, 17 Jan 2020 17:02:36 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 4B7D81B2174D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579269757; bh=v/Dy3HkDobXo0LsphaOFqbzTfgXYux03ksrKq4FwcgU=;
        h=From:To:Cc:Subject:Date;
        b=fZrv0Jk0A9wmkx6kT8l14THsP38B9s4ps8r4aOlhIomlMU7ztmNi9NMf9xyk83BzD
         /nYzK8P4lt0+Dsz/vr5tFGHiL23SxI7pJWxhcgapsGmeYO++xPhj4El1m3IX0IqaU3
         7DQwlYehWidye7n3JDXdRrstZWELoVZsQfSZSSQE=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id AD0F41B2012B;
        Fri, 17 Jan 2020 17:02:29 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru AD0F41B2012B
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id E94861B20AE9;
        Fri, 17 Jan 2020 17:02:28 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Fri, 17 Jan 2020 17:02:28 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Paul Burton <paulburton@kernel.org>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>,
        Alexander Lobakin <alobakin@dlink.ru>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH mips-fixes 0/3] MIPS: a set of tiny Kbuild fixes
Date:   Fri, 17 Jan 2020 17:02:06 +0300
Message-Id: <20200117140209.17672-1-alobakin@dlink.ru>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These three fix two command output messages and a typo which leads
to constant rebuild of vmlinux.lzma.its and all dependants on every
make invocation.
Nothing critical, and can be backported without manual intervention.

Alexander Lobakin (3):
  MIPS: fix indentation of the 'RELOCS' message
  MIPS: boot: fix typo in 'vmlinux.lzma.its' target
  MIPS: syscalls: fix indentation of the 'SYSNR' message

 arch/mips/Makefile.postlink        | 2 +-
 arch/mips/boot/Makefile            | 2 +-
 arch/mips/kernel/syscalls/Makefile | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.25.0

