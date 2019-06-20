Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2094C459
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 02:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfFTANK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 20:13:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbfFTANK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 20:13:10 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 48FF730811C7
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 00:13:10 +0000 (UTC)
Received: from [172.54.67.194] (cpt-large-cpu-02.paas.prod.upshift.rdu2.redhat.com [10.0.18.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3F0C5C205;
        Thu, 20 Jun 2019 00:13:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Stable queue: queue-5.1
Message-ID: <cki.FCB5477057.6ESDYD89JG@redhat.com>
X-Gitlab-Pipeline-ID: 12843
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 20 Jun 2019 00:13:10 +0000 (UTC)
Date:   Wed, 19 Jun 2019 20:13:10 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 5752b50477da - Linux 5.1.12

The results of these automated tests are provided below.

    Overall result: FAILED (see details below)
             Merge: FAILED




When we attempted to merge the patchset, we received an error:

  error: patch failed: net/ipv6/ip6_flowlabel.c:254
  error: net/ipv6/ip6_flowlabel.c: patch does not apply
  hint: Use 'git am --show-current-patch' to see the failed patch
  Applying: ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
  Patch failed at 0001 ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero

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
  Commit: 5752b50477da - Linux 5.1.12


We then merged the patchset with `git am`:

  netfilter-nat-fix-udp-checksum-corruption.patch
  ax25-fix-inconsistent-lock-state-in-ax25_destroy_timer.patch
  be2net-fix-number-of-rx-queues-used-for-flow-hashing.patch
  hv_netvsc-set-probe-mode-to-sync.patch
  ipv6-flowlabel-fl6_sock_lookup-must-use-atomic_inc_not_zero.patch
  lapb-fixed-leak-of-control-blocks.patch
  neigh-fix-use-after-free-read-in-pneigh_get_next.patch
  net-dsa-rtl8366-fix-up-vlan-filtering.patch
  net-openvswitch-do-not-free-vport-if-register_netdevice-is-failed.patch
  net-phylink-set-the-autoneg-state-in-phylink_phy_change.patch
  net-tls-correctly-account-for-copied-bytes-with-multiple-sk_msgs.patch
  nfc-ensure-presence-of-required-attributes-in-the-deactivate_target-handler.patch
  sctp-free-cookie-before-we-memdup-a-new-one.patch
  sunhv-fix-device-naming-inconsistency-between-sunhv_console-and-sunhv_reg.patch
  tipc-purge-deferredq-list-for-each-grp-member-in-tipc_group_delete.patch
  vsock-virtio-set-sock_done-on-peer-shutdown.patch
  net-mlx5-avoid-reloading-already-removed-devices.patch
  vxlan-don-t-assume-linear-buffers-in-error-handler.patch
  geneve-don-t-assume-linear-buffers-in-error-handler.patch
  net-mvpp2-prs-fix-parser-range-for-vid-filtering.patch
  net-mvpp2-prs-use-the-correct-helpers-when-removing-all-vid-filters.patch
  net-dsa-microchip-don-t-try-to-read-stats-for-unused-ports.patch
  net-ethtool-allow-matching-on-vlan-dei-bit.patch
  net-mlx5-update-pci-error-handler-entries-and-command-translation.patch
  mlxsw-spectrum_router-refresh-nexthop-neighbour-when-it-becomes-dead.patch
  net-mlx5e-add-ndo_set_feature-for-uplink-representor.patch
  mlxsw-spectrum_flower-fix-tos-matching.patch
  net-mlx5e-fix-source-port-matching-in-fdb-peer-flow-rule.patch
  mlxsw-spectrum_buffers-reduce-pool-size-on-spectrum-2.patch
  net-mlx5e-support-tagged-tunnel-over-bond.patch
  net-correct-udp-zerocopy-refcnt-also-when-zerocopy-only-on-append.patch
  net-mlx5e-avoid-detaching-non-existing-netdev-under-switchdev-mode.patch
  ipv6-flowlabel-fl6_sock_lookup-must-use-atomic_inc_n.patch
