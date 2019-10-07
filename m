Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2BDCE4E0
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfJGOOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:14:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42038 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfJGOOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 10:14:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id n14so15474437wrw.9;
        Mon, 07 Oct 2019 07:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eAFFgxm3qY/7LxpkZUrTWdSLnmn3UbQs0xpqBO+b2a4=;
        b=nKBF67N0rqnOTvG/Tl+oK7nJS0Wjo9edLmEGrRwKwpan0BzcwD+ej2m0C5PmxDvxwU
         3YKV8uwKPt4z7oatfdCUCM92/SznZ5cciPpCQyHo0Cs7Fuxd5XmIiKmuPo54cxUSjT4v
         /FRhZRSVuv3dc4UBv518bNDDnVwGzq6JkrrP97ukTKw7sUEQpIAN9pQ42HC6bGLQY4iU
         C/gbdNlttA4PvQW+mLkdPU2ZlIlneJ/XQPaE/k195Ccc84M5Ol6m18X99ZvO5CV3XTSy
         shYjTDb5n9NQukgvS7HgpnVRSzpVcm2GB6sEorZ8K0+7oBmoCchblbaGd5gss3uLyFW8
         5Geg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eAFFgxm3qY/7LxpkZUrTWdSLnmn3UbQs0xpqBO+b2a4=;
        b=E26DYEZOxgFaLMoxpcuEboJFPy3z0OHUab3xYrCQFIJMv3+XGh0ihRBxAvmItb3QZR
         BTEoSrN7upILW7744JD03YB3AdAltDqpYpVPASrQNyLQcmb2ynx4XB2MhC77Me2mcQOj
         vbW0gxb5OMzTXKK72lczI+Bubap3povx24mqpDBn09jcbK6/z23r9MwDCa1gNoVr7oJL
         fu8szSZKsyHqiGBUfjaZEGMRzGN5o+BIQVvIAik5ET6wAIzZUvsb+uixrEwzki4TBPFM
         /mkFCvqcGA+bbCb1+BKVRlyQsYEH8NSYM5kH8sUme2MhLEur0NaR/n4aH9YSKyGPsDXe
         et7w==
X-Gm-Message-State: APjAAAX0+hzYbYGKcJP66fGgnLKyspFgqKcTh+KhKnyCrW9YbRTq8y53
        MQVtIJvtfwommxtISU40UL8=
X-Google-Smtp-Source: APXvYqwapccFJ6OREAdhuMQJ4J1B+5o2iairGFJrhmlBACH5UaQdZWGbeLkf9Ag4sHZH/5WelSIa2Q==
X-Received: by 2002:adf:fe11:: with SMTP id n17mr16300070wrr.221.1570457678013;
        Mon, 07 Oct 2019 07:14:38 -0700 (PDT)
Received: from andrea.guest.corp.microsoft.com ([2a01:110:8012:1012:69a4:816:a2c:e717])
        by smtp.gmail.com with ESMTPSA id a7sm33011934wra.43.2019.10.07.07.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 07:14:37 -0700 (PDT)
Date:   Mon, 7 Oct 2019 16:14:32 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        bsingharora@gmail.com, Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] taskstats: fix data-race
Message-ID: <20191007141432.GA22083@andrea.guest.corp.microsoft.com>
References: <20191007104039.GA16085@andrea.guest.corp.microsoft.com>
 <20191007110117.1096-1-christian.brauner@ubuntu.com>
 <20191007131804.GA19242@andrea.guest.corp.microsoft.com>
 <CACT4Y+YG23qbL16MYH3GTK4hOPsM9tDfbLzrTZ7k_ocR2ABa6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YG23qbL16MYH3GTK4hOPsM9tDfbLzrTZ7k_ocR2ABa6A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > >  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
> > >  {
> > >       struct signal_struct *sig = tsk->signal;
> > > -     struct taskstats *stats;
> > > +     struct taskstats *stats_new, *stats;
> > >
> > > -     if (sig->stats || thread_group_empty(tsk))
> > > -             goto ret;
> > > +     /* Pairs with smp_store_release() below. */
> > > +     stats = READ_ONCE(sig->stats);
> >
> > This pairing suggests that the READ_ONCE() is heading an address
> > dependency, but I fail to identify it: what is the target memory
> > access of such a (putative) dependency?
> 
> I would assume callers of this function access *stats. So the
> dependency is between loading stats and accessing *stats.

AFAICT, the only caller of the function in 5.4-rc2 is taskstats_exit(),
which 'casts' the return value to a boolean (so I really don't see how
any address dependency could be carried over/relied upon here).

  Andrea
