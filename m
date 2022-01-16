Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B470448FC2E
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 11:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiAPKmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 05:42:39 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:37249 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiAPKmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 05:42:38 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JcBSX4D8xz4xtf;
        Sun, 16 Jan 2022 21:42:36 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Paul Mackerras <paulus@samba.org>
Cc:     linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Dmitry V . Levin" <ldv@altlinux.org>
In-Reply-To: <c55cddb8f65713bf5859ed675d75a50cb37d5995.1642159570.git.christophe.leroy@csgroup.eu>
References: <c55cddb8f65713bf5859ed675d75a50cb37d5995.1642159570.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v2] powerpc/audit: Fix syscall_get_arch()
Message-Id: <164232966465.2885693.13588785394784064877.b4-ty@ellerman.id.au>
Date:   Sun, 16 Jan 2022 21:41:04 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Jan 2022 11:26:25 +0000, Christophe Leroy wrote:
> Commit 770cec16cdc9 ("powerpc/audit: Simplify syscall_get_arch()")
> and commit 898a1ef06ad4 ("powerpc/audit: Avoid unneccessary #ifdef
> in syscall_get_arguments()")
> replaced test_tsk_thread_flag(task, TIF_32BIT)) by is_32bit_task().
> 
> But is_32bit_task() applies on current task while be want the test
> done on task 'task'
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/audit: Fix syscall_get_arch()
      https://git.kernel.org/powerpc/c/252745240ba0ae774d2f80c5e185ed59fbc4fb41

cheers
