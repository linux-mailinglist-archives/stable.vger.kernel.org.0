Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95DD7B8D7F
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 11:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405614AbfITJRv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 20 Sep 2019 05:17:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405605AbfITJRu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 05:17:50 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3A5E230860C0
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 09:17:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 31540608A5
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 09:17:50 +0000 (UTC)
Received: from zmail19.collab.prod.int.phx2.redhat.com (zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 290EE4EE50;
        Fri, 20 Sep 2019 09:17:50 +0000 (UTC)
Date:   Fri, 20 Sep 2019 05:17:50 -0400 (EDT)
From:   Veronika Kabatova <vkabatov@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Cc:     CKI Project <cki-project@redhat.com>
Message-ID: <997421181.767393.1568971070109.JavaMail.zimbra@redhat.com>
In-Reply-To: <cki.EA0D2465F7.LSWT0R58HX@redhat.com>
References: <cki.EA0D2465F7.LSWT0R58HX@redhat.com>
Subject: =?utf-8?Q?Re:_=E2=9C=85_PASS:_Stable_queue:_queue-5.2?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.40.204.214, 10.4.195.29]
Thread-Topic: =?utf-8?B?4pyFIFBBU1M6?= Stable queue: queue-5.2
Thread-Index: tXfnY81foYfcfxsVSkrxEZ4k3jZQdw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 20 Sep 2019 09:17:50 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



----- Original Message -----
> From: "CKI Project" <cki-project@redhat.com>
> To: "Linux Stable maillist" <stable@vger.kernel.org>
> Sent: Friday, September 20, 2019 9:39:58 AM
> Subject: ✅ PASS: Stable queue: queue-5.2
> 
> 
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 

Hi,

we are having an outage now and an important part of the system is out.
Merge and compile results are still valid but no testing can be executed
until the issue is resolved. People are currently working on resolving the
problem, hopefully it's under control soon.

In case you'd like to resubmit specific revisions for testing please let
me know and I'll retrigger them when the problem is solved.


Thanks and sorry for the trouble,
Veronika


>        Kernel repo:
>        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 1e2ba4a74fa7 - Linux 5.2.16
> 
> The results of these automated tests are provided below.
> 
>     Overall result: PASSED
>              Merge: OK
>            Compile: OK
>              Tests: OK
> 
> All kernel binaries, config files, and logs are available for download here:
> 
>   https://artifacts.cki-project.org/pipelines/175260
> 
> Please reply to this email if you have any questions about the tests that we
> ran or if you have any suggestions on how to make future tests more
> effective.
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
>   Commit: 1e2ba4a74fa7 - Linux 5.2.16
> 
> 
> We grabbed the 5d06de98f77f commit of the stable queue repository.
> 
> We then merged the patchset with `git am`:
> 
>   usb-usbcore-fix-slab-out-of-bounds-bug-during-device-reset.patch
>   media-tm6000-double-free-if-usb-disconnect-while-streaming.patch
>   phy-renesas-rcar-gen3-usb2-disable-clearing-vbus-in-over-current.patch
>   net-hns3-adjust-hns3_uninit_phy-s-location-in-the-hns3_client_uninit.patch
>   netfilter-nf_flow_table-set-default-timeout-after-successful-insertion.patch
>   hid-wacom-generic-read-hid_dg_contactmax-from-any-feature-report.patch
>   input-elan_i2c-remove-lenovo-legion-y7000-pnpid.patch
>   sunrpc-handle-connection-breakages-correctly-in-call_status.patch
>   media-stm32-dcmi-fix-irq-0-case.patch
>   nfs-disable-client-side-deduplication.patch
>   powerpc-mm-radix-use-the-right-page-size-for-vmemmap-mapping.patch
>   scripts-decode_stacktrace-match-basepath-using-shell-prefix-operator-not-regex.patch
>   net-hns-fix-led-configuration-for-marvell-phy.patch
>   net-aquantia-fix-limit-of-vlan-filters.patch
>   ip6_gre-fix-a-dst-leak-in-ip6erspan_tunnel_xmit.patch
>   net-sched-fix-race-between-deactivation-and-dequeue-for-nolock-qdisc.patch
>   net_sched-let-qdisc_put-accept-null-pointer.patch
>   udp-correct-reuseport-selection-with-connected-sockets.patch
>   xen-netfront-do-not-assume-sk_buff_head-list-is-empty-in-error-handling.patch
>   net-dsa-fix-load-order-between-dsa-drivers-and-taggers.patch
>   kvm-coalesced_mmio-add-bounds-checking.patch
>   firmware-google-check-if-size-is-valid-when-decoding-vpd-data.patch
>   serial-sprd-correct-the-wrong-sequence-of-arguments.patch
>   tty-serial-atmel-reschedule-tx-after-rx-was-started.patch
>   mwifiex-fix-three-heap-overflow-at-parsing-element-in-cfg80211_ap_settings.patch
>   nl80211-fix-possible-spectre-v1-for-cqm-rssi-thresholds.patch
>   ieee802154-hwsim-fix-error-handle-path-in-hwsim_init.patch
>   ieee802154-hwsim-unregister-hw-while-hwsim_subscribe.patch
>   arm-dts-am57xx-disable-voltage-switching-for-sd-card.patch
>   arm-omap2-fix-missing-sysc_has_reset_status-for-dra7.patch
>   bus-ti-sysc-fix-handling-of-forced-idle.patch
>   bus-ti-sysc-fix-using-configured-sysc-mask-value.patch
>   arm-dts-fix-flags-for-gpio7.patch
>   arm-dts-fix-incorrect-dcan-register-mapping-for-am3-.patch
>   arm64-dts-meson-g12a-add-missing-dwc2-phy-names.patch
>   s390-bpf-fix-lcgr-instruction-encoding.patch
>   arm-omap2-fix-omap4-errata-warning-on-other-socs.patch
>   arm-dts-am335x-fix-uarts-length.patch
>   arm-dts-dra74x-fix-iodelay-configuration-for-mmc3.patch
>   arm-omap1-ams-delta-fiq-fix-missing-irq_ack.patch
>   bus-ti-sysc-simplify-cleanup-upon-failures-in-sysc_p.patch
>   arm-dts-fix-incomplete-dts-data-for-am3-and-am4-mmc.patch
>   s390-bpf-use-32-bit-index-for-tail-calls.patch
>   selftests-bpf-fix-bind-4-6-deny-specific-ip-port-on-.patch
>   tools-bpftool-close-prog-fd-before-exit-on-showing-a.patch
>   fpga-altera-ps-spi-fix-getting-of-optional-confd-gpi.patch
>   netfilter-ebtables-fix-argument-order-to-add_counter.patch
>   netfilter-nft_flow_offload-missing-netlink-attribute.patch
>   netfilter-xt_nfacct-fix-alignment-mismatch-in-xt_nfa.patch
>   nfsv4-fix-return-values-for-nfs4_file_open.patch
>   nfsv4-fix-return-value-in-nfs_finish_open.patch
>   nfs-fix-initialisation-of-i-o-result-struct-in-nfs_p.patch
>   nfs-on-fatal-writeback-errors-we-need-to-call-nfs_in.patch
>   kconfig-fix-the-reference-to-the-idt77105-phy-driver.patch
>   xdp-unpin-xdp-umem-pages-in-error-path.patch
>   selftests-bpf-fix-test_cgroup_storage-on-s390.patch
>   selftests-bpf-add-config-fragment-bpf_jit.patch
>   qed-add-cleanup-in-qed_slowpath_start.patch
>   drm-omap-fix-port-lookup-for-sdi-output.patch
>   drm-virtio-use-virtio_max_dma_size.patch
>   arm-8874-1-mm-only-adjust-sections-of-valid-mm-struc.patch
>   batman-adv-only-read-ogm2-tvlv_len-after-buffer-len-.patch
>   flow_dissector-fix-potential-use-after-free-on-bpf_p.patch
>   bpf-allow-narrow-loads-of-some-sk_reuseport_md-field.patch
>   r8152-set-memory-to-all-0xffs-on-failed-reg-reads.patch
>   x86-apic-fix-arch_dynirq_lower_bound-bug-for-dt-enab.patch
>   pnfs-flexfiles-don-t-time-out-requests-on-hard-mount.patch
>   nfs-fix-spurious-eio-read-errors.patch
>   nfs-fix-writepage-s-error-handling-to-not-report-err.patch
>   drm-amdgpu-fix-dma_fence_wait-without-reference.patch
>   netfilter-xt_physdev-fix-spurious-error-message-in-p.patch
>   netfilter-nf_conntrack_ftp-fix-debug-output.patch
>   nfsv2-fix-eof-handling.patch
>   nfsv2-fix-write-regression.patch
>   nfs-remove-set-but-not-used-variable-mapping.patch
>   kallsyms-don-t-let-kallsyms_lookup_size_offset-fail-.patch
>   netfilter-conntrack-make-sysctls-per-namespace-again.patch
>   drm-amd-powerplay-correct-vega20-dpm-level-related-s.patch
>   cifs-set-domainname-when-a-domain-key-is-used-in-mul.patch
>   cifs-use-kzfree-to-zero-out-the-password.patch
>   libceph-don-t-call-crypto_free_sync_skcipher-on-a-nu.patch
>   usb-host-xhci-tegra-set-dma-mask-correctly.patch
>   risc-v-fix-fixmap-area-corruption-on-rv32-systems.patch
>   arm-8901-1-add-a-criteria-for-pfn_valid-of-arm.patch
>   ibmvnic-do-not-process-reset-during-or-after-device-.patch
>   sky2-disable-msi-on-yet-another-asus-boards-p6xxxx.patch
>   i2c-designware-synchronize-irqs-when-unregistering-s.patch
>   perf-x86-intel-restrict-period-on-nehalem.patch
>   perf-x86-amd-ibs-fix-sample-bias-for-dispatched-micr.patch
>   i2c-iproc-stop-advertising-support-of-smbus-quick-cm.patch
>   i2c-mediatek-disable-zero-length-transfers-for-mt818.patch
>   amd-xgbe-fix-error-path-in-xgbe_mod_init.patch
>   netfilter-nf_flow_table-clear-skb-tstamp-before-xmit.patch
>   tools-power-x86_energy_perf_policy-fix-uninitialized.patch
>   tools-power-x86_energy_perf_policy-fix-argument-pars.patch
>   tools-power-turbostat-fix-leak-of-file-descriptor-on.patch
>   tools-power-turbostat-fix-file-descriptor-leaks.patch
>   tools-power-turbostat-fix-buffer-overrun.patch
>   tools-power-turbostat-fix-haswell-core-systems.patch
>   tools-power-turbostat-add-ice-lake-nnpi-support.patch
>   tools-power-turbostat-fix-cpu-c1-display-value.patch
>   net-aquantia-fix-removal-of-vlan-0.patch
>   net-aquantia-reapply-vlan-filters-on-up.patch
>   net-aquantia-linkstate-irq-should-be-oneshot.patch
>   net-aquantia-fix-out-of-memory-condition-on-rx-side.patch
>   net-dsa-microchip-add-ksz8563-compatibility-string.patch
>   enetc-add-missing-call-to-pci_free_irq_vectors-in-pr.patch
>   net-seeq-fix-the-function-used-to-release-some-memor.patch
>   arm64-dts-renesas-r8a77995-draak-fix-backlight-regul.patch
>   dmaengine-ti-dma-crossbar-fix-a-memory-leak-bug.patch
>   dmaengine-ti-omap-dma-add-cleanup-in-omap_dma_probe.patch
>   x86-uaccess-don-t-leak-the-ac-flags-into-__get_user-.patch
>   x86-hyper-v-fix-overflow-bug-in-fill_gva_list.patch
>   iommu-vt-d-remove-global-page-flush-support.patch
>   dmaengine-sprd-fix-the-dma-link-list-configuration.patch
>   dmaengine-rcar-dmac-fix-dmachclr-handling-if-iommu-i.patch
>   keys-fix-missing-null-pointer-check-in-request_key_a.patch
>   iommu-amd-flush-old-domains-in-kdump-kernel.patch
>   iommu-amd-fix-race-in-increase_address_space.patch
>   revert-arm64-remove-unnecessary-isbs-from-set_-pte-pmd-pud.patch
>   ovl-fix-regression-caused-by-overlapping-layers-detection.patch
>   floppy-fix-usercopy-direction.patch
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
> 
>     ⚡ Internal infrastructure issues prevented one or more tests (marked
>     with ⚡⚡⚡) from running on this architecture.
>     This is not the fault of the kernel that was tested.
> 
>   ppc64le:
> 
>     ⚡ Internal infrastructure issues prevented one or more tests (marked
>     with ⚡⚡⚡) from running on this architecture.
>     This is not the fault of the kernel that was tested.
> 
>   x86_64:
> 
>     ⚡ Internal infrastructure issues prevented one or more tests (marked
>     with ⚡⚡⚡) from running on this architecture.
>     This is not the fault of the kernel that was tested.
> 
>   Test sources: https://github.com/CKI-project/tests-beaker
>     💚 Pull requests are welcome for new tests or improvements to existing
>     tests!
> 
> Waived tests
> ------------
> If the test run included waived tests, they are marked with 🚧. Such tests
> are
> executed but their results are not taken into account. Tests are waived when
> their results are not reliable enough, e.g. when they're just introduced or
> are
> being fixed.
> 
> 
