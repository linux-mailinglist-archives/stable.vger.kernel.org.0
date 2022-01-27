Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53F249E640
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240650AbiA0Piu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:38:50 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:55143 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241074AbiA0Pit (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:38:49 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8262B32023E5;
        Thu, 27 Jan 2022 10:38:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 27 Jan 2022 10:38:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; bh=JNA/fNuV/eKjgJbAJpxVCDIvXo0/llqbLsSBeo
        X7Qsk=; b=CyIrBtffufwEz/j+F+6g6Opuc0XSZYJwkpa/IIRipG9Ctwl37SA79t
        6Tj8jlTpYkIP7iGIBOwBxkODqluCNcEW418a2ddk6aLrphZwxIuoeB2294aOjU4v
        xofxZfJHnv2QIAy/Vx4G5yhtOfUvD9Gg51WHTYXezxmIds6pPYUHZ3ydrUD3pK8A
        /qQEUzfIQFOvxIJPyz9BS0fLbYLn5U4I787LDb42/WYlWKOQUmqCj25eIXCgDRt5
        sJVBg9j1EoCCA9UATZoSBxD47LiI8a97fNeW3zzqwg1f2FJLWGwMtx00Q3Q3UVwV
        MdFsLn9mxZRevR1AMlRN/MiiLRa+1tzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JNA/fNuV/eKjgJbAJ
        pxVCDIvXo0/llqbLsSBeoX7Qsk=; b=l2nvYi+Q7zkmJeEFhX4eFV14Kc2KCZcmX
        PxNHUNkfXLxnu7yEQKRH3zXZBjm8Ja54xTrRCBqL0DFbhYnT6ratqQ/Bn4QuMzUn
        65jZNrd3mbPaHrFpxHrFDUhiTDzKE3Ws/jzMe1b+U3X+WGWFBLz8KIP/C8hhY+Iu
        skqyS7v2hnm/fq1Y94tpIRheUyND6XzizAEb//nJkqhVvhsZPO2ebcOV0J3Y7sCF
        FxO9PHmmIEcAHyNHYCgDuzhCoddqJhfyJoImGZ8CC/siq4POMLJIaIqifBErkVaT
        sQniurUkj75CetV4Sn2JAQzcMmTS5CjjcYQLvNEcJvN9aRjMBm3Wg==
X-ME-Sender: <xms:h7zyYaNirf6KLfMg47CJOqXlKTyXKxc9H3JCU3PuY92dkJkYEitDew>
    <xme:h7zyYY-Nq8YDS8_mpmZVZ_E4eIOAG6FMrrsMha4x-lkWTbYLIjruKDlYF3xWsKBe6
    p2TAbm61XUplA>
X-ME-Received: <xmr:h7zyYRQYbjEf_PdW8XHBTVeJC5Ebg8wCJi7L1lGRQIYFfUeSlnK1-hHx-b3s1KeKQmzzv6gzKZcTAHNe8xtG_4N_PyyNLbZ8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfeefgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:h7zyYauk1cR3JSIi4bW0sgoGoplOl4q6960R8UOyG7_Y1RJMBS2Ggw>
    <xmx:h7zyYSeD0BQ5fEA1jMbMlltgko8LTTtlpDTLnM1ztliOnDjGR3WwzQ>
    <xmx:h7zyYe19d20qb2Z7tT9nazIER39qixj3tRwIN0moZVSMn414ayexkA>
    <xmx:iLzyYZwt4wnL57FWkYWXeDd6DkkNLbs2-mR8cavEEIC00QP-QZC1pA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Jan 2022 10:38:47 -0500 (EST)
Date:   Thu, 27 Jan 2022 16:38:29 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Dennis Cagle <d-cagle@codeaurora.org>,
        Patrick Daly <pdaly@codeaurora.org>
Subject: Re: [PATCH v2 4.9 1/3] ion: Fix use after free during ION_IOC_ALLOC
Message-ID: <YfK8dUjOqKSrXLXl@kroah.com>
References: <20220125141808.1172511-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125141808.1172511-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 02:18:06PM +0000, Lee Jones wrote:
> From: Daniel Rosenberg <drosen@google.com>
> 
> If a user happens to call ION_IOC_FREE during an ION_IOC_ALLOC
> on the just allocated id, and the copy_to_user fails, the cleanup
> code will attempt to free an already freed handle.
> 
> This adds a wrapper for ion_alloc that adds an ion_handle_get to
> avoid this.
> 
> Signed-off-by: Daniel Rosenberg <drosen@google.com>
> Signed-off-by: Dennis Cagle <d-cagle@codeaurora.org>
> Signed-off-by: Patrick Daly <pdaly@codeaurora.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
> 
> NB: These are Android patches that were not sent to Mainline.
> 
> Only v4.9 is affected by these issues due to refactoring.

All now queued up, thanks.

greg k-h
