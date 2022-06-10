Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5776E546B8B
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 19:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346927AbiFJRI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 13:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350051AbiFJRI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 13:08:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 186A742A35
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 10:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654880932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4ANwx+OMyXNowyieBwMzIYahPnwy7qmLsW5cvYFJ8R8=;
        b=QGR93hvbyoSQQ8PPIpjIpWJwJAux4U2G+eUna3YoImeYD1BXQXpi8hltcEHn8ej2ak7c72
        LPBYjMLRboM1fr3M0lzvfxhWe+mn/RcoCJBSb1x/iFcs3gKMg+yIOuXp1uNcpfbB4u5anv
        omPMYoFiPfHFtjcKYMZNAcMS7JVrzLQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-ygP10FcKMfmMMeGZWNxJaw-1; Fri, 10 Jun 2022 13:08:50 -0400
X-MC-Unique: ygP10FcKMfmMMeGZWNxJaw-1
Received: by mail-wm1-f69.google.com with SMTP id n15-20020a05600c4f8f00b0039c3e76d646so1504451wmq.7
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 10:08:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4ANwx+OMyXNowyieBwMzIYahPnwy7qmLsW5cvYFJ8R8=;
        b=t1bikjzqq4TQb5X/X7NrBnZUP/dkjC0vt0u2N4z/KUBxwwMYSWrelVhXa4vtrdBWCv
         X60PRFP29hFhM06u02pgtXceT7JyrJGqjmUF5F9GZB2b/TuY17azuoynFxv5CE5vpj4Y
         /Vyb4BXRVEu5uucvzo56IVb/U9dNR4lv6R8Ji4RFj4Qk7F0pY8YHKluvvMGkUSed1gY3
         kR0QeZTj24Ro9xGip6+By2uEOoBNb712o2kCfsiD6mD1NZiCjYjht/ixVHueyQGZqd/1
         pNSv7vPgP0yqeCQoZUxL5+gCjuf1oir2kOgFZeoJnU3RmDjpDhcG8FQq7b6L9Lok0zWk
         khcg==
X-Gm-Message-State: AOAM5329ACsoFXc6P9idWA0gUFyp2fCA0KxcgKgVldiBXuvna33Fi5f9
        hP2qPBaAUuZwZ9ZQ+YauvDkCdZnYOEuZRpz9Qkd5QMaAPfYvy+vPo5lCqjbmySR/vT0xyyYUG5k
        jdLnxrRArqXsfvtP7
X-Received: by 2002:a05:600c:2105:b0:39c:37d0:6f5e with SMTP id u5-20020a05600c210500b0039c37d06f5emr739816wml.44.1654880929474;
        Fri, 10 Jun 2022 10:08:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZJs6XbYJl2zOLGlWj8UF8lip2Ni42S9UP0aeISQ4wEmsDZUqWJ4bz7ejna9ri4qPgoZ0SZw==
X-Received: by 2002:a05:600c:2105:b0:39c:37d0:6f5e with SMTP id u5-20020a05600c210500b0039c37d06f5emr739798wml.44.1654880929244;
        Fri, 10 Jun 2022 10:08:49 -0700 (PDT)
Received: from localhost (net-93-66-64-158.cust.vodafonedsl.it. [93.66.64.158])
        by smtp.gmail.com with ESMTPSA id j3-20020a5d4483000000b0020fcc655e4asm28105624wrq.5.2022.06.10.10.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 10:08:48 -0700 (PDT)
Date:   Fri, 10 Jun 2022 19:08:48 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, echaudro@redhat.com, i.maximets@ovn.org
Subject: Re: net/sched: act_police: more accurate MTU policing
Message-ID: <YqN6oALiUdh7vnCE@dcaratti.users.ipa.redhat.com>
References: <YqNcHbk0K20+qfxP@dcaratti.users.ipa.redhat.com>
 <YqNeoTphHJV5jRYy@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqNeoTphHJV5jRYy@kroah.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hello Greg,

thanks for looking at this!

On Fri, Jun 10, 2022 at 05:09:21PM +0200, Greg KH wrote:
> On Fri, Jun 10, 2022 at 04:58:37PM +0200, Davide Caratti wrote:
> > hello,
> > 
> > Ilya reports bad TCP throughput when GSO packets hit an OVS rule that does
> > tc MTU policing. According to his observations [1], the problem is fixed
> > by upstream commit 4ddc844eb81d ("net/sched: act_police: more accurate MTU
> > policing"). Can we queue this commit for inclusion in stable trees?
> 
> Did you test this,

I tested it on upstream, RHEL8 and RHEL9 kernels. BTW, the kselftest I included
in the commit only verifies the correct setting for the MTU threshold, not
the GSO problem (to test GSO, we should use netperf / iperf3 rather than
mausezahn to generate traffic).

> and what kernel(s) do you want it applied to?

the reported bug is in act_police since the very beginning; however, the
patch should apply cleanly at least on 5.x kernels. On older ones, there
might be a small conflict due to lack of RCU-ification of struct
tcf_police_params.
A conflict that gets fixed easily, but in case we need it I volunteer to
write a patch for kernels older than 4.20. @Ilya, what is the
minimum kernel usable for openvswitch with MTU policing?

-- 
davide

