Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0CB3466E
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfFDMVT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 4 Jun 2019 08:21:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726994AbfFDMVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 08:21:18 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EBD24A3EB5
        for <stable@vger.kernel.org>; Tue,  4 Jun 2019 12:21:17 +0000 (UTC)
Received: from [172.54.208.215] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32C7F1017E39;
        Tue,  4 Jun 2019 12:21:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.80C57F7E0C.TF5XUFAPTS@redhat.com>
X-Gitlab-Pipeline-ID: 11474
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11474?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 04 Jun 2019 12:21:17 +0000 (UTC)
Date:   Tue, 4 Jun 2019 08:21:18 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: e109a984cf38 - Linux 4.19.48

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK


We hope that these logs can help you find the problem quickly. For the full
detail on our testing procedures, please scroll to the bottom of this message.

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

  Repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: e109a984cf38 - Linux 4.19.48


We then merged the patchset with `git am`:

  sparc64-fix-regression-in-non-hypervisor-tlb-flush-xcall.patch
  include-linux-bitops.h-sanitize-rotate-primitives.patch
  xhci-update-bounce-buffer-with-correct-sg-num.patch
  xhci-use-zu-for-printing-size_t-type.patch
  xhci-convert-xhci_handshake-to-use-readl_poll_timeout_atomic.patch
  usb-xhci-avoid-null-pointer-deref-when-bos-field-is-null.patch
  usbip-usbip_host-fix-bug-sleeping-function-called-from-invalid-context.patch
  usbip-usbip_host-fix-stub_dev-lock-context-imbalance-regression.patch
  usb-fix-slab-out-of-bounds-write-in-usb_get_bos_descriptor.patch
  usb-sisusbvga-fix-oops-in-error-path-of-sisusb_probe.patch
  usb-add-lpm-quirk-for-surface-dock-gige-adapter.patch
  usb-rio500-refuse-more-than-one-device-at-a-time.patch
  usb-rio500-fix-memory-leak-in-close-after-disconnect.patch
  media-usb-siano-fix-general-protection-fault-in-smsusb.patch
  media-usb-siano-fix-false-positive-uninitialized-variable-warning.patch
  media-smsusb-better-handle-optional-alignment.patch
  brcmfmac-fix-null-pointer-derefence-during-usb-disconnect.patch
  scsi-zfcp-fix-missing-zfcp_port-reference-put-on-ebusy-from-port_remove.patch
  scsi-zfcp-fix-to-prevent-port_remove-with-pure-auto-scan-luns-only-sdevs.patch
  tracing-avoid-memory-leak-in-predicate_parse.patch
  btrfs-fix-wrong-ctime-and-mtime-of-a-directory-after-log-replay.patch
  btrfs-fix-race-updating-log-root-item-during-fsync.patch
  btrfs-fix-fsync-not-persisting-changed-attributes-of-a-directory.patch
  btrfs-incremental-send-fix-file-corruption-when-no-holes-feature-is-enabled.patch
  iio-dac-ds4422-ds4424-fix-chip-verification.patch
  iio-adc-ti-ads8688-fix-timestamp-is-not-updated-in-buffer.patch
  s390-crypto-fix-gcm-aes-s390-selftest-failures.patch
  s390-crypto-fix-possible-sleep-during-spinlock-aquired.patch
  kvm-ppc-book3s-hv-xive-do-not-clear-irq-data-of-passthrough-interrupts.patch
  powerpc-perf-fix-mmcra-corruption-by-bhrb_filter.patch
  alsa-line6-assure-canceling-delayed-work-at-disconnection.patch
  alsa-hda-realtek-set-default-power-save-node-to-0.patch
  alsa-hda-realtek-improve-the-headset-mic-for-acer-aspire-laptops.patch
  kvm-s390-do-not-report-unusabled-ids-via-kvm_cap_max_vcpu_id.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-024938ed400abc12b05e139d5282530207c65503.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-024938ed400abc12b05e139d5282530207c65503.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-024938ed400abc12b05e139d5282530207c65503.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-024938ed400abc12b05e139d5282530207c65503.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-024938ed400abc12b05e139d5282530207c65503.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-024938ed400abc12b05e139d5282530207c65503.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-024938ed400abc12b05e139d5282530207c65503.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-024938ed400abc12b05e139d5282530207c65503.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:

    ⚡ Internal infrastructure issues prevented one or more tests from running
    on this architecture. This is not the fault of the kernel that was tested.

  ppc64le:

    ⚡ Internal infrastructure issues prevented one or more tests from running
    on this architecture. This is not the fault of the kernel that was tested.

  s390x:

    ⚡ Internal infrastructure issues prevented one or more tests from running
    on this architecture. This is not the fault of the kernel that was tested.

  x86_64:

    ⚡ Internal infrastructure issues prevented one or more tests from running
    on this architecture. This is not the fault of the kernel that was tested.

  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!

