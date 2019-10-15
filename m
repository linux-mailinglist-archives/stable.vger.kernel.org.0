Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9553D75A6
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 13:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbfJOL4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 07:56:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36959 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfJOL4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 07:56:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id p14so23495558wro.4
        for <stable@vger.kernel.org>; Tue, 15 Oct 2019 04:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yAwedaQmhP6SnPIEV8Cz99ZuZIEK2enEAC2WtodOdw8=;
        b=bhF8okyTKEtKzcimYTnw/ute32N+lw/PA1aVErlt0+7GqFytvWWW/UuV9QZ+b7u9/d
         KdmBJouzs/udg4X3MLdcpSfC12BH0baq40PbjzQqIu41aIGSVFiHWTR3ZIEnBXuLmKPo
         lstQs9dPKuX1619CdQyOMPawyuMw8qAUiObWYSawPtbRjFjutB9Afy4RG7yELu16XEkT
         5GPN/0bJf5l0hV8py8jMQFFR7VWohk7uW0Bgwuyfe5Zaktc45lFlWXqCqnNY3Rr2YEHv
         l/Dr1/eHiI5m4DOOluHL+dnLMWd5F4GrLGIBN9YWxmXnYkHni7S41YjWj+o3KOdziFK1
         QQVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yAwedaQmhP6SnPIEV8Cz99ZuZIEK2enEAC2WtodOdw8=;
        b=AEi/e8BHFC6wV5OUUtK9NELH0c/H+Rfi7Gv60j8bDdWgET1SFHUOArp2gcflE1mlTe
         dCWPdFLYroeYAvKJavJ6wVdnGP4S0/C4i22g3mq+h75R6964R59Z0TBKpKSzejXWf7Fx
         uZZRo58b1Tmxk1bH6V6SfHMnWKi/d04rdJZwYkvf7w3Y9Qm2xHb8Nfv9y53srxm9+4qs
         xAT6MYTQZT7zpNhKc0rpuG0LgcY0bs+22EMJbZrggMmdqIAJg0itAQgnqQ28uLRYTphX
         228GqwMMbn3bdQGnOC7zCJQPyPaVoH3hLU+hAsF2kS6nZVX13KC1LxuP3h/eMriJUzCL
         Egzg==
X-Gm-Message-State: APjAAAUzxN3/anYIWs6r1fKjTe6wVX9RvC6fmvgs7TLulTDPXnWD8PNy
        zHh3lVlzfMK9rtEFh3EVTrPEVA==
X-Google-Smtp-Source: APXvYqyD0JiP5Vjzz/Ob2cl78I3RHYa2pXAFgS65YCSh3NzGL4FLqEi7nL0+DAaVfiBX1+EWTZpHfQ==
X-Received: by 2002:adf:ff8e:: with SMTP id j14mr3020909wrr.178.1571140596214;
        Tue, 15 Oct 2019 04:56:36 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:7687:11a4:4657:121d])
        by smtp.gmail.com with ESMTPSA id z9sm21434838wrl.35.2019.10.15.04.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 04:56:35 -0700 (PDT)
Date:   Tue, 15 Oct 2019 12:56:32 +0100
From:   Quentin Perret <qperret@google.com>
To:     Valentin Schneider <valentin.schneider@arm.com>
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org, vincent.guittot@linaro.org,
        Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] sched/topology: Allow sched_asym_cpucapacity to be
 disabled
Message-ID: <20191015115632.GC242992@google.com>
References: <20191015102956.20133-1-valentin.schneider@arm.com>
 <20191015104010.GA242992@google.com>
 <a3a1a3d9-5d3a-3ab3-0eaf-e63e0c401c99@arm.com>
 <d1dac9d1-3ac6-1a1b-f1c9-48b136833686@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1dac9d1-3ac6-1a1b-f1c9-48b136833686@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 15 Oct 2019 at 12:49:22 (+0100), Valentin Schneider wrote:
> 
> 
> On 15/10/2019 11:58, Valentin Schneider wrote:
> > On 15/10/2019 11:40, Quentin Perret wrote:
> >>> @@ -2124,8 +2124,17 @@ static void detach_destroy_domains(const struct cpumask *cpu_map)
> >>>  	int i;
> >>>  
> >>>  	rcu_read_lock();
> >>> +
> >>> +	if (static_key_enabled(&sched_asym_cpucapacity)) {
> >>> +		unsigned int cpu = cpumask_any(cpu_map);
> >>> +
> >>> +		if (rcu_dereference(per_cpu(sd_asym_cpucapacity, cpu)))
> >>> +			static_branch_dec_cpuslocked(&sched_asym_cpucapacity);
> >>
> >> Lockdep should scream for this :)
> > 
> > Bleh, yes indeed...
> > 
> 
> Urgh, I forgot about the funny hotplug lock scenario at boot time.
> rebuild_sched_domains() takes the lock but sched_init_domains() doesn't, so
> we don't get the might_sleep warn at boot time.
> 
> So if we want to flip the key post boot time we probably need to separately
> count our asymmetric root domains and flip the key after all the rebuilds,
> outside of the hotplug lock.

Hmm, a problem here is that static_branch*() can block (it uses a
mutex) while you're in the rcu section, I think.

I suppose you could just move this above rcu_read_lock() and use
rcu_access_pointer() instead ?

Thanks,
Quentin
