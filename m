Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF9C2B823
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 17:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfE0PEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 11:04:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfE0PEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 May 2019 11:04:38 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A4CAA5946A;
        Mon, 27 May 2019 15:04:17 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 6D33260BE5;
        Mon, 27 May 2019 15:04:10 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Mon, 27 May 2019 17:04:17 +0200 (CEST)
Date:   Mon, 27 May 2019 17:04:09 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] signal: Adjust error codes according to
 restore_user_sigmask()
Message-ID: <20190527150409.GA8961@redhat.com>
References: <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
 <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
 <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
 <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
 <20190524141054.GB2655@redhat.com>
 <CABeXuvqSzy+v=3Y5NnMmfob7bvuNkafmdDqoex8BVENN3atqZA@mail.gmail.com>
 <20190524163310.GG2655@redhat.com>
 <CABeXuvrUKZnECj+NgLdpe5uhKBEmSynrakD-3q9XHqk8Aef5UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeXuvrUKZnECj+NgLdpe5uhKBEmSynrakD-3q9XHqk8Aef5UQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 27 May 2019 15:04:38 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Deepa,

it seems that we both are saying the same things again and again, and we
simply can't understand each other.

I'll try to write another email to restart this discussion. Tomorrow, somehow
I can't wake up today.

And let me repeat, of course I can be wrong. IOW, it is not that I am trying
to blame you for all this confusion.

On 05/24, Deepa Dinamani wrote:
>
> > > Ok, then can you point out what specifically was wrong with
> > > 854a6ed56839a?
> >
> > Cough. If nothing else the lost -EINTR?
>
> This was my theory. My basis behind the theory was [1](the issue with
> return value not being updated) above. And, you are saying this is ok.

I agree that "the lost -EINTR" above was not clear. I'll try to clarify
what I think is not OK.

Oleg.

