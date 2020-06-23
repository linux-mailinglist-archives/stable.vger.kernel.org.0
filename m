Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBFB20515A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732396AbgFWLxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:53:37 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42187 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732389AbgFWLxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 07:53:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 12A1D5C0372;
        Tue, 23 Jun 2020 07:53:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 07:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=25kIAXdAw0kOV0/zxnutehrDDw+
        kCzSQPSMJ8URnz5M=; b=FISaHYK4g0yzbMrSVKB62tqVNCP+A6jmAzziFBaNls+
        VhVgpYbRMKnNN96JbTZUQ/LeNTdbyeAzvYCDegoNyO+hsoPZ7WkB0zozAZzxY3HF
        4TBjSFsjX0exh6Vs1DqfcBGJ9izWyZiZRE2e6DQ8wFLLujQ3OB4EliXuVkm/4f/n
        dCM7L9DFT4InYEm470uiH+/b1Cqe6YYcz400PHn28ShKw4BEjiv5qQDQsE28/fco
        fNxIwki2iYHt/YCz39g1tEUZbH++vDjlhCpJD/Y4RQmSF0WKpnToeqHdUGojPWq0
        UhAvmtpzLJrFMq3M2zyXLlertwmRA3xnHKvgNxieiFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=25kIAX
        dAw0kOV0/zxnutehrDDw+kCzSQPSMJ8URnz5M=; b=Iv3QRArRmPwsaKUYIeI9eX
        FRS8x3+piqZ68iKFjRFm3wAUgHotJRi6hb6E/lrvA64TpnmBD0pbKsAMYVUilVYT
        iLOetp084C3umbQmfNhtpPTnokFXhrrvwDciqOojTm+NXc99T+zIUA7w3t/3W0NV
        sOiVTYReVKC/ErYx32nrNMq6B4o4E/6vmJhEth1V1s7zA1QZvYXg0hayrknx8zrW
        6DOCQCiYyq8b2asnV8O3iaPfNbwGldlRhA35a8QM/sAnMHHOA5cioqg5tEMjCuAu
        YajqRJH7zA1bex6wUXjGtbLT85xTXbkVjAXf73go1Yeq2WRbigtiFoAi6FY/Reyw
        ==
X-ME-Sender: <xms:Pu3xXtby42WdvW13xL1Kx-bNyZhdGdJ_yRHk93oC_zTLLUGCKZhghQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Pu3xXkbFeOcN3AIYlbfMSVQ1v3oPFHfDai3NIbMwSIcKB2iSoCJwXw>
    <xmx:Pu3xXv86kZclWK_yBMg2Epkw6nxUDucYhd871U1sEIt3Ja5gHag0nA>
    <xmx:Pu3xXrqkzs02tjbRv5O82DGrM1aBW5z5T1wSg9PiR-tr1wnPmw5L4Q>
    <xmx:P-3xXtAYrPxwW7mqaShqRuwwGDU9YC0SWE0qbxMWH4ijj9pICFWO-A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2FFC630674D3;
        Tue, 23 Jun 2020 07:53:34 -0400 (EDT)
Date:   Tue, 23 Jun 2020 13:53:26 +0200
From:   Greg KH <greg@kroah.com>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alexander Monakov <amonakov@ispras.ru>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Michael Chiu <Michael.Chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Subject: Re: [PATCH] Revert "drm/amd/display: disable dcn20 abm feature for
 bring up"
Message-ID: <20200623115326.GA1966723@kroah.com>
References: <20200622163706.906713-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622163706.906713-1-alexander.deucher@amd.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 12:37:06PM -0400, Alex Deucher wrote:
> From: Harry Wentland <harry.wentland@amd.com>
> 
> This reverts commit 96cb7cf13d8530099c256c053648ad576588c387.
> 
> This change was used for DCN2 bringup and is no longer desired.
> In fact it breaks backlight on DCN2 systems.
> 
> Cc: Alexander Monakov <amonakov@ispras.ru>
> Cc: Hersen Wu <hersenxs.wu@amd.com>
> Cc: Anthony Koo <Anthony.Koo@amd.com>
> Cc: Michael Chiu <Michael.Chiu@amd.com>
> Signed-off-by: Harry Wentland <harry.wentland@amd.com>
> Acked-by: Alex Deucher <alexander.deucher@amd.com>
> Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> Reported-and-tested-by: Alexander Monakov <amonakov@ispras.ru>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org
> (cherry picked from commit 14ed1c908a7a623cc0cbf0203f8201d1b7d31d16)
> ---
> 
> Fixed up to apply cleanly on 5.7 and older kernels.

Thanks, now queued up.

greg k-h
