Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDCB3CD1BE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 12:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236261AbhGSJfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 05:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbhGSJfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 05:35:38 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E3AC061574;
        Mon, 19 Jul 2021 02:21:35 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id a7so15472792iln.6;
        Mon, 19 Jul 2021 03:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RsTA6lCPJUSqFkf4kI50Ly+s7/7eeHMzPSdXglSoeiU=;
        b=fCF/wlFqLzoWUG6sB7JEQhqPMSNr0qNYYHAcrGNftTyFMaAxKtbGI0v+eASFWU5I8k
         j8EvuDGk/sotP6K0xugNeM6wScVJaoSbC0CDpDO4otpTZb6anM/A3oAesl6KKGHeIK6p
         KEDxWS86n9ONQf4whk7pTCFOfK5B7tJd32LP/Ie6LvP3f6SSuG4xlmoZ1cMd4dlurc5w
         C12NaHMsP4Wmfawd5cuSqf7J3egAZCZFBiw9TEOmxLiGeZxmYs4JRw/Wex8r2DQLM/ZU
         A5gGi42MWz3AwpAJwriJp7SF7ktQXocm9Jf7FGPLRmDMYHCnIzEuNB1k3gcJl2qAMCWI
         dvhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RsTA6lCPJUSqFkf4kI50Ly+s7/7eeHMzPSdXglSoeiU=;
        b=lKU9TdY8yP6eTRQHsAHOww8UaShGEauHyeGoMkhjLVaxDqZ4bLn1XzOGPlBiFd3N9k
         /TMr5iNehHufgACFYxyKMejaW88l6U1T1s5+4PD8coD27s4hy8IzG3U2T2itw8tMqyMJ
         mFXlP2e3EcnP7qg8MIz7x6SlK3FqD2mlKgCI+2ehasgi1Km9YxsgEk03CTY/bPxac3ui
         vAddUinG1i8EUcj36je6dQi56Z2+teXnhWReuDi5fPiEcSapWj+Y/ShM623BMinH97T4
         QOrn90w9iZhq0YILjwmH8jNA66ICAKMYpFfMthW1OI57JhoHpORxtO7sPDCmUaJ+6/Xi
         WLaA==
X-Gm-Message-State: AOAM5320loqBtEgaoa7oAAhchdx8/YSLROW+wVVnoxR92iL/k2nQdGmD
        QGy7bZEkO/AGUxsiK4qmY1M=
X-Google-Smtp-Source: ABdhPJyg22NH0H96Cln4985p2ZO9QxyhhyxfxkKUd9PhaAdC91kNtz1JN47YbQKDW6ClGowUFMNR7Q==
X-Received: by 2002:a05:6e02:54c:: with SMTP id i12mr16393080ils.103.1626689777961;
        Mon, 19 Jul 2021 03:16:17 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id l5sm10209774ion.44.2021.07.19.03.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 03:16:17 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 7C43C27C0054;
        Mon, 19 Jul 2021 06:16:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 19 Jul 2021 06:16:16 -0400
X-ME-Sender: <xms:7lD1YJCnOA7qdyPTT6Ux6QVd_wzvepX5BIbjW7xnOninRM2B6BFLUA>
    <xme:7lD1YHjUYJUWi3e0F6QtK8hxzMhw36-IBmDBblnmWgU9ZI8qdmtUX0BTfG7_Hvap6
    vRBirsxlKPrJYIaUQ>
X-ME-Received: <xmr:7lD1YEmfHn9bkfKTKIyHfseOZPwsramQSXVCKEaYxL3RwWiTofcVGdJNFIGZng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfedtgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtth
    gvrhhnpedvleeigedugfegveejhfejveeuveeiteejieekvdfgjeefudehfefhgfegvdeg
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsoh
    hquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedq
    udejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmh
    gvrdhnrghmvg
X-ME-Proxy: <xmx:7lD1YDzUVA3o0an-5EjSYhp2BtUXk7U_d1grh6R0MKuCofnmA3F22Q>
    <xmx:7lD1YOQJYM9eaC8_S2_kAj8vHa_PXZuNRhnVHfWLHkWJRCyF2E18pA>
    <xmx:7lD1YGaq3esEAlBTFpfmpHuxCnOtDLmmwrIug6wSrDm5tt3lPxNplw>
    <xmx:8FD1YIG4VwJ1dmeENCapvT0hNrTKngyV8UYWxPV-2KJg0nmKFsHr--Eq1PA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jul 2021 06:16:14 -0400 (EDT)
Date:   Mon, 19 Jul 2021 18:14:21 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Zhouyi Zhou <zhouzhouyi@gmail.com>, paulmck@kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Chris Clayton <chris2553@googlemail.com>,
        Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        rcu <rcu@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, Miaohe Lin <linmiaohe@huawei.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
Message-ID: <YPVQfaamqwu1PRrK@boqun-archlinux>
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2245518.LNIG0phfVR@natalenko.name>
 <6698965.kvI7vG0SvZ@natalenko.name>
 <20210718215914.GQ4397@paulmck-ThinkPad-P17-Gen-1>
 <YPSweHyCrD2q2Pue@casper.infradead.org>
 <20210719015313.GS4397@paulmck-ThinkPad-P17-Gen-1>
 <CAABZP2yE+3vzd+LgJDJcJ2f8qttJQSUQ6efD9MaFd2iD4xPTZA@mail.gmail.com>
 <YPTmtNMJpykEpzx6@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPTmtNMJpykEpzx6@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 03:43:00AM +0100, Matthew Wilcox wrote:
> On Mon, Jul 19, 2021 at 10:24:18AM +0800, Zhouyi Zhou wrote:
> > Meanwhile, I examined the 5.12.17 by naked eye, and found a suspicious place
> > that could possibly trigger that problem:
> > 
> > struct swap_info_struct *get_swap_device(swp_entry_t entry)
> > {
> >      struct swap_info_struct *si;
> >      unsigned long offset;
> > 
> >      if (!entry.val)
> >              goto out;
> >     si = swp_swap_info(entry);
> >     if (!si)
> >        goto bad_nofile;
> > 
> >    rcu_read_lock();
> >   if (data_race(!(si->flags & SWP_VALID)))
> >      goto unlock_out;
> >   offset = swp_offset(entry);
> >   if (offset >= si->max)
> >    goto unlock_out;
> > 
> >   return si;
> > bad_nofile:
> >   pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
> > out:
> >   return NULL;
> > unlock_out:
> >   rcu_read_unlock();
> >   return NULL;
> > }
> > I guess the function "return si" without a rcu_read_unlock.
> 
> Yes, but the caller is supposed to call put_swap_device() which
> calls rcu_read_unlock().  See commit eb085574a752.

Right, but we need to make sure there is no sleepable function called
before put_swap_device() called, and the call trace showed the following
happened:

	do_swap_page():
	  si = get_swap_device():
	    rcu_read_lock();
	  lock_page_or_retry():
	    might_sleep(); // call a sleepable function inside RCU read-side c.s.
	    __lock_page_or_retry():
	      wait_on_page_bit_common():
	        schedule():
		  rcu_note_context_switch();
		  // Warn here
	  put_swap_device();
	    rcu_read_unlock();

, which introduced by commit 2799e77529c2a

[Copy the author]

Regards,
Boqun
