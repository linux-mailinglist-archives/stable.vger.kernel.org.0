Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4525EE576
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 18:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfKDRDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 12:03:04 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52101 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727989AbfKDRDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 12:03:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572886982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cYvQdBFtAql7wjQ/NHJHVT6A7DR8AMu7gQlsuOtUl1w=;
        b=DQJzmARG6HH8n4giz0QFBc04pLD888ImlgRVAU80zYMLwdEO6Nl4Rz1awxivVJLVFnS00x
        wZYZZFyPNdOs5+bOit974L4A4UiDdcm6AJKVEjjLE64/QB2HjHQiboh/ZynRLR5HSkAlhB
        yquKrLtEHvcC2dS0bVftB+FQk6aK3ss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-3544PBzdMfCfkWwvvI8HNw-1; Mon, 04 Nov 2019 12:02:56 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF22E107ACC2;
        Mon,  4 Nov 2019 17:02:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E131A600C6;
        Mon,  4 Nov 2019 17:02:54 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 224BF18095FF;
        Mon,  4 Nov 2019 17:02:54 +0000 (UTC)
Date:   Mon, 4 Nov 2019 12:02:53 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     CKI Project <cki-project@redhat.com>,
        Jaroslav Kysela <jkysela@redhat.com>,
        alsa-devel@alsa-project.org, LTP Mailing List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>
Message-ID: <1766459302.10389172.1572886973921.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191104163033.GB2253150@kroah.com>
References: <cki.1210A7ECB0.BD9Q3APV4K@redhat.com> <2029139028.10333037.1572874551626.JavaMail.zimbra@redhat.com> <20191104135135.GA2162401@kroah.com> <1341418315.10342806.1572877690830.JavaMail.zimbra@redhat.com> <20191104145947.GA2211991@kroah.com> <251943262.10356408.1572881121044.JavaMail.zimbra@redhat.com> <20191104163033.GB2253150@kroah.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kern?=
 =?utf-8?Q?el_5.3.9-rc1-dfe283e.cki_(stable)?=
MIME-Version: 1.0
X-Originating-IP: [10.43.17.163, 10.4.195.19]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.3.9-rc1-dfe283e.cki (stable)
Thread-Index: efHF9Qv+rDzWei/mHs7JnJR0U0OTsg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 3544PBzdMfCfkWwvvI8HNw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


----- Original Message -----
> On Mon, Nov 04, 2019 at 10:25:21AM -0500, Jan Stancek wrote:
> >=20
> > ----- Original Message -----
> > > On Mon, Nov 04, 2019 at 09:28:10AM -0500, Jan Stancek wrote:
> > > >=20
> > > >=20
> > > > ----- Original Message -----
> > > > > On Mon, Nov 04, 2019 at 08:35:51AM -0500, Jan Stancek wrote:
> > > > > >=20
> > > > > >=20
> > > > > > ----- Original Message -----
> > > > > > >=20
> > > > > > > Hello,
> > > > > > >=20
> > > > > > > We ran automated tests on a recent commit from this kernel tr=
ee:
> > > > > > >=20
> > > > > > >        Kernel repo:
> > > > > > >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/l=
inux-stable-rc.git
> > > > > > >             Commit: dfe283e9fdac - Linux 5.3.9-rc1
> > > > > > >=20
> > > > > > > The results of these automated tests are provided below.
> > > > > > >=20
> > > > > > >     Overall result: FAILED (see details below)
> > > > > > >              Merge: OK
> > > > > > >            Compile: OK
> > > > > > >              Tests: FAILED
> > > > > > >=20
> > > > > > > All kernel binaries, config files, and logs are available for
> > > > > > > download
> > > > > > > here:
> > > > > > >=20
> > > > > > >   https://artifacts.cki-project.org/pipelines/262380
> > > > > > >=20
> > > > > > > One or more kernel tests failed:
> > > > > > >=20
> > > > > > >     x86_64:
> > > > > > >      =E2=9D=8C LTP lite
> > > > > > >
> > > > > >=20
> > > > > > Not a 5.3 -stable regression.
> > > > > >=20
> > > > > > Failure comes from test that sanity checks all /proc files by d=
oing
> > > > > > 1k read from each. There are couple issues it hits wrt. snd_hda=
_*.
> > > > > >=20
> > > > > > Example reproducer:
> > > > > >   dd if=3D/sys/kernel/debug/regmap/hdaudioC0D3-hdaudio/access
> > > > > >   of=3Dout.txt
> > > > > >   count=3D1 bs=3D1024 iflag=3Dnonblock
> > > > >=20
> > > > > That's not a proc file :)
> > > >=20
> > > > Right. It's same test that's used for /proc too.
> > > >=20
> > > > >=20
> > > > > > It's slow and triggers soft lockups [1]. And it also requires l=
ot
> > > > > > of memory, triggering OOMs on smaller VMs:
> > > > > > 0x0000000024f0437b-0x000000001a32b1c8 1073745920
> > > > > > seq_read+0x131/0x400
> > > > > > pages=3D262144 vmalloc vpages N0=3D262144
> > > > > >=20
> > > > > > I'm leaning towards skipping all regmap entries in this test.
> > > > > > Comments are welcomed.
> > > > >=20
> > > > > Randomly poking around in debugfs is a sure way to cause crashes =
and
> > > > > major problems.  Also, debugfs files are NOT stable and only for
> > > > > debugging and should never be enabled on "real" systems.
> > > > >=20
> > > > > So what exactly is the test trying to do here?
> > > >=20
> > > > It's (unprivileged) user trying to open/read anything it can (/proc=
,
> > > > /sys)
> > > > to see if that triggers anything bad.
> > > >=20
> > > > It can run as privileged user too, which was the case above.
> > >=20
> > > Sure, you can do tons of bad things as root poking around in sysfs,
> > > debugfs, and procfs.  What exactly are you trying to do, break the
> > > system?
> >=20
> > We are talking about read-only here. Is it unreasonable to expect
> > that root can read all /proc entries without crashing the system?
>=20
> You are NOT reading /proc/ here.

No. That was a general question to usefulness of privileged read,
using /proc as example where it commonly happens.

> You are reading debugfs which you
> really have NOT idea what is in there.  As you saw, you are reading from
> hardware that is slow and doing odd things when you read from it.

Agreed, I already sent a patch to LTP to blacklist it.

> And yes, there are some /proc/ files that you should not read from as
> root and expect things to always work.  PCI devices are notorious for
> this, and if you are reading those files as root, you "know" you know
> what you are doing and can accept the risk for when things go wrong.
>=20
> It is fine to write tests to read specific /proc/ files that you know
> what is happening in them.  To pick random ones is never a good idea.

Thanks for example.=20

