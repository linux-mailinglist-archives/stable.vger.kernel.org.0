Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7105721A1C
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 16:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbfEQO4f convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 17 May 2019 10:56:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13665 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728396AbfEQO4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 10:56:35 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1475C30842B0
        for <stable@vger.kernel.org>; Fri, 17 May 2019 14:56:35 +0000 (UTC)
Received: from [172.54.252.111] (cpt-0020.paas.prod.upshift.rdu2.redhat.com [10.0.18.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AE097E57E;
        Fri, 17 May 2019 14:56:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Stable queue: queue-5.1
Message-ID: <cki.0DFA48C38B.A7FUXQ4QCE@redhat.com>
X-Gitlab-Pipeline-ID: 10293
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/10293?=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 17 May 2019 14:56:35 +0000 (UTC)
Date:   Fri, 17 May 2019 10:56:35 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 7cb9c5d341b9 - Linux 5.1.3

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: OK
           Compile: OK
             Tests: FAILED


One or more kernel tests failed:

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
  Commit: 7cb9c5d341b9 - Linux 5.1.3

We then merged the patchset with `git am`:

  locking-rwsem-prevent-decrement-of-reader-count-befo.patch
  x86-speculation-mds-revert-cpu-buffer-clear-on-double-fault-exit.patch
  x86-speculation-mds-improve-cpu-buffer-clear-documentation.patch
  objtool-fix-function-fallthrough-detection.patch
  arm64-dts-rockchip-fix-io-domain-voltage-setting-of-apio5-on-rockpro64.patch
  arm64-dts-rockchip-disable-dcmds-on-rk3399-s-emmc-controller.patch
  arm-dts-qcom-ipq4019-enlarge-pcie-bar-range.patch
  arm-dts-exynos-fix-interrupt-for-shared-eints-on-exynos5260.patch
  arm-dts-exynos-fix-audio-routing-on-odroid-xu3.patch
  arm-dts-exynos-fix-audio-microphone-routing-on-odroid-xu3.patch
  mmc-sdhci-of-arasan-add-dts-property-to-disable-dcmds.patch
  arm-exynos-fix-a-leaked-reference-by-adding-missing-of_node_put.patch
  power-supply-axp288_charger-fix-unchecked-return-value.patch
  power-supply-axp288_fuel_gauge-add-acepc-t8-and-t11-mini-pcs-to-the-blacklist.patch
  arm64-mmap-ensure-file-offset-is-treated-as-unsigned.patch
  arm64-arch_timer-ensure-counter-register-reads-occur-with-seqlock-held.patch
  arm64-compat-reduce-address-limit.patch
  arm64-clear-osdlr_el1-on-cpu-boot.patch
  arm64-save-and-restore-osdlr_el1-across-suspend-resume.patch
  sched-x86-save-flags-on-context-switch.patch
  x86-mce-add-an-mce-record-filtering-function.patch
  x86-mce-amd-don-t-report-l1-btb-mca-errors-on-some-family-17h-models.patch
  crypto-crypto4xx-fix-ctr-aes-missing-output-iv.patch
  crypto-crypto4xx-fix-cfb-and-ofb-overran-dst-buffer-issues.patch
  crypto-salsa20-don-t-access-already-freed-walk.iv.patch
  crypto-lrw-don-t-access-already-freed-walk.iv.patch
  crypto-chacha-generic-fix-use-as-arm64-no-neon-fallback.patch
  crypto-chacha20poly1305-set-cra_name-correctly.patch
  crypto-ccm-fix-incompatibility-between-ccm-and-ccm_base.patch
  crypto-ccp-do-not-free-psp_master-when-platform_init-fails.patch
  crypto-vmx-fix-copy-paste-error-in-ctr-mode.patch
  crypto-skcipher-don-t-warn-on-unprocessed-data-after-slow-walk-step.patch
  crypto-crct10dif-generic-fix-use-via-crypto_shash_digest.patch
  crypto-x86-crct10dif-pcl-fix-use-via-crypto_shash_digest.patch
  crypto-arm64-gcm-aes-ce-fix-no-neon-fallback-code.patch
  crypto-gcm-fix-incompatibility-between-gcm-and-gcm_base.patch
  crypto-rockchip-update-iv-buffer-to-contain-the-next-iv.patch
  crypto-caam-qi2-fix-zero-length-buffer-dma-mapping.patch
  crypto-caam-qi2-fix-dma-mapping-of-stack-memory.patch
  crypto-caam-qi2-generate-hash-keys-in-place.patch
  crypto-arm-aes-neonbs-don-t-access-already-freed-walk.iv.patch
  crypto-arm64-aes-neonbs-don-t-access-already-freed-walk.iv.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-b8c64e03eec95531f980141caf95b99550be3585.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_5.1-aarch64-b8c64e03eec95531f980141caf95b99550be3585.tar.gz

  ppc64le:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-b8c64e03eec95531f980141caf95b99550be3585.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_5.1-ppc64le-b8c64e03eec95531f980141caf95b99550be3585.tar.gz

  s390x:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-b8c64e03eec95531f980141caf95b99550be3585.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_5.1-s390x-b8c64e03eec95531f980141caf95b99550be3585.tar.gz

  x86_64:
    build options: -j25 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-b8c64e03eec95531f980141caf95b99550be3585.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_5.1-x86_64-b8c64e03eec95531f980141caf95b99550be3585.tar.gz


Hardware testing
----------------

We booted each kernel and ran the following tests:

  aarch64:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ audit: audit testsuite test [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Usex - version 1.9-29 [7]
     ✅ stress: stress-ng [8]
     ✅ Boot test [0]
     ✅ selinux-policy: serge-testsuite [9]

  ppc64le:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ audit: audit testsuite test [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Usex - version 1.9-29 [7]
     ✅ stress: stress-ng [8]
     ✅ Boot test [0]
     ✅ selinux-policy: serge-testsuite [9]

  s390x:
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ audit: audit testsuite test [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Usex - version 1.9-29 [7]
     ✅ stress: stress-ng [8]
     ✅ Boot test [0]
     ✅ selinux-policy: serge-testsuite [9]

  x86_64:
     ✅ Boot test [0]
     ✅ selinux-policy: serge-testsuite [9]
     ✅ Boot test [0]
     ✅ LTP lite [1]
     ✅ AMTU (Abstract Machine Test Utility) [2]
     ✅ audit: audit testsuite test [3]
     ✅ httpd: mod_ssl smoke sanity [4]
     ✅ iotop: sanity [5]
     ✅ tuned: tune-processes-through-perf [6]
     ✅ Usex - version 1.9-29 [7]
     ✅ stress: stress-ng [8]

  Test source:
    [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
    [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
    [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
    [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
    [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
    [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
    [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
    [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
    [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
    [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite

