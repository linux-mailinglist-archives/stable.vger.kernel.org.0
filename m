Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39084CD9A1
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 01:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfJFX2H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 6 Oct 2019 19:28:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbfJFX2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 19:28:07 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EE02D3082E10
        for <stable@vger.kernel.org>; Sun,  6 Oct 2019 23:28:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E65EE600C8
        for <stable@vger.kernel.org>; Sun,  6 Oct 2019 23:28:06 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id D6F204E589;
        Sun,  6 Oct 2019 23:28:06 +0000 (UTC)
Date:   Sun, 6 Oct 2019 19:28:06 -0400 (EDT)
From:   Jan Stancek <jstancek@redhat.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Jeff Bastian <jbastian@redhat.com>,
        Memory Management <mm-qe@redhat.com>
Message-ID: <1178463299.3785809.1570404486626.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.F7D7AF8291.B2RERZ8XG4@redhat.com>
References: <cki.F7D7AF8291.B2RERZ8XG4@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9D=8C_FAIL:_Test_report_for_ke?=
 =?utf-8?Q?rnel_5.3.4-ed56826.cki_(stable)?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.40.204.34, 10.4.195.5]
Thread-Topic: =?utf-8?B?4p2MIEZBSUw6?= Test report for kernel 5.3.4-ed56826.cki (stable)
Thread-Index: DlwPCTbwxy74h88HTw4iNKpZaNTFKg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Sun, 06 Oct 2019 23:28:06 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
> 
>   aarch64:
>       Host 1:
>          ✅ Boot test
>          ✅ xfstests: ext4
>          ✅ xfstests: xfs
>          ✅ selinux-policy: serge-testsuite
>          ✅ lvm thinp sanity
>          ✅ storage: software RAID testing
>          🚧 ✅ Storage blktests
> 
>       Host 2:
> 
>          ⚡ Internal infrastructure issues prevented one or more tests (marked
>          with ⚡⚡⚡) from running on this architecture.
>          This is not the fault of the kernel that was tested.
> 
>          ✅ Boot test
>          ✅ Podman system integration test (as root)
>          ✅ Podman system integration test (as user)
>          ✅ Loopdev Sanity
>          ✅ jvm test suite
>          ✅ Memory function: memfd_create
>          ✅ AMTU (Abstract Machine Test Utility)
>          ✅ Ethernet drivers sanity
>          ✅ Networking socket: fuzz
>          ✅ Networking sctp-auth: sockopts test
>          ✅ Networking: igmp conformance test
>          ✅ Networking TCP: keepalive test
>          ✅ Networking UDP: socket
>          ✅ Networking tunnel: gre basic
>          ✅ Networking tunnel: vxlan basic
>          ✅ audit: audit testsuite test
>          ✅ httpd: mod_ssl smoke sanity
>          ✅ iotop: sanity
>          ✅ tuned: tune-processes-through-perf
>          ✅ Usex - version 1.9-29
>          ✅ storage: SCSI VPD
>          🚧 ⚡⚡⚡ LTP lite

read_all_sys is triggering hard lockups on specific arm64 while reading /sys.
LTP doesn't hit it 100%, but a plain "cat" or "hexdump" works reliable for me.

Doesn't seem to be recent, Fedora's 5.0.9-301.fc30.aarch64 hanged too on same file.
I sent a description to arm list:
  https://lore.kernel.org/linux-arm-kernel/1507592549.3785589.1570404050459.JavaMail.zimbra@redhat.com/
