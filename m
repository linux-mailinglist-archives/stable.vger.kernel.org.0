Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BABE16675B
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 20:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbgBTTnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 14:43:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29731 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728582AbgBTTnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 14:43:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582227783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IVSSF09XwOssK8yY/5II/1giwG5duURP8nkL9//18cc=;
        b=VN3ADIOG5qYqL4wmOZWupcGVfU90+LZjF0DEJD+q3YRXKs44R74rzVzQTPLC4Dpz2GS+1x
        JRtdkzAnji61r+kEG7Nia0LSBytjc2G70HvtaiPp/NOY16w5LsWh7EeA+6CwY+3Rw9t4X+
        KG2t0LL4didPTsxyAUlBKKmcMVgDl4o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-Wq80ucSGOzqnd-v0k-aXxg-1; Thu, 20 Feb 2020 14:42:58 -0500
X-MC-Unique: Wq80ucSGOzqnd-v0k-aXxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 503A38017CC;
        Thu, 20 Feb 2020 19:42:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 474CD87B0A;
        Thu, 20 Feb 2020 19:42:56 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0813C866DA;
        Thu, 20 Feb 2020 19:42:56 +0000 (UTC)
Date:   Thu, 20 Feb 2020 14:42:55 -0500 (EST)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Message-ID: <1011809226.8353012.1582227775821.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.C7F44073DC.K13BODGQAA@redhat.com>
References: <cki.C7F44073DC.K13BODGQAA@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_ker?=
 =?utf-8?Q?nel_5.4.21-2d636a1.cki_(stable)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.43.17.25, 10.4.195.11]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.4.21-2d636a1.cki (stable)
Thread-Index: zGHFPwxkGH3VdIVSrLocgrXxhi0zhw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>        Kernel repo:
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
>             Commit: 2d636a1263be - Linux 5.4.21
>=20
> The results of these automated tests are provided below.
>=20
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
>=20
> All kernel binaries, config files, and logs are available for download he=
re:
>=20
>   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=3Dda=
tawarehouse/2020/02/19/446693
>=20
> One or more kernel tests failed:
>=20
>     ppc64le:
>      =E2=9D=8C LTP

This is warning from preadv203, because it failed to clear loop device.
Kernel reports an I/O error:

[ 2338.786854] blk_update_request: I/O error, dev loop0, sector 512 op 0x0:=
(READ) flags 0x0 phys_seg 1 prio class 0

tst_test.c:1278: INFO: Testing on ext3
tst_mkfs.c:89: INFO: Formatting /dev/loop0 with ext3 opts=3D'' extra opts=
=3D''
mke2fs 1.45.5 (07-Jan-2020)
tst_test.c:1215: INFO: Timeout per run is 0h 05m 00s
preadv203.c:143: INFO: Number of full_reads 425, short reads 10, zero len r=
eads 0, EAGAIN(s) 100
preadv203.c:180: INFO: Number of writes 300
preadv203.c:194: INFO: Cache dropped 1 times
preadv203.c:223: PASS: Got some EAGAIN
tst_test.c:1278: INFO: Testing on ext4
tst_device.c:348: WARN: Failed to clear 512k block on /dev/loop0
tst_mkfs.c:87: BROK: tst_clear_device() failed

Summary:
passed   2
failed   0
skipped  0
warnings 1

but I haven't been able to reliably reproduce it so far.

