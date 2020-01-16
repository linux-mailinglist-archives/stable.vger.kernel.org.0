Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B6013DC41
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 14:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgAPNmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 08:42:10 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38638 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726084AbgAPNmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 08:42:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579182127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YCOdngENjyc8DLL+2gEfGaW1gNWmEl+yqFS7NsTgmiw=;
        b=WiShErMHZdgp1w7fWuhUaZfmriUhul9mb6y3b8aIHa4TZzqxMF35HIO5dx93tIz1GxsI6D
        bg5RWzD69qbfGZ87sbDGFo0OXjHU57t7txUGhTugC6e4FkFa2BkJO1I4lzVsFqbtXFlRVI
        xN3NHq4J+vaNKlykwqO+1PKSPfWy4jE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-kWYw7L9gOXCicVjOvpJ2Dg-1; Thu, 16 Jan 2020 08:42:06 -0500
X-MC-Unique: kWYw7L9gOXCicVjOvpJ2Dg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B87CA8010C8;
        Thu, 16 Jan 2020 13:42:05 +0000 (UTC)
Received: from localhost.localdomain (ovpn-120-211.rdu2.redhat.com [10.10.120.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBF335C299;
        Thu, 16 Jan 2020 13:41:59 +0000 (UTC)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e4=2e13?=
 =?UTF-8?Q?-rc1-7f1b863=2ecki_=28stable=29?=
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Jianwen Ji <jiji@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jianlin Shi <jishi@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
References: <cki.FA900DB853.LBD049H627@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Message-ID: <84944fa0-3c18-f8a4-47ca-7627eb4e0594@redhat.com>
Date:   Thu, 16 Jan 2020 08:41:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cki.FA900DB853.LBD049H627@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/16/20 7:13 AM, CKI Project wrote:
>=20
> Hello,
>=20
> We ran automated tests on a recent commit from this kernel tree:
>=20
>         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stab=
le/linux-stable-rc.git
>              Commit: 7f1b8631b5a5 - Linux 5.4.13-rc1
>=20
> The results of these automated tests are provided below.
>=20
>      Overall result: FAILED (see details below)
>               Merge: OK
>             Compile: OK
>               Tests: FAILED
>=20
> All kernel binaries, config files, and logs are available for download =
here:
>=20
>    https://artifacts.cki-project.org/pipelines/385189
>=20
> One or more kernel tests failed:
>=20
>      ppc64le:
>       =E2=9D=8C LTP

Hi, I see max_map_count failed on ppc64le:
https://artifacts.cki-project.org/pipelines/385189/logs/ppc64le_host_2_LT=
P_mm.run.log

>=20
>      aarch64:
>       =E2=9D=8C Networking tunnel: gre basic
>       =E2=9D=8C Networking tunnel: vxlan basic
>=20
>      x86_64:
>       =E2=9D=8C Networking route_func: local
>       =E2=9D=8C Networking tunnel: geneve basic test

Please disregard the networking failures, they are related to an infrastr=
ucture bug and we now
have a workaround to avoid these failure until it's resolved, you should =
stop seeing these shortly,
sorry for the noise!

>=20
> We hope that these logs can help you find the problem quickly. For the =
full
> detail on our testing procedures, please scroll to the bottom of this m=
essage.
>=20
> Please reply to this email if you have any questions about the tests th=
at we
> ran or if you have any suggestions on how to make future tests more eff=
ective.
>=20
>          ,-.   ,-.
>         ( C ) ( K )  Continuous
>          `-',-.`-'   Kernel
>            ( I )     Integration
>             `-'
> _______________________________________________________________________=
_______
>=20
> Compile testing
> ---------------
>=20
> We compiled the kernel for 3 architectures:
>=20
>      aarch64:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>      ppc64le:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>      x86_64:
>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>=20
>=20
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
>=20
>    aarch64:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9C=85 LTP
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 Networking bridge: sanity
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking: igmp conformance test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9C=85 Networking tunnel: geneve basic test
>         =E2=9D=8C Networking tunnel: gre basic
>         =E2=9C=85 L2TP basic test
>         =E2=9D=8C Networking tunnel: vxlan basic
>         =E2=9C=85 Networking ipsec: basic netns transport
>         =E2=9C=85 Networking ipsec: basic netns tunnel
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 storage: SCSI VPD
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =E2=8F=B1  POSIX pjd-fstest suites
>         =E2=8F=B1  jvm test suite
>         =E2=8F=B1  Memory function: kaslr
>         =E2=8F=B1  LTP: openposix test suite
>         =E2=8F=B1  Networking vnic: ipvlan/basic
>         =E2=8F=B1  iotop: sanity
>         =E2=8F=B1  Usex - version 1.9-29
>         =E2=8F=B1  storage: dm/common
>=20
>      Host 2:
>=20
>         =E2=9A=A1 Internal infrastructure issues prevented one or more =
tests (marked
>         with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architec=
ture.
>         This is not the fault of the kernel that was tested.
>=20
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests: ext4
>         =E2=9C=85 xfstests: xfs
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =E2=9C=85 stress: stress-ng
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
>=20
>    ppc64le:
>      Host 1:
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests: ext4
>         =E2=9C=85 xfstests: xfs
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>      Host 2:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9D=8C LTP
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 Networking bridge: sanity
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9C=85 Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9C=85 Networking tunnel: geneve basic test
>         =E2=9C=85 Networking tunnel: gre basic
>         =E2=9C=85 L2TP basic test
>         =E2=9C=85 Networking tunnel: vxlan basic
>         =E2=9C=85 Networking ipsec: basic netns tunnel
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =F0=9F=9A=A7 =E2=9C=85 jvm test suite
>         =F0=9F=9A=A7 =E2=9C=85 Memory function: kaslr
>         =F0=9F=9A=A7 =E2=9C=85 LTP: openposix test suite
>         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
>         =F0=9F=9A=A7 =E2=9C=85 iotop: sanity
>         =F0=9F=9A=A7 =E2=9C=85 Usex - version 1.9-29
>         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
>=20
>    x86_64:
>      Host 1:
>         =E2=8F=B1  Boot test
>         =E2=8F=B1  Storage SAN device stress - mpt3sas driver
>=20
>      Host 2:
>         =E2=8F=B1  Boot test
>         =E2=8F=B1  Storage SAN device stress - megaraid_sas
>=20
>      Host 3:
>=20
>         =E2=9A=A1 Internal infrastructure issues prevented one or more =
tests (marked
>         with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architec=
ture.
>         This is not the fault of the kernel that was tested.
>=20
>         =E2=9C=85 Boot test
>         =E2=9C=85 xfstests: ext4
>         =E2=9C=85 xfstests: xfs
>         =E2=9C=85 selinux-policy: serge-testsuite
>         =E2=9C=85 lvm thinp sanity
>         =E2=9C=85 storage: software RAID testing
>         =E2=9C=85 stress: stress-ng
>         =F0=9F=9A=A7 =E2=9C=85 IOMMU boot test
>         =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
>         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
>         =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 power-management: cpup=
ower/sanity test
>         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
>=20
>      Host 4:
>         =E2=9C=85 Boot test
>         =E2=9C=85 Podman system integration test (as root)
>         =E2=9C=85 Podman system integration test (as user)
>         =E2=9C=85 LTP
>         =E2=9C=85 Loopdev Sanity
>         =E2=9C=85 Memory function: memfd_create
>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>         =E2=9C=85 Networking bridge: sanity
>         =E2=9C=85 Ethernet drivers sanity
>         =E2=9C=85 Networking MACsec: sanity
>         =E2=9C=85 Networking socket: fuzz
>         =E2=9C=85 Networking sctp-auth: sockopts test
>         =E2=9C=85 Networking: igmp conformance test
>         =E2=9C=85 Networking route: pmtu
>         =E2=9D=8C Networking route_func: local
>         =E2=9C=85 Networking route_func: forward
>         =E2=9C=85 Networking TCP: keepalive test
>         =E2=9C=85 Networking UDP: socket
>         =E2=9D=8C Networking tunnel: geneve basic test
>         =E2=9C=85 Networking tunnel: gre basic
>         =E2=9C=85 L2TP basic test
>         =E2=9C=85 Networking tunnel: vxlan basic
>         =E2=9C=85 Networking ipsec: basic netns transport
>         =E2=9C=85 Networking ipsec: basic netns tunnel
>         =E2=9C=85 audit: audit testsuite test
>         =E2=9C=85 httpd: mod_ssl smoke sanity
>         =E2=9C=85 tuned: tune-processes-through-perf
>         =E2=9C=85 pciutils: sanity smoke test
>         =E2=9C=85 ALSA PCM loopback test
>         =E2=9C=85 ALSA Control (mixer) Userspace Element test
>         =E2=9C=85 storage: SCSI VPD
>         =E2=9C=85 trace: ftrace/tracer
>         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
>         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
>         =E2=8F=B1  jvm test suite
>         =E2=8F=B1  Memory function: kaslr
>         =E2=8F=B1  LTP: openposix test suite
>         =E2=8F=B1  Networking vnic: ipvlan/basic
>         =E2=8F=B1  iotop: sanity
>         =E2=8F=B1  Usex - version 1.9-29
>         =E2=8F=B1  storage: dm/common
>=20
>    Test sources: https://github.com/CKI-project/tests-beaker
>      =F0=9F=92=9A Pull requests are welcome for new tests or improvemen=
ts to existing tests!
>=20
> Waived tests
> ------------
> If the test run included waived tests, they are marked with =F0=9F=9A=A7=
. Such tests are
> executed but their results are not taken into account. Tests are waived=
 when
> their results are not reliable enough, e.g. when they're just introduce=
d or are
> being fixed.
>=20
> Testing timeout
> ---------------
> We aim to provide a report within reasonable timeframe. Tests that have=
n't
> finished running are marked with =E2=8F=B1. Reports for non-upstream ke=
rnels have
> a Beaker recipe linked to next to each host.
>=20
>=20

