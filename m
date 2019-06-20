Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A414C458
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 02:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbfFTAM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 20:12:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35042 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbfFTAM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 20:12:58 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DFBA67EBDC
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 00:12:57 +0000 (UTC)
Received: from [172.54.67.194] (cpt-large-cpu-02.paas.prod.upshift.rdu2.redhat.com [10.0.18.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BC3951DD5;
        Thu, 20 Jun 2019 00:12:55 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   CKI Project <cki-project@redhat.com>
To:     Linux Stable maillist <stable@vger.kernel.org>
Subject: =?utf-8?b?4p2O?= FAIL: Stable queue: queue-4.19
Message-ID: <cki.7602EAEC92.HPY067VWRJ@redhat.com>
X-Gitlab-Pipeline-ID: 12842
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 20 Jun 2019 00:12:57 +0000 (UTC)
Date:   Wed, 19 Jun 2019 20:12:58 -0400
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We ran automated tests on a patchset that was proposed for merging into this
kernel tree. The patches were applied to:

       Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
            Commit: 9f31eb60d7a2 - Linux 4.19.53

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
  Commit: 9f31eb60d7a2 - Linux 4.19.53


We then merged the patchset with `git am`:

  ax25-fix-inconsistent-lock-state-in-ax25_destroy_timer.patch
  be2net-fix-number-of-rx-queues-used-for-flow-hashing.patch
  hv_netvsc-set-probe-mode-to-sync.patch
  ipv6-flowlabel-fl6_sock_lookup-must-use-atomic_inc_not_zero.patch
  lapb-fixed-leak-of-control-blocks.patch
  neigh-fix-use-after-free-read-in-pneigh_get_next.patch
  net-dsa-rtl8366-fix-up-vlan-filtering.patch
  net-openvswitch-do-not-free-vport-if-register_netdevice-is-failed.patch
  net-phylink-set-the-autoneg-state-in-phylink_phy_change.patch
  nfc-ensure-presence-of-required-attributes-in-the-deactivate_target-handler.patch
  sctp-free-cookie-before-we-memdup-a-new-one.patch
  sunhv-fix-device-naming-inconsistency-between-sunhv_console-and-sunhv_reg.patch
  tipc-purge-deferredq-list-for-each-grp-member-in-tipc_group_delete.patch
  vsock-virtio-set-sock_done-on-peer-shutdown.patch
  net-mlx5-avoid-reloading-already-removed-devices.patch
  net-mvpp2-prs-fix-parser-range-for-vid-filtering.patch
  net-mvpp2-prs-use-the-correct-helpers-when-removing-all-vid-filters.patch
  ipv6-flowlabel-fl6_sock_lookup-must-use-atomic_inc_n.patch
