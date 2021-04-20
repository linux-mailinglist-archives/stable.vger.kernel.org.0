Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062F83652BD
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 09:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhDTHCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 03:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhDTHB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 03:01:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C312C06174A;
        Tue, 20 Apr 2021 00:01:24 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lYkNs-00EAPs-Ov; Tue, 20 Apr 2021 09:01:21 +0200
Message-ID: <74494183e65ef549fc5596f314db43a8e792d2ff.camel@sipsolutions.net>
Subject: Re: [PATCH AUTOSEL 5.4 13/14] gcov: clang: fix clang-11+ build
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Date:   Tue, 20 Apr 2021 09:01:19 +0200
In-Reply-To: <20210419204454.6601-13-sashal@kernel.org>
References: <20210419204454.6601-1-sashal@kernel.org>
         <20210419204454.6601-13-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-04-19 at 20:44 +0000, Sasha Levin wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> [ Upstream commit 04c53de57cb6435738961dace8b1b71d3ecd3c39 ]
> 
> With clang-11+, the code is broken due to my kvmalloc() conversion
> (which predated the clang-11 support code) leaving one vmalloc() in
> place.  Fix that.

This patch might *apply* on 5.4 (and the other kernels you selected it
for), but then I'm pretty sure it'll be broken, unless you also applied
the various patches this was actually fixing (my kvmalloc conversion,
and the clang-11 support).

Also, Linus has (correctly) reverted this patch from mainline, it
shouldn't have gone there in the first place, probably really should be
squashed into my kvmalloc conversion patch that's in -mm now.

Sorry if I didn't make that clear enough at the time.


In any case, please drop this patch from all stable trees.

johannes

