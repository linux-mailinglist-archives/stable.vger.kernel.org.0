Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6D19A569
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 04:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388583AbfHWCTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 22:19:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfHWCTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 22:19:19 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E73A930A5A61
        for <stable@vger.kernel.org>; Fri, 23 Aug 2019 02:19:18 +0000 (UTC)
Received: from localhost (dhcp-12-130.nay.redhat.com [10.66.12.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 064D41001B17;
        Fri, 23 Aug 2019 02:19:11 +0000 (UTC)
Date:   Fri, 23 Aug 2019 10:19:10 +0800
From:   Murphy Zhou <xzhou@redhat.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>
Subject: Re: ? FAIL: Stable queue: queue-5.2
Message-ID: <20190823021910.4msjdyxpvftcql4t@XZHOUW.usersys.redhat.com>
References: <cki.A52B1C532D.YEFB2VN58T@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cki.A52B1C532D.YEFB2VN58T@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 23 Aug 2019 02:19:18 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 22, 2019 at 06:48:49PM -0400, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: aad39e30fb9e - Linux 5.2.9
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
> 
> All kernel binaries, config files, and logs are available for download here:
> 
>   https://artifacts.cki-project.org/pipelines/116984
> 
> 
> 
> One or more kernel tests failed:
> 
>   aarch64:
>     ❌ LTP lite
>     ❌ Loopdev Sanity

I guess we need to include logs of testcases in the report.

Thanks,
Xiong

> 
> We hope that these logs can help you find the problem quickly. For the full
> detail on our testing procedures, please scroll to the bottom of this message.
> 
> Please reply to this email if you have any questions about the tests that we
> ran or if you have any suggestions on how to make future tests more effective.
> 
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> ______________________________________________________________________________
> 
> Merge testing
> -------------
> 
> We cloned this repository and checked out the following commit:
> 
>   Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>   Commit: aad39e30fb9e - Linux 5.2.9
> 
> 
> We grabbed the 8a2474fee8e4 commit of the stable queue repository.
> 
> We then merged the patchset with `git am`:
> 
>   keys-trusted-allow-module-init-if-tpm-is-inactive-or-deactivated.patch
>   sh-kernel-hw_breakpoint-fix-missing-break-in-switch-statement.patch
>   seq_file-fix-problem-when-seeking-mid-record.patch
>   mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch
>   mm-mempolicy-make-the-behavior-consistent-when-mpol_mf_move-and-mpol_mf_strict-were-specified.patch
>   mm-mempolicy-handle-vma-with-unmovable-pages-mapped-correctly-in-mbind.patch
>   mm-z3fold.c-fix-z3fold_destroy_pool-ordering.patch
>   mm-z3fold.c-fix-z3fold_destroy_pool-race-condition.patch
>   mm-memcontrol.c-fix-use-after-free-in-mem_cgroup_iter.patch
>   mm-usercopy-use-memory-range-to-be-accessed-for-wraparound-check.patch
>   mm-vmscan-do-not-special-case-slab-reclaim-when-watermarks-are-boosted.patch
>   cpufreq-schedutil-don-t-skip-freq-update-when-limits-change.patch
>   drm-amdgpu-fix-gfx9-soft-recovery.patch
>   drm-nouveau-only-recalculate-pbn-vcpi-on-mode-connector-changes.patch
>   xtensa-add-missing-isync-to-the-cpu_reset-tlb-code.patch
>   arm64-ftrace-ensure-module-ftrace-trampoline-is-coherent-with-i-side.patch
>   alsa-hda-realtek-add-quirk-for-hp-envy-x360.patch
>   alsa-usb-audio-fix-a-stack-buffer-overflow-bug-in-check_input_term.patch
>   alsa-usb-audio-fix-an-oob-bug-in-parse_audio_mixer_unit.patch
>   alsa-hda-apply-workaround-for-another-amd-chip-1022-1487.patch
>   alsa-hda-fix-a-memory-leak-bug.patch
>   alsa-hda-add-a-generic-reboot_notify.patch
>   alsa-hda-let-all-conexant-codec-enter-d3-when-rebooting.patch
>   hid-holtek-test-for-sanity-of-intfdata.patch
>   hid-hiddev-avoid-opening-a-disconnected-device.patch
>   hid-hiddev-do-cleanup-in-failure-of-opening-a-device.patch
>   input-kbtab-sanity-check-for-endpoint-type.patch
>   input-iforce-add-sanity-checks.patch
>   net-usb-pegasus-fix-improper-read-if-get_registers-fail.patch
>   bpf-fix-access-to-skb_shared_info-gso_segs.patch
>   netfilter-ebtables-also-count-base-chain-policies.patch
>   riscv-correct-the-initialized-flow-of-fp-register.patch
>   riscv-make-__fstate_clean-work-correctly.patch
>   revert-i2c-imx-improve-the-error-handling-in-i2c_imx_dma_request.patch
>   blk-mq-move-cancel-of-requeue_work-to-the-front-of-blk_exit_queue.patch
>   io_uring-fix-manual-setup-of-iov_iter-for-fixed-buffers.patch
>   rdma-hns-fix-sg-offset-non-zero-issue.patch
>   ib-mlx5-replace-kfree-with-kvfree.patch
>   clk-at91-generated-truncate-divisor-to-generated_max.patch
>   clk-sprd-select-regmap_mmio-to-avoid-compile-errors.patch
>   clk-renesas-cpg-mssr-fix-reset-control-race-conditio.patch
>   dma-mapping-check-pfn-validity-in-dma_common_-mmap-g.patch
>   platform-x86-pcengines-apuv2-fix-softdep-statement.patch
>   platform-x86-intel_pmc_core-add-icl-nnpi-support-to-.patch
>   mm-hmm-always-return-ebusy-for-invalid-ranges-in-hmm.patch
>   xen-pciback-remove-set-but-not-used-variable-old_sta.patch
>   irqchip-gic-v3-its-free-unused-vpt_page-when-alloc-v.patch
>   irqchip-irq-imx-gpcv2-forward-irq-type-to-parent.patch
>   f2fs-fix-to-read-source-block-before-invalidating-it.patch
>   tools-perf-beauty-fix-usbdevfs_ioctl-table-generator.patch
>   perf-header-fix-divide-by-zero-error-if-f_header.att.patch
>   perf-header-fix-use-of-unitialized-value-warning.patch
>   rdma-qedr-fix-the-hca_type-and-hca_rev-returned-in-d.patch
>   alsa-pcm-fix-lost-wakeup-event-scenarios-in-snd_pcm_.patch
>   libata-zpodd-fix-small-read-overflow-in-zpodd_get_me.patch
>   powerpc-nvdimm-pick-nearby-online-node-if-the-device.patch
>   drm-bridge-lvds-encoder-fix-build-error-while-config.patch
>   drm-bridge-tc358764-fix-build-error.patch
>   btrfs-fix-deadlock-between-fiemap-and-transaction-co.patch
>   scsi-hpsa-correct-scsi-command-status-issue-after-re.patch
>   scsi-qla2xxx-fix-possible-fcport-null-pointer-derefe.patch
>   tracing-fix-header-include-guards-in-trace-event-hea.patch
>   drm-amdkfd-fix-byte-align-on-vegam.patch
>   drm-amd-powerplay-fix-null-pointer-dereference-aroun.patch
>   drm-amdgpu-fix-error-handling-in-amdgpu_cs_process_f.patch
>   drm-amdgpu-fix-a-potential-information-leaking-bug.patch
>   ata-libahci-do-not-complain-in-case-of-deferred-prob.patch
>   kbuild-modpost-handle-kbuild_extra_symbols-only-for-.patch
>   kbuild-check-for-unknown-options-with-cc-option-usag.patch
>   arm64-efi-fix-variable-si-set-but-not-used.patch
>   riscv-fix-perf-record-without-libelf-support.patch
>   arm64-lower-priority-mask-for-gic_prio_irqon.patch
>   arm64-unwind-prohibit-probing-on-return_address.patch
>   arm64-mm-fix-variable-pud-set-but-not-used.patch
>   arm64-mm-fix-variable-tag-set-but-not-used.patch
>   ib-core-add-mitigation-for-spectre-v1.patch
>   ib-mlx5-fix-mr-registration-flow-to-use-umr-properly.patch
>   rdma-restrack-track-driver-qp-types-in-resource-trac.patch
>   ib-mad-fix-use-after-free-in-ib-mad-completion-handl.patch
>   rdma-mlx5-release-locks-during-notifier-unregister.patch
>   drm-msm-fix-add_gpu_components.patch
>   rdma-hns-fix-error-return-code-in-hns_roce_v1_rsv_lp.patch
>   drm-exynos-fix-missing-decrement-of-retry-counter.patch
>   arm64-kprobes-recover-pstate.d-in-single-step-except.patch
>   arm64-make-debug-exception-handlers-visible-from-rcu.patch
>   revert-kmemleak-allow-to-coexist-with-fault-injectio.patch
>   ocfs2-remove-set-but-not-used-variable-last_hash.patch
>   page-flags-prioritize-kasan-bits-over-last-cpuid.patch
>   asm-generic-fix-wtype-limits-compiler-warnings.patch
>   tpm-tpm_ibm_vtpm-fix-unallocated-banks.patch
>   arm64-kvm-regmap-fix-unexpected-switch-fall-through.patch
>   staging-comedi-dt3000-fix-signed-integer-overflow-divider-base.patch
>   staging-comedi-dt3000-fix-rounding-up-of-timer-divisor.patch
>   iio-adc-max9611-fix-temperature-reading-in-probe.patch
>   usb-core-fix-races-in-character-device-registration-and-deregistraion.patch
>   usb-gadget-udc-renesas_usb3-fix-sysfs-interface-of-role.patch
>   usb-cdc-acm-make-sure-a-refcount-is-taken-early-enough.patch
>   usb-cdc-fix-sanity-checks-in-cdc-union-parser.patch
>   usb-serial-option-add-d-link-dwm-222-device-id.patch
>   usb-serial-option-add-support-for-zte-mf871a.patch
>   usb-serial-option-add-the-broadmobi-bm818-card.patch
>   usb-serial-option-add-motorola-modem-uarts.patch
>   usb-setup-authorized_default-attributes-using-usb_bus_notify.patch
>   netfilter-conntrack-use-consistent-ct-id-hash-calculation.patch
>   iwlwifi-add-support-for-sar-south-korea-limitation.patch
>   input-psmouse-fix-build-error-of-multiple-definition.patch
>   bnx2x-fix-vf-s-vlan-reconfiguration-in-reload.patch
>   bonding-add-vlan-tx-offload-to-hw_enc_features.patch
>   net-dsa-check-existence-of-.port_mdb_add-callback-before-calling-it.patch
>   net-mlx4_en-fix-a-memory-leak-bug.patch
>   net-packet-fix-race-in-tpacket_snd.patch
>   net-sched-sch_taprio-fix-memleak-in-error-path-for-sched-list-parse.patch
>   sctp-fix-memleak-in-sctp_send_reset_streams.patch
>   sctp-fix-the-transport-error_count-check.patch
>   team-add-vlan-tx-offload-to-hw_enc_features.patch
>   tipc-initialise-addr_trail_end-when-setting-node-addresses.patch
>   xen-netback-reset-nr_frags-before-freeing-skb.patch
>   net-mlx5e-only-support-tx-rx-pause-setting-for-port-owner.patch
>   bnxt_en-fix-vnic-clearing-logic-for-57500-chips.patch
>   bnxt_en-improve-rx-doorbell-sequence.patch
>   bnxt_en-fix-handling-frag_err-when-nvm_install_update-cmd-fails.patch
>   bnxt_en-suppress-hwrm-errors-for-hwrm_nvm_get_variable-command.patch
>   bnxt_en-use-correct-src_fid-to-determine-direction-of-the-flow.patch
>   bnxt_en-fix-to-include-flow-direction-in-l2-key.patch
>   net-sched-update-skbedit-action-for-batched-events-operations.patch
>   tc-testing-updated-skbedit-action-tests-with-batch-create-delete.patch
>   netdevsim-restore-per-network-namespace-accounting-for-fib-entries.patch
>   net-mlx5e-ethtool-avoid-setting-speed-to-56gbase-when-autoneg-off.patch
>   net-mlx5e-fix-false-negative-indication-on-tx-reporter-cqe-recovery.patch
>   net-mlx5e-remove-redundant-check-in-cqe-recovery-flow-of-tx-reporter.patch
>   net-mlx5e-use-flow-keys-dissector-to-parse-packets-for-arfs.patch
>   net-tls-prevent-skb_orphan-from-leaking-tls-plain-text-with-offload.patch
>   net-phy-consider-an_restart-status-when-reading-link-status.patch
>   netlink-fix-nlmsg_parse-as-a-wrapper-for-strict-message-parsing.patch
> 
> Compile testing
> ---------------
> 
> We compiled the kernel for 3 architectures:
> 
>     aarch64:
>       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
>     ppc64le:
>       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
>     x86_64:
>       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> 
> 
> Hardware testing
> ----------------
> We booted each kernel and ran the following tests:
> 
>   aarch64:
>       Host 1:
>          ✅ Boot test [0]
>          ✅ xfstests: xfs [1]
>          ✅ selinux-policy: serge-testsuite [2]
>          ✅ lvm thinp sanity [3]
>          ✅ storage: software RAID testing [4]
>          🚧 ✅ Storage blktests [5]
> 
>       Host 2:
>          ✅ Boot test [0]
>          ✅ Podman system integration test (as root) [6]
>          ✅ Podman system integration test (as user) [6]
>          ❌ LTP lite [7]
>          ❌ Loopdev Sanity [8]
>          ✅ jvm test suite [9]
>          ✅ AMTU (Abstract Machine Test Utility) [10]
>          ✅ LTP: openposix test suite [11]
>          ✅ Ethernet drivers sanity [12]
>          ✅ Networking socket: fuzz [13]
>          ✅ Networking sctp-auth: sockopts test [14]
>          ✅ Networking TCP: keepalive test [15]
>          ✅ audit: audit testsuite test [16]
>          ✅ httpd: mod_ssl smoke sanity [17]
>          ✅ iotop: sanity [18]
>          ✅ tuned: tune-processes-through-perf [19]
>          ✅ Usex - version 1.9-29 [20]
>          ✅ storage: SCSI VPD [21]
>          ✅ stress: stress-ng [22]
> 
> 
>   ppc64le:
>       Host 1:
>          ✅ Boot test [0]
>          ✅ xfstests: xfs [1]
>          ✅ selinux-policy: serge-testsuite [2]
>          ✅ lvm thinp sanity [3]
>          ✅ storage: software RAID testing [4]
>          🚧 ✅ Storage blktests [5]
> 
>       Host 2:
>          ✅ Boot test [0]
>          ✅ Podman system integration test (as root) [6]
>          ✅ Podman system integration test (as user) [6]
>          ✅ LTP lite [7]
>          ✅ Loopdev Sanity [8]
>          ✅ jvm test suite [9]
>          ✅ AMTU (Abstract Machine Test Utility) [10]
>          ✅ LTP: openposix test suite [11]
>          ✅ Ethernet drivers sanity [12]
>          ✅ Networking socket: fuzz [13]
>          ✅ Networking sctp-auth: sockopts test [14]
>          ✅ Networking TCP: keepalive test [15]
>          ✅ audit: audit testsuite test [16]
>          ✅ httpd: mod_ssl smoke sanity [17]
>          ✅ iotop: sanity [18]
>          ✅ tuned: tune-processes-through-perf [19]
>          ✅ Usex - version 1.9-29 [20]
> 
> 
>   x86_64:
>       Host 1:
>          ✅ Boot test [0]
>          ✅ xfstests: xfs [1]
>          ✅ selinux-policy: serge-testsuite [2]
>          ✅ lvm thinp sanity [3]
>          ✅ storage: software RAID testing [4]
>          🚧 ✅ Storage blktests [5]
> 
>       Host 2:
>          ✅ Boot test [0]
>          ✅ Podman system integration test (as root) [6]
>          ✅ Podman system integration test (as user) [6]
>          ✅ LTP lite [7]
>          ✅ Loopdev Sanity [8]
>          ✅ jvm test suite [9]
>          ✅ AMTU (Abstract Machine Test Utility) [10]
>          ✅ LTP: openposix test suite [11]
>          ✅ Ethernet drivers sanity [12]
>          ✅ Networking socket: fuzz [13]
>          ✅ Networking sctp-auth: sockopts test [14]
>          ✅ Networking TCP: keepalive test [15]
>          ✅ audit: audit testsuite test [16]
>          ✅ httpd: mod_ssl smoke sanity [17]
>          ✅ iotop: sanity [18]
>          ✅ tuned: tune-processes-through-perf [19]
>          ✅ pciutils: sanity smoke test [23]
>          ✅ Usex - version 1.9-29 [20]
>          ✅ storage: SCSI VPD [21]
>          ✅ stress: stress-ng [22]
> 
> 
>   Test source:
>     💚 Pull requests are welcome for new tests or improvements to existing tests!
>     [0]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/kpkginstall
>     [1]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/filesystems/xfs/xfstests
>     [2]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/packages/selinux-policy/serge-testsuite
>     [3]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/lvm/thinp/sanity
>     [4]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/swraid/trim
>     [5]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/blk
>     [6]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/container/podman
>     [7]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/lite
>     [8]: https://github.com/CKI-project/tests-beaker/archive/master.zip#filesystems/loopdev/sanity
>     [9]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/jvm
>     [10]: https://github.com/CKI-project/tests-beaker/archive/master.zip#misc/amtu
>     [11]: https://github.com/CKI-project/tests-beaker/archive/master.zip#distribution/ltp/openposix_testsuite
>     [12]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/driver/sanity
>     [13]: https://github.com/CKI-project/tests-beaker/archive/master.zip#/networking/socket/fuzz
>     [14]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/sctp/auth/sockopts
>     [15]: https://github.com/CKI-project/tests-beaker/archive/master.zip#networking/tcp/tcp_keepalive
>     [16]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/audit/audit-testsuite
>     [17]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/httpd/mod_ssl-smoke
>     [18]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/iotop/sanity
>     [19]: https://github.com/CKI-project/tests-beaker/archive/master.zip#packages/tuned/tune-processes-through-perf
>     [20]: https://github.com/CKI-project/tests-beaker/archive/master.zip#standards/usex/1.9-29
>     [21]: https://github.com/CKI-project/tests-beaker/archive/master.zip#storage/scsi/vpd
>     [22]: https://github.com/CKI-project/tests-beaker/archive/master.zip#stress/stress-ng
>     [23]: https://github.com/CKI-project/tests-beaker/archive/master.zip#pciutils/sanity-smoke
> 
> Waived tests
> ------------
> If the test run included waived tests, they are marked with 🚧. Such tests are
> executed but their results are not taken into account. Tests are waived when
> their results are not reliable enough, e.g. when they're just introduced or are
> being fixed.
