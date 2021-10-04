Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85ACE4209CE
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 13:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhJDLRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 07:17:41 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49031 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232519AbhJDLRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 07:17:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ECAB95C0126;
        Mon,  4 Oct 2021 07:15:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 04 Oct 2021 07:15:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=Ro+x3/V0XJj8yniVDrm2njrKNgN
        X3rskcmDa6rLY6i0=; b=ft9/QkKLU2adJp/NvRxOPEejo5akgs3Ajm/8Ygai+gv
        firDS9zqhd311OKeYKWUm3G3E1s+/siASlqbr2zrMsO4bMjTGOU3QbrAl1P1/NEk
        bAmIRN1o/T0xk3nL4aUL2IhWO9uQ5z3uCY25coLvZte/XqkOWUcVGhy9x6gh+jBf
        acdJw056YprZqhKDjHfv5HalGIUaV4F5hrr0ssM+bGjnJgRMxke3DfON2rmDeGJj
        4kMEUuUvo8NTWJO45z6Vr3r+fHqmoOrCmBifmwTmxXH9Qin3W5RO6EIALJnnP1M4
        UuJlDFF2odNT4S31DUL0o2hHhPVNQFlQKxYZu0hsTFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ro+x3/
        V0XJj8yniVDrm2njrKNgNX3rskcmDa6rLY6i0=; b=Yo/Hn8UVQwsLSlMy+yP0xt
        6kKI3SpqevWaHUcA5fDM23tIxW465kdj78c3WIgZiBpSk/UNcfMpy6hmuHQVpRTP
        L1P3+x1pbFLoEpLUkhTPwvk12E3Old1LmwaPNmds3cIUPF5hsxNgnzDtZel8Jvvo
        F0zqOZSlx+IFL3jALeZJdUmbVnmro8S8n5hsVGbV6Mhv5lDDu+SjAlLrqN/PQxnO
        wrccKP09BmhseDuYDBOjHAtbu+nAQiCoAKxFh6Nih9nbF4Zj7r0Ql8/e5Yeiq8Gh
        H3cGsedT2MhCJVZF6nTkrBmSGcVjVLQ6A30MiV1232nvGhFyt7lzV+5Kv0Cj/5VA
        ==
X-ME-Sender: <xms:ZuJaYZdYGABB6gm1RjXHm19dQ1tDwdtnTqLVfIyXiYZsBIFPyH3pNg>
    <xme:ZuJaYXN-H88FeqOf39PpXVgPv9m805r2kpy0Al-D9MWf4hPDZBkBoEakqLiwDoj0x
    I8qwmLMUwkUIw>
X-ME-Received: <xmr:ZuJaYSiBaL8W_iq9_o4a-954kol76u6ihM4IsZxKH_YZ3e1W4uPdKt5B8xeovuDxeiEA4RY0j5OB2kL5WO2UVrzlk29oM6hS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelvddgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ZuJaYS9aTGnZcxf6JyCZrA2R-ixJZI8IpJ9GVhjrnCdRE3UqptaVvw>
    <xmx:ZuJaYVtkIJDWmFIhy6DT35-XHmRzTJmGmkAb-kS5R2mef6-3tTMBiQ>
    <xmx:ZuJaYREZv2apK8Y993XIMx4U6vECl3wbRBcAHq-DPy5oCmwNRXKKiA>
    <xmx:ZuJaYe6Bc3U8bcz_hjFXNNtklPYAYa22-DJVZndBqHdsLnVN8ZZaPw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Oct 2021 07:15:50 -0400 (EDT)
Date:   Mon, 4 Oct 2021 13:15:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4 0/3] usb: hso: backport CVE-2021-37159 fix
Message-ID: <YVriZLdyjyQ4iEDg@kroah.com>
References: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 28, 2021 at 04:15:20PM +0300, Ovidiu Panait wrote:
> All 3 upstream commits apply cleanly:
>    * 5fcfb6d0bfcd ("hso: fix bailout in error case of probe") is a support
>      patch needed for context
>    * a6ecfb39ba9d ("usb: hso: fix error handling code of hso_create_net_device")
>      is the actual fix
>    * dcb713d53e2e ("usb: hso: remove the bailout parameter") is a follow up
>      cleanup commit
> 
> Dongliang Mu (2):
>   usb: hso: fix error handling code of hso_create_net_device
>   usb: hso: remove the bailout parameter
> 
> Oliver Neukum (1):
>   hso: fix bailout in error case of probe
> 
>  drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)
> 
> -- 
> 2.25.1

All now queued up, thanks.

greg k-h
