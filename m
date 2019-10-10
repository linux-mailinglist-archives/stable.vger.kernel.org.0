Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33867D1DDE
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 03:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732034AbfJJBKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 21:10:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731751AbfJJBKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 21:10:00 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DBDD930860C5;
        Thu, 10 Oct 2019 01:09:59 +0000 (UTC)
Received: from redhat.com (ovpn-120-118.rdu2.redhat.com [10.10.120.118])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7787610013A1;
        Thu, 10 Oct 2019 01:09:54 +0000 (UTC)
Date:   Wed, 9 Oct 2019 21:09:52 -0400
From:   Don Zickus <dzickus@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     CKI Project <cki-project@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Zhaojuan Guo <zguo@redhat.com>
Subject: Re: =?utf-8?B?4p2M?= FAIL: Stable queue: queue-5.3
Message-ID: <20191010010952.suo6opzifh5y37gm@redhat.com>
References: <cki.F2FC419F40.7K0EACX2QA@redhat.com>
 <20191009224437.GY1396@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191009224437.GY1396@sasha-vm>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 10 Oct 2019 01:09:59 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 06:44:37PM -0400, Sasha Levin wrote:
> On Wed, Oct 09, 2019 at 06:11:40PM -0400, CKI Project wrote:
> > 
> > Hello,
> > 
> > We ran automated tests on a patchset that was proposed for merging into this
> > kernel tree. The patches were applied to:
> > 
> >       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> >            Commit: 52020d3f6633 - Linux 5.3.5
> > 
> > The results of these automated tests are provided below.
> > 
> >    Overall result: FAILED (see details below)
> >             Merge: OK
> >           Compile: OK
> >             Tests: FAILED
> > 
> > All kernel binaries, config files, and logs are available for download here:
> > 
> >  https://artifacts.cki-project.org/pipelines/214657
> > 
> > One or more kernel tests failed:
> > 
> >    x86_64:
> >      ❌ Boot test
> >      ❌ Boot test
> >      ❌ Boot test
> >      ❌ Boot test
> 
> Hm, I looked here:
> 
> https://artifacts.cki-project.org/pipelines/214657/logs/x86_64_host_1_Boot_test_dmesg.log
> 
> and here:
> 
> https://artifacts.cki-project.org/pipelines/214657/logs/x86_64_host_2_Boot_test_dmesg.log
> 
> but both look sane. What am I missing?

I don't believe you are.  I looked at the raw beaker jobs and the x86_64
machines passed and another set is still queued.  There is an aarch64
machine that failed to boot.

Unfortunately, I am skeptical of this result too but I would wait for the
CKI team to triage this.

Sorry about that.

Cheers,
Don
