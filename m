Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4ED5D9868
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 19:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfJPRZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 13:25:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726940AbfJPRZ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 13:25:59 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9644A20F2;
        Wed, 16 Oct 2019 17:25:58 +0000 (UTC)
Received: from jra-laptop (unknown [10.43.17.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E0B95D6A9;
        Wed, 16 Oct 2019 17:25:51 +0000 (UTC)
Date:   Wed, 16 Oct 2019 19:25:51 +0200
From:   Jakub Racek <jracek@redhat.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Don Zickus <dzickus@redhat.com>, Sasha Levin <sashal@kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Zhaojuan Guo <zguo@redhat.com>
Subject: Re: ? FAIL: Stable queue: queue-5.3
Message-ID: <20191016172551.bijr2fqnrwylglu4@jra-laptop>
References: <cki.F2FC419F40.7K0EACX2QA@redhat.com>
 <20191009224437.GY1396@sasha-vm>
 <20191010010952.suo6opzifh5y37gm@redhat.com>
 <CA+G9fYsKqnev+Ayu8-p8AY-4cxLJv-zTx4s-A9hxxB83R4Pejg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsKqnev+Ayu8-p8AY-4cxLJv-zTx4s-A9hxxB83R4Pejg@mail.gmail.com>
X-OS:   Linux jra-laptop 3.10.0-1062.el7.x86_64 x86_64
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Wed, 16 Oct 2019 17:25:58 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+++ Naresh Kamboju [10/10/19 12:00 +0530]:
>3831659 Warn Aborted cki@gitlab:214657 5.3.5-dc073f1.cki@upstream-stable aarch64
>3831713 Fail Completed cki@gitlab:214657 5.3.5-dc073f1.cki@upstream-stable aarch64 [RS:6067440]
>3831660 Pass Completed cki@gitlab:214657 5.3.5-dc073f1.cki@upstream-stable ppc64le
>3831662 Fail Completed cki@gitlab:214657 5.3.5-dc073f1.cki@upstream-stable x86_64
>3831661 Pass Completed cki@gitlab:214657 5.3.5-dc073f1.cki@upstream-stable x86_64
>
>On Thu, 10 Oct 2019 at 06:40, Don Zickus <dzickus@redhat.com> wrote:
>>
>> On Wed, Oct 09, 2019 at 06:44:37PM -0400, Sasha Levin wrote:
>> > On Wed, Oct 09, 2019 at 06:11:40PM -0400, CKI Project wrote:
>> > >
>> > > Hello,
>> > >
>> > > We ran automated tests on a patchset that was proposed for merging into this
>> > > kernel tree. The patches were applied to:
>> > >
>> > >       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>> > >            Commit: 52020d3f6633 - Linux 5.3.5
>> > >
>> > > The results of these automated tests are provided below.
>> > >
>> > >    Overall result: FAILED (see details below)
>> > >             Merge: OK
>> > >           Compile: OK
>> > >             Tests: FAILED
>> > >
>> > > All kernel binaries, config files, and logs are available for download here:
>> > >
>> > >  https://artifacts.cki-project.org/pipelines/214657
>> > >
>> > > One or more kernel tests failed:
>> > >
>> > >    x86_64:
>> > >      ✗ Boot test
>> > >      ✗ Boot test
>> > >      ✗ Boot test
>> > >      ✗ Boot test
>> >
>> > Hm, I looked here:
>> >
>> > https://artifacts.cki-project.org/pipelines/214657/logs/x86_64_host_1_Boot_test_dmesg.log
>> >
>> > and here:
>> >
>> > https://artifacts.cki-project.org/pipelines/214657/logs/x86_64_host_2_Boot_test_dmesg.log
>> >
>> > but both look sane. What am I missing?
>>
>> I don't believe you are.  I looked at the raw beaker jobs and the x86_64
>> machines passed and another set is still queued.  There is an aarch64
>> machine that failed to boot.
>>
>> Unfortunately, I am skeptical of this result too but I would wait for the
>> CKI team to triage this.
>
>On the quick look i see
>
>x86_64: Host 3 failed to do any testing.
>Is it an infrastructure problem ?
>

Sorry, this was a super weird bug in our CI. It has since been fixed. 

>- Naresh
>

-- 
Best regards,

Jakub Racek
ARK
