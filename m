Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF71B2523BF
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 00:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgHYWoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 18:44:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53020 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgHYWoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 18:44:16 -0400
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=mussarela)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1kAhfp-0006AU-Ay; Tue, 25 Aug 2020 22:44:13 +0000
Date:   Tue, 25 Aug 2020 19:44:08 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
        sashal@kernel.org, gregkh@linuxfoundation.org
Subject: Please apply commit 0828137e8f16 ("powerpc/64s: Don't init FSCR_DSCR
 in __init_FSCR()") to v4.14.y, v4.19.y, v5.4.y, v5.7.y
Message-ID: <20200825224408.GB6060@mussarela>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit 912c0a7f2b5daa3cbb2bc10f303981e493de73bd ("powerpc/64s: Save FSCR
to init_task.thread.fscr after feature init"), which has been applied to the
referred branches, when userspace sets the user DSCR MSR, it won't be inherited
or restored during context switch, because the facility unavailable interrupt
won't trigger.

Applying 0828137e8f16721842468e33df0460044a0c588b ("powerpc/64s: Don't init
FSCR_DSCR in __init_FSCR()") will fix it.

Cascardo.
