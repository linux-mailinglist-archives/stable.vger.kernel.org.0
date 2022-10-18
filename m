Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B863A602A65
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 13:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiJRLkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 07:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiJRLkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 07:40:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2758C03E
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 04:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666092984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0gI9MyQ0B2I4eAIApFlcYq/WtrU7aTjA+O4P8PbTfnw=;
        b=KQrGdzrxTVSg1B+p7eZJYKpC9z/GNmIfeNiVDB1g9tEiIeNk2WzyvHbmQykIs8OVor9HcC
        vHNNPC51dqGJ9YPYOTQzvUzE1fXbrrVCSZx/xvaJSd17UnMtgqqOjunGPi0542tGFz4qzp
        tn0sTl8N5nPpcvuIGAmFNjfoQnMOk2w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-OR57aaCpMRukR07h2z1Eow-1; Tue, 18 Oct 2022 07:36:23 -0400
X-MC-Unique: OR57aaCpMRukR07h2z1Eow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF76285A583;
        Tue, 18 Oct 2022 11:36:22 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AA9852166B41;
        Tue, 18 Oct 2022 11:36:22 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 29IBaMVx005945;
        Tue, 18 Oct 2022 07:36:22 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 29IBaMkM005941;
        Tue, 18 Oct 2022 07:36:22 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 18 Oct 2022 07:36:22 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: Re: backport of patches 8238b4579866b7c1bb99883cfe102a43db5506ff
 and d6ffe6067a54972564552ea45d320fb98db1ac5e
In-Reply-To: <Y0U+UkLYiRzvgoF8@kroah.com>
Message-ID: <alpine.LRH.2.02.2210180733360.5835@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com> <YzflXQMdGLsjPb70@kroah.com> <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com> <Yz21dn2vJPOVOffr@kroah.com> <Y0Rtkk7hA4CBwp16@kroah.com>
 <alpine.LRH.2.02.2210110531260.30193@file01.intranet.prod.int.rdu2.redhat.com> <Y0U+UkLYiRzvgoF8@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Tue, 11 Oct 2022, Greg KH wrote:

> On Tue, Oct 11, 2022 at 05:48:26AM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 10 Oct 2022, Greg KH wrote:
> > 
> > > Nope, these cause loads of breakages.  See
> > > https://lore.kernel.org/r/09eca44e-4d91-a060-d48c-d0aa41ac5045@roeck-us.net
> > > for one such example, and I know kbuild sent you other build problems.
> > > I'll drop all of these from the stable trees now.  Please feel free to
> > > resend them when you have the build issues worked out.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > I don't have cross compilers for all the architectures that Linux 
> > supports. Is there some way how to have the patch compile-tested before I 
> > send it to you?
> 
> You can download those compilers from kernel.org, they are all available
> there.

OK. I downloaded cross compilers from 
https://mirrors.edge.kernel.org/pub/tools/crosstool/ and compile-tested 
the patches with all possible architectures.

Here I'm sending new versions.

Mikulas

