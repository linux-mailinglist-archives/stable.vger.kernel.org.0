Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E983E470C03
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 21:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhLJUto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 15:49:44 -0500
Received: from ns.iliad.fr ([212.27.33.1]:48300 "EHLO ns.iliad.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231685AbhLJUtn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Dec 2021 15:49:43 -0500
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Dec 2021 15:49:43 EST
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id 8D87E200D4;
        Fri, 10 Dec 2021 21:37:42 +0100 (CET)
Received: from sakura (freebox.vlq16.iliad.fr [213.36.7.13])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ns.iliad.fr (Postfix) with ESMTPS id 7F7F91FF54;
        Fri, 10 Dec 2021 21:37:42 +0100 (CET)
Date:   Fri, 10 Dec 2021 21:37:41 +0100
From:   Maxime Bizon <mbizon@freebox.fr>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] powerpc: Add set_memory_{p/np}() and remove
 set_memory_attr()
Message-ID: <20211210203741.GA9550@sakura>
References: <715cc0c2f801ef3b39b91233be44d328a91c30bc.1639123757.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <715cc0c2f801ef3b39b91233be44d328a91c30bc.1639123757.git.christophe.leroy@csgroup.eu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Virus-Scanned: ClamAV using ClamSMTP ; ns.iliad.fr ; Fri Dec 10 21:37:42 2021 +0100 (CET)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Friday 10 Dec 2021 à 08:09:42 (+0000), Christophe Leroy wrote:

Tested-by: Maxime Bizon <mbizon@freebox.fr>

-- 
Maxime
