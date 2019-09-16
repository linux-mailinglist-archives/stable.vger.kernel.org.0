Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19BCFB3439
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 06:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfIPEwc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 16 Sep 2019 00:52:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbfIPEwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 00:52:32 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CCE833B738
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 04:52:31 +0000 (UTC)
Received: from [172.54.70.177] (cpt-1030.paas.prod.upshift.rdu2.redhat.com [10.0.19.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FDA6608C2;
        Mon, 16 Sep 2019 04:52:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.2
Message-ID: <cki.61601B30BD.2A0SX1HYNJ@redhat.com>
X-Gitlab-Pipeline-ID: 166424
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/166424
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 16 Sep 2019 04:52:31 +0000 (UTC)
Date:   Mon, 16 Sep 2019 00:52:32 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 997fee5473ce - Linux 5.2.14

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here:

  https://artifacts.cki-project.org/pipelines/166424

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
  Commit: 997fee5473ce - Linux 5.2.14


We grabbed the 652de59d50b1 commit of the stable queue repository.

We then merged the patchset with `git am`:

  gpio-pca953x-correct-type-of-reg_direction.patch
  gpio-pca953x-use-pca953x_read_regs-instead-of-regmap_bulk_read.patch
  alsa-hda-fix-potential-endless-loop-at-applying-quirks.patch
  alsa-hda-realtek-fix-overridden-device-specific-initialization.patch
  alsa-hda-realtek-add-quirk-for-hp-pavilion-15.patch
  alsa-hda-realtek-enable-internal-speaker-headset-mic-of-asus-ux431fl.patch
  alsa-hda-realtek-fix-the-problem-of-two-front-mics-on-a-thinkcentre.patch
  sched-fair-don-t-assign-runtime-for-throttled-cfs_rq.patch
  drm-vmwgfx-fix-double-free-in-vmw_recv_msg.patch
  drm-nouveau-sec2-gp102-add-missing-module_firmwares.patch
  vhost-test-fix-build-for-vhost-test.patch
  vhost-test-fix-build-for-vhost-test-again.patch
  powerpc-64e-drop-stale-call-to-smp_processor_id-which-hangs-smp-startup.patch
  powerpc-tm-fix-fp-vmx-unavailable-exceptions-inside-a-transaction.patch
  powerpc-tm-fix-restoring-fp-vmx-facility-incorrectly-on-interrupts.patch
  batman-adv-fix-uninit-value-in-batadv_netlink_get_ifindex.patch
  batman-adv-only-read-ogm-tvlv_len-after-buffer-len-check.patch
  bcache-only-clear-btree_node_dirty-bit-when-it-is-se.patch
  bcache-add-comments-for-mutex_lock-b-write_lock.patch
  bcache-fix-race-in-btree_flush_write.patch
  ib-rdmavt-add-new-completion-inline.patch
  ib-rdmavt-qib-hfi1-convert-to-new-completion-api.patch
  ib-hfi1-unreserve-a-flushed-opfn-request.patch
  drm-i915-disable-sampler_state-prefetching-on-all-ge.patch
  drm-i915-make-sure-cdclk-is-high-enough-for-dp-audio.patch
  mmc-sdhci-sprd-fix-the-incorrect-soft-reset-operatio.patch
  usb-chipidea-imx-add-imx7ulp-support.patch
  usb-chipidea-imx-fix-eprobe_defer-support-during-dri.patch
  virtio-s390-fix-race-on-airq_areas.patch
  drm-i915-support-flags-in-whitlist-was.patch
  drm-i915-support-whitelist-workarounds-on-all-engine.patch
  drm-i915-whitelist-ps_-depth-invocation-_count.patch
  drm-i915-add-whitelist-workarounds-for-icl.patch
  drm-i915-icl-whitelist-ps_-depth-invocation-_count.patch
  btrfs-fix-unwritten-extent-buffers-and-hangs-on-future-writeback-attempts.patch
  vhost-make-sure-log_num-in_num.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    s390x:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:
      Host 1:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [1]
         ✅ storage: software RAID testing [2]

      Host 2:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [3]
         ✅ Podman system integration test (as user) [3]
         ⚡⚡⚡ Loopdev Sanity [4]
         ✅ jvm test suite [5]
         ✅ AMTU (Abstract Machine Test Utility) [6]
         ✅ LTP: openposix test suite [7]
         ✅ Networking socket: fuzz [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ Usex - version 1.9-29 [13]
         ✅ stress: stress-ng [14]
         🚧 ✅ LTP lite [15]
         🚧 ✅ ALSA PCM loopback test [16]
         🚧 ✅ ALSA Control (mixer) Userspace Element test [17]

  ppc64le:
      Host 1:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [1]
         ✅ storage: software RAID testing [2]

      Host 2:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [3]
         ✅ Podman system integration test (as user) [3]
         ⚡⚡⚡ Loopdev Sanity [4]
         ✅ jvm test suite [5]
         ✅ AMTU (Abstract Machine Test Utility) [6]
         ✅ LTP: openposix test suite [7]
         ✅ Networking socket: fuzz [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ Usex - version 1.9-29 [13]
         🚧 ✅ LTP lite [15]
         🚧 ✅ ALSA PCM loopback test [16]
         🚧 ✅ ALSA Control (mixer) Userspace Element test [17]

  s390x:

    ⚡ Internal infrastructure issues prevented one or more tests (marked
    with ⚡⚡⚡) from running on this architecture.
    This is not the fault of the kernel that was tested.

  x86_64:
      Host 1:
         ✅ Boot test [0]
         ✅ selinux-policy: serge-testsuite [1]
         ✅ storage: software RAID testing [2]

      Host 2:

         ⚡ Internal infrastructure issues prevented one or more tests (marked
         with ⚡⚡⚡) from running on this architecture.
         This is not the fault of the kernel that was tested.

         ✅ Boot test [0]
         ✅ Podman system integration test (as root) [3]
         ✅ Podman system integration test (as user) [3]
         ⚡⚡⚡ Loopdev Sanity [4]
         ✅ jvm test suite [5]
         ✅ AMTU (Abstract Machine Test Utility) [6]
         ✅ LTP: openposix test suite [7]
         ✅ Networking socket: fuzz [8]
         ✅ audit: audit testsuite test [9]
         ✅ httpd: mod_ssl smoke sanity [10]
         ✅ iotop: sanity [11]
         ✅ tuned: tune-processes-through-perf [12]
         ✅ pciutils: sanity smoke test [18]
         ✅ Usex - version 1.9-29 [13]
         ✅ stress: stress-ng [14]
         🚧 ✅ LTP lite [15]
         🚧 ✅ ALSA PCM loopback test [16]
         🚧 ✅ ALSA Control (mixer) Userspace Element test [17]

  Test source:
    💚 Pull requests are welcome for new tests or improvements to existing tests!
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp-upstream/lite
    [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/sound/aloop
    [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/sound/user-ctl-elem
    [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke

Waived tests
------------
If the test run included waived tests, they are marked with 🚧. Such tests are
executed but their results are not taken into account. Tests are waived when
their results are not reliable enough, e.g. when they're just introduced or are
being fixed.
