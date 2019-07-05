Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52DC60789
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 16:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfGEOMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 10:12:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59352 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfGEOMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jul 2019 10:12:32 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 461E2308216C
        for <stable@vger.kernel.org>; Fri,  5 Jul 2019 14:12:32 +0000 (UTC)
Received: from [172.54.129.25] (cpt-1023.paas.prod.upshift.rdu2.redhat.com [10.0.19.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CFE59D912;
        Fri,  5 Jul 2019 14:12:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2M?= FAIL: Stable queue: queue-4.19
Message-ID: <cki.F5FF1F2506.C37ZD8PDAV@redhat.com>
X-Gitlab-Pipeline-ID: 21824
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 05 Jul 2019 14:12:32 +0000 (UTC)
Date:   Fri, 5 Jul 2019 10:12:32 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 1a0592436669 - Linux 4.19.57

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: FAILED




When we attempted to merge the patchset, we received an error:

  error: patch failed: arch/x86/kernel/ftrace.c:22
  error: arch/x86/kernel/ftrace.c: patch does not apply
  error: patch failed: kernel/trace/ftrace.c:35
  error: kernel/trace/ftrace.c: patch does not apply
  hint: Use 'git am --show-current-patch' to see the failed patch
  Applying: ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()
  Patch failed at 0001 ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()

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
  Commit: 1a0592436669 - Linux 4.19.57


We grabbed the a602ecdaf763 commit of the stable queue repository.

We then merged the patchset with `git am`:

  bluetooth-fix-faulty-expression-for-minimum-encryption-key-size-check.patch
  block-fix-a-null-pointer-dereference-in-generic_make_request.patch
  md-raid0-do-not-bypass-blocking-queue-entered-for-raid0-bios.patch
  netfilter-nf_flow_table-ignore-df-bit-setting.patch
  netfilter-nft_flow_offload-set-liberal-tracking-mode-for-tcp.patch
  netfilter-nft_flow_offload-don-t-offload-when-sequence-numbers-need-adjustment.patch
  netfilter-nft_flow_offload-ipcb-is-only-valid-for-ipv4-family.patch
  asoc-cs4265-readable-register-too-low.patch
  asoc-ak4458-add-return-value-for-ak4458_probe.patch
  asoc-soc-pcm-be-dai-needs-prepare-when-pause-release.patch
  asoc-ak4458-rstn_control-return-a-non-zero-on-error-.patch
  spi-bitbang-fix-null-pointer-dereference-in-spi_unre.patch
  drm-mediatek-fix-unbind-functions.patch
  drm-mediatek-unbind-components-in-mtk_drm_unbind.patch
  drm-mediatek-call-drm_atomic_helper_shutdown-when-un.patch
  drm-mediatek-clear-num_pipes-when-unbind-driver.patch
  drm-mediatek-call-mtk_dsi_stop-after-mtk_drm_crtc_at.patch
  asoc-max98090-remove-24-bit-format-support-if-rj-is-.patch
  asoc-sun4i-i2s-fix-sun8i-tx-channel-offset-mask.patch
  asoc-sun4i-i2s-add-offset-to-rx-channel-select.patch
  x86-cpu-add-more-icelake-model-numbers.patch
  usb-gadget-fusb300_udc-fix-memory-leak-of-fusb300-ep.patch
  usb-gadget-udc-lpc32xx-allocate-descriptor-with-gfp_.patch
  alsa-hdac-fix-memory-release-for-sst-and-sof-drivers.patch
  soc-rt274-fix-internal-jack-assignment-in-set_jack-c.patch
  scsi-hpsa-correct-ioaccel2-chaining.patch
  drm-panel-orientation-quirks-add-quirk-for-gpd-pocke.patch
  drm-panel-orientation-quirks-add-quirk-for-gpd-micro.patch
  platform-x86-asus-wmi-only-tell-ec-the-os-will-handl.patch
  platform-x86-intel-vbtn-report-switch-events-when-ev.patch
  platform-x86-mlx-platform-fix-parent-device-in-i2c-m.patch
  platform-mellanox-mlxreg-hotplug-add-devm_free_irq-c.patch
  i2c-pca-platform-fix-gpio-lookup-code.patch
  cpuset-restore-sanity-to-cpuset_cpus_allowed_fallbac.patch
  scripts-decode_stacktrace.sh-prefix-addr2line-with-c.patch
  mm-mlock.c-change-count_mm_mlocked_page_nr-return-ty.patch
  tracing-avoid-build-warning-with-have_nop_mcount.patch
  module-fix-livepatch-ftrace-module-text-permissions-.patch
  ftrace-fix-null-pointer-dereference-in-free_ftrace_f.patch
  drm-i915-dmc-protect-against-reading-random-memory.patch
  ptrace-fix-ptracer_cred-handling-for-ptrace_traceme.patch
  crypto-user-prevent-operating-on-larval-algorithms.patch
  crypto-cryptd-fix-skcipher-instance-memory-leak.patch
  alsa-seq-fix-incorrect-order-of-dest_client-dest_ports-arguments.patch
  alsa-firewire-lib-fireworks-fix-miss-detection-of-received-midi-messages.patch
  alsa-line6-fix-write-on-zero-sized-buffer.patch
  alsa-usb-audio-fix-sign-unintended-sign-extension-on-left-shifts.patch
  alsa-hda-realtek-add-quirks-for-several-clevo-notebook-barebones.patch
  alsa-hda-realtek-change-front-mic-location-for-lenovo-m710q.patch
  lib-mpi-fix-karactx-leak-in-mpi_powm.patch
  fs-userfaultfd.c-disable-irqs-for-fault_pending-and-event-locks.patch
  tracing-snapshot-resize-spare-buffer-if-size-changed.patch
  arm-dts-armada-xp-98dx3236-switch-to-armada-38x-uart-serial-node.patch
  arm64-kaslr-keep-modules-inside-module-region-when-kasan-is-enabled.patch
  drm-amd-powerplay-use-hardware-fan-control-if-no-powerplay-fan-table.patch
  drm-amdgpu-gfx9-use-reset-default-for-pa_sc_fifo_size.patch
  drm-etnaviv-add-missing-failure-path-to-destroy-suballoc.patch
  drm-imx-notify-drm-core-before-sending-event-during-crtc-disable.patch
  drm-imx-only-send-event-on-crtc-disable-if-kept-disabled.patch
  ftrace-x86-remove-possible-deadlock-between-register_kprobe-and-ftrace_run_update_code.patch
  mm-vmscan.c-prevent-useless-kswapd-loops.patch
  btrfs-ensure-replaced-device-doesn-t-have-pending-chunk-allocation.patch
  tty-rocket-fix-incorrect-forward-declaration-of-rp_i.patch
  ftrace-x86-remove-possible-deadlock-between-register.patch
