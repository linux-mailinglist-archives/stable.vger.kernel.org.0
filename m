Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9296C10AAD0
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 07:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfK0Gxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 01:53:45 -0500
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:50731 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbfK0Gxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 01:53:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 05DB47BB;
        Wed, 27 Nov 2019 01:53:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 27 Nov 2019 01:53:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=B0mPw++l8p6HLV7BgESX8Ad2sit
        vnZ/g/HTnedtorqQ=; b=nCPps3pwXl5joesg9r7VdrSTcgFsYxh+36vsjZEdyW8
        twqViyjSJpEvzVlfhCN4rUbuZdCb8misat0UIRuAbTF/N1dOE+7rT+KLulErEZkj
        dvV5GuLIw2Pnw+/sfcd5V7IrlNYCIfSspLb8vOzG6uZRMTorKxDYR4PO+n5v7yNp
        AuaxyA7uZPlv8+6oDPAoKDnWMcGsnSJHstGFLF3ztK5stujnrO8VO7FYMBeg0TVK
        Z0IpUxTURWQScsnZVT2du/VRzbWo9ftMaK/LgUhzqTgio6dkCEEdbhVOejdHuBUD
        cv/UrzbrKLMDzd4KIejU7rlL4d3ppSyCF1smWPZm1NQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=B0mPw+
        +l8p6HLV7BgESX8Ad2sitvnZ/g/HTnedtorqQ=; b=CZS59tomepkbYW3NIjHPva
        vfQ1NTyfRYLdOQDNOufTYo0KFcMDN+SIUtfZvHEfLqyFn5A8chk2aiT/Sqo9/iHy
        rlc9xKQCMDKt3dK5TMOO8EQ88qhraD0Yfr4TzNf+ILcoQSkhFKDaCw+FTJG5+wxq
        XQWWXr4AgqdL5dtPN4LvEl768JWBwJ1XW5cqPcuEDX6jUFbOhy2F12QPacyPSabG
        /JEYqg+xAFMrT9m9BTJzytxCG0Ac7XTTv7jaD7oc/fJW+Q3u14rBzluzsxdWgsrK
        mnU67lE02pG/19aPet2YQK4HeV6q38UsoclYzH0hIgKR9iLLHmADeM1wV1iIxRhA
        ==
X-ME-Sender: <xms:dR3eXWzvjcvjnSUgj7wDcVjx4lwzJ-SkO0XNtRXPoExntf3dwhlXIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeigedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:dR3eXenlxFH3JATnk-4Vp00G0RTMaUUON3kXpOoThfdmt_QD7eylRA>
    <xmx:dR3eXbFDMMfaqP2J_zp9c7FoPuEZPK3qcOPsN-HfXtHXp_c48_TcVA>
    <xmx:dR3eXeV3Herp7KxpD-ja_Qt6UwewanwPQxTusqXu65phobU5sKBvcA>
    <xmx:dh3eXcSxu4Oot6AuwErPz_OW1V9Orkmhi1ywd3eu-cUeMsBPC9cAINGtfik>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 033F98005B;
        Wed, 27 Nov 2019 01:53:40 -0500 (EST)
Date:   Wed, 27 Nov 2019 07:53:39 +0100
From:   Greg KH <greg@kroah.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Nathan Huckleberry <nhuck15@gmail.com>,
        Miles Chen =?utf-8?B?KOmZs+awkeaouik=?= 
        <miles.chen@mediatek.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Tri Vo <trong@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Stefan Agner <stefan@agner.ch>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: please apply mbox files for CONFIG_UNWINDER_FRAME_POINTER clang
 support
Message-ID: <20191127065339.GE1711684@kroah.com>
References: <CAKwvOd=eubuZH-tVY_KX2pjp4rnTzLBkk9iPfaHkRDqg2zaBKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=eubuZH-tVY_KX2pjp4rnTzLBkk9iPfaHkRDqg2zaBKA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26, 2019 at 03:12:43PM -0800, Nick Desaulniers wrote:
> Greg, Sasha,
> 
> Please apply the following mbox files to 5.3, 4.19, and 4.14
> respectively.  They enable CONFIG_UNWINDER_FRAME_POINTER support for
> 32b ARM kernels when compiled with Clang.
> 
> This is upstream commit 6dc5fd93b2f1ef75d5e50fced8cb193811f25f22.
> 
> It's a clean cherry-pick to 5.3.
> A slight nudge was needed for 4.19 and 4.14 since the config name was
> changed in upstream commit f9b58e8c7d03.
> A further nudge was needed for 4.14 since a4353898980c and
> 469cb7376c06 don't exist there.
> 
> We're looking to use these in Android. Trusting the better judgement
> of the stable maintainers, we're happy to carry these in the Android
> common kernel trees, alternatively, but I think these are pretty low
> risk to take.

It's a new feature, so no, I can't take this for the stable trees,
sorry.  Feel free to carry them in the android trees.

thanks,

greg k-h
