Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8188BD0E
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 17:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfHMP2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 11:28:11 -0400
Received: from 8bytes.org ([81.169.241.247]:48928 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727404AbfHMP2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 11:28:11 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id D84F1391; Tue, 13 Aug 2019 17:28:09 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 0/3 4.19-stable] Sync mappings in vmalloc/ioremap areas
Date:   Tue, 13 Aug 2019 17:28:02 +0200
Message-Id: <20190813152805.5251-1-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Backport commits from upstream to fix a data corruption
issue that gets exposed when using PTI on x86-32.

Please consider them for inclusion into stable-4.19.

Joerg Roedel (3):
  x86/mm: Check for pfn instead of page in vmalloc_sync_one()
  x86/mm: Sync also unmappings in vmalloc_sync_all()
  mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy()

 arch/x86/mm/fault.c | 15 ++++++---------
 mm/vmalloc.c        |  9 +++++++++
 2 files changed, 15 insertions(+), 9 deletions(-)

-- 
2.16.4

