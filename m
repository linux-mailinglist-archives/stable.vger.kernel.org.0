Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD6F43CE74
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 18:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbhJ0QQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 12:16:43 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:51897 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229480AbhJ0QQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 12:16:42 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9A1515806A2;
        Wed, 27 Oct 2021 12:14:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 27 Oct 2021 12:14:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=KV/0XgKlMdmKe7kuRBM0TM1FwqG
        czle+Ubs/clKek54=; b=cvC4yQu45pJauSRA9F7us9kh8KXL+r4Hk8kVAGBFF1B
        9rJvb2mLrrutKcqsoqPwnYC1e1OjM+Ju8gHqF+Gz3CuYE5O5XpafG1a6T/Z0sAMX
        lLsaWxsLK07b9LHtfKAAVdb4desSdfx3hEBLCimvz9qtVpbIOyPS1aKn5q54QstJ
        +wQK74fDM3q0Jlj9T1alJ2c7KGDC9UqGNTv4jgHeAcUmfK+BKSRFZcWOwZRPgrTj
        jtDYAqRRLQoUhkhUd5zwsuC3hKnZt76solND4EQDdsdBrSkxbtZCMPJdXtPpoW61
        dCGsH++xPV7pb+kkFa+8xy0XslKWcjXe+aZ6fcMzUUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KV/0Xg
        KlMdmKe7kuRBM0TM1FwqGczle+Ubs/clKek54=; b=EDd5CWEd3zWrPPVDgVIhE7
        kuFhHMhsukYtD6NY/xcgUSXA4/a1UgAXXE+JkH75xTauk1PRpY84VIgR815EdfpA
        rwVMm4591z9VZogpbAuktFtpAwxSTZEPfcbFUTAQy34CSBGWZlAchtIG6mcZdiQu
        iyQ2mZhccdlCwKF+M2x6Ing+Nd90WsBGtclE2rjB5NbXs2SZHrKIwsyuOFVimKNc
        Z5scP9f1Du3O09ElOnL/gAntaBE0SajCIogREBWdgH0ugq+qCqQ29qqXIV2LLnVa
        JGjTz5WGSl/b33Mai83l6zTd0GT8I655BBRnKEwo7ud+WEKbWeQM0fpli0tyXr8Q
        ==
X-ME-Sender: <xms:13p5YcilzGqg0CguEJpyQeoa9Z9DZCbiWbkeVMiIlFnULs9hooqxWQ>
    <xme:13p5YVBiauKy1ksH1v578AclserWHc4KPwVr3u98qeuWMnRoRdfqtIsPCRjKIu-K2
    A98skaF25ZEEA>
X-ME-Received: <xmr:13p5YUEUwPQqQBkeCV9mIsPBr1o-kuT26EVg0KgsBQVwIdDv8c_fSIU5vO6MzTWIl1al2zLbuWOQJj4KBtYWbKW1hr6ErTIS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:13p5YdRxyhaKSIW84u88qTX0OXBDHsNtW7vigDlcX5OiUFj71Q2miw>
    <xmx:13p5YZyzKpq-OMB-1ggM_HAYfV1LgHRW67SyVJpKUiCuL6T_PrZPLw>
    <xmx:13p5Yb49Q17ISAeQEph8C01VrxQekvqJlUyj5RaOp0zaCswZMq8PQg>
    <xmx:2Hp5YcpCfgjf_fNetJTXrcMs15CiW4HA9LoVZTkXsBCy7gXGU-ChZA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 12:14:15 -0400 (EDT)
Date:   Wed, 27 Oct 2021 18:14:12 +0200
From:   Greg KH <greg@kroah.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Song Liu <songliubraving@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 5.10] powerpc/bpf: Fix BPF_MOD when imm == 1
Message-ID: <YXl61Is/h1zm3BJj@kroah.com>
References: <20211027112804.1273985-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027112804.1273985-1-cascardo@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 08:28:03AM -0300, Thadeu Lima de Souza Cascardo wrote:
> From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
> 
> commit 8bbc9d822421d9ac8ff9ed26a3713c9afc69d6c8 upstream.
> 
> Only ignore the operation if dividing by 1.
> 
> Fixes: 156d0e290e969c ("powerpc/ebpf/jit: Implement JIT compiler for extended BPF")
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> Tested-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Acked-by: Song Liu <songliubraving@fb.com>
> Acked-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/c674ca18c3046885602caebb326213731c675d06.1633464148.git.naveen.n.rao@linux.vnet.ibm.com
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> ---
>  arch/powerpc/net/bpf_jit_comp64.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 

All now queued up, thanks.

greg k-h
