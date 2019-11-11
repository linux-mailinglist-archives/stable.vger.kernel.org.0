Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A401DF7358
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 12:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfKKLn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 06:43:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43174 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726791AbfKKLn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 06:43:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573472634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YvUXlh0Fm3KeMBAqNf6SpPn+O7vh5b3aebzrs0OP6eI=;
        b=KWsnbIcFLlqY/w1rhGWIwDXUVotVmFTLNEj9elmoKzB0NHObmTMmvCunJJQOkRrLXucLZF
        t/N/yhgtAhSSHH9vEgOOJMCOMMz2GSHC7nPq4bzYFyIungYkt/6NfyLhQQksxx2O0FvGNo
        c28aiuJIsWY7myEQ+WvqKCCVsi/g4ME=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-RlCpDTKIPMihlK7prO_Ntw-1; Mon, 11 Nov 2019 06:43:53 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 387F1107ACFE
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 11:43:52 +0000 (UTC)
Received: from [172.54.37.191] (cpt-1013.paas.prod.upshift.rdu2.redhat.com [10.0.19.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 436F95EE0F;
        Mon, 11 Nov 2019 11:43:49 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Stable queue: queue-5.3
Date:   Mon, 11 Nov 2019 11:43:48 -0000
CC:     Milos Malik <mmalik@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Message-ID: <cki.EFF853E453.I45IP7GV3J@redhat.com>
X-Gitlab-Pipeline-ID: 278192
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/278192
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: RlCpDTKIPMihlK7prO_Ntw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
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
            Commit: 81584694bb70 - Linux 5.3.10

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED

All kernel binaries, config files, and logs are available for download here=
:

  https://artifacts.cki-project.org/pipelines/278192

One or more kernel tests failed:

    ppc64le:
     =E2=9D=8C selinux-policy: serge-testsuite

    aarch64:
     =E2=9D=8C selinux-policy: serge-testsuite

    x86_64:
     =E2=9D=8C selinux-policy: serge-testsuite

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
  Commit: 81584694bb70 - Linux 5.3.10


We grabbed the 94c2a109543a commit of the stable queue repository.

We then merged the patchset with `git am`:

  bonding-fix-state-transition-issue-in-link-monitoring.patch
  cdc-ncm-handle-incomplete-transfer-of-mtu.patch
  ipv4-fix-table-id-reference-in-fib_sync_down_addr.patch
  net-ethernet-octeon_mgmt-account-for-second-possible-vlan-header.patch
  net-fix-data-race-in-neigh_event_send.patch
  net-qualcomm-rmnet-fix-potential-uaf-when-unregistering.patch
  net-tls-fix-sk_msg-trim-on-fallback-to-copy-mode.patch
  net-usb-qmi_wwan-add-support-for-dw5821e-with-esim-support.patch
  nfc-fdp-fix-incorrect-free-object.patch
  nfc-netlink-fix-double-device-reference-drop.patch
  nfc-st21nfca-fix-double-free.patch
  qede-fix-null-pointer-deref-in-__qede_remove.patch
  net-mscc-ocelot-don-t-handle-netdev-events-for-other-netdevs.patch
  net-mscc-ocelot-fix-null-pointer-on-lag-slave-removal.patch
  net-tls-don-t-pay-attention-to-sk_write_pending-when-pushing-partial-reco=
rds.patch
  net-tls-add-a-tx-lock.patch
  selftests-tls-add-test-for-concurrent-recv-and-send.patch
  ipv6-fixes-rt6_probe-and-fib6_nh-last_probe-init.patch
  net-hns-fix-the-stray-netpoll-locks-causing-deadlock-in-napi-path.patch
  net-prevent-load-store-tearing-on-sk-sk_stamp.patch
  net-sched-prevent-duplicate-flower-rules-from-tcf_proto-destroy-race.patc=
h
  net-smc-fix-ethernet-interface-refcounting.patch
  vsock-virtio-fix-sock-refcnt-holding-during-the-shutdown.patch
  r8169-fix-page-read-in-r8168g_mdio_read.patch
  alsa-timer-fix-incorrectly-assigned-timer-instance.patch
  alsa-bebob-fix-to-detect-configured-source-of-sampling-clock-for-focusrit=
e-saffire-pro-i-o-series.patch
  alsa-hda-ca0132-fix-possible-workqueue-stall.patch
  mm-memcontrol-fix-null-ptr-deref-in-percpu-stats-flush.patch
  mm-memcontrol-fix-network-errors-from-failing-__gfp_atomic-charges.patch
  mm-meminit-recalculate-pcpu-batch-and-high-limits-after-init-completes.pa=
tch
  mm-thp-handle-page-cache-thp-correctly-in-pagetranscompoundmap.patch
  mm-vmstat-hide-proc-pagetypeinfo-from-normal-users.patch

Compile testing
---------------

We compiled the kernel for 3 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9D=8C selinux-policy: serge-testsuite

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =E2=9C=85 stress: stress-ng

  ppc64le:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9D=8C selinux-policy: serge-testsuite

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29

  x86_64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9D=8C selinux-policy: serge-testsuite

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking route: pmtu
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 pciutils: sanity smoke test
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =E2=9C=85 stress: stress-ng

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

