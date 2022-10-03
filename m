Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED8E5F3043
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 14:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiJCM2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 08:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJCM2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 08:28:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856E132D87
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 05:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664800089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T1BID29+nWkgsNEajrBX0No7HMBZTrYkAUPU6LH2upY=;
        b=G/Dky5R3P1ai1UVdPaBBw3tRCF4nyMhnRdU/gOBU4Wx4S6e1Q5tdmyD1sUa9Ofn7idG2Kx
        SNDW6ePBzN2dhkpNZ3hkmqyoUPC4AJBWqNm2KiWqfxdExRObP+blYKODPzMXVw9Vuz0dj8
        eJ79crDzqUvog8f/AClwc0jqzWIq3HM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-bAjMAIVYPeiOiX6Onu6M3A-1; Mon, 03 Oct 2022 08:28:06 -0400
X-MC-Unique: bAjMAIVYPeiOiX6Onu6M3A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BD8E85A59D;
        Mon,  3 Oct 2022 12:28:06 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 76E6B492B04;
        Mon,  3 Oct 2022 12:28:06 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 293CS6Pt009574;
        Mon, 3 Oct 2022 08:28:06 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 293CS6iT009570;
        Mon, 3 Oct 2022 08:28:06 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Mon, 3 Oct 2022 08:28:06 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: Re: backport of patches 8238b4579866b7c1bb99883cfe102a43db5506ff
 and d6ffe6067a54972564552ea45d320fb98db1ac5e
In-Reply-To: <YzflXQMdGLsjPb70@kroah.com>
Message-ID: <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com> <YzflXQMdGLsjPb70@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Sat, 1 Oct 2022, Greg KH wrote:

> On Fri, Sep 30, 2022 at 11:32:30AM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > Here I'm submitting backport of patches 
> > 8238b4579866b7c1bb99883cfe102a43db5506ff and 
> > d6ffe6067a54972564552ea45d320fb98db1ac5e to the stable branches.
> 
> Thanks, but you provide no information as to why these are needed.
> 
> What needs them?  They are just adding new functions to the tree from
> what I can tell.
> 
> thanks,
> 
> greg k-h

There's a race condition in wait_on_bit. wait_on_bit tests a bit using the 
"test_bit" function, however this function doesn't do any memory barrier, 
so the memory accesses that follow wait_on_bit may be reordered before it 
and return invalid data.

Linus didn't want to add a memory barrier to wait_on_bit, he instead 
wanted to introduce a new function test_bit_acquire that performs the 
"acquire" memory barrier and use it in wait_on_bit.

The patch d6ffe6067a54972564552ea45d320fb98db1ac5e fixes an oversight in 
the patch 8238b4579866b7c1bb99883cfe102a43db5506ff where the function 
test_bit_acquire was not defined for some architectures and this caused 
compile failure.

The backport of the patch 8238b4579866b7c1bb99883cfe102a43db5506ff should 
be applied first and the backport of the patch 
d6ffe6067a54972564552ea45d320fb98db1ac5e afterwards.

Mikulas

