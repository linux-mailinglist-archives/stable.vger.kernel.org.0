Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40532EE240
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 15:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfKDO2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 09:28:17 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49014 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727861AbfKDO2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 09:28:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572877695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sXs+LDxO88IFopCBCdlf8Wk3p0+58YbIqWF2eEqPtpk=;
        b=aXqHmeYlAAY6SZkDL3JDP0xkx/X+LqORa1tdu1R1+X4CGU0x5wW0epXCn+MIGpwoYU5/Ga
        y97rGrPe8MKyPB/19RNaxuSr4ssV7Td8j+oWdgfpu6+Uw1mD4RSLrswwKoD8MaXY4fMgqC
        rVdXdgDEi9ngE9c+TzzHYc/HX2KBVWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-t_2Xk-g9NVCNSG-XGMKtLA-1; Mon, 04 Nov 2019 09:28:12 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85AC48017DD;
        Mon,  4 Nov 2019 14:28:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 75D2E5D6C5;
        Mon,  4 Nov 2019 14:28:11 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 13CBF4BB5B;
        Mon,  4 Nov 2019 14:28:11 +0000 (UTC)
Date:   Mon, 4 Nov 2019 09:28:10 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     CKI Project <cki-project@redhat.com>,
        Jaroslav Kysela <jkysela@redhat.com>,
        alsa-devel@alsa-project.org, LTP Mailing List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>
Message-ID: <1341418315.10342806.1572877690830.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191104135135.GA2162401@kroah.com>
References: <cki.1210A7ECB0.BD9Q3APV4K@redhat.com> <2029139028.10333037.1572874551626.JavaMail.zimbra@redhat.com> <20191104135135.GA2162401@kroah.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kern?=
 =?utf-8?Q?el_5.3.9-rc1-dfe283e.cki_(stable)?=
MIME-Version: 1.0
X-Originating-IP: [10.43.17.163, 10.4.195.10]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.3.9-rc1-dfe283e.cki (stable)
Thread-Index: Kx4pHL9z3NzPO+lMPvoi41zdd+kemg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: t_2Xk-g9NVCNSG-XGMKtLA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> On Mon, Nov 04, 2019 at 08:35:51AM -0500, Jan Stancek wrote:
> >=20
> >=20
> > ----- Original Message -----
> > >=20
> > > Hello,
> > >=20
> > > We ran automated tests on a recent commit from this kernel tree:
> > >=20
> > >        Kernel repo:
> > >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-sta=
ble-rc.git
> > >             Commit: dfe283e9fdac - Linux 5.3.9-rc1
> > >=20
> > > The results of these automated tests are provided below.
> > >=20
> > >     Overall result: FAILED (see details below)
> > >              Merge: OK
> > >            Compile: OK
> > >              Tests: FAILED
> > >=20
> > > All kernel binaries, config files, and logs are available for downloa=
d
> > > here:
> > >=20
> > >   https://artifacts.cki-project.org/pipelines/262380
> > >=20
> > > One or more kernel tests failed:
> > >=20
> > >     x86_64:
> > >      =E2=9D=8C LTP lite
> > >
> >=20
> > Not a 5.3 -stable regression.
> >=20
> > Failure comes from test that sanity checks all /proc files by doing
> > 1k read from each. There are couple issues it hits wrt. snd_hda_*.
> >=20
> > Example reproducer:
> >   dd if=3D/sys/kernel/debug/regmap/hdaudioC0D3-hdaudio/access of=3Dout.=
txt
> >   count=3D1 bs=3D1024 iflag=3Dnonblock
>=20
> That's not a proc file :)

Right. It's same test that's used for /proc too.

>=20
> > It's slow and triggers soft lockups [1]. And it also requires lot
> > of memory, triggering OOMs on smaller VMs:
> > 0x0000000024f0437b-0x000000001a32b1c8 1073745920 seq_read+0x131/0x400
> > pages=3D262144 vmalloc vpages N0=3D262144
> >=20
> > I'm leaning towards skipping all regmap entries in this test.
> > Comments are welcomed.
>=20
> Randomly poking around in debugfs is a sure way to cause crashes and
> major problems.  Also, debugfs files are NOT stable and only for
> debugging and should never be enabled on "real" systems.
>=20
> So what exactly is the test trying to do here?

It's (unprivileged) user trying to open/read anything it can (/proc, /sys)
to see if that triggers anything bad.

It can run as privileged user too, which was the case above.

[1] https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/=
fs/read_all/read_all.c

