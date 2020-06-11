Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510941F6C69
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 18:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgFKQv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 12:51:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54695 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726553AbgFKQv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 12:51:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591894285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VyiOMCknkLLdkkng3brgL4BkJyIYCIkonWDKyJSqKTI=;
        b=g/cd1D77jKVsZ+6Wkk++zDhHsUxLJ+Ff0nnfQjMra4Tmz4an77SWay/NlqiqS04LvbebRI
        wp57fCyDOSGl5+/c/dh5TlhPfFeivjkhSBqWxFmmmrkakFMQz9gBc1Rd1rJggPD5WA6ijB
        GTIHs69TogRC7yQXI18UB2dlhv8ePU0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-s3RYe3d_NMOnloE6AlIXkg-1; Thu, 11 Jun 2020 12:51:23 -0400
X-MC-Unique: s3RYe3d_NMOnloE6AlIXkg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F27891800D41;
        Thu, 11 Jun 2020 16:51:20 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.195.101])
        by smtp.corp.redhat.com (Postfix) with SMTP id 6A1375D9E5;
        Thu, 11 Jun 2020 16:51:18 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 11 Jun 2020 18:51:20 +0200 (CEST)
Date:   Thu, 11 Jun 2020 18:51:17 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.19 24/25] uprobes: ensure that uprobe->offset and
 ->ref_ctr_offset are properly aligned
Message-ID: <20200611165116.GE12500@redhat.com>
References: <20200609174048.576094775@linuxfoundation.org>
 <20200609174051.488794266@linuxfoundation.org>
 <CA+G9fYukN5V1z3g6Qwe9K5xnnXEuFafWdqGfDA1Wj2iVstoxfw@mail.gmail.com>
 <20200609190321.GA1046130@kroah.com>
 <20200610145305.GA3254@redhat.com>
 <20200610145855.GA2102398@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610145855.GA2102398@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10, Greg Kroah-Hartman wrote:
>
> > Greg, please let me know if you want me to send the patches for 4.9/4.14/4.19.
>
> Please do.  I tried to backport it to those trees, and it seems to
> build/boot/run, but I would like verification I didn't mess anything up
> :)
>
> Your 4.4 version below matched my version, so I think I'm ok...

Greg, I was going to send the patches, but after I've cloned
git/stable/linux-stable-rc.git I see that you have already updated these

	origin/queue/4.14
	origin/queue/4.19
	origin/queue/4.4
	origin/queue/4.9

branches, and the new patches look good to me.

So I think I can relax? ;)

Thanks!

Oleg.

