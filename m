Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910DA3B0E9
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 10:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388300AbfFJImj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 10 Jun 2019 04:42:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50132 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388267AbfFJImi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 04:42:38 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5DDF2821D1
        for <stable@vger.kernel.org>; Mon, 10 Jun 2019 08:42:38 +0000 (UTC)
Received: from [172.54.141.148] (cpt-large-cpu-05.paas.prod.upshift.rdu2.redhat.com [10.0.18.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2F8A60BF1;
        Mon, 10 Jun 2019 08:42:35 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.1A3297B9BE.42YYZUEZUN@redhat.com>
X-Gitlab-Pipeline-ID: 11879
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11879?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 10 Jun 2019 08:42:38 +0000 (UTC)
Date:   Mon, 10 Jun 2019 04:42:38 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: bb7b450e61a1 - Linux 4.19.49

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

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
  Commit: bb7b450e61a1 - Linux 4.19.49


We then merged the patchset with `git am`:

  ethtool-fix-potential-userspace-buffer-overflow.patch
  fix-memory-leak-in-sctp_process_init.patch
  ipv4-not-do-cache-for-local-delivery-if-bc_forwarding-is-enabled.patch
  ipv6-fix-the-check-before-getting-the-cookie-in-rt6_get_cookie.patch
  neighbor-call-__ipv4_neigh_lookup_noref-in-neigh_xmit.patch
  net-ethernet-ti-cpsw_ethtool-fix-ethtool-ring-param-set.patch
  net-mlx4_en-ethtool-remove-unsupported-sfp-eeprom-high-pages-query.patch
  net-mvpp2-use-strscpy-to-handle-stat-strings.patch
  net-rds-fix-memory-leak-in-rds_ib_flush_mr_pool.patch
  net-sfp-read-eeprom-in-maximum-16-byte-increments.patch
  net-tls-replace-the-sleeping-lock-around-rx-resync-with-a-bit-lock.patch
  packet-unconditionally-free-po-rollover.patch
  pktgen-do-not-sleep-with-the-thread-lock-held.patch
  revert-fib_rules-return-0-directly-if-an-exactly-same-rule-exists-when-nlm_f_excl-not-supplied.patch
  ipv6-use-read_once-for-inet-hdrincl-as-in-ipv4.patch
  ipv6-fix-efault-on-sendto-with-icmpv6-and-hdrincl.patch
  mtd-spinand-macronix-fix-ecc-status-read.patch
  rcu-locking-and-unlocking-need-to-always-be-at-least-barriers.patch
  parisc-use-implicit-space-register-selection-for-loading-the-coherence-index-of-i-o-pdirs.patch
  nfsv4.1-again-fix-a-race-where-cb_notify_lock-fails-to-wake-a-waiter.patch
  nfsv4.1-fix-bug-only-first-cb_notify_lock-is-handled.patch
  fuse-fallocate-fix-return-with-locked-inode.patch
  pstore-remove-needless-lock-during-console-writes.patch
  pstore-convert-buf_lock-to-semaphore.patch
  pstore-set-tfm-to-null-on-free_buf_for_compression.patch
  pstore-ram-run-without-kernel-crash-dump-region.patch
  x86-power-fix-nosmt-vs-hibernation-triple-fault-during-resume.patch
  x86-insn-eval-fix-use-after-free-access-to-ldt-entry.patch
  i2c-xiic-add-max_read_len-quirk.patch
  s390-mm-fix-address-space-detection-in-exception-handling.patch
  xen-blkfront-switch-kcalloc-to-kvcalloc-for-large-array-allocation.patch
  mips-bounds-check-virt_addr_valid.patch
  mips-pistachio-build-uimage.gz-by-default.patch
  revert-mips-perf-ath79-fix-perfcount-irq-assignment.patch
  genwqe-prevent-an-integer-overflow-in-the-ioctl.patch
  test_firmware-use-correct-snprintf-limit.patch
  drm-gma500-cdv-check-vbt-config-bits-when-detecting-lvds-panels.patch
  drm-msm-fix-fb-references-in-async-update.patch
  drm-add-non-desktop-quirk-for-valve-hmds.patch
  drm-nouveau-add-kconfig-option-to-turn-off-nouveau-legacy-contexts.-v3.patch
  drm-add-non-desktop-quirks-to-sensics-and-osvr-headsets.patch
  drm-amdgpu-psp-move-psp-version-specific-function-pointers-to-early_init.patch
  drm-radeon-prefer-lower-reference-dividers.patch
  drm-amdgpu-remove-atpx_dgpu_req_power_for_displays-check-when-hotplug-in.patch
  drm-i915-fix-i915_exec_ring_mask.patch
  drm-amdgpu-soc15-skip-reset-on-init.patch
  drm-i915-fbc-disable-framebuffer-compression-on-geminilake.patch
  drm-i915-maintain-consistent-documentation-subsection-ordering.patch
  drm-don-t-block-fb-changes-for-async-plane-updates.patch
  drm-i915-gvt-initialize-intel_gvt_gtt_entry-in-stack.patch
  tty-serial_core-add-install.patch
  ipv4-define-__ipv4_neigh_lookup_noref-when-config_inet-is-disabled.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-3821cc6fc6286fbe8ff0111fb3b15821f1446588.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-3821cc6fc6286fbe8ff0111fb3b15821f1446588.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-3821cc6fc6286fbe8ff0111fb3b15821f1446588.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-3821cc6fc6286fbe8ff0111fb3b15821f1446588.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-3821cc6fc6286fbe8ff0111fb3b15821f1446588.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-3821cc6fc6286fbe8ff0111fb3b15821f1446588.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-3821cc6fc6286fbe8ff0111fb3b15821f1446588.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-3821cc6fc6286fbe8ff0111fb3b15821f1446588.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Loopdev Sanity [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ tuned: tune-processes-through-perf [9]
       ✅ Usex - version 1.9-29 [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ Networking sctp-auth: sockopts test [12]
       🚧 ✅ Networking route: pmtu [13]
       🚧 ✅ Networking route_func: local [14]
       🚧 ✅ Networking route_func: forward [14]


  ppc64le:
    Host 1:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]

    Host 2:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Loopdev Sanity [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ tuned: tune-processes-through-perf [9]
       ✅ Usex - version 1.9-29 [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ Networking sctp-auth: sockopts test [12]
       🚧 ✅ Networking route: pmtu [13]
       🚧 ✅ Networking route_func: local [14]
       🚧 ✅ Networking route_func: forward [14]


  s390x:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Loopdev Sanity [3]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ tuned: tune-processes-through-perf [9]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ Networking sctp-auth: sockopts test [12]
       🚧 ✅ Networking route: pmtu [13]
       🚧 ✅ Networking route_func: local [14]
       🚧 ✅ Networking route_func: forward [14]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]


  x86_64:
    Host 1:
       ✅ Boot test [0]
       ✅ LTP lite [2]
       ✅ Loopdev Sanity [3]
       ✅ AMTU (Abstract Machine Test Utility) [4]
       ✅ Ethernet drivers sanity [5]
       ✅ audit: audit testsuite test [6]
       ✅ httpd: mod_ssl smoke sanity [7]
       ✅ iotop: sanity [8]
       ✅ tuned: tune-processes-through-perf [9]
       ✅ Usex - version 1.9-29 [10]
       🚧 ✅ Networking socket: fuzz [11]
       🚧 ✅ Networking sctp-auth: sockopts test [12]
       🚧 ✅ Networking route: pmtu [13]
       🚧 ✅ Networking route_func: local [14]
       🚧 ✅ Networking route_func: forward [14]

    Host 2:
       ✅ Boot test [0]
       ✅ selinux-policy: serge-testsuite [1]


  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/pmtu
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/route/route_func

Waived tests (marked with 🚧)
-----------------------------
This test run included waived tests. Such tests are executed but their results
are not taken into account. Tests are waived when their results are not
reliable enough, e.g. when they're just introduced or are being fixed.
