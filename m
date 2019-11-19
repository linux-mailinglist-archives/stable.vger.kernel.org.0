Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEF3100FA3
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 01:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfKSADM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 19:03:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56579 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726809AbfKSADM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 19:03:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574121790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=i6feWnG+wB05OQFYPtiB0wnbFl7YrpSPH/X0qI7Tbp4=;
        b=LwvQr9Cvn20qVD+V6YAn9H6B2erlWRqWbeCf0NcPeR/jDrrM5LcXGjIpA6BFUX6xiNGF2Q
        mX+UcjT8LyDWXqgZtoeKckkbMUfNbiGXFln5ShVY3ex/1GmxwfhM7sJmE7hRBIvDBUpO4h
        wTiqpKsIsDidYGYxrQZtx5D8aL9JF6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-W9soRUoBNIyhiNMXQbTNLA-1; Mon, 18 Nov 2019 19:03:09 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37291801E5B
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 00:03:08 +0000 (UTC)
Received: from [172.54.93.16] (cpt-1055.paas.prod.upshift.rdu2.redhat.com [10.0.19.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E72810002B8;
        Tue, 19 Nov 2019 00:03:05 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.3
Date:   Tue, 19 Nov 2019 00:03:05 -0000
Message-ID: <cki.2EF99A55E2.WXJ9OM3A2V@redhat.com>
X-Gitlab-Pipeline-ID: 293753
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/293753
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: W9soRUoBNIyhiNMXQbTNLA-1
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
            Commit: 116a395b7061 - Linux 5.3.11

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here=
:

  https://artifacts.cki-project.org/pipelines/293753

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
  Commit: 116a395b7061 - Linux 5.3.11


We grabbed the 58c4f05126ee commit of the stable queue repository.

We then merged the patchset with `git am`:

  scsi-core-handle-drivers-which-set-sg_tablesize-to-zero.patch
  ax88172a-fix-information-leak-on-short-answers.patch
  devlink-disallow-reload-operation-during-device-cleanup.patch
  ipmr-fix-skb-headroom-in-ipmr_get_route.patch
  mlxsw-core-enable-devlink-reload-only-on-probe.patch
  net-gemini-add-missed-free_netdev.patch
  net-smc-fix-fastopen-for-non-blocking-connect.patch
  net-usb-qmi_wwan-add-support-for-foxconn-t77w968-lte-modules.patch
  slip-fix-memory-leak-in-slip_open-error-path.patch
  tcp-remove-redundant-new-line-from-tcp_event_sk_skb.patch
  dpaa2-eth-free-already-allocated-channels-on-probe-defer.patch
  devlink-add-method-for-time-stamp-on-reporter-s-dump.patch
  net-smc-fix-refcount-non-blocking-connect-part-2.patch
  alsa-usb-audio-fix-missing-error-check-at-mixer-resolution-test.patch
  alsa-usb-audio-not-submit-urb-for-stopped-endpoint.patch
  alsa-usb-audio-fix-incorrect-null-check-in-create_yamaha_midi_quirk.patch
  alsa-usb-audio-fix-incorrect-size-check-for-processing-extension-units.pa=
tch
  btrfs-fix-log-context-list-corruption-after-rename-exchange-operation.pat=
ch
  cgroup-freezer-call-cgroup_enter_frozen-with-preemption-disabled-in-ptrac=
e_stop.patch
  input-ff-memless-kill-timer-in-destroy.patch
  input-synaptics-rmi4-fix-video-buffer-size.patch
  input-synaptics-rmi4-disable-the-relative-position-irq-in-the-f12-driver.=
patch
  input-synaptics-rmi4-do-not-consume-more-data-than-we-have-f11-f12.patch
  input-synaptics-rmi4-clear-irq-enables-for-f54.patch
  input-synaptics-rmi4-destroy-f54-poller-workqueue-when-removing.patch
  kvm-mmu-do-not-treat-zone_device-pages-as-being-reserved.patch
  ib-hfi1-ensure-r_tid_ack-is-valid-before-building-tid-rdma-ack-packet.pat=
ch
  ib-hfi1-calculate-flow-weight-based-on-qp-mtu-for-tid-rdma.patch
  ib-hfi1-tid-rdma-write-should-not-return-ib_wc_rnr_retry_exc_err.patch
  ib-hfi1-ensure-full-gen3-speed-in-a-gen4-system.patch
  ib-hfi1-use-a-common-pad-buffer-for-9b-and-16b-packets.patch
  i2c-acpi-force-bus-speed-to-400khz-if-a-silead-touchscreen-is-present.pat=
ch
  x86-quirks-disable-hpet-on-intel-coffe-lake-platforms.patch
  ecryptfs_lookup_interpose-lower_dentry-d_inode-is-not-stable.patch
  ecryptfs_lookup_interpose-lower_dentry-d_parent-is-not-stable-either.patc=
h
  io_uring-ensure-registered-buffer-import-returns-the-io-length.patch
  drm-i915-update-rawclk-also-on-resume.patch
  revert-drm-i915-ehl-update-mocs-table-for-ehl.patch
  ntp-y2038-remove-incorrect-time_t-truncation.patch
  net-ethernet-dwmac-sun8i-use-the-correct-function-in-exit-path.patch
  iommu-vt-d-fix-qi_dev_iotlb_pfsid-and-qi_dev_eiotlb_pfsid-macros.patch
  mm-mempolicy-fix-the-wrong-return-value-and-potential-pages-leak-of-mbind=
.patch
  mm-memcg-switch-to-css_tryget-in-get_mem_cgroup_from_mm.patch
  mm-hugetlb-switch-to-css_tryget-in-hugetlb_cgroup_charge_cgroup.patch
  mm-slub-really-fix-slab-walking-for-init_on_free.patch
  mm-memory_hotplug-fix-try_offline_node.patch
  mm-page_io.c-do-not-free-shared-swap-slots.patch
  mmc-sdhci-of-at91-fix-quirk2-overwrite.patch

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
       =E2=9C=85 xfstests: xfs
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =E2=9C=85 storage: SCSI VPD
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites

  ppc64le:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 xfstests: xfs
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites

  x86_64:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 xfstests: xfs
       =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 pciutils: sanity smoke test
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =E2=9C=85 storage: SCSI VPD
       =E2=9C=85 stress: stress-ng
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites

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

