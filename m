Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3363720098A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgFSNHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:07:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42112 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726124AbgFSNHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:07:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592572041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gIEymJG7GNr8Q3T3pq3TOlxvAu56PT3Zq5tmDSAoOEA=;
        b=HFp+3EsbY7+ZP3KJCplx7tBV/18Un9tdTZuarf5WLMtWUjZxC07lJTYdq2SQf+80Jiyp+I
        qnWYzNI/6gXgIOp2LNxn59uuu3bx3TA8yy/0THXya71yvxF+bNHrbDq7542Mg9OiDx4Bow
        Al+dKf0rbNS/SBnS8mZ+waWytlZnL6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-nHnFoBiFPVShtgqfcixhsg-1; Fri, 19 Jun 2020 09:07:20 -0400
X-MC-Unique: nHnFoBiFPVShtgqfcixhsg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 471D41B18BC0;
        Fri, 19 Jun 2020 13:07:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FB6A1CA;
        Fri, 19 Jun 2020 13:07:19 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 323AE1809543;
        Fri, 19 Jun 2020 13:07:19 +0000 (UTC)
Date:   Fri, 19 Jun 2020 09:07:18 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     sedat dilek <sedat.dilek@gmail.com>
Cc:     Yi Chen <yiche@redhat.com>, Jianwen Ji <jiji@redhat.com>,
        Hangbin Liu <haliu@redhat.com>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Message-ID: <328409138.27353672.1592572038963.JavaMail.zimbra@redhat.com>
In-Reply-To: <CA+icZUU8mXX23JHvEGjgBtTTp_zpm++wBkAgw_Rx0T-Rajz28w@mail.gmail.com>
References: <CA+icZUU8mXX23JHvEGjgBtTTp_zpm++wBkAgw_Rx0T-Rajz28w@mail.gmail.com>
Subject: Re: PASS: Test report for kernel 5.7.4-1d8b8c5.cki (stable-queue)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.195.5, 10.4.195.21]
Thread-Topic: PASS: Test report for kernel 5.7.4-1d8b8c5.cki (stable-queue)
Thread-Index: 9KKoEAIs99iWQmMT8pIonocGcf5vLg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "Sedat Dilek" <sedat.dilek@gmail.com>
> To: "Yi Chen" <yiche@redhat.com>, "Jianwen Ji" <jiji@redhat.com>, "Hangbin Liu" <haliu@redhat.com>, "Ondrej Moris"
> <omoris@redhat.com>, "Ondrej Mosnacek" <omosnace@redhat.com>
> Cc: "CKI Project" <cki-project@redhat.com>, "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Friday, June 19, 2020 1:48:51 PM
> Subject: Re: PASS: Test report for kernel 5.7.4-1d8b8c5.cki (stable-queue)
> 
> Hi CKI maintainers,
> 
> thanks for doing automated tests.
> 
> I am interested in a report of currently released Linux v5.7.5-rc1
> before doing my testing with Clang's Integrated Assembly on
> Debian/testing AMD64.
> 
> Is there a browsable URL you can give me where I can see if AMD64
> (x86-64) tests have passed OK?
> 
> Or is it "Be patient and wait".
> 

Hi Sedat,

thanks for the interest in our testing! The testing for v5.7.5-rc1 is
currently still running. The x86_64 tests that had the chance to run so
far all passed but you'll have to wait a few hours to get the complete
results.

We're planning a public web dashboard so in the future you should be able
to follow the results there instead of having to wait for test run
completion, but it will take us a few more months to get that ready.


Veronika

> Thanks.
> 
> Regards,
> - Sedat -
> 
> [1]
> https://git.kernel.org/pub/scm/public-inbox/vger.kernel.org/stable/0.git/commit/?id=2009b13ce33bf5a474ccdda991559e39712862c8
> 
> 

