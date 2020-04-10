Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C232E1A439E
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 10:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgDJImE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 04:42:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60959 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbgDJImE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Apr 2020 04:42:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id E5DEC5C0189;
        Fri, 10 Apr 2020 04:42:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 10 Apr 2020 04:42:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=sOBXUSVXStCfTNieFarlvMr29qD
        kLbxsNm7ta1fJEac=; b=NePG3nwJZu7ahVjP97YX2OTUAa0/Dkkjhl7XgYVb3hy
        FtP26U7dNQ0N9lxxIDecYiXp25BgGpDnH5UCilyiUzbP+pnpClLSITr28vkUrxxm
        d9v0FVXcau/dltALKM8b3bYDTUAxYGK8x30yq+52ONqOO3e+sd2ErWNx66HVAMVu
        nuGQzi3C2rnQvvy+HkpONdN+YO1fZu/oz6S2Yae6B/23aszbOC+fVwRvJkk4AEDF
        2QRnLudiGVqa0Y+E9d71oczq3SPu9o9vOcs4ViKcG3Qn2/nlbnGxWgqzIHO4UF1/
        wYYpnWh+kpjzeaKXWuNRqvW7aXxaoZKhebnIgzH0I1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sOBXUS
        VXStCfTNieFarlvMr29qDkLbxsNm7ta1fJEac=; b=feHKxiVDInEiJFET8daj6w
        pdi7lXqcdjV7VUCTwCOBELFtjT1ZqaAdinp/tdCyJH2h6uJVXEy+RDk3qa8EqMi+
        ZtoocGchnbTnF+rd83foUAKQ7v6Fj7ygU/uHGz/q/XnbXFioWGR6WSeBGPuPBifc
        ikCUF8EVpwEAs2oQ48+XKASmOFSZWyRx+rRhDRRHq6wdMuIcml8Efn8e4SE+/nzB
        o8C5krpWzr+cFfVzlatUzw6srd5SgBptnNP1vwyKwA9+L/GNS50mKXV/pYlW8/yz
        /ztCye7IXhy6aOJb6njGIGiFDNm/SyiXFCHbxyM4c/YrDcAyS4ctApl4hZPNi5Uw
        ==
X-ME-Sender: <xms:WzGQXi8j9661dZOJjvk9vYd3WwXd5XxqNz42ZD_gcfO2J8jeXCI5wA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrvddvgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlhdroh
    hrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:WzGQXm8qT1thB9UIWvSEC2uI1Pv9N7KSJrV2nSv5tyQyaA89cinvfw>
    <xmx:WzGQXjC40yLKeUrbuR3fbghaOPwBmYlcFIRYfIiFyVW9sD0EdEQ9CA>
    <xmx:WzGQXuyV34Yc3Jcp7AGEdaUOSf4pto86v3NmvGQ7XUQ31LEf_CKTvA>
    <xmx:WzGQXuLXJTV2r1BLfEwcVlyjykgAu-GKUCneOFTGY8yoKMRndDOvSw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E5103280064;
        Fri, 10 Apr 2020 04:42:03 -0400 (EDT)
Date:   Fri, 10 Apr 2020 10:42:01 +0200
From:   Greg KH <greg@kroah.com>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH for 4.4.y] x86/vdso: Fix lsl operand order
Message-ID: <20200410084201.GA1670984@kroah.com>
References: <20200408082430.4132299-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408082430.4132299-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 08, 2020 at 05:24:30PM +0900, Nobuhiro Iwamatsu wrote:
> From: Samuel Neves <sneves@dei.uc.pt>
> 
> commit e78e5a91456fcecaa2efbb3706572fe043766f4d upstream.
> 
> In the __getcpu function, lsl is using the wrong target and destination
> registers. Luckily, the compiler tends to choose %eax for both variables,
> so it has been working so far.
> 
> Fixes: a582c540ac1b ("x86/vdso: Use RDPID in preference to LSL when available")
> Signed-off-by: Samuel Neves <sneves@dei.uc.pt>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Andy Lutomirski <luto@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://lkml.kernel.org/r/20180901201452.27828-1-sneves@dei.uc.pt
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  arch/x86/include/asm/vgtod.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

What about 4.9?  I can't take a patch for 4.4 without also it being in
newer kernels.

ANd always cc: all the people involved in a patch, let them have a say
if this is ok or not.

Please fix up and resend for both trees.

thanks,

greg k-h
