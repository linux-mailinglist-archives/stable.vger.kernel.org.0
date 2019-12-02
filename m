Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B148210EA13
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 13:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfLBMbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 07:31:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60477 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727362AbfLBMbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 07:31:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575289866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JpEh+m3IUPpD3ZuffVtnmrdQ4ORagqFqM7OpNTqT+3U=;
        b=aN3F+TByzJSa9CrNqdGozqu8NMn+TbcGpy1RzPaYt87mOA69kTe7IcI8GnuthFwi5QgFak
        79UJlOoVc0ikjFTk5oNZsf59MezGKtzaAAgBx+Wy1BIvfeMzOMxGDo7cRflp9NnjV12TMQ
        BEUwy4dTWhTa/6e88Up/2416YnlXGSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-5wjuG0DUOtamm041Da2Gjg-1; Mon, 02 Dec 2019 07:31:02 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC430107ACC5;
        Mon,  2 Dec 2019 12:31:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EF661001901;
        Mon,  2 Dec 2019 12:31:00 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2E7FF1809565;
        Mon,  2 Dec 2019 12:31:00 +0000 (UTC)
Date:   Mon, 2 Dec 2019 07:30:59 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        linuxppc-dev@lists.ozlabs.org
Message-ID: <1420623640.14527843.1575289859701.JavaMail.zimbra@redhat.com>
In-Reply-To: <8736e3ffen.fsf@mpe.ellerman.id.au>
References: <cki.6C6A189643.3T2ZUWEMOI@redhat.com> <1738119916.14437244.1575151003345.JavaMail.zimbra@redhat.com> <8736e3ffen.fsf@mpe.ellerman.id.au>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_kernel?=
 =?utf-8?Q?_5.3.13-3b5f971.cki_(stable-queue)?=
MIME-Version: 1.0
X-Originating-IP: [10.43.17.163, 10.4.195.17]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.3.13-3b5f971.cki (stable-queue)
Thread-Index: cteAZVs1buDEh+CFMxyFiJYhnT9cJA==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 5wjuG0DUOtamm041Da2Gjg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> Hi Jan,
>=20
> Jan Stancek <jstancek@redhat.com> writes:
> > ----- Original Message -----
> >>=20
> >> Hello,
> >>=20
> >> We ran automated tests on a recent commit from this kernel tree:
> >>=20
> >>        Kernel repo:
> >>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-que=
ue.git
> >>             Commit: 3b5f97139acc - KVM: PPC: Book3S HV: Flush link sta=
ck
> >>             on
> >>             guest exit to host kernel
>=20
> I can't find this commit, I assume it's roughly the same as:
>=20
>   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git/commit/?h=3Dlinux-5.3.y&id=3D0815f75f90178bc7e1933cf0d0c818b5f3f5a20c

Hi,

yes, that looks like same one:
  https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/c=
ommit/?h=3D3b5f97139acc

Looking at CKI reports for past 2 weeks, there were 3 (unexplained) SIGBUS =
related failures:

5.3.13-3b5f971.cki@upstream-stable
LTP genpower Bus error

5.4.0-rc8-4b17a56.cki@upstream-stable
LTP genatan Bus error

5.3.11-200.fc30
xfstests
+/var/lib/xfstests/tests/generic/248: line 38: 161943 Bus error            =
   (core dumped) $TEST_PROG $TESTFILE

All 3 are from ppc64le, all power9 systems.

>=20
> >> The results of these automated tests are provided below.
> >>=20
> >>     Overall result: FAILED (see details below)
> >>              Merge: OK
> >>            Compile: OK
> >>              Tests: FAILED
> >>=20
> >> All kernel binaries, config files, and logs are available for download
> >> here:
> >>=20
> >>   https://artifacts.cki-project.org/pipelines/314344
> >>=20
> >> One or more kernel tests failed:
> >>=20
> >>     ppc64le:
> >>      =E2=9D=8C LTP
> >
> > I suspect kernel bug.
>=20
> Looks that way, but I can't reproduce it on a machine here.
>=20
> I have the same CPU revision and am booting the exact kernel binary &
> modules linked above.

I can semi-reliably reproduce it with:
(where LTP is installed to /mnt/testarea/ltp)

while [ True ]; do
        echo 3 > /proc/sys/vm/drop_caches
        rm -f /mnt/testarea/ltp/results/RUNTEST.log /mnt/testarea/ltp/outpu=
t/RUNTEST.run.log
        ./runltp -p -d results -l RUNTEST.log -o RUNTEST.run.log -f math
        grep FAIL /mnt/testarea/ltp/results/RUNTEST.log && exit 1
done

and some stress activity in other terminal (e.g. kernel build).
Sometimes in minutes, sometimes in hours. I did try couple
older kernels and could reproduce it with v4.19 and v5.0 as well.

v4.18 ran OK for 2 hours, assuming that one is good, it could be
related to xfs switching to iomap in 4.19-rc1.

Tracing so far led me to filemap_fault(), where it reached this -EIO,
before returning SIGBUS.

page_not_uptodate:
        /*
         * Umm, take care of errors if the page isn't up-to-date.
         * Try to re-read it _once_. We do this synchronously,
         * because there really aren't any performance issues here
         * and we need to check for errors.
         */
        ClearPageError(page);
        fpin =3D maybe_unlock_mmap_for_io(vmf, fpin);
        error =3D mapping->a_ops->readpage(file, page);
        if (!error) {
                wait_on_page_locked(page);
                if (!PageUptodate(page))
                        error =3D -EIO;
        }

...
        return VM_FAULT_SIGBUS;

>=20
> > There were couple of 'math' runtest related failures in recent couple d=
ays.
> > In all cases, some data file used by test was missing. Presumably becau=
se
> > binary that generates it crashed.
> >
> > I managed to reproduce one failure with this CKI build, which I believe
> > is the same problem.
> >
> > We crash early during load, before any LTP code runs:
> >
> > (gdb) r
> > Starting program: /mnt/testarea/ltp/testcases/bin/genasin
>=20
> What is this /mnt/testarea? Looks like it's setup by some of the beaker
> scripts or something?

Correct, it's where beaker script installs LTP. It's not a real mount,
just a directory on /. In my case it's xfs. It should match default
Fedora-31 Server ppc64le installation.

>=20
> I'm running LTP out of /home, which is ext4 directly on disk.
>=20
> I tried getting the tests-beaker stuff working on my machine, but I
> couldn't find all the libraries and so on it requires.
>=20
>=20
> > Program received signal SIGBUS, Bus error.
> > dl_main (phdr=3D0x10000040, phnum=3D<optimized out>, user_entry=3D0x7ff=
fffffe760,
> > auxv=3D<optimized out>) at rtld.c:1362
> > 1362        switch (ph->p_type)
> > (gdb) bt
> > #0  dl_main (phdr=3D0x10000040, phnum=3D<optimized out>,
> > user_entry=3D0x7fffffffe760, auxv=3D<optimized out>) at rtld.c:1362
> > #1  0x00007ffff7fcf3c8 in _dl_sysdep_start (start_argptr=3D<optimized o=
ut>,
> > dl_main=3D0x7ffff7fb37b0 <dl_main>) at ../elf/dl-sysdep.c:253
> > #2  0x00007ffff7fb1d1c in _dl_start_final (arg=3Darg@entry=3D0x7fffffff=
ee20,
> > info=3Dinfo@entry=3D0x7fffffffe870) at rtld.c:445
> > #3  0x00007ffff7fb2f5c in _dl_start (arg=3D0x7fffffffee20) at rtld.c:53=
7
> > #4  0x00007ffff7fb14d8 in _start () from /lib64/ld64.so.2
> > (gdb) f 0
> > #0  dl_main (phdr=3D0x10000040, phnum=3D<optimized out>,
> > user_entry=3D0x7fffffffe760, auxv=3D<optimized out>) at rtld.c:1362
> > 1362        switch (ph->p_type)
> > (gdb) l
> > 1357      /* And it was opened directly.  */
> > 1358      ++main_map->l_direct_opencount;
> > 1359
> > 1360      /* Scan the program header table for the dynamic section.  */
> > 1361      for (ph =3D phdr; ph < &phdr[phnum]; ++ph)
> > 1362        switch (ph->p_type)
> > 1363          {
> > 1364          case PT_PHDR:
> > 1365            /* Find out the load address.  */
> > 1366            main_map->l_addr =3D (ElfW(Addr)) phdr - ph->p_vaddr;
> >
> > (gdb) p ph
> > $1 =3D (const Elf64_Phdr *) 0x10000040
> >
> > (gdb) p *ph
> > Cannot access memory at address 0x10000040
> >
> > (gdb) info proc map
> > process 1110670
> > Mapped address spaces:
> >
> >           Start Addr           End Addr       Size     Offset objfile
> >           0x10000000         0x10010000    0x10000        0x0
> >           /mnt/testarea/ltp/testcases/bin/genasin
> >           0x10010000         0x10030000    0x20000        0x0
> >           /mnt/testarea/ltp/testcases/bin/genasin
> >       0x7ffff7f90000     0x7ffff7fb0000    0x20000        0x0 [vdso]
> >       0x7ffff7fb0000     0x7ffff7fe0000    0x30000        0x0
> >       /usr/lib64/ld-2.30.so
> >       0x7ffff7fe0000     0x7ffff8000000    0x20000    0x20000
> >       /usr/lib64/ld-2.30.so
> >       0x7ffffffd0000     0x800000000000    0x30000        0x0 [stack]
> >
> > (gdb) x/1x 0x10000040
> > 0x10000040:     Cannot access memory at address 0x10000040
>=20
> Yeah that's weird.
>=20
> > # /mnt/testarea/ltp/testcases/bin/genasin
> > Bus error (core dumped)
> >
> > However, as soon as I copy that binary somewhere else, it works fine:
> >
> > # cp /mnt/testarea/ltp/testcases/bin/genasin /tmp
> > # /tmp/genasin
> > # echo $?
> > 0
>=20
> Is /tmp a real disk or tmpfs?

tmpfs

Filesystem                           Type      1K-blocks     Used  Availabl=
e Use% Mounted on
devtmpfs                             devtmpfs  254530176        0  25453017=
6   0% /dev
tmpfs                                tmpfs     267992768        0  26799276=
8   0% /dev/shm
tmpfs                                tmpfs     267992768     9152  26798361=
6   1% /run
/dev/mapper/fedora_ibm--p9b--03-root xfs        15718400 13029284    268911=
6  83% /
tmpfs                                tmpfs     267992768        0  26799276=
8   0% /tmp
/dev/sda1                            xfs         1038336   944588      9374=
8  91% /boot
tmpfs                                tmpfs      53598528        0   5359852=
8   0% /run/user/0

