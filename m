Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C0A2E7A0C
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 15:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgL3Otm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 09:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgL3Otl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 09:49:41 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758A8C061799;
        Wed, 30 Dec 2020 06:49:01 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kucmY-001hOo-30; Wed, 30 Dec 2020 15:48:58 +0100
Message-ID: <d17899cc72a31f12da166de6223338b844ee2428.camel@sipsolutions.net>
Subject: Re: [PATCH AUTOSEL 5.10 20/31] um: allocate a guard page to helper
 threads
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Richard Weinberger <richard@nod.at>, linux-um@lists.infradead.org
Date:   Wed, 30 Dec 2020 15:48:57 +0100
In-Reply-To: <20201230130314.3636961-20-sashal@kernel.org>
References: <20201230130314.3636961-1-sashal@kernel.org>
         <20201230130314.3636961-20-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-12-30 at 08:03 -0500, Sasha Levin wrote:
> 
> We've been running into stack overflows in helper threads
> corrupting memory

For the record, that was mostly referring to "while development", so
while this change makes a few things a bit safer, I don't think there's
all that much point in backporting to stable; presumably things are
working OK there for people, and developers will (hopefully) be working
on mainline anyway.

johannes

