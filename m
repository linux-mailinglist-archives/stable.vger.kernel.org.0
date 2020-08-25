Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9361E251C84
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 17:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgHYPoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 11:44:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20914 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726939AbgHYPoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 11:44:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598370259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CZRaT4/1v5rcK6uBWShBNZ1mDYfCi2rVf7HvsIeOBAY=;
        b=SC/GsWxYwCDroG4PZyXp7sIl8D8begNwwNeW3opOYmqWif5ZxFGQe+FLDhqvbSCkg1avA4
        y6RTmQRW7ii7jNHgx4hAOcEBg2MhC0B8ARUvHXWVIN6lxKeLHAwrTeyQ6rkl23eoVUKUpI
        TBtNJRAVRuHeuMIbO+A5oTdHo0vkTY4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-cL8SAhWDOX-o6j3mbwXjmg-1; Tue, 25 Aug 2020 11:44:14 -0400
X-MC-Unique: cL8SAhWDOX-o6j3mbwXjmg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF6291084C95;
        Tue, 25 Aug 2020 15:44:11 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.194.8])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5AE091944D;
        Tue, 25 Aug 2020 15:44:02 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue, 25 Aug 2020 17:44:11 +0200 (CEST)
Date:   Tue, 25 Aug 2020 17:44:01 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Suren Baghdasaryan <surenb@google.com>,
        christian.brauner@ubuntu.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, esyr@redhat.com,
        christian@kellner.me, areber@redhat.com, shakeelb@google.com,
        cyphar@cyphar.com, adobriyan@gmail.com, akpm@linux-foundation.org,
        ebiederm@xmission.com, gladkov.alexey@gmail.com, walken@google.com,
        daniel.m.jordan@oracle.com, avagin@gmail.com,
        bernd.edlinger@hotmail.de, john.johansen@canonical.com,
        laoar.shao@gmail.com, timmurray@google.com, minchan@kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 1/1] mm, oom_adj: don't loop through tasks in
 __set_oom_adj when not necessary
Message-ID: <20200825154400.GC28468@redhat.com>
References: <20200824153036.3201505-1-surenb@google.com>
 <20200825150516.GJ22869@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825150516.GJ22869@dhcp22.suse.cz>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/25, Michal Hocko wrote:
>
> Btw. now that the flag is in place we can optimize __oom_kill_process as
> well.

and zap_threads().

Oleg.

