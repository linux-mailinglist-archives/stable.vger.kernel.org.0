Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B06C8766
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 13:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfJBLee convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 2 Oct 2019 07:34:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60520 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbfJBLee (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Oct 2019 07:34:34 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 442D98AC6F5;
        Wed,  2 Oct 2019 11:34:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A7C660BE0;
        Wed,  2 Oct 2019 11:34:34 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 216B618089C8;
        Wed,  2 Oct 2019 11:34:34 +0000 (UTC)
Date:   Wed, 2 Oct 2019 07:34:33 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Greg KH <greg@kroah.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Message-ID: <1062039737.2099822.1570016073892.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191002053202.GA1450924@kroah.com>
References: <cki.7E7289C905.6I9MGQOO2V@redhat.com> <20191002053202.GA1450924@kroah.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kernel=09?=
 =?utf-8?Q?5.4.0-rc1-643b3a0.cki_(stable-next)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.40.204.19, 10.4.195.20]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.4.0-rc1-643b3a0.cki (stable-next)
Thread-Index: Nyd1/HJMlVXfU+ij9JqBhDB6/85Nww==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Wed, 02 Oct 2019 11:34:34 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "Greg KH" <greg@kroah.com>
> To: "CKI Project" <cki-project@redhat.com>
> Cc: "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Wednesday, October 2, 2019 7:32:02 AM
> Subject: Re: ❌ FAIL: Test report for kernel	5.4.0-rc1-643b3a0.cki (stable-next)
> 
> On Wed, Oct 02, 2019 at 12:27:24AM -0400, CKI Project wrote:
> > 
> > Hello,
> > 
> > We ran automated tests on a recent commit from this kernel tree:
> > 
> >        Kernel repo:
> >        git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-stable.git
> >             Commit: 643b3a097f86 - selftests: pidfd: Fix undefined
> >             reference to pthread_create()
> 
> That is 5.4-rc1?
> 
> Why are you sending those results to the stable list?
> 
> confused,
> 

Hi,

Sasha has requested to have stable-next tested and results sent to this list:

https://gitlab.com/cki-project/pipeline-data/commit/16e0c06addbe62c689782357673f69bb7dff4d9a


Veronika


> greg k-h
> 
> 
