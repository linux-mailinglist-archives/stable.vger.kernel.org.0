Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C611CEA44C
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 20:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfJ3Tdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 15:33:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53171 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726184AbfJ3Tdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Oct 2019 15:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572464025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RO1hg9SEJyKA8799FTVo9pzTWEUUgfTd1GKjWiZ/G6c=;
        b=gejr5GaEmgRvwApOP5UaKuZZLkL/ih5w+Sl8SKGL4bRp13ebi5UWvSoTwh18sNeeXDjnc8
        qCp8Jc0ALSxuVPHII7AvgXKYksGYfX7y4kNQcMxvcrsdUP+A5DWvfTyBAVNqtw+9zSyilF
        Fo1MVs0J/USi6cDJWoqNq/AcEyRqe6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-rVmzlPG9NAmLmndI9dOSiw-1; Wed, 30 Oct 2019 15:33:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F8C82EDC
        for <stable@vger.kernel.org>; Wed, 30 Oct 2019 19:33:37 +0000 (UTC)
Received: from localhost.localdomain (ovpn-121-15.rdu2.redhat.com [10.10.121.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E22860872;
        Wed, 30 Oct 2019 19:33:28 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e4=2e0-?=
 =?UTF-8?Q?rc5-c15dde9=2ecki_=28stable-next=29?=
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        William Gomeringer <wgomeringer@redhat.com>
References: <cki.988D4031A9.LPRH57O40D@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <477b8013-5eca-9c87-cc82-ea508422eebe@redhat.com>
Date:   Wed, 30 Oct 2019 15:33:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <cki.988D4031A9.LPRH57O40D@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: rVmzlPG9NAmLmndI9dOSiw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Both oom03/oom05 failed here, I'm working on disabling the failing LTP test=
s
due to https://github.com/linux-test-project/ltp/issues/611

-Rachel

On 10/30/19 1:54 PM, CKI Project wrote:
> Hello,
>
> We ran automated tests on a recent commit from this kernel tree:
>
>         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/sashal=
/linux-stable.git
>              Commit: c15dde9190b4 - scsi: zfcp: trace channel log even fo=
r FCP command responses
>
> The results of these automated tests are provided below.
>
>      Overall result: FAILED (see details below)
>               Merge: OK
>             Compile: OK
>               Tests: FAILED
>
> All kernel binaries, config files, and logs are available for download he=
re:
>
>    https://artifacts.cki-project.org/pipelines/256777
>
> One or more kernel tests failed:
>
>      x86_64:
>       =E2=9D=8C LTP lite
>
> We hope that these logs can help you find the problem quickly. For the fu=
ll
> detail on our testing procedures, please scroll to the bottom of this mes=
sage.
>
> Please reply to this email if you have any questions about the tests that=
 we
> ran or if you have any suggestions on how to make future tests more effec=
tive.
>
>          ,-.   ,-.
>         ( C ) ( K )  Continuous
>          `-',-.`-'   Kernel
>            ( I )     Integration
>             `-'
> _________________________________________________________________________=
_____
>
> Compile testing
> ---------------
>
> We compiled the kernel for 3 architectures:
>
>      aarch64:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>
>      ppc64le:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>
>      x86_64:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>
>
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
>
>    aarch64:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>         =F0=9F=9A=A7 =E2=9C=85 xfstests: ext4
>         =F0=9F=9A=A7 =E2=9C=85 xfstests: xfs
>
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9C=85 LTP lite
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 jvm test suite
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 Memory function: kaslr
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 LTP: openposix test suite
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking: igmp conformance test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9C=85 Networking tunnel: geneve basic test
>         =E2=9C=85 Networking tunnel: gre basic
>         =E2=9C=85 Networking tunnel: vxlan basic
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 iotop: sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 Usex - version 1.9-29
>         =E2=9C=85 storage: SCSI VPD
>         =E2=9C=85 stress: stress-ng
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 Networking bridge: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =F0=9F=9A=A7 =E2=9C=85 L2TP basic test
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 ALSA PCM loopback test
>         =F0=9F=9A=A7 =E2=9C=85 ALSA Control (mixer) Userspace Element tes=
t
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns transport
>         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns tunnel
>
>    ppc64le:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>         =F0=9F=9A=A7 =E2=9C=85 xfstests: ext4
>         =F0=9F=9A=A7 =E2=9C=85 xfstests: xfs
>
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9C=85 LTP lite
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 jvm test suite
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 Memory function: kaslr
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 LTP: openposix test suite
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9C=85 Networking tunnel: geneve basic test
>         =E2=9C=85 Networking tunnel: gre basic
>         =E2=9C=85 Networking tunnel: vxlan basic
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 iotop: sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 Usex - version 1.9-29
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 Networking bridge: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =F0=9F=9A=A7 =E2=9C=85 L2TP basic test
>         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns tunnel
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 ALSA PCM loopback test
>         =F0=9F=9A=A7 =E2=9C=85 ALSA Control (mixer) Userspace Element tes=
t
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>
>    x86_64:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9D=8C LTP lite
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 jvm test suite
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 Memory function: kaslr
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 LTP: openposix test suite
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking: igmp conformance test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9C=85 Networking tunnel: geneve basic test
>         =E2=9C=85 Networking tunnel: gre basic
>         =E2=9C=85 Networking tunnel: vxlan basic
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 iotop: sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 pciutils: sanity smoke test
>         =E2=9C=85 Usex - version 1.9-29
>         =E2=9C=85 storage: SCSI VPD
>         =E2=9C=85 stress: stress-ng
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 Networking bridge: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =F0=9F=9A=A7 =E2=9C=85 L2TP basic test
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 ALSA PCM loopback test
>         =F0=9F=9A=A7 =E2=9C=85 ALSA Control (mixer) Userspace Element tes=
t
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns transport
>         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns tunnel
>
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9D=8C IOMMU boot test
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>         =F0=9F=9A=A7 =E2=9C=85 xfstests: ext4
>         =F0=9F=9A=A7 =E2=9C=85 xfstests: xfs
>
>      Host 3:
>         =E2=9C=85 Boot test
>         =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>
>    Test sources: https://github.com/CKI-project/tests-beaker
>      =F0=9F=92=9A Pull requests are welcome for new tests or improvements=
 to existing tests!
>
> Waived tests
> ------------
> If the test run included waived tests, they are marked with =F0=9F=9A=A7.=
 Such tests are
> executed but their results are not taken into account. Tests are waived w=
hen
> their results are not reliable enough, e.g. when they're just introduced =
or are
> being fixed.
>
> Testing timeout
> ---------------
> We aim to provide a report within reasonable timeframe. Tests that haven'=
t
> finished running are marked with =E2=8F=B1. Reports for non-upstream kern=
els have
> a Beaker recipe linked to next to each host.
>

