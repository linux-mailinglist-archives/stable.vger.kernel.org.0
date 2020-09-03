Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5347625C3E6
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 17:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgICPAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 11:00:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53747 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728409AbgICOGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Sep 2020 10:06:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599141961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CRM5SDuyNkyo2LaLrW1Sn25CKUsI02PlDXJ3rHe+Ca0=;
        b=gmeIcB5AxzZTdDpclejsQUCrH7H+zIRhbAUXmpWrUSM29+s+zwo1UwkR4mBxDc1fEqfD7T
        CgIsugwfmsmuB7b3ilqnrhAhlsBG38JPXnQHOJG7dQPuZhCh/dn+bXmywO1CtaHO3S2T7E
        ychBSWM9FPo/Uk/t5cV2PDOOOb4UjJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-cE6VzjKJNmuEUzUKyLYZWQ-1; Thu, 03 Sep 2020 10:03:52 -0400
X-MC-Unique: cE6VzjKJNmuEUzUKyLYZWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3D9E18B9F86;
        Thu,  3 Sep 2020 14:03:47 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.114])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4F9A65C22B;
        Thu,  3 Sep 2020 14:03:27 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  3 Sep 2020 16:03:47 +0200 (CEST)
Date:   Thu, 3 Sep 2020 16:03:26 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     mhocko@suse.com, christian.brauner@ubuntu.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, esyr@redhat.com,
        christian@kellner.me, areber@redhat.com, shakeelb@google.com,
        cyphar@cyphar.com, adobriyan@gmail.com, akpm@linux-foundation.org,
        ebiederm@xmission.com, gladkov.alexey@gmail.com, walken@google.com,
        daniel.m.jordan@oracle.com, avagin@gmail.com,
        bernd.edlinger@hotmail.de, john.johansen@canonical.com,
        laoar.shao@gmail.com, timmurray@google.com, minchan@kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v3 1/1] mm, oom_adj: don't loop through tasks in
 __set_oom_adj when not necessary
Message-ID: <20200903140324.GH4386@redhat.com>
References: <20200902012558.2335613-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902012558.2335613-1-surenb@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/01, Suren Baghdasaryan wrote:
>
>  fs/proc/base.c                 |  3 +--
>  include/linux/oom.h            |  1 +
>  include/linux/sched/coredump.h |  1 +
>  kernel/fork.c                  | 21 +++++++++++++++++++++
>  mm/oom_kill.c                  |  2 ++
>  5 files changed, 26 insertions(+), 2 deletions(-)

Acked-by: Oleg Nesterov <oleg@redhat.com>

