Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5846739FCF1
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 18:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhFHQ7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 12:59:46 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:49629 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231840AbhFHQ7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 12:59:45 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 97FB219FE;
        Tue,  8 Jun 2021 12:57:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 08 Jun 2021 12:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=x
        KFvQwF2xuVNgTPeEcCZemf+7fKbI5Bf8jPTvXQSMt4=; b=MCEdnpGEVeOPG6epa
        Wu8GULVqnQT7AGc5kSHynTmSJkYQK35AFc0O8/eccqga40Q9dJbe9Uoqg55XQTy0
        DMydZTL7HEz1RHjQWvvqqqecfXaHsvWAp07XjWDmZdVSsWado9ygPyLubwC2mryo
        VOBFVCMadbR+7caFy5tuAh2CMZnW4hZbWwmoBOW0mhItxvtDNk17pixoWOXTv3iD
        TEBctFuCn3fgDFH930N11AqDTy+bBEiMEA//8bqW6CIjl65Gzus4bgh/t4GdvMcx
        UImU+envPfkDTkPeTcbLz4HBEvL28Ilb98Pvu497FqttlacyMd6s2PprTQIrZccZ
        EWLbg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=xKFvQwF2xuVNgTPeEcCZemf+7fKbI5Bf8jPTvXQSM
        t4=; b=cQwDIwj9j1efi1MDaGwA3IVoyBWxRM8rhSZhsmfSXqeGIExmdUQBnDMar
        xW1lmG4Fr50I67v099llKQziQejA5ZysyYKuS9F9JJ/6P1zg81l1eUKMlJzkUjtO
        2aWInGZKgou/D2d+vO5aHcbsXBfHPqhATSOPuZjHEFjLDmoH+nkf1wHi3nyhCRNV
        8Yd+I5NHV/Tw/jVPH/xH9Q0jpWbXCjhuak1YJvQZCTTuCtGpcRCi4ODEDowhU4Ts
        oMWRvZ2h6logyDdPoCP2nLGDtKjoO3BCgISiwl7r1gK/Uuh9VeBan7eAhRVWFxUM
        EFQ7gDn/N0qY0JKp+WChSfz2ER1wQ==
X-ME-Sender: <xms:jqG_YHahQ7zTFs1kz6gDIkm5OeBxhPgX9aIFYjlI7Ok5s7Y3-z-Dkw>
    <xme:jqG_YGbfmWDhNUl3G2NbaM3OB6scXeXaMrsKoO70ljU0aCX2CNtnVFWELc9SIpKLT
    zK6SjIVTEOa7Q>
X-ME-Received: <xmr:jqG_YJ8aor0F8CE0OPzcsVa6JQwvMsSByNRLLkD_aqkStn568fiEvlZczCQxaL0JKTqI9K5shSL9gsUjHU1COrdSVUiezl9l>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueehke
    ehlefffeeiudetfeekjeffvdeuheejjeffheeludfgteekvdelkeduuddvnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:jqG_YNqbZxN3JdCgeeSCUHQwuUIau7P7VFsKfEg6LtXe6hpJZ8V5yg>
    <xmx:jqG_YCr8Xk7s7lKkbep7NSOWa2kdiG2HTNlDU0ZLDakYQI7OQDOE0g>
    <xmx:jqG_YDS2nRiUxxAeglSMOoCbU54Jxa2Obd9cLLePpWREV8pykLU4QQ>
    <xmx:j6G_YDdQVGn1yC2plGOW6-nO7WOHC99AY3fWgXCYQSqARd2gXLQk6w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 12:57:50 -0400 (EDT)
Date:   Tue, 8 Jun 2021 18:57:48 +0200
From:   Greg KH <greg@kroah.com>
To:     =?utf-8?Q?Lauren=C8=9Biu_P=C4=83ncescu?= <lpancescu@gmail.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Backporting fix for #199981 to 4.19.y?
Message-ID: <YL+hjH1I0qXOArdW@kroah.com>
References: <c75fcd12-e661-bc03-e077-077799ef1c44@gmail.com>
 <YLiNrCFFGEmltssD@kroah.com>
 <5399984e-0860-170e-377e-1f4bf3ccb3a0@gmail.com>
 <YLiel5ZEcq+mlshL@kroah.com>
 <addc193a-5b19-f7f3-5f26-cdce643cd436@gmail.com>
 <YLpJyhTNF+MLPHCi@kroah.com>
 <YLzAw27CQpdEshBl@eldamar.lan>
 <YL+AMiD7falsvZOf@kroah.com>
 <41c228f1-451e-d5b5-f4a4-bd1bf13389fb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <41c228f1-451e-d5b5-f4a4-bd1bf13389fb@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 05:45:44PM +0200, Laurențiu Păncescu wrote:
> Hi Greg,
> 
> On 6/8/21 4:35 PM, Greg KH wrote:
> > I do not see a commit a46393c02c76 in Linus's tree :(
> > 
> > Are you sure these ids are correct?
> 
> Sorry for the confusion, I think the correct ids are
> d737f333b211361b6e239fc753b84c3be2634aaa and
> b1c0330823fe842dbb34641f1410f0afa51c29d3.

That works, thanks!

greg k-h
