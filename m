Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4DFFB81FD
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 21:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390149AbfIST4c convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 19 Sep 2019 15:56:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387854AbfIST4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 15:56:31 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 78FDA3082149
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 19:56:31 +0000 (UTC)
Received: from [172.54.46.6] (cpt-1015.paas.prod.upshift.rdu2.redhat.com [10.0.19.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 371875C1B5;
        Thu, 19 Sep 2019 19:56:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.C679103D4E.BLJOJTN7PS@redhat.com>
X-Gitlab-Pipeline-ID: 174802
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/174802
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 19 Sep 2019 19:56:31 +0000 (UTC)
Date:   Thu, 19 Sep 2019 15:56:31 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 1e2ba4a74fa7 - Linux 5.2.16

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/174802

Please reply to this email if you have any questions about the tests that we
ran or if you have any suggestions on how to make future tests more effective.

        ,-.   ,-.
       ( C ) ( K )  Continuous
        `-',-.`-'   Kernel
          ( I )     Integration
           `-'
______________________________________________________________________________

Merge testing
-------------

We cloned this repository and checked out the following commit:

  Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: 1e2ba4a74fa7 - Linux 5.2.16


We grabbed the 1f6dc2bee06f commit of the stable queue repository.

We then merged the patchset with `git am`:

  usb-usbcore-fix-slab-out-of-bounds-bug-during-device-reset.patch
  media-tm6000-double-free-if-usb-disconnect-while-streaming.patch
  phy-renesas-rcar-gen3-usb2-disable-clearing-vbus-in-over-current.patch
  net-hns3-adjust-hns3_uninit_phy-s-location-in-the-hns3_client_uninit.patch
  netfilter-nf_flow_table-set-default-timeout-after-successful-insertion.patch
  hid-wacom-generic-read-hid_dg_contactmax-from-any-feature-report.patch
  input-elan_i2c-remove-lenovo-legion-y7000-pnpid.patch
  sunrpc-handle-connection-breakages-correctly-in-call_status.patch
  media-stm32-dcmi-fix-irq-0-case.patch
  nfs-disable-client-side-deduplication.patch
  powerpc-mm-radix-use-the-right-page-size-for-vmemmap-mapping.patch
  scripts-decode_stacktrace-match-basepath-using-shell-prefix-operator-not-regex.patch
  net-hns-fix-led-configuration-for-marvell-phy.patch
  net-aquantia-fix-limit-of-vlan-filters.patch
  ip6_gre-fix-a-dst-leak-in-ip6erspan_tunnel_xmit.patch
  net-sched-fix-race-between-deactivation-and-dequeue-for-nolock-qdisc.patch
  net_sched-let-qdisc_put-accept-null-pointer.patch
  udp-correct-reuseport-selection-with-connected-sockets.patch
  xen-netfront-do-not-assume-sk_buff_head-list-is-empty-in-error-handling.patch
  net-dsa-fix-load-order-between-dsa-drivers-and-taggers.patch
  kvm-coalesced_mmio-add-bounds-checking.patch
  firmware-google-check-if-size-is-valid-when-decoding-vpd-data.patch
  serial-sprd-correct-the-wrong-sequence-of-arguments.patch
  tty-serial-atmel-reschedule-tx-after-rx-was-started.patch

Compile testing
---------------

We compiled the kernel for 3 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:

    ⚡ Internal infrastructure issues prevented one or more tests (marked
    with ⚡⚡⚡) from running on this architecture.
    This is not the fault of the kernel that was tested.

  ppc64le:

    ⚡ Internal infrastructure issues prevented one or more tests (marked
    with ⚡⚡⚡) from running on this architecture.
    This is not the fault of the kernel that was tested.

  x86_64:

    ⚡ Internal infrastructure issues prevented one or more tests (marked
    with ⚡⚡⚡) from running on this architecture.
    This is not the fault of the kernel that was tested.

  Test sources: https://github.com/CKI-project/tests-beaker
    💚 Pull requests are welcome for new tests or improvements to existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
