Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71B04920DF
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 09:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbiARIEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 03:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344027AbiARIEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 03:04:33 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABAFC06161C;
        Tue, 18 Jan 2022 00:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=F+DKVuOeeAd/lnzZqM+KdPM4PLOytZiGkPYxEeyXGaQ=;
        t=1642493072; x=1643702672; b=eBbnqpsC8ebGMKRtMrsUmUAEE41adWL7z/5YlrZOOrLHUFo
        Npy50I6h6s9pjwj7+DdWx+grZwxsPyNnT3/aE0sBSiTkB1IvzUCJeV1XD294NKQsxs8ebfywYyq2A
        qNldqq0+85JZj111mwkcmkxxVBo9v0fZGoRnl83Q4s7qCOh7ltab5MPL3L/zZJG/B5vwx3IhUf72K
        iIn9dJOoii2Js5AaN6A4WjHuL74Z/dFUVOn/p0DIJIdS8sVCC/FhdYsG+DU4Fj+9Wh2lY0Ss0hGle
        n/JQHLVsTW5+GphQICeYrDefdLOVXilwmWfh2pKRtc7/j5SgHKpxXgE5NflYgFvw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1n9jTe-0079HC-6F;
        Tue, 18 Jan 2022 09:04:26 +0100
Message-ID: <06a7e64e62bf8191be5004dac52f84d711e0e9a0.camel@sipsolutions.net>
Subject: Re: [PATCH AUTOSEL 4.4 19/29] um: registers: Rename function names
 to avoid conflicts and build problems
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        linux-um@lists.infradead.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        viro@zeniv.linux.org.uk
Date:   Tue, 18 Jan 2022 09:04:24 +0100
In-Reply-To: <20220118030822.1955469-19-sashal@kernel.org>
References: <20220118030822.1955469-1-sashal@kernel.org>
         <20220118030822.1955469-19-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-01-17 at 22:08 -0500, Sasha Levin wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> [ Upstream commit 077b7320942b64b0da182aefd83c374462a65535 ]
> 
> The function names init_registers() and restore_registers() are used
> in several net/ethernet/ and gpu/drm/ drivers for other purposes (not
> calls to UML functions), so rename them.
> 
> This fixes multiple build errors.

FWIW, this is certainly fine to backport, but also almost certainly not
necessary: most likely all those drivers cannot be built before 5.14
(commit 68f5d3f3b654 ("um: add PCI over virtio emulation driver"))
anyway.

johannes
