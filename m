Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27752F5A72
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 22:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfKHVzv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 8 Nov 2019 16:55:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbfKHVzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 16:55:50 -0500
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6ACAC057F22
        for <stable@vger.kernel.org>; Fri,  8 Nov 2019 21:55:49 +0000 (UTC)
Received: by mail-oi1-f199.google.com with SMTP id r206so4339840oih.6
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 13:55:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ti0SHE5G7K/O/jLGldn3MsoOZFrnTEa2xSrG30P5HdQ=;
        b=myetIbBunS3th/L/6u9pEfefDQp1jOnQa58aVQWr7D1LILKqhCq156gPUljO0l/Zeo
         wfFEOGaWkF/YVPoVblU6bfCk5pgGN7WbZPLb5nLbF2jcSZr475Nzjd55Fw923ywXS4Cr
         VGXye0bmQ27KvzQ/oo1tXdYM2L5DhPx+gYzFqPH6qQ+OOnxl0HKo6bRXh+tS6OXiGk+Z
         PIFnTVJrSm9Um2zzrPY0n957xV9ZQBVIJtkZOeSUWXLabvkoYl1xA8gRH2P5vr0YsBQJ
         1I6HzcSUenoaBWkg8f+Fv1/wO3EBP61MNVqXBs0D1dG9jmyjwAVp2shssakubbc7jzSh
         psSA==
X-Gm-Message-State: APjAAAWWALetyzVbnQD6/+JRi9xdoYbBhGTtvBUxd/3h1YxoL40iHxwe
        kACsBED1H58oT7aDhphyjZc981ewW2vNyDeWi8G9gzRw9bObpxMI0fGp1m+ZK7RUoidsVmCMAvZ
        zZ66cE41zZsG84aPIxEQwvSmZvE6fes5B
X-Received: by 2002:a9d:313:: with SMTP id 19mr1480602otv.197.1573250148905;
        Fri, 08 Nov 2019 13:55:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqx6Pl1ty6laR/Mm5FewNWksaG0O80wMeHs8U5nKacCj+Ls5S+VX4h9fNPF2pjEUO1DXqDhYC+758Ld/CM9N7YM=
X-Received: by 2002:a9d:313:: with SMTP id 19mr1480582otv.197.1573250148371;
 Fri, 08 Nov 2019 13:55:48 -0800 (PST)
MIME-Version: 1.0
References: <cki.8ED53A8A5E.EINWAVAC53@redhat.com>
In-Reply-To: <cki.8ED53A8A5E.EINWAVAC53@redhat.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Fri, 8 Nov 2019 22:55:37 +0100
Message-ID: <CAFqZXNtrdX5rU389G-QmZgHJX=safpof8RyLtX9Fj-rYb_yBZQ@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBTdGFibGUgcXVldWU6IHF1ZXVlLTUuMw==?=
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Milos Malik <mmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 8, 2019 at 10:16 PM CKI Project <cki-project@redhat.com> wrote:
> Hello,
>
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
>
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 37b4d0c37c0b - Linux 5.3.9
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
>   https://artifacts.cki-project.org/pipelines/272770
>
> One or more kernel tests failed:
>
>     ppc64le:
>      ❌ selinux-policy: serge-testsuite
>
>     aarch64:
>      ❌ selinux-policy: serge-testsuite
>
>     x86_64:
>      ❌ selinux-policy: serge-testsuite

Hm... these failed due to a bug in libbpf-0.0.3-1.fc31, which has been
fixed in libbpf-0.0.5-1.fc31. Bodhi shows it as already pushed to
stable [1], so I don't understand why the old 0.0.3-1 version was
installed here...

[1] https://bodhi.fedoraproject.org/updates/FEDORA-2019-8519f326c2

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
>   Commit: 37b4d0c37c0b - Linux 5.3.9
>
>
> We grabbed the a429997a66bb commit of the stable queue repository.
>
> We then merged the patchset with `git am`:
>
>   regulator-of-fix-suspend-min-max-voltage-parsing.patch
>   asoc-samsung-arndale-add-missing-of-node-dereferenci.patch
>   asoc-wm8994-do-not-register-inapplicable-controls-fo.patch
>   regulator-da9062-fix-suspend_enable-disable-preparat.patch
>   asoc-topology-fix-a-signedness-bug-in-soc_tplg_dapm_.patch
>   arm64-dts-allwinner-a64-pine64-plus-add-phy-regulato.patch
>   arm64-dts-allwinner-a64-drop-pmu-node.patch
>   arm64-dts-allwinner-a64-sopine-baseboard-add-phy-reg.patch
>   arm64-dts-fix-gpio-to-pinmux-mapping.patch
>   regulator-ti-abb-fix-timeout-in-ti_abb_wait_txdone-t.patch
>   pinctrl-intel-allocate-irq-chip-dynamic.patch
>   asoc-sof-loader-fix-kernel-oops-on-firmware-boot-fai.patch
>   asoc-sof-topology-fix-parse-fail-issue-for-byte-bool.patch
>   asoc-sof-intel-hda-fix-warnings-during-fw-load.patch
>   asoc-sof-intel-initialise-and-verify-fw-crash-dump-d.patch
>   asoc-sof-intel-hda-disable-dmi-l1-entry-during-captu.patch
>   asoc-rt5682-add-null-handler-to-set_jack-function.patch
>   asoc-intel-sof_rt5682-add-remove-function-to-disable.patch
>   asoc-intel-bytcr_rt5651-add-null-check-to-support_bu.patch
>   regulator-pfuze100-regulator-variable-val-in-pfuze10.patch
>   asoc-wm_adsp-don-t-generate-kcontrols-without-read-f.patch
>   asoc-rockchip-i2s-fix-rpm-imbalance.patch
>   arm64-dts-rockchip-fix-rockpro64-rk808-interrupt-lin.patch
>   arm-dts-logicpd-torpedo-som-remove-twl_keypad.patch
>   arm64-dts-rockchip-fix-rockpro64-vdd-log-regulator-s.patch
>   arm64-dts-rockchip-fix-rockpro64-sdhci-settings.patch
>   pinctrl-ns2-fix-off-by-one-bugs-in-ns2_pinmux_enable.patch
>   pinctrl-stmfx-fix-null-pointer-on-remove.patch
>   arm64-dts-zii-ultra-fix-arm-regulator-states.patch
>   arm-dts-am3874-iceboard-fix-i2c-mux-idle-disconnect-.patch
>   asoc-msm8916-wcd-digital-add-missing-mix2-path-for-r.patch
>   asoc-simple_card_utils.h-fix-potential-multiple-rede.patch
>   arm-dts-use-level-interrupt-for-omap4-5-wlcore.patch
>   arm-mm-fix-alignment-handler-faults-under-memory-pre.patch
>   scsi-qla2xxx-fix-a-potential-null-pointer-dereferenc.patch
>   scsi-scsi_dh_alua-handle-rtpg-sense-code-correctly-d.patch
>   scsi-sni_53c710-fix-compilation-error.patch
>   scsi-fix-kconfig-dependency-warning-related-to-53c70.patch
>   arm-8908-1-add-__always_inline-to-functions-called-f.patch
>   arm-8914-1-nommu-fix-exc_ret-for-xip.patch
>   arm64-dts-rockchip-fix-rockpro64-sdmmc-settings.patch
>   arm64-dts-rockchip-fix-usb-c-on-hugsun-x99-tv-box.patch
>   arm64-dts-lx2160a-correct-cpu-core-idle-state-name.patch
>   arm-dts-imx6q-logicpd-re-enable-snvs-power-key.patch
>   arm-dts-vf610-zii-scu4-aib-specify-i2c-mux-idle-disc.patch
>   arm-dts-imx7s-correct-gpt-s-ipg-clock-source.patch
>   arm64-dts-imx8mq-use-correct-clock-for-usdhc-s-ipg-c.patch
>   arm64-dts-imx8mm-use-correct-clock-for-usdhc-s-ipg-c.patch
>   perf-tools-fix-resource-leak-of-closedir-on-the-erro.patch
>   perf-c2c-fix-memory-leak-in-build_cl_output.patch
>   8250-men-mcb-fix-error-checking-when-get_num_ports-r.patch
>   perf-kmem-fix-memory-leak-in-compact_gfp_flags.patch
>   arm-davinci-dm365-fix-mcbsp-dma_slave_map-entry.patch
>   drm-amdgpu-fix-potential-vm-faults.patch
>   drm-amdgpu-fix-error-handling-in-amdgpu_bo_list_crea.patch
>   scsi-target-core-do-not-overwrite-cdb-byte-1.patch
>   scsi-hpsa-add-missing-hunks-in-reset-patch.patch
>   asoc-intel-sof-rt5682-add-a-check-for-devm_clk_get.patch
>   asoc-sof-control-return-true-when-kcontrol-values-ch.patch
>   tracing-fix-gfp_t-format-for-synthetic-events.patch
>   arm-dts-bcm2837-rpi-cm3-avoid-leds-gpio-probing-issu.patch
>   i2c-aspeed-fix-master-pending-state-handling.patch
>   drm-komeda-don-t-flush-inactive-pipes.patch
>   arm-8926-1-v7m-remove-register-save-to-stack-before-.patch
>   selftests-kvm-vmx_set_nested_state_test-don-t-check-.patch
>   selftests-kvm-fix-sync_regs_test-with-newer-gccs.patch
>   alsa-hda-add-tigerlake-jasperlake-pci-id.patch
>   of-unittest-fix-memory-leak-in-unittest_data_add.patch
>   mips-bmips-mark-exception-vectors-as-char-arrays.patch
>   irqchip-gic-v3-its-use-the-exact-itslist-for-vmovp.patch
>   i2c-mt65xx-fix-null-ptr-dereference.patch
>   i2c-stm32f7-fix-first-byte-to-send-in-slave-mode.patch
>   i2c-stm32f7-fix-a-race-in-slave-mode-with-arbitratio.patch
>   i2c-stm32f7-remove-warning-when-compiling-with-w-1.patch
>   cifs-fix-cifsinodeinfo-lock_sem-deadlock-when-reconn.patch
>   irqchip-sifive-plic-skip-contexts-except-supervisor-.patch
>   nbd-protect-cmd-status-with-cmd-lock.patch
>   nbd-handle-racing-with-error-ed-out-commands.patch
>   cxgb4-fix-panic-when-attaching-to-uld-fail.patch
>   cxgb4-request-the-tx-cidx-updates-to-status-page.patch
>   dccp-do-not-leak-jiffies-on-the-wire.patch
>   erspan-fix-the-tun_info-options_len-check-for-erspan.patch
>   inet-stop-leaking-jiffies-on-the-wire.patch
>   net-annotate-accesses-to-sk-sk_incoming_cpu.patch
>   net-annotate-lockless-accesses-to-sk-sk_napi_id.patch
>   net-dsa-bcm_sf2-fix-imp-setup-for-port-different-than-8.patch
>   net-ethernet-ftgmac100-fix-dma-coherency-issue-with-sw-checksum.patch
>   net-fix-sk_page_frag-recursion-from-memory-reclaim.patch
>   net-hisilicon-fix-ping-latency-when-deal-with-high-throughput.patch
>   net-mlx4_core-dynamically-set-guaranteed-amount-of-counters-per-vf.patch
>   netns-fix-gfp-flags-in-rtnl_net_notifyid.patch
>   net-rtnetlink-fix-a-typo-fbd-fdb.patch
>   net-usb-lan78xx-disable-interrupts-before-calling-generic_handle_irq.patch
>   net-zeroing-the-structure-ethtool_wolinfo-in-ethtool_get_wol.patch
>   selftests-net-reuseport_dualstack-fix-uninitalized-parameter.patch
>   udp-fix-data-race-in-udp_set_dev_scratch.patch
>   vxlan-check-tun_info-options_len-properly.patch
>   net-add-skb_queue_empty_lockless.patch
>   udp-use-skb_queue_empty_lockless.patch
>   net-use-skb_queue_empty_lockless-in-poll-handlers.patch
>   net-use-skb_queue_empty_lockless-in-busy-poll-contexts.patch
>   net-add-read_once-annotation-in-__skb_wait_for_more_packets.patch
>   ipv4-fix-route-update-on-metric-change.patch
>   selftests-fib_tests-add-more-tests-for-metric-update.patch
>   net-smc-fix-closing-of-fallback-smc-sockets.patch
>   net-smc-keep-vlan_id-for-smc-r-in-smc_listen_work.patch
>   keys-fix-memory-leak-in-copy_net_ns.patch
>   net-phylink-fix-phylink_dbg-macro.patch
>   rxrpc-fix-handling-of-last-subpacket-of-jumbo-packet.patch
>   net-mlx5e-determine-source-port-properly-for-vlan-push-action.patch
>   net-mlx5e-remove-incorrect-match-criteria-assignment-line.patch
>   net-mlx5e-initialize-on-stack-link-modes-bitmap.patch
>   net-mlx5-fix-flow-counter-list-auto-bits-struct.patch
>   net-smc-fix-refcounting-for-non-blocking-connect.patch
>   net-mlx5-fix-rtable-reference-leak.patch
>   mlxsw-core-unpublish-devlink-parameters-during-reload.patch
>   r8169-fix-wrong-phy-id-issue-with-rtl8168dp.patch
>   net-mlx5e-fix-ethtool-self-test-link-speed.patch
>   net-mlx5e-fix-handling-of-compressed-cqes-in-case-of-low-napi-budget.patch
>   ipv4-fix-ipskb_frag_pmtu-handling-with-fragmentation.patch
>   net-bcmgenet-don-t-set-phydev-link-from-mac.patch
>   net-dsa-b53-do-not-clear-existing-mirrored-port-mask.patch
>   net-dsa-fix-switch-tree-list.patch
>   net-ensure-correct-skb-tstamp-in-various-fragmenters.patch
>   net-hns3-fix-mis-counting-irq-vector-numbers-issue.patch
>   net-netem-fix-error-path-for-corrupted-gso-frames.patch
>   net-reorder-struct-net-fields-to-avoid-false-sharing.patch
>   net-usb-lan78xx-connect-phy-before-registering-mac.patch
>   r8152-add-device-id-for-lenovo-thinkpad-usb-c-dock-gen-2.patch
>   net-netem-correct-the-parent-s-backlog-when-corrupted-packet-was-dropped.patch
>   net-phy-bcm7xxx-define-soft_reset-for-40nm-ephy.patch
>   net-bcmgenet-reset-40nm-ephy-on-energy-detect.patch
>   net-flow_dissector-switch-to-siphash.patch
>   platform-x86-pmc_atom-add-siemens-simatic-ipc227e-to-critclk_systems-dmi-table.patch
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
>     Host 1:
>        ✅ Boot test
>        ❌ selinux-policy: serge-testsuite
>         ✅ Storage blktests
>
>     Host 2:
>        ✅ Boot test
>        ✅ Podman system integration test (as root)
>        ✅ Podman system integration test (as user)
>        ✅ LTP lite
>        ✅ Loopdev Sanity
>        ✅ jvm test suite
>        ✅ AMTU (Abstract Machine Test Utility)
>        ✅ LTP: openposix test suite
>        ✅ Networking bridge: sanity
>        ✅ Ethernet drivers sanity
>        ✅ Networking socket: fuzz
>        ✅ Networking sctp-auth: sockopts test
>        ✅ Networking route_func: local
>        ✅ Networking route_func: forward
>        ✅ Networking TCP: keepalive test
>        ✅ Networking UDP: socket
>        ✅ Networking tunnel: gre basic
>        ✅ Networking tunnel: vxlan basic
>        ✅ audit: audit testsuite test
>        ✅ httpd: mod_ssl smoke sanity
>        ✅ iotop: sanity
>        ✅ tuned: tune-processes-through-perf
>        ✅ ALSA PCM loopback test
>        ✅ ALSA Control (mixer) Userspace Element test
>        ✅ Usex - version 1.9-29
>        ✅ storage: SCSI VPD
>        ✅ stress: stress-ng
>        ✅ trace: ftrace/tracer
>         ✅ CIFS Connectathon
>         ✅ POSIX pjd-fstest suites
>
>   ppc64le:
>     Host 1:
>        ✅ Boot test
>        ✅ Podman system integration test (as root)
>        ✅ Podman system integration test (as user)
>        ✅ LTP lite
>        ✅ Loopdev Sanity
>        ✅ jvm test suite
>        ✅ AMTU (Abstract Machine Test Utility)
>        ✅ LTP: openposix test suite
>        ✅ Networking bridge: sanity
>        ✅ Ethernet drivers sanity
>        ✅ Networking socket: fuzz
>        ✅ Networking sctp-auth: sockopts test
>        ✅ Networking route_func: local
>        ✅ Networking route_func: forward
>        ✅ Networking TCP: keepalive test
>        ✅ Networking UDP: socket
>        ✅ Networking tunnel: gre basic
>        ✅ Networking tunnel: vxlan basic
>        ✅ audit: audit testsuite test
>        ✅ httpd: mod_ssl smoke sanity
>        ✅ iotop: sanity
>        ✅ tuned: tune-processes-through-perf
>        ✅ ALSA PCM loopback test
>        ✅ ALSA Control (mixer) Userspace Element test
>        ✅ Usex - version 1.9-29
>        ✅ trace: ftrace/tracer
>         ✅ CIFS Connectathon
>         ✅ POSIX pjd-fstest suites
>
>     Host 2:
>        ✅ Boot test
>        ❌ selinux-policy: serge-testsuite
>         ✅ Storage blktests
>
>   x86_64:
>     Host 1:
>        ✅ Boot test
>        ✅ Podman system integration test (as root)
>        ✅ Podman system integration test (as user)
>        ✅ LTP lite
>        ✅ Loopdev Sanity
>        ✅ jvm test suite
>        ✅ AMTU (Abstract Machine Test Utility)
>        ✅ LTP: openposix test suite
>        ✅ Networking bridge: sanity
>        ✅ Ethernet drivers sanity
>        ✅ Networking socket: fuzz
>        ✅ Networking sctp-auth: sockopts test
>        ✅ Networking route_func: local
>        ✅ Networking route_func: forward
>        ✅ Networking TCP: keepalive test
>        ✅ Networking UDP: socket
>        ✅ Networking tunnel: gre basic
>        ✅ Networking tunnel: vxlan basic
>        ✅ audit: audit testsuite test
>        ✅ httpd: mod_ssl smoke sanity
>        ✅ iotop: sanity
>        ✅ tuned: tune-processes-through-perf
>        ✅ pciutils: sanity smoke test
>        ✅ ALSA PCM loopback test
>        ✅ ALSA Control (mixer) Userspace Element test
>        ✅ Usex - version 1.9-29
>        ✅ storage: SCSI VPD
>        ✅ stress: stress-ng
>        ✅ trace: ftrace/tracer
>         ✅ CIFS Connectathon
>         ✅ POSIX pjd-fstest suites
>
>     Host 2:
>        ✅ Boot test
>        ❌ selinux-policy: serge-testsuite
>         ✅ Storage blktests
>
>   Test sources: https://github.com/CKI-project/tests-beaker
>     Pull requests are welcome for new tests or improvements to existing tests!
>
> Waived tests
> ------------
> If the test run included waived tests, they are marked with . Such tests are
> executed but their results are not taken into account. Tests are waived when
> their results are not reliable enough, e.g. when they're just introduced or are
> being fixed.
>
> Testing timeout
> ---------------
> We aim to provide a report within reasonable timeframe. Tests that haven't
> finished running are marked with ⏱. Reports for non-upstream kernels have
> a Beaker recipe linked to next to each host.



-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
