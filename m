Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD3460F673
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 13:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiJ0LqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 07:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234492AbiJ0LqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 07:46:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB1A48EB0
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 04:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666871158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wluq0BvZRndX5r83nkxOQAau+EmVPHUH6BV1JAWueaE=;
        b=CzyAF+JL5F3ng/mtSRDhA0B9speCRdK103nb4Y0PQAufHYxCXAadzy/Xikow3cXNFkhAA7
        l9fQOdgDXj1z3Xm/ZaKVbPvJmgx//kNgs5LnpR8GHPuFleyc9l5UVrmi81Af8ovC/i+phA
        9dNsN8IP/O9tQH1hREf3Bx66W3D/5Cw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-YO0pqHW7NQi3yNi-L9eAbQ-1; Thu, 27 Oct 2022 07:45:54 -0400
X-MC-Unique: YO0pqHW7NQi3yNi-L9eAbQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1433A1C07555;
        Thu, 27 Oct 2022 11:45:53 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F925C15BA8;
        Thu, 27 Oct 2022 11:45:53 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 29RBjrvV003917;
        Thu, 27 Oct 2022 07:45:53 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 29RBjqYi003913;
        Thu, 27 Oct 2022 07:45:52 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 27 Oct 2022 07:45:52 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: Re: backport of patches 8238b4579866b7c1bb99883cfe102a43db5506ff
 and d6ffe6067a54972564552ea45d320fb98db1ac5e
In-Reply-To: <Y1lnzkSUjuH7acSf@kroah.com>
Message-ID: <alpine.LRH.2.21.2210270733280.3240@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com> <YzflXQMdGLsjPb70@kroah.com> <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com> <Yz21dn2vJPOVOffr@kroah.com> <Y0Rtkk7hA4CBwp16@kroah.com>
 <alpine.LRH.2.02.2210110531260.30193@file01.intranet.prod.int.rdu2.redhat.com> <Y0U+UkLYiRzvgoF8@kroah.com> <alpine.LRH.2.02.2210180733360.5835@file01.intranet.prod.int.rdu2.redhat.com> <Y1lnzkSUjuH7acSf@kroah.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Wed, 26 Oct 2022, Greg KH wrote:

> On Tue, Oct 18, 2022 at 07:36:22AM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Tue, 11 Oct 2022, Greg KH wrote:
> > 
> > > On Tue, Oct 11, 2022 at 05:48:26AM -0400, Mikulas Patocka wrote:
> > > > 
> > > > 
> > > > On Mon, 10 Oct 2022, Greg KH wrote:
> > > > 
> > > > > Nope, these cause loads of breakages.  See
> > > > > https://lore.kernel.org/r/09eca44e-4d91-a060-d48c-d0aa41ac5045@roeck-us.net
> > > > > for one such example, and I know kbuild sent you other build problems.
> > > > > I'll drop all of these from the stable trees now.  Please feel free to
> > > > > resend them when you have the build issues worked out.
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > 
> > > > I don't have cross compilers for all the architectures that Linux 
> > > > supports. Is there some way how to have the patch compile-tested before I 
> > > > send it to you?
> > > 
> > > You can download those compilers from kernel.org, they are all available
> > > there.
> > 
> > OK. I downloaded cross compilers from 
> > https://mirrors.edge.kernel.org/pub/tools/crosstool/ and compile-tested 
> > the patches with all possible architectures.
> > 
> > Here I'm sending new versions.
> 
> But don't you need 2 patches, not just 1, to be applied?

Just one patch is sufficient.

The upstream patch 8238b4579866b7c1bb99883cfe102a43db5506ff fixes a bug 
and the patch d6ffe6067a54972564552ea45d320fb98db1ac5e fixes compile 
failures triggered by 8238b4579866b7c1bb99883cfe102a43db5506ff on some 
architectures.

For simplicity of making and testing the stable branch patches I folded 
these changes into just one patch - that fixes the bug and fixes compile 
failures as well.

> Please resend a set of series, one series per stable kernel branch, to
> make it more obvious what to do.  Your thread here is very confusing.

I'll resend it, but except for the subject line I don't know what have I 
done wrong.

Mikulas

> See the stable mailing list archives for lots of examples of how to do
> this properly, here are 2 good examples:
> 	https://lore.kernel.org/r/20221019125303.2845522-1-conor.dooley@microchip.com
> 	https://lore.kernel.org/r/20221019125209.2844943-1-conor.dooley@microchip.com
> 
> thanks,
> 
> greg k-h
> 

