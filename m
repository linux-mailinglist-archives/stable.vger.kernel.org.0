Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C2C31BB1E
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 15:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhBOObv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 09:31:51 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:34035 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhBOObs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 09:31:48 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AE35CEC4;
        Mon, 15 Feb 2021 09:30:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 15 Feb 2021 09:30:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=VTF+InyvJ1i+IExFvTo0zZ2GIbm
        UxMajMuGt1DH2D0g=; b=nErQjQnLRMZq8A/zgnQvDrcIq8lB9drZzEY624c39Sx
        AHgkX0Mu7uDpzTBbxoWF3dKWTjxCu3vULPJvBAFeviiRpMuMYyEnVFFjm7IBvoYd
        oWNowSXy2VtJjDlXhodflNoX615DJAVmBuXmnXcoM29+HxFUAzx7+RE6GJel2rfR
        pRaW3NiDTRgE6DiuP+9ZR/MsTCC/MkY06mDNHgJAYONIIMlLKMV3Pgx3GIyiI3Ps
        3WkYwK1+1cnX9OnQv3ue4exALw4p3Q2OPuO1IfLUYuAe1dzk4EqqmIoivSwK6syp
        T9WfMwHENcAwOBqs3yKdVHQ2Fd3IcaSUnQwIx0OMf4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VTF+In
        yvJ1i+IExFvTo0zZ2GIbmUxMajMuGt1DH2D0g=; b=UAasazt4qrIDfv0CJtgUQp
        8eISUDCS7p35pAPjDkdeqVUUBlYq7C6rY7MPDC/yk5AF91AvcqG/AAWJ31X69G5c
        VV+695VJKApew1Yi+hrvynPfIkP5mESsc8TsaXdgZLZdsfpfTAqAASYaODauWNA0
        Ea+prsSB5Msq1QAUcLVuAluDzuV4LAepOWvGaO8tpigmB0sXxdjKAXbWXBLd/Mz5
        2k8Wcr/ARJZurra7YHlmykpVvA/b49UZA3Ou0FfGHcJz6BSHObxAB5ZboNnyj9q8
        Xl2c6lHi/kr3F4BGwkZkBJ9GjV6BRg7ip3hPxxjKE6eZHel1RRxPnlZnrPAZakEQ
        ==
X-ME-Sender: <xms:oYUqYEdf1dxzdiTAtt-V6tLqrokHF2TspyFyyS5IVoCdGbLssZWRRw>
    <xme:oYUqYP0NfP0FVYl5a8lfk0DUKUd7fBPphZH5974kRJjUscsYJOfvEcvKWsJXSH2Zd
    1qvZSepUKWgPg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrieekgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:oYUqYFg6cV9GBNAKpBcidjPZmTiLBvFvb1l0YMSna0BbBQW-kT6C_Q>
    <xmx:oYUqYNTvPqtVos1qhZgibTgOygnq1zvvBFmS_ZnGfLZJiogen04eTA>
    <xmx:oYUqYOgYf00MfMxhOZoS9qy-Wg2GNLSfyxDU4IAoxF0N2U7gglEkaA>
    <xmx:ooUqYMrgmndUSN6a_pb_Ja0nnhwCiB5qPfjohjR6dkpo3VmXSbra5A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 657F924005D;
        Mon, 15 Feb 2021 09:30:57 -0500 (EST)
Date:   Mon, 15 Feb 2021 15:30:55 +0100
From:   Greg KH <greg@kroah.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     fedora.dm0@gmail.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH for 5.10] powerpc/32: Preserve cr1 in exception prolog
 stack check to fix build error
Message-ID: <YCqFn/4YuT+445xW@kroah.com>
References: <f6d16f3321f1dc89b77ada1c7d961fae4089766e.1613120077.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6d16f3321f1dc89b77ada1c7d961fae4089766e.1613120077.git.christophe.leroy@csgroup.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 08:57:14AM +0000, Christophe Leroy wrote:
> This is backport of 3642eb21256a ("powerpc/32: Preserve cr1 in
> exception prolog stack check to fix build error") for kernel 5.10
> 
> It fixes the build failure on v5.10 reported by kernel test robot
> and by David Michael.
> 
> This fix is not in Linux tree yet, it is in next branch in powerpc tree.

Then there's nothing I can do about it until that happens :(

