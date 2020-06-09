Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066D61F3461
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 08:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgFIGvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 02:51:05 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:4711 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727892AbgFIGvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 02:51:04 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 8 Jun 2020 23:51:02 -0700
Received: from vikash-ubuntu-virtual-machine.eng.vmware.com (unknown [10.197.103.194])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 75837B12E0;
        Tue,  9 Jun 2020 02:51:03 -0400 (EDT)
From:   Vikash Bansal <bvikas@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>, <amakhalov@vmware.com>,
        <srinidhir@vmware.com>, <bvikas@vmware.com>, <anishs@vmware.com>,
        <vsirnapalli@vmware.com>, <akaher@vmware.com>, <clm@fb.com>,
        <josef@toxicpanda.com>, <dsterba@suse.com>,
        <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4.19.y 0/2] btrfs: Fix for CVE-2019-18885
Date:   Tue, 9 Jun 2020 12:20:16 +0530
Message-ID: <20200609065018.26378-1-bvikas@vmware.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: bvikas@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CVE Description:
NVD Site Link: https://nvd.nist.gov/vuln/detail?vulnId=CVE-2019-18885

It was discovered that the btrfs file system in the Linux kernel did not
properly validate metadata, leading to a NULL pointer dereference. An
attacker could use this to specially craft a file system image that, when
mounted, could cause a denial of service (system crash).

[PATCH v4.19.y 1/2]:
Backporting of upsream commit 09ba3bc9dd15:
btrfs: merge btrfs_find_device and find_device

[PATCH v4.19.y 2/2]:
Backporting of upstream commit 62fdaa52a3d0:
btrfs: Detect unbalanced tree with empty leaf before crashing

On NVD site link of "commit 09ba3bc9dd150457c506e4661380a6183af651c1" 
was given as the fix for this CVE. But the issue was still reproducible.
So had to apply patch "Commit 62fdaa52a3d00a875da771719b6dc537ca79fce1"
to fix the issue.
