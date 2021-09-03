Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B309440013B
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 16:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243495AbhICO2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 10:28:48 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:41083 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235668AbhICO2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 10:28:48 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4D3533200657;
        Fri,  3 Sep 2021 10:27:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 03 Sep 2021 10:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=TzkJUtwOamdrhJMKlLig7A/Meoo
        qDU2vTYTum6dJFeE=; b=GKh2g5arQ2kTu38b+imaWM7cZhXDK1L6sofFmexmpry
        pMpI/HQEzX8MB+KqHPWB/VoAnGqSaz8DPy6Hno8gaBSszGSbnfYrh+cecLdGTJLv
        JTD8waY6xg+/saxs72cKDaAqk2JQ8inDPzJs/vEXU+A1CXe55YNQCG4a2UWxcqbI
        /T14r2pqA3Y6Rz0puQgSmJc142wFm7HOFuvL9eIykV9S0s4YVXVVtXRRu7p+LUCm
        FyNz2PkscKyXAktwXGo+apI28OsVs2lJU/zkLfASsYcEuWZbPfdXIxmjRHbof0z9
        Vu3dLGsGAJ3DtETMzqtzSPwY77VqYzhTRz2GDeD7rcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=TzkJUt
        wOamdrhJMKlLig7A/MeooqDU2vTYTum6dJFeE=; b=WtMYMA3WHTUawyn2k5lgh3
        8LVGTPj5mxbhmy6meJAQMmMsfQJVr2mW3suN+MarOoI03Q9GCGFt35PBp+3JwzX2
        MFC/GO/gTUckJO30PfcRdh9HO90bRRZ0/4+/VZa+hfXYvCR9sCUly/rzRscjSEqT
        uI3IeI4nZgHhEbVhOQNMU7Gffu4V+gHoTQzeMgslY/H+ItXPMnAqi+6MycmlL+Qz
        TkLS9EEz+Hq+k9LUfu4m7JwWS6U2ntev3lpTJO0QooHh7m5POW7Mwslskh7GN11i
        C7eTAwaQ4PoHR+/HPp4Ha5k7TwaDF5Nq4TKVZvCbsf2S4tICe2bX2qGLqJ8dAcNg
        ==
X-ME-Sender: <xms:4jAyYUtxavzwR6dawyZdFHJaKyYS7YYJKHTt9ENGf-3taUHUc10XxA>
    <xme:4jAyYRe7Nd7gBVE2YXHa6i9J_a-wTozDeJ60ITsLbPp26633jiG9Mz6VnGd5buCNM
    Puai6LsD7qI3Q>
X-ME-Received: <xmr:4jAyYfyqi0Wl_TZbR9NlaH0yRJjYGjwyyIZpjLESwAyQIRKhuKQz1Yr9X65FAoalBhVkYAJ0HpNYixsyz5MiSvg8bgbGLR-r>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvjedgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:4jAyYXOhSYV6mNFBSI4yI4EZeumBcC4fhz8TcQotFPHzMxjQ_pWgqg>
    <xmx:4jAyYU_UrrOcKY_hl_WXasltl7T7SPvJvE0L_dasa5emo3AEvnE21w>
    <xmx:4jAyYfX76U9jU4gN0RkA5EDeKsy6b6AICS33dudEv4zIh8Ssv8txfw>
    <xmx:4jAyYUy_Ug281V1zqkhldUcYZbPkQePtaLdsHQbT_DlvsuIa1SDARg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Sep 2021 10:27:45 -0400 (EDT)
Date:   Fri, 3 Sep 2021 16:27:43 +0200
From:   Greg KH <greg@kroah.com>
To:     Patrick Schaaf <bof@bof.de>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] for 5.4 : kthread: Fix PF_KTHREAD vs to_kthread() race
Message-ID: <YTIw3/blzpQ3eadg@kroah.com>
References: <CAJ26g5THH5uZW2D86H64TXBE-OhdSLva8vGwF7Sdak1_R6PmRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ26g5THH5uZW2D86H64TXBE-OhdSLva8vGwF7Sdak1_R6PmRw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 03, 2021 at 10:02:02AM +0200, Patrick Schaaf wrote:
> After 3 days of successfully running 5.4.143 with this patch attached
> and no issues, on a production workload (host + vms) of a busy
> webserver and mysql database, I request queueing this for a future 5.4
> stable, like the 5.10 one requested by Borislav; copying his mail text
> in the hope that this is best form.
> 
> please queue for 5.4 stable
> 
> See https://bugzilla.kernel.org/show_bug.cgi?id=214159 for more info.
> 
> ---
> Commit 3a7956e25e1d7b3c148569e78895e1f3178122a9 upstream.

<snip>

This patch is corrupted and can not be applied :(

Can you fix up your email client and resend?

thanks,

greg k-h
