Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBEFE16C08B
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 13:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgBYMPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 07:15:47 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:18426 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbgBYMPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 07:15:46 -0500
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 25 Feb 2020 04:15:43 -0800
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 021A7405C3;
        Tue, 25 Feb 2020 04:15:38 -0800 (PST)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <willy@infradead.org>,
        <jannh@google.com>, <vbabka@suse.cz>, <will.deacon@arm.com>,
        <punit.agrawal@arm.com>, <steve.capper@arm.com>,
        <kirill.shutemov@linux.intel.com>,
        <aneesh.kumar@linux.vnet.ibm.com>, <catalin.marinas@arm.com>,
        <n-horiguchi@ah.jp.nec.com>, <mark.rutland@arm.com>,
        <mhocko@suse.com>, <mike.kravetz@oracle.com>,
        <akpm@linux-foundation.org>, <mszeredi@redhat.com>,
        <viro@zeniv.linux.org.uk>, <stable@vger.kernel.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <amakhalov@vmware.com>, <srinidhir@vmware.com>,
        <bvikas@vmware.com>, <anishs@vmware.com>, <vsirnapalli@vmware.com>,
        <sharathg@vmware.com>, <srostedt@vmware.com>, <akaher@vmware.com>
Subject: [PATCH v4 v4.4.y 0/7] Backported fixes for 4.4 stable tree
Date:   Wed, 26 Feb 2020 01:46:07 +0530
Message-ID: <1582661774-30925-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Received-SPF: None (EX13-EDG-OU-002.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Posting again after correcting CC’ed e-mail id]

These patches include few backported fixes for the 4.4 stable
tree.
I would appreciate if you could kindly consider including them in the
next release.

Ajay

---

[Changes from v3]:
- Dropped [Patch v3 8/8] [2] as patches 1-7 are independent from patch 8
  and patch 8 may require more work.

[Changes from v2]:
Merged following changes from Vlastimil's series [1]:
- Added page_ref_count() in [Patch v3 5/8]
- Added missing refcount overflow checks on x86 and s390 [Patch v3 5/8]
- Added [Patch v3 8/8]
- Removed 7aef4172c795 i.e. [Patch v2 3/8]

[1] https://lore.kernel.org/stable/20191108093814.16032-1-vbabka@suse.cz/
[2] https://lore.kernel.org/stable/1576529149-14269-9-git-send-email-akaher@vmware.com/
---

[PATCH v4 1/7]:
Backporting of upstream commit f958d7b528b1:
mm: make page ref count overflow check tighter and more explicit

[PATCH v4 2/7]:
Backporting of upstream commit 88b1a17dfc3e:
mm: add 'try_get_page()' helper function

[PATCH v4 3/7]:
Backporting of upstream commit a3e328556d41:
mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages

[PATCH v4 4/7]:
Backporting of upstream commit d63206ee32b6:
mm, gup: ensure real head page is ref-counted when using hugepages

[PATCH v4 5/7]:
Backporting of upstream commit 8fde12ca79af:
mm: prevent get_user_pages() from overflowing page refcount

[PATCH v4 6/7]:
Backporting of upstream commit 7bf2d1df8082:
pipe: add pipe_buf_get() helper

[PATCH v4 7/7]:
Backporting of upstream commit 15fab63e1e57:
fs: prevent page refcount overflow in pipe_buf_get

