Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A832635ACF4
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 13:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbhDJLat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 07:30:49 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44001 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231279AbhDJLat (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 07:30:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AB6F25C0109;
        Sat, 10 Apr 2021 07:30:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 07:30:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=YTCcS6TlCRRkwsAF7FqwhifD/vB
        TIXiE3hWM+5pNyjU=; b=D0SbLl8yzwsq+TKkDMgwYdg2QOW6jyOPeP+BVey12ZO
        kfSG6cM7UWWZ2iNTTb96/usdvlrgLtwVWCqQqT1TeWL+V0m0qvqzXIGC8hT1xh5g
        pSHo4ZWyycrG8KlME714xjtlXO7V4R8OoBMK+XMUIalU3wH1RG0I0iX8J6SxvLjf
        rW3AtwuaLhqZVE9sLSrF+QGlCODyw8di4tveCuqVpEcs+ftLyCGhM4eviYoVrwLQ
        xcat6sBSP4FiRYOkJLT8cGy6HDyHzi3KuR0mNibg2ervFcICc94sk5U5/oa40CrH
        FUVo7POvYIeOfxz998UdVsuvSwIRQzxLag+9MFJ7ZbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YTCcS6
        TlCRRkwsAF7FqwhifD/vBTIXiE3hWM+5pNyjU=; b=EywXAJNZXTHe/cZ/YteTsG
        1vszJBqn1PhepTol/DAyCQigjwNSDqgCerKJmtQm/6lzqL+M2Ix9SCqUYXtcRVQt
        VUJZ9aZHxNcuitvC2krMLKf/WPdspckCWzZjVNcw5ctS9OQQdgap1SSRAV3GTNMs
        /C+i/tE1NRRakD+LnNarhj641Kxm9KcMVQnqRx72PkiZIR+tqBp0IhfnVK7CiulU
        OEwjkAhlK+hkFyspNdeSYtiLbWEKjt2mjIWyO8soUhW8huSJbnBV3Kt4UCAiRf/m
        PcdtcTfiUCJCuL3qDJ91ZSZN3DsSCJJ2YyAwcMY0JyjbrOfs8J8X0IPKxAZn8awg
        ==
X-ME-Sender: <xms:WoxxYA2alzyPrKFkGajZ07IVWq35JWyETObjUfDVFPgjeVyP-Gk_ww>
    <xme:WoxxYLFh5pI4mlb1CRikYDViX9GQW02u0d4wcVfS09hbn4lF0fDVtQYtCvez-OTF6
    35ECurfpnVnSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepveeuheejgfffgfeivddukedvkedtleelleeghfeljeeiue
    eggeevueduudekvdetnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtoh
    hm
X-ME-Proxy: <xmx:WoxxYI72aAy6OmZOwuNfCqMoAPq0ABfRHXk69Vsj3x6Ijeke1JqMyg>
    <xmx:WoxxYJ36_0lEVFKkHnmQUTenplsadUlu8JEZkRhc3uNWnIosL4O1Gg>
    <xmx:WoxxYDGHJugeDYrQkQ4FXCxajCrMmW0DYHw-_05bGL9wDmDA_1ut1g>
    <xmx:WoxxYKy5uIOeky1YfWxs3Cifm6SJRtA-ci3JhKt3lZ62-jeJvrLtcQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4D04324005C;
        Sat, 10 Apr 2021 07:30:34 -0400 (EDT)
Date:   Sat, 10 Apr 2021 13:30:32 +0200
From:   Greg KH <greg@kroah.com>
To:     "Zidenberg, Tsahi" <tsahee@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/2] fix userspace access on arm64 for linux 5.4
Message-ID: <YHGMWBj+DEW+EiQE@kroah.com>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 01:56:53PM +0300, Zidenberg, Tsahi wrote:
> 
> arm64 access to userspace addresses in bpf and kprobes is broken,
> because kernelspace address accessors are always used, and won't work
> for userspace.

What does not work exactly?

What is broken that is fixed in these changes?  I can't seem to
understand that as it feels like bpf and kprobes works on 5.4.y unless
something broke it?

confused,

greg k-h
