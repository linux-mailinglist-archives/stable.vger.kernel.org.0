Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3B914F764
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 10:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgBAJkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 04:40:20 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:34393 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726202AbgBAJkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Feb 2020 04:40:20 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id C082E4FE;
        Sat,  1 Feb 2020 04:40:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 01 Feb 2020 04:40:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=npgJrAgT4sjggKO+bPEbQOmpHpa
        yBX0MQXmKKErt76Y=; b=Z+IHjRZ+PHhOjlqt+e1Xbp2eIjqGKrhSIfOM5aia4nB
        n1ja6pf7aVYVjJqN5UVfennPKB0h98VAMzD9jwFYqFEpC3z9kPAz0VDk6QnkZsFP
        AN4g2QNyX2oAVvn5elEGi67Ds3Efky+byb5OYqaTqiW/5XbcrI6aQ6Qh8vlnz2Fl
        OHbsYGtohHY5aNqqQ7pG/u5hoC6YqaCPPob7LyCmHnkTlyxmG+KLsj+nomV/TqQi
        uCRAWq6l1/NpHRfxRONwdg92PvDhjb8MSQnfWtNQeXOCMNPWxozFnbc3A4PzCL3R
        zV5wER+m1W8XmmscUWZ5maATcNTKVbuBuzW4cvvhAgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=npgJrA
        gT4sjggKO+bPEbQOmpHpayBX0MQXmKKErt76Y=; b=vOv+GsKpcqO6dv0T5DUHim
        TiUkXtt2EBYiY65BW1Xt5Rho0KaBxfZ/OjxfCTTYn6IQ4Io39A3aKZvEnPPtv1EA
        TcTmdrqjSLZM2Ydcg5dGUA4j/ipU2jUgqO7+7vaV05+d8NkwYuKTYH0h08R86VcI
        if46ij1zMQ5xR+EkhFOOKiSPqEi6oU9NmEkn6FX6GZfBqQOnh+Ptz6MZqbp8y+f8
        Zsxb6QlFGIdrM2ZztyTOXQnSQCIXa5Rs34TPm2tc1SuNLocc64IgqvbM9OAFaFXu
        jkjghuC9jTtDUSj+AzybM8ipo2qCOB8R1tC4s25ubPO8CReA09/QiWOhc5QFcG5g
        ==
X-ME-Sender: <xms:g0c1Xvd5uw9LMsMQv0Nd6-xAg-VVHogrxeB6yEUaVGzNcGcF1TeaQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgedvgddthecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrvdduiedrjeehrdelud
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:g0c1XqfhGdPdyJQZMCaFyR3sqWt0b2f9188Shdkpm7-0qNzj1o20fw>
    <xmx:g0c1XqO9SNNPFeDYUK6HYvLQcczdfdHMyCf9uE3JejPlkZnA1iP-Pw>
    <xmx:g0c1XpIm5rAVfLyWF3i-yNiYW8zLjC8nFvR2lalKxjsiFFcKNTPFcA>
    <xmx:g0c1XpJTRglUTLkbS3OjAkI0NR6nttTIGEeP_MtrP7msG69QvgnfRA>
Received: from localhost (unknown [83.216.75.91])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB9B5328005D;
        Sat,  1 Feb 2020 04:40:18 -0500 (EST)
Date:   Sat, 1 Feb 2020 09:39:59 +0000
From:   Greg KH <greg@kroah.com>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     stable kernel team <stable@vger.kernel.org>
Subject: Re: [tip-bot2@linutronix.de: [tip: x86/urgent] x86/timer: Don't skip
 PIT setup when APIC is disabled or in legacy mode]
Message-ID: <20200201093959.GA2301481@kroah.com>
References: <20200201093001.GB71555@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201093001.GB71555@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 01, 2020 at 10:30:01AM +0100, Ingo Molnar wrote:
> 
> hi Greg,
> 
> Wondering whether you could include 979923871f69a4 in -stable once it 
> hits upstream - we forgot to tag it. Or should I track it myself and 
> notify you once that happens?

I can do it, this is all you need to do, I can take it from here.

thanks,

greg k-h
