Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3710318C7
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 02:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfFAAXM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 31 May 2019 20:23:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbfFAAXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 20:23:11 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64F9C3001C61
        for <stable@vger.kernel.org>; Sat,  1 Jun 2019 00:23:11 +0000 (UTC)
Received: from [172.54.208.215] (cpt-0038.paas.prod.upshift.rdu2.redhat.com [10.0.18.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15EB41001E86;
        Sat,  1 Jun 2019 00:23:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-4.19
Message-ID: <cki.C03FA26746.5ZGHJTQAHM@redhat.com>
X-Gitlab-Pipeline-ID: 11267
X-Gitlab-Pipeline: =?utf-8?q?https=3A//xci32=2Elab=2Eeng=2Erdu2=2Eredhat=2Ec?=
 =?utf-8?q?om/cki-project/cki-pipeline/pipelines/11267?=
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Sat, 01 Jun 2019 00:23:11 +0000 (UTC)
Date:   Fri, 31 May 2019 20:23:11 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 0df021b2e841 - Linux 4.19.47

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
  Commit: 0df021b2e841 - Linux 4.19.47


We then merged the patchset with `git am`:

  bonding-802.3ad-fix-slave-link-initialization-transition-states.patch
  cxgb4-offload-vlan-flows-regardless-of-vlan-ethtype.patch
  inet-switch-ip-id-generator-to-siphash.patch
  ipv4-igmp-fix-another-memory-leak-in-igmpv3_del_delrec.patch
  ipv4-igmp-fix-build-error-if-config_ip_multicast.patch
  ipv6-consider-sk_bound_dev_if-when-binding-a-raw-socket-to-an-address.patch
  ipv6-fix-redirect-with-vrf.patch
  llc-fix-skb-leak-in-llc_build_and_send_ui_pkt.patch
  net-dsa-mv88e6xxx-fix-handling-of-upper-half-of-stats_type_port.patch
  net-fec-fix-the-clk-mismatch-in-failed_reset-path.patch
  net-gro-fix-use-after-free-read-in-napi_gro_frags.patch
  net-mvneta-fix-err-code-path-of-probe.patch
  net-mvpp2-fix-bad-mvpp2_txq_sched_token_cntr_reg-queue-value.patch
  net-phy-marvell10g-report-if-the-phy-fails-to-boot-firmware.patch
  net-sched-don-t-use-tc_action-order-during-action-dump.patch
  net-stmmac-fix-reset-gpio-free-missing.patch
  usbnet-fix-kernel-crash-after-disconnect.patch
  net-mlx5-avoid-double-free-in-fs-init-error-unwinding-path.patch
  tipc-avoid-copying-bytes-beyond-the-supplied-data.patch
  net-mlx5-allocate-root-ns-memory-using-kzalloc-to-match-kfree.patch
  net-mlx5e-disable-rxhash-when-cqe-compress-is-enabled.patch
  net-stmmac-dma-channel-control-register-need-to-be-init-first.patch
  bnxt_en-fix-aggregation-buffer-leak-under-oom-condition.patch
  net-tls-avoid-null-deref-on-resync-during-device-removal.patch
  net-tls-fix-state-removal-with-feature-flags-off.patch
  net-tls-don-t-ignore-netdev-notifications-if-no-tls-features.patch

Compile testing
---------------

We compiled the kernel for 4 architectures:

  aarch64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-44c69b5e1b79ffcbba06619ba69b032d7827bda1.config
    kernel build: https://artifacts.cki-project.org/builds/aarch64/kernel-stable_queue_4.19-aarch64-44c69b5e1b79ffcbba06619ba69b032d7827bda1.tar.gz

  ppc64le:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-44c69b5e1b79ffcbba06619ba69b032d7827bda1.config
    kernel build: https://artifacts.cki-project.org/builds/ppc64le/kernel-stable_queue_4.19-ppc64le-44c69b5e1b79ffcbba06619ba69b032d7827bda1.tar.gz

  s390x:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-44c69b5e1b79ffcbba06619ba69b032d7827bda1.config
    kernel build: https://artifacts.cki-project.org/builds/s390x/kernel-stable_queue_4.19-s390x-44c69b5e1b79ffcbba06619ba69b032d7827bda1.tar.gz

  x86_64:
    build options: -j20 INSTALL_MOD_STRIP=1 targz-pkg
    configuration: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-44c69b5e1b79ffcbba06619ba69b032d7827bda1.config
    kernel build: https://artifacts.cki-project.org/builds/x86_64/kernel-stable_queue_4.19-x86_64-44c69b5e1b79ffcbba06619ba69b032d7827bda1.tar.gz


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

