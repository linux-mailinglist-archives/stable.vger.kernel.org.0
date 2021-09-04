Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF25400949
	for <lists+stable@lfdr.de>; Sat,  4 Sep 2021 04:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhIDCVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 22:21:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:3609 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231389AbhIDCVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 22:21:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10096"; a="217703033"
X-IronPort-AV: E=Sophos;i="5.85,267,1624345200"; 
   d="scan'208";a="217703033"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 19:20:34 -0700
X-IronPort-AV: E=Sophos;i="5.85,267,1624345200"; 
   d="scan'208";a="534516983"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 19:20:34 -0700
Subject: [PATCH 0/6] cxl fixes for v5.15-rc1
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     Ben Widawsky <ben.widawsky@intel.com>,
        Paul Moore <paul@paul-moore.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Alison Schofield <alison.schofield@intel.com>,
        "Li Qiang \(Johnny Li\)" <johnny.li@montage-tech.com>,
        ben.widawsky@intel.com, Jonathan.Cameron@huawei.com
Date:   Fri, 03 Sep 2021 19:20:33 -0700
Message-ID: <163072203373.2250120.8373702699578427249.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Given the decision to delay cxl_test and some of the related reworks to
the next merge window, here are the broken out fixes that will be
appended to the base-commit noted below. Changes from previous posting
include:

- "cxl/acpi: Do not add DSDT disabled ACPI0016 host bridge ports": Add a
  comment about when acpi_pci_find_root() is known to not fail
  (Jonathan)

- Fix lockdown reason in cxl_mem_raw_command_allowed() (Ondrej)

- Pick up, with small change log tweaks, Ben's defined, but not used patch

- Fix some 'make docs' warnings (Ben)

---

Alison Schofield (1):
      cxl/acpi: Do not add DSDT disabled ACPI0016 host bridge ports

Ben Widawsky (1):
      cxl/uapi: Fix defined but not used warnings

Dan Williams (3):
      cxl/pci: Fix lockdown level
      cxl/pmem: Fix Documentation warning
      cxl/registers: Fix Documentation warning

Li Qiang (Johnny Li) (1):
      cxl/pci: Fix debug message in cxl_probe_regs()


 Documentation/driver-api/cxl/memory-devices.rst |    4 ++-
 drivers/cxl/acpi.c                              |   12 ++++++---
 drivers/cxl/core/pmem.c                         |   30 +++++++++++++++++++++--
 drivers/cxl/core/regs.c                         |   15 +++++++++++-
 drivers/cxl/pci.c                               |    6 ++---
 include/uapi/linux/cxl_mem.h                    |    2 +-
 6 files changed, 56 insertions(+), 13 deletions(-)

base-commit: 00ca683e618065e2375b49c91002384735c76d41
