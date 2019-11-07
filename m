Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 594D1F2431
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 02:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbfKGB3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 20:29:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30649 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732732AbfKGB3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 20:29:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573090145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YdjKsNlIaeeWZ7SZPWJvhvTe55krQD4JJVelWiT79Do=;
        b=Gpgfp6a5S3QjwGJr+q+DQHfPBNF3rEQ7eJ6CHhOb6T1saQu0HHWZsasOFOE10nepLJiLWn
        J0QxhdY70NptKJl6c+S0i6lOZsdGK190wEcao0khaUU6GNU7dYtaFnN1eJ4gu7+sdl0mCV
        54XEZEq+vy3SBM1lKipZu5z6HD3vlrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-gVCGHiQsP8GtUPNE4sEKgA-1; Wed, 06 Nov 2019 20:29:02 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90B468017DD
        for <stable@vger.kernel.org>; Thu,  7 Nov 2019 01:29:01 +0000 (UTC)
Received: from [172.54.37.191] (cpt-1013.paas.prod.upshift.rdu2.redhat.com [10.0.19.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AED425D9E5;
        Thu,  7 Nov 2019 01:28:58 +0000 (UTC)
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4pyF?= PASS: Stable queue: queue-5.3
Date:   Thu, 07 Nov 2019 01:28:58 -0000
Message-ID: <cki.B4D6858D96.FEUYNHT819@redhat.com>
X-Gitlab-Pipeline-ID: 268506
X-Gitlab-Url: https://xci32.lab.eng.rdu2.redhat.com
X-Gitlab-Path: /cki-project/cki-pipeline/pipelines/268506
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: gVCGHiQsP8GtUPNE4sEKgA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

We ran automated tests on a patchset that was proposed for merging into thi=
s
kernel tree. The patches were applied to:

       Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/=
linux.git
            Commit: 37b4d0c37c0b - Linux 5.3.9

The results of these automated tests are provided below.

    Overall result: PASSED
             Merge: OK
           Compile: OK
             Tests: OK

All kernel binaries, config files, and logs are available for download here=
:

  https://artifacts.cki-project.org/pipelines/268506

Please reply to this email if you have any questions about the tests that w=
e
ran or if you have any suggestions on how to make future tests more effecti=
ve.

        ,-.   ,-.
       ( C ) ( K )  Continuous
        `-',-.`-'   Kernel
          ( I )     Integration
           `-'
___________________________________________________________________________=
___

Merge testing
-------------

We cloned this repository and checked out the following commit:

  Repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  Commit: 37b4d0c37c0b - Linux 5.3.9


We grabbed the b6cfbed0ac3d commit of the stable queue repository.

We then merged the patchset with `git am`:

  regulator-of-fix-suspend-min-max-voltage-parsing.patch
  asoc-samsung-arndale-add-missing-of-node-dereferenci.patch
  asoc-wm8994-do-not-register-inapplicable-controls-fo.patch
  regulator-da9062-fix-suspend_enable-disable-preparat.patch
  asoc-topology-fix-a-signedness-bug-in-soc_tplg_dapm_.patch
  arm64-dts-allwinner-a64-pine64-plus-add-phy-regulato.patch
  arm64-dts-allwinner-a64-drop-pmu-node.patch
  arm64-dts-allwinner-a64-sopine-baseboard-add-phy-reg.patch
  arm64-dts-fix-gpio-to-pinmux-mapping.patch
  regulator-ti-abb-fix-timeout-in-ti_abb_wait_txdone-t.patch
  pinctrl-intel-allocate-irq-chip-dynamic.patch
  asoc-sof-loader-fix-kernel-oops-on-firmware-boot-fai.patch
  asoc-sof-topology-fix-parse-fail-issue-for-byte-bool.patch
  asoc-sof-intel-hda-fix-warnings-during-fw-load.patch
  asoc-sof-intel-initialise-and-verify-fw-crash-dump-d.patch
  asoc-sof-intel-hda-disable-dmi-l1-entry-during-captu.patch
  asoc-rt5682-add-null-handler-to-set_jack-function.patch
  asoc-intel-sof_rt5682-add-remove-function-to-disable.patch
  asoc-intel-bytcr_rt5651-add-null-check-to-support_bu.patch
  regulator-pfuze100-regulator-variable-val-in-pfuze10.patch
  asoc-wm_adsp-don-t-generate-kcontrols-without-read-f.patch
  asoc-rockchip-i2s-fix-rpm-imbalance.patch
  arm64-dts-rockchip-fix-rockpro64-rk808-interrupt-lin.patch
  arm-dts-logicpd-torpedo-som-remove-twl_keypad.patch
  arm64-dts-rockchip-fix-rockpro64-vdd-log-regulator-s.patch
  arm64-dts-rockchip-fix-rockpro64-sdhci-settings.patch
  pinctrl-ns2-fix-off-by-one-bugs-in-ns2_pinmux_enable.patch
  pinctrl-stmfx-fix-null-pointer-on-remove.patch
  arm64-dts-zii-ultra-fix-arm-regulator-states.patch
  arm-dts-am3874-iceboard-fix-i2c-mux-idle-disconnect-.patch
  asoc-msm8916-wcd-digital-add-missing-mix2-path-for-r.patch
  asoc-simple_card_utils.h-fix-potential-multiple-rede.patch
  arm-dts-use-level-interrupt-for-omap4-5-wlcore.patch
  arm-mm-fix-alignment-handler-faults-under-memory-pre.patch
  scsi-qla2xxx-fix-a-potential-null-pointer-dereferenc.patch
  scsi-scsi_dh_alua-handle-rtpg-sense-code-correctly-d.patch
  scsi-sni_53c710-fix-compilation-error.patch
  scsi-fix-kconfig-dependency-warning-related-to-53c70.patch
  arm-8908-1-add-__always_inline-to-functions-called-f.patch
  arm-8914-1-nommu-fix-exc_ret-for-xip.patch
  arm64-dts-rockchip-fix-rockpro64-sdmmc-settings.patch
  arm64-dts-rockchip-fix-usb-c-on-hugsun-x99-tv-box.patch
  arm64-dts-lx2160a-correct-cpu-core-idle-state-name.patch
  arm-dts-imx6q-logicpd-re-enable-snvs-power-key.patch
  arm-dts-vf610-zii-scu4-aib-specify-i2c-mux-idle-disc.patch
  arm-dts-imx7s-correct-gpt-s-ipg-clock-source.patch
  arm64-dts-imx8mq-use-correct-clock-for-usdhc-s-ipg-c.patch
  arm64-dts-imx8mm-use-correct-clock-for-usdhc-s-ipg-c.patch
  perf-tools-fix-resource-leak-of-closedir-on-the-erro.patch
  perf-c2c-fix-memory-leak-in-build_cl_output.patch
  8250-men-mcb-fix-error-checking-when-get_num_ports-r.patch
  perf-kmem-fix-memory-leak-in-compact_gfp_flags.patch
  arm-davinci-dm365-fix-mcbsp-dma_slave_map-entry.patch
  drm-amdgpu-fix-potential-vm-faults.patch
  drm-amdgpu-fix-error-handling-in-amdgpu_bo_list_crea.patch
  scsi-target-core-do-not-overwrite-cdb-byte-1.patch
  scsi-hpsa-add-missing-hunks-in-reset-patch.patch
  asoc-intel-sof-rt5682-add-a-check-for-devm_clk_get.patch
  asoc-sof-control-return-true-when-kcontrol-values-ch.patch
  tracing-fix-gfp_t-format-for-synthetic-events.patch
  arm-dts-bcm2837-rpi-cm3-avoid-leds-gpio-probing-issu.patch
  i2c-aspeed-fix-master-pending-state-handling.patch
  drm-komeda-don-t-flush-inactive-pipes.patch
  arm-8926-1-v7m-remove-register-save-to-stack-before-.patch
  selftests-kvm-vmx_set_nested_state_test-don-t-check-.patch
  selftests-kvm-fix-sync_regs_test-with-newer-gccs.patch
  alsa-hda-add-tigerlake-jasperlake-pci-id.patch
  of-unittest-fix-memory-leak-in-unittest_data_add.patch
  mips-bmips-mark-exception-vectors-as-char-arrays.patch
  irqchip-gic-v3-its-use-the-exact-itslist-for-vmovp.patch
  i2c-mt65xx-fix-null-ptr-dereference.patch
  i2c-stm32f7-fix-first-byte-to-send-in-slave-mode.patch
  i2c-stm32f7-fix-a-race-in-slave-mode-with-arbitratio.patch
  i2c-stm32f7-remove-warning-when-compiling-with-w-1.patch
  cifs-fix-cifsinodeinfo-lock_sem-deadlock-when-reconn.patch
  irqchip-sifive-plic-skip-contexts-except-supervisor-.patch
  nbd-protect-cmd-status-with-cmd-lock.patch
  nbd-handle-racing-with-error-ed-out-commands.patch
  ata-libahci_platform-fix-regulator_get_optional-misu.patch
  cxgb4-fix-panic-when-attaching-to-uld-fail.patch
  cxgb4-request-the-tx-cidx-updates-to-status-page.patch
  dccp-do-not-leak-jiffies-on-the-wire.patch
  erspan-fix-the-tun_info-options_len-check-for-erspan.patch
  inet-stop-leaking-jiffies-on-the-wire.patch
  net-annotate-accesses-to-sk-sk_incoming_cpu.patch
  net-annotate-lockless-accesses-to-sk-sk_napi_id.patch
  net-dsa-bcm_sf2-fix-imp-setup-for-port-different-than-8.patch
  net-ethernet-ftgmac100-fix-dma-coherency-issue-with-sw-checksum.patch
  net-fix-sk_page_frag-recursion-from-memory-reclaim.patch
  net-hisilicon-fix-ping-latency-when-deal-with-high-throughput.patch
  net-mlx4_core-dynamically-set-guaranteed-amount-of-counters-per-vf.patch
  netns-fix-gfp-flags-in-rtnl_net_notifyid.patch
  net-rtnetlink-fix-a-typo-fbd-fdb.patch
  net-usb-lan78xx-disable-interrupts-before-calling-generic_handle_irq.patc=
h
  net-zeroing-the-structure-ethtool_wolinfo-in-ethtool_get_wol.patch
  selftests-net-reuseport_dualstack-fix-uninitalized-parameter.patch
  udp-fix-data-race-in-udp_set_dev_scratch.patch
  vxlan-check-tun_info-options_len-properly.patch
  net-add-skb_queue_empty_lockless.patch
  udp-use-skb_queue_empty_lockless.patch
  net-use-skb_queue_empty_lockless-in-poll-handlers.patch
  net-use-skb_queue_empty_lockless-in-busy-poll-contexts.patch
  net-add-read_once-annotation-in-__skb_wait_for_more_packets.patch
  ipv4-fix-route-update-on-metric-change.patch
  selftests-fib_tests-add-more-tests-for-metric-update.patch
  net-smc-fix-closing-of-fallback-smc-sockets.patch
  net-smc-keep-vlan_id-for-smc-r-in-smc_listen_work.patch
  keys-fix-memory-leak-in-copy_net_ns.patch
  net-phylink-fix-phylink_dbg-macro.patch
  rxrpc-fix-handling-of-last-subpacket-of-jumbo-packet.patch
  net-mlx5e-determine-source-port-properly-for-vlan-push-action.patch
  net-mlx5e-remove-incorrect-match-criteria-assignment-line.patch
  net-mlx5e-initialize-on-stack-link-modes-bitmap.patch
  net-mlx5-fix-flow-counter-list-auto-bits-struct.patch
  net-smc-fix-refcounting-for-non-blocking-connect.patch
  net-mlx5-fix-rtable-reference-leak.patch
  mlxsw-core-unpublish-devlink-parameters-during-reload.patch
  r8169-fix-wrong-phy-id-issue-with-rtl8168dp.patch
  net-mlx5e-fix-ethtool-self-test-link-speed.patch
  net-mlx5e-fix-handling-of-compressed-cqes-in-case-of-low-napi-budget.patc=
h
  ipv4-fix-ipskb_frag_pmtu-handling-with-fragmentation.patch
  net-bcmgenet-don-t-set-phydev-link-from-mac.patch
  net-dsa-b53-do-not-clear-existing-mirrored-port-mask.patch
  net-dsa-fix-switch-tree-list.patch
  net-ensure-correct-skb-tstamp-in-various-fragmenters.patch
  net-hns3-fix-mis-counting-irq-vector-numbers-issue.patch
  net-netem-fix-error-path-for-corrupted-gso-frames.patch
  net-reorder-struct-net-fields-to-avoid-false-sharing.patch
  net-usb-lan78xx-connect-phy-before-registering-mac.patch
  r8152-add-device-id-for-lenovo-thinkpad-usb-c-dock-gen-2.patch
  net-netem-correct-the-parent-s-backlog-when-corrupted-packet-was-dropped.=
patch
  net-phy-bcm7xxx-define-soft_reset-for-40nm-ephy.patch
  net-bcmgenet-soft-reset-40nm-ephys-before-mac-init.patch
  net-bcmgenet-reset-40nm-ephy-on-energy-detect.patch
  net-flow_dissector-switch-to-siphash.patch

Compile testing
---------------

We compiled the kernel for 3 architectures:

    aarch64:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    ppc64le:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg

    x86_64:
      make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg


Hardware testing
----------------
We booted each kernel and ran the following tests:

  aarch64:

    =E2=9A=A1 Internal infrastructure issues prevented one or more tests (m=
arked
    with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
    This is not the fault of the kernel that was tested.

  ppc64le:
    Host 1:
       =E2=9C=85 Boot test
       =E2=9C=85 Podman system integration test (as root)
       =E2=9C=85 Podman system integration test (as user)
       =E2=9C=85 LTP lite
       =E2=9C=85 Loopdev Sanity
       =E2=9C=85 jvm test suite
       =E2=9C=85 AMTU (Abstract Machine Test Utility)
       =E2=9C=85 LTP: openposix test suite
       =E2=9C=85 Networking bridge: sanity
       =E2=9C=85 Ethernet drivers sanity
       =E2=9C=85 Networking socket: fuzz
       =E2=9C=85 Networking sctp-auth: sockopts test
       =E2=9C=85 Networking route_func: local
       =E2=9C=85 Networking route_func: forward
       =E2=9C=85 Networking TCP: keepalive test
       =E2=9C=85 Networking UDP: socket
       =E2=9C=85 Networking tunnel: gre basic
       =E2=9C=85 Networking tunnel: vxlan basic
       =E2=9C=85 audit: audit testsuite test
       =E2=9C=85 httpd: mod_ssl smoke sanity
       =E2=9C=85 iotop: sanity
       =E2=9C=85 tuned: tune-processes-through-perf
       =E2=9C=85 ALSA PCM loopback test
       =E2=9C=85 ALSA Control (mixer) Userspace Element test
       =E2=9C=85 Usex - version 1.9-29
       =E2=9C=85 trace: ftrace/tracer
       =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
       =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites

    Host 2:
       =E2=9C=85 Boot test
       =E2=9C=85 selinux-policy: serge-testsuite
       =F0=9F=9A=A7 =E2=9C=85 Storage blktests

  x86_64:

    =E2=9A=A1 Internal infrastructure issues prevented one or more tests (m=
arked
    with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture.
    This is not the fault of the kernel that was tested.

  Test sources: https://github.com/CKI-project/tests-beaker
    =F0=9F=92=9A Pull requests are welcome for new tests or improvements to=
 existing tests!

Waived tests
------------
If the test run included waived tests, they are marked with =F0=9F=9A=A7. S=
uch tests are
executed but their results are not taken into account. Tests are waived whe=
n
their results are not reliable enough, e.g. when they're just introduced or=
 are
being fixed.

Testing timeout
---------------
We aim to provide a report within reasonable timeframe. Tests that haven't
finished running are marked with =E2=8F=B1. Reports for non-upstream kernel=
s have
a Beaker recipe linked to next to each host.

