Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC32546B6CA
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhLGJPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:15:43 -0500
Received: from ns.iliad.fr ([212.27.33.1]:33840 "EHLO ns.iliad.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233586AbhLGJPn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 04:15:43 -0500
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id 64AAB20870;
        Tue,  7 Dec 2021 10:03:58 +0100 (CET)
Received: from sakura (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id 4AE6920289;
        Tue,  7 Dec 2021 10:03:58 +0100 (CET)
Message-ID: <266a430090341526b2cd259be1266654381b1d86.camel@freebox.fr>
Subject: Re: [PATCH v2] powerpc/32s: Fix kasan_init_region() for KASAN
From:   Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Tue, 07 Dec 2021 10:03:58 +0100
In-Reply-To: <90826d123e3e28b840f284412b150a1e13ed62fb.1638799954.git.christophe.leroy@csgroup.eu>
References: <90826d123e3e28b840f284412b150a1e13ed62fb.1638799954.git.christophe.leroy@csgroup.eu>
Organization: Freebox
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP ; ns.iliad.fr ; Tue Dec  7 10:03:58 2021 +0100 (CET)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Mon, 2021-12-06 at 14:12 +0000, Christophe Leroy wrote:

Tested-by: Maxime Bizon <mbizon@freebox.fr>

-- 
Maxime



