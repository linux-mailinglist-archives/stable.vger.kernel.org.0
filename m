Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BD9310736
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 09:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhBEI5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 03:57:05 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35829 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230034AbhBEI5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 03:57:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D88595C00C5;
        Fri,  5 Feb 2021 03:55:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 05 Feb 2021 03:55:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=moHFmjFYaKsJDKf96AsqqD910WG
        eWkybbH8yb0jUZJs=; b=m0sYpZFLNOI1TL7ZxWITZ9Hzkm7iBYt1wCMfTtleVkr
        6LJnB7Lx0DJfopAatXyGsgwqXeDYHVQR7JeMx9XAZpaTAqFk1xfd1DIfmvV8C6bw
        WHoqPOaQgXu/qTHjo3m5/8eDn2iwTLvbpQt7q+fIApKpEur8FhGG3LMQd9vsw3Fd
        1NyafBhxbZO8+GJkCo/hMUmJStD+9ik/2dnD1dsrzc1gM7p7UjpK+VAGpBhXMWEf
        ahXmt9ZFqqp5eBAN0sg3w8YAKWV/X3Owz4QUCghyLaXmsjTqG8IaK3W79sqLIm2r
        9yFd/D5pmK7YaNcT+e8Zw1KvNqGHsQWGGwrwgkz3V8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=moHFmj
        FYaKsJDKf96AsqqD910WGeWkybbH8yb0jUZJs=; b=BnEHt0zCXEUF5EyuSVgMdH
        nsL427kLDYB1hcMetYCT4yfQQfMlx81qHjcQ8IehuZXlwLmTqV3OZCY2Ge96ptrP
        H/NrtZn97pdNB+CgsqKth2I8sMAsIlnGNQx6vwL0pBJ6DoX3JFBiIExHLFbi+/Vw
        T0qTXH1dcgccP5zsSV7rDqMVemumUCr3ehFv1DyyKviElAQP2FPi9qSGUosdgmUj
        nKOCx7NF1MrHg9uClyVc6zsF97zX5MqJYMrVuIfYhkbl0S8DaWEZZhG80gua9S+e
        UNyJkDpH2Si9A2v8nD5xQ3J8gB4U3uGEzLan/W65o40Y6c+xCRkTLHZUJw3Vk3Ww
        ==
X-ME-Sender: <xms:GwgdYDtIVJgSW6bDfKXaS0du35h9pPNC9W72vdfTTZCHkh3ypbIa4w>
    <xme:GwgdYEffIZ0Y5chSdoKBO5EnAYSZwo-td7sG8jM6sqxc1hhgbmCOjpJAYSpffMUVr
    8ZMXlQgrwR1bA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgeehgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:GwgdYGwz2rRuf7jpj2exDBghcoMLuHUmNLLxSwl9pOFr9Jv391aIBg>
    <xmx:GwgdYCNZjl-pCq49crjI1dJQo2KHSnfwbrYuOfEgWTF9iXwB4FYntg>
    <xmx:GwgdYD8qOVbJqrLeDi6H3a__C_pNc799Pn8yBSzP7QhbRSUJ1nRr-g>
    <xmx:GwgdYEPJ7eenK3SJ60zIVV8orSRtByQUO1ifbHcaO8GRxfWyoKfiJw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id ACBB8108005C;
        Fri,  5 Feb 2021 03:55:54 -0500 (EST)
Date:   Fri, 5 Feb 2021 09:55:53 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, bigeasy@linutronix.de, bristot@redhat.com,
        Darren Hart <dvhart@infradead.org>, jdesfossez@efficios.com,
        juri.lelli@arm.com, mathieu.desnoyers@efficios.com,
        rostedt@goodmis.org, xlpang@redhat.com
Subject: Re: [PATCH 4.4 00/10] [Set 2] Futex back-port
Message-ID: <YB0IGXv+vC45mU0S@kroah.com>
References: <20210204172903.2860981-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204172903.2860981-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 05:28:53PM +0000, Lee Jones wrote:
> This set required 4 additional patches to avoid errors.
> 
> Peter Zijlstra (4):
>   futex,rt_mutex: Provide futex specific rt_mutex API
>   futex: Remove rt_mutex_deadlock_account_*()
>   futex: Rework inconsistent rt_mutex/futex_q state
>   futex: Avoid violating the 10th rule of futex
> 
> Thomas Gleixner (6):
>   futex: Replace pointless printk in fixup_owner()
>   futex: Provide and use pi_state_update_owner()
>   rtmutex: Remove unused argument from rt_mutex_proxy_unlock()
>   futex: Use pi_state_update_owner() in put_pi_state()
>   futex: Simplify fixup_pi_state_owner()
>   futex: Handle faults correctly for PI futexes

All now queued up, thanks!

greg k-h
