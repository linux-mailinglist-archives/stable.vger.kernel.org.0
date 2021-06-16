Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034B73AA7CD
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 01:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhFQABK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 20:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhFQABJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 20:01:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A243760FD7;
        Wed, 16 Jun 2021 23:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623887942;
        bh=EIxI0VmomUpgT7/iZ3xMEinSY8OYAHPRUBOAfgdZDYE=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=cAce7FEXeesB3Eakd7FgmWGf9Fh349iEWi+MqQzZ25859UgzlcGjhB2BDd2939UFF
         swbXKFMMUdw4Lf+O1slRiUqFuttqF0etwHzTY0wHeB6RSCkLyVoM4XBLPGqhXnD8Vy
         ors7qsDhNt7P21cKbCRelkAgERBZrb2NfrWqltsCsQrFLWLgM+gW3v3AlI/4BV+8VO
         sxLxp5xmR56CzdHm9PQuO8mg7UR72l1k5JO6rm0gX/1n5is9oztdoCCHVum8UcJWpy
         FLV26Q2SGb/zFJ7VnfiNVIwdJ7shRlHNP9v1agEMM8Gg1M5S7s7YYTabA6xg0Ktcxg
         +WhRvMO37fYtg==
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailauth.nyi.internal (Postfix) with ESMTP id A561627C0054;
        Wed, 16 Jun 2021 19:59:00 -0400 (EDT)
Received: from imap21 ([10.202.2.71])
  by compute2.internal (MEProxy); Wed, 16 Jun 2021 19:59:00 -0400
X-ME-Sender: <xms:QZDKYGayzehKC7WKofAuiaTI_p_AXBTXjR97NC1qdb2U7WrkOwJohw>
    <xme:QZDKYJa12h8h2X7FlDPPbwMvsBHD72ykVvc_boJ7rN7E57BomoCnpua3usi4AiYoX
    EB4LHQMkB4zFscDaiM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeftddgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreerjeenucfhrhhomhepfdetnhgu
    hicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpeegjefghfdtledvfeegfeelvedtgfevkeeugfekffdvveeffeetieeh
    ueetveekfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedukeeh
    ieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinhhugi
    drlhhuthhordhush
X-ME-Proxy: <xmx:QZDKYA9t7IAn3EgEhT7Si9BB0h1DUXL8hkKKGUIYkWMoV_34tvkjsQ>
    <xmx:QZDKYIpVXR-AAN4T8sDDSYyKYiHet_5trvbmKPNYhNBss_hnzQgqWw>
    <xmx:QZDKYBosE_nForDcuC7qt-yJ__5SNPLQalZxTjeeqoHM9EnxGzFFPA>
    <xmx:RJDKYC6Cm1vS3Ti_WH1_dNhaA6MfvzVejlUbA17GfozO0IOY3qXJd184TWvlGDmL>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A4AE751C0060; Wed, 16 Jun 2021 19:58:57 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-526-gf020ecf851-fm-20210616.001-gf020ecf8
Mime-Version: 1.0
Message-Id: <ec728634-d7d3-4dbe-9989-d039c733bd6b@www.fastmail.com>
In-Reply-To: <20210616102026.GB22350@willie-the-truck>
References: <cover.1623813516.git.luto@kernel.org>
 <07a8b963002cb955b7516e61bad19514a3acaa82.1623813516.git.luto@kernel.org>
 <20210616102026.GB22350@willie-the-truck>
Date:   Wed, 16 Jun 2021 16:58:37 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Will Deacon" <will@kernel.org>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, "Andrew Morton" <akpm@linux-foundation.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Paul Mackerras" <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        "Nicholas Piggin" <npiggin@gmail.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org
Subject: =?UTF-8?Q?Re:_[PATCH_8/8]_membarrier:_Rewrite_sync=5Fcore=5Fbefore=5Fuse?=
 =?UTF-8?Q?rmode()_and_improve_documentation?=
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021, at 3:20 AM, Will Deacon wrote:
> 
> For the arm64 bits (docs and asm/sync_core.h):
> 
> Acked-by: Will Deacon <will@kernel.org>
> 

Thanks.

Per Nick's suggestion, I renamed the header to membarrier.h.  Unless I hear otherwise, I'll keep the ack.

> Will
> 
