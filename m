Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5990D33BF24
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241778AbhCOOyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239593AbhCOOxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 10:53:50 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65885C06174A;
        Mon, 15 Mar 2021 07:53:50 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id l4so31898186qkl.0;
        Mon, 15 Mar 2021 07:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qE9Ppz0N3hLMfdFALMqtSOrt8JpFdsQN6dnt3f0ZSTo=;
        b=SAZ1uES/qFasD82o1L631cG0J0AqQtyqJx1AjdKjg/G4mncs9dUf9WJiLR3D4O5ldW
         UfMywQOopH3ai3pwoB3U4MggR3RYqrDo4ZJETv36rHPxEm9NJtq5QrtI98vpJXb8Cv96
         wTDWCFAUuuioM9cfVvRYlkTn18gTmv/FL9uRKPGM7W2LYm0OVz1+xezFFRCpcEh+ux7E
         6T0IKao3XCdD6JpecH0d3Spc0c7EeVDU73hORpd/YTJvDZ2l4C3o3HwWIaq3KmASAIr/
         /DR6KcSQ4H90Y+yqbhYB4eSAV+40pvJqDLXKZgnvD1qu9WA0sv4BcgmX9t+rxrtTZfsa
         yd+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qE9Ppz0N3hLMfdFALMqtSOrt8JpFdsQN6dnt3f0ZSTo=;
        b=nJuuUrIAaPDylYSWWy4eF3L79X1pd+4didQjzWGutwoxW+F8dp6VKH//U/rLbA1eWI
         m4GzSkNi4FZwLZPhAwrq7uHQhCOmPHxsi7Hd3EQ+NqqXgFjhFXmDpcLrLLJ8cNY3iqlK
         gphZs1vjl5WMhBQEdEiRxj1JerG3HWfbbommN5X7RdMW6VN3tOLbAXO+6Y3+R/H/pbnG
         MfkaIiSNFkIFRjbxrJDLI/s4pTGA4qvBnMNCocfrT8kvgkU1pmX6K9L7ad0jVbd6ZYew
         IMrNF8ONENtxSMSQPcwdKMEEZTaa4b1IOzFTpZR3YTsU6YsCyVWe0Z2/547nDaxxHLra
         OdYw==
X-Gm-Message-State: AOAM531OBtzF+pHpHGPrbYw+EwJPUS7CGvbeM8loML4A2j7nuXGZgehl
        SHz6vExGoh696Zt9OWlrlqA=
X-Google-Smtp-Source: ABdhPJxM+2aIt3zQQ3Gp6cLT+xUskFnn0JwG0+35iILUORVbHTjZRwEv1XNZfN/AWwRZ2LJYcThOwA==
X-Received: by 2002:a37:5884:: with SMTP id m126mr25279968qkb.459.1615820029645;
        Mon, 15 Mar 2021 07:53:49 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id w13sm11350021qtv.37.2021.03.15.07.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 07:53:48 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailauth.nyi.internal (Postfix) with ESMTP id 3D8B327C0080;
        Mon, 15 Mar 2021 10:53:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Mar 2021 10:53:48 -0400
X-ME-Sender: <xms:-3RPYAz9bZTgP8l8qpwj1nZ7sAK-JFjwpuFe_MY30Ep66WOBdms-wA>
    <xme:-3RPYD9IuDwiDiSKwwBgAVWAccU583XrMAPmYASDJ7tcrUDEv3LKl2jtCwXgkfph2
    MsvokTdATE4F9--3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvledgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrth
    htvghrnhepvdelieegudfggeevjefhjeevueevieetjeeikedvgfejfeduheefhffggedv
    geejnecukfhppedufedurddutdejrddugeejrdduvdeinecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunh
    drfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:-3RPYN_i6wmeYWAQuUiS1bzS_IYXTOO6k6sy_7HKeC69vEU4q68QNw>
    <xmx:-3RPYKU2JqaNy3uFBd48QmkSZhdtq7kOsJdC2vXQsua_pMVb9V3hZw>
    <xmx:-3RPYCdVXoDjGT-Y-UeabYm3IRoBGKR7TsXzpAcaFQ1CvjDiwtfxdQ>
    <xmx:_HRPYLip858_820HzlTqKX15HIcPx4t1Zd5rNXMa9jk4WNPzAg-1b0-EvJE>
Received: from localhost (unknown [131.107.147.126])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1846E108005F;
        Mon, 15 Mar 2021 10:53:46 -0400 (EDT)
Date:   Mon, 15 Mar 2021 22:53:36 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 10/13] rcu/nocb: Delete bypass_timer upon nocb_gp wakeup
Message-ID: <YE908FC8F8/0p07q@boqun-archlinux>
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-11-frederic@kernel.org>
 <20210303012456.GC20917@paulmck-ThinkPad-P72>
 <20210310221702.GC2949@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310221702.GC2949@lothringen>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 11:17:02PM +0100, Frederic Weisbecker wrote:
> On Tue, Mar 02, 2021 at 05:24:56PM -0800, Paul E. McKenney wrote:
> > On Tue, Feb 23, 2021 at 01:10:08AM +0100, Frederic Weisbecker wrote:
> > > A NOCB-gp wake up can safely delete the nocb_bypass_timer. nocb_gp_wait()
> > > is going to check again the bypass state and rearm the bypass timer if
> > > necessary.
> > > 
> > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > Cc: Josh Triplett <josh@joshtriplett.org>
> > > Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> > > Cc: Joel Fernandes <joel@joelfernandes.org>
> > > Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> > > Cc: Boqun Feng <boqun.feng@gmail.com>
> > 
> > Give that you delete this code a couple of patches later in this series,
> > why not just leave it out entirely?  ;-)
> 
> It's not exactly deleted later, it's rather merged within the
> "del_timer(&rdp_gp->nocb_timer)".
> 
> The purpose of that patch is to make it clear that we explicitly cancel
> the nocb_bypass_timer here before we do it implicitly later with the
> merge of nocb_bypass_timer into nocb_timer.
> 
> We could drop that patch, the resulting code in the end of the patchset
> will be the same of course but the behaviour detail described here might
> slip out of the reviewers attention :-)
> 

How about merging the timers first and adding those small improvements
later? i.e. move patch #12 #13 right after #7 (IIUC, #7 is the last
requirement you need for merging timers), and then patch #8~#11 just
follow, because IIUC, those patches are not about correctness but more
about avoiding necessary timer fire-ups, right?

Just my 2 cents. The overall patchset looks good to me ;-)

Feel free to add

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> > 
> > 							Thanx, Paul
> > 
> > > ---
> > >  kernel/rcu/tree_plugin.h | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > > index b62ad79bbda5..9da67b0d3997 100644
> > > --- a/kernel/rcu/tree_plugin.h
> > > +++ b/kernel/rcu/tree_plugin.h
> > > @@ -1711,6 +1711,8 @@ static bool __wake_nocb_gp(struct rcu_data *rdp_gp,
> > >  		del_timer(&rdp_gp->nocb_timer);
> > >  	}
> > >  
> > > +	del_timer(&rdp_gp->nocb_bypass_timer);
> > > +
> > >  	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
> > >  		WRITE_ONCE(rdp_gp->nocb_gp_sleep, false);
> > >  		needwake = true;
> 
> Thanks.
