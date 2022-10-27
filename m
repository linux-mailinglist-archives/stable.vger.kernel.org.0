Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A12460F7E5
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 14:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbiJ0Msk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 08:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235755AbiJ0Msj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 08:48:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E92E16DC14
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 05:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666874918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PXHmdzdJEf6A8pfwrVST9RMbP82sW/y1m06hNKA5vEg=;
        b=DTz+5QXmNV7nCzbkVNufHpTOR/9FRuHanVVB62BRbmWJYCvEOQPs810dAFGlvl8OSsrhvV
        z7EYxjel63J4oAaEIM+iteiZEiFM1Ao+10IBdGTroh3RslM2RxfLlu2pGK5nVmjwxf2vKz
        9qKL4Nu8bAhT+tZe51knm5u3/mvFPww=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-YPno0K6QOESccPBj412UqQ-1; Thu, 27 Oct 2022 08:48:36 -0400
X-MC-Unique: YPno0K6QOESccPBj412UqQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6407E86F12D;
        Thu, 27 Oct 2022 12:48:36 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E75D39D6A;
        Thu, 27 Oct 2022 12:48:36 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 29RCmagh022868;
        Thu, 27 Oct 2022 08:48:36 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 29RCmaPn022864;
        Thu, 27 Oct 2022 08:48:36 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 27 Oct 2022 08:48:36 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: Re: backport of patches 8238b4579866b7c1bb99883cfe102a43db5506ff
 and d6ffe6067a54972564552ea45d320fb98db1ac5e
In-Reply-To: <Y1pxPsFAOVQf140J@kroah.com>
Message-ID: <alpine.LRH.2.21.2210270847540.22202@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com> <YzflXQMdGLsjPb70@kroah.com> <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com> <Yz21dn2vJPOVOffr@kroah.com> <Y0Rtkk7hA4CBwp16@kroah.com>
 <alpine.LRH.2.02.2210110531260.30193@file01.intranet.prod.int.rdu2.redhat.com> <Y0U+UkLYiRzvgoF8@kroah.com> <alpine.LRH.2.02.2210180733360.5835@file01.intranet.prod.int.rdu2.redhat.com> <Y1lnzkSUjuH7acSf@kroah.com> <alpine.LRH.2.21.2210270733280.3240@file01.intranet.prod.int.rdu2.redhat.com>
 <Y1pxPsFAOVQf140J@kroah.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Thu, 27 Oct 2022, Greg KH wrote:
>
> > For simplicity of making and testing the stable branch patches I folded 
> > these changes into just one patch - that fixes the bug and fixes compile 
> > failures as well.
> 
> No, please do not do that.  We want both commits at once, not a "fixed
> up" change, right?  Otherwise our tools will want to apply the second
> one as it is insisting that a fix is still needed.

OK - so I split the patches in two and resent them.

Mikulas

