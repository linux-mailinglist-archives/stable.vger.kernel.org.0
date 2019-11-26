Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C23C1097A8
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 03:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKZCAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 21:00:36 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32309 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726970AbfKZCAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 21:00:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574733633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lUx2IIywchPM6bvYayEpHrtxFkeiYR+xNbXJAVYTSdw=;
        b=T7mFCpx6fY9LkrU/Ro5yzm01G4gAAB8UDiYxlBuI6w7Yw+txZ2dsVxtxmNvctL75mQMnLB
        SYAl4zws+r736PO0FbTmF/NdzMi5pVgz0hFPD6yxenlRYdELdDyXSrOyZGz3X3IFfEeDX2
        qkq97J5c9V46Cs42rfVdRB2RxcSfAqI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-SsuvRqyVPx6Z_GceQYywDg-1; Mon, 25 Nov 2019 21:00:31 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D21A80183C
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 02:00:31 +0000 (UTC)
Received: from [172.54.50.241] (cpt-1014.paas.prod.upshift.rdu2.redhat.com [10.0.19.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7712B1001902;
        Tue, 26 Nov 2019 02:00:25 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Stable queue: queue-5.3
Date:   Tue, 26 Nov 2019 02:00:25 -0000
CC:     Christine Flood <chf@redhat.com>
Message-ID: <cki.C344755D67.02OLLDXO3P@redhat.com>
X-Gitlab-Pipeline-ID: 307687
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/307687
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: SsuvRqyVPx6Z_GceQYywDg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into thi=
s
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/=
linux.git
            Commit: cea54ae336ae - Linux 5.3.13

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

All kernel binaries, config files, and logs are available for download here=
:

  https://artifacts.cki-project.org/pipelines/307687

One or more kernel tests failed:

    ppc64le:
     =E2=9D=8C Boot test

We hope that these logs can help you find the problem quickly. For the full
detail on our testing procedures, please scroll to the bottom of this messa=
ge.

Please reply to this email if you have any questions about the tests that w=
e
ran or if you have any suggestions on how to make future tests more effecti=
ve.

        ,-.   ,-.
       ( C ) ( K )  Continuous
        `-',-.`-'   Kernel
          ( I )     Integration
           `-'
___________________________________________________________________________=
___

Merge testing
-------------

We cloned this repository and checked out the following commit:

  Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: cea54ae336ae - Linux 5.3.13


We grabbed the 52eec70445d5 commit of the stable queue repository.

We then merged the patchset with `git am`:

  mlxsw-spectrum_router-fix-determining-underlay-for-a-gre-tunnel.patch
  net-mlx4_en-fix-mlx4-ethtool-n-insertion.patch
  net-mlx4_en-fix-wrong-limitation-for-number-of-tx-rings.patch
  net-rtnetlink-prevent-underflows-in-do_setvfinfo.patch
  net-sched-act_pedit-fix-warn-in-the-traffic-path.patch
  net-sched-ensure-opts_len-ip_tunnel_opts_max-in-act_tunnel_key.patch
  sfc-only-cancel-the-pps-workqueue-if-it-exists.patch
  net-mlxfw-verify-fsm-error-code-translation-doesn-t-exceed-array-size.pat=
ch
  net-mlx5e-fix-set-vf-link-state-error-flow.patch
  net-mlx5-fix-auto-group-size-calculation.patch
  net-tls-enable-sk_msg-redirect-to-tls-socket-egress.patch
  ipv6-route-return-if-there-is-no-fib_nh_gw_family.patch
  mdio_bus-fix-mdio_register_device-when-reset_controller-is-disabled.patch
  taprio-don-t-reject-same-mqprio-settings.patch
  net-ipv4-fix-sysctl-max-for-fib_multipath_hash_policy.patch
  net-mlx5e-fix-error-flow-cleanup-in-mlx5e_tc_tun_create_header_ipv4-6.pat=
ch
  net-mlx5e-do-not-use-non-ext-link-modes-in-ext-mode.patch
  net-mlx5-update-the-list-of-the-pci-supported-devices.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    s390x:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 stress: stress-ng
       =F0=9F=9A=A7 =E2=9D=8C jvm test suite
       =F0=9F=9A=A7 =E2=9C=85 iotop: sanity

    Host 2:
       =E2=9C=85 Boot test
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite

  ppc64le:
    Host 1:
       =E2=9C=85 Boot test
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite

    Host 2:
       =E2=9D=8C Boot test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as root)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Podman system integration test (as user)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test suite
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route: pmtu
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: local
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking route_func: forward
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 httpd: mod_ssl smoke sanity
       =E2=9A=A1=E2=9A=A1=E2=9A=A1 tuned: tune-processes-through-perf
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm test suite
       =F0=9F=9A=A7 =E2=9A=A1=E2=9A=A1=E2=9A=A1 iotop: sanity

  s390x:

    =E2=9A=A1 Internal infrastructure issues prevented one or more tests (m=
arked
    with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
    This is not the fault of the kernel that was tested.

  x86_64:
    Host 1:
       =E2=9C=85 Boot test
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 pciutils: sanity smoke test
       =E2=9C=85 stress: stress-ng
       =F0=9F=9A=A7 =E2=9C=85 jvm test suite
       =F0=9F=9A=A7 =E2=9C=85 iotop: sanity

  Test sources: https://github.com/CKI-project/tests-beaker
    =F0=9F=92=9A Pull requests are welcome for new tests or improvements to=
 existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with =F0=9F=9A=A7. S=
uch tests are
executed but their results are not taken into account. Tests are waived whe=
n
their results are not reliable enough, e.g. when they're just introduced or=
 are
being fixed.

Testing timeout
---------------
We aim to provide a report within reasonable timeframe. Tests that haven't
finished running are marked with =E2=8F=B1. Reports for non-upstream kernel=
s have
a Beaker recipe linked to next to each host.

