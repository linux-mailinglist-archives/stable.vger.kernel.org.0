Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE873A93E9
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 09:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhFPHcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 03:32:19 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58394 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbhFPHcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 03:32:16 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 538CE1FD47;
        Wed, 16 Jun 2021 07:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623828610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ZIhury5ftO1rCyrI+1BJ+XupQSloUA5hjiMSaC8bUjc=;
        b=ucl+Y4z0TKifrQyD9WE/MlO6t3brYmjm8sEy7S2xiYkp9TKMEnNQoia7hROaajuttppBMM
        To/W7nAXMyuWTS0lz7aUfTW/F1lReXMCZAKCuFhIklT7Kjn/6peAFR9Ao0idHpnKbM7inl
        UTV9wIFj38OuUamOxFEy6iYkjsQaCJM=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 0658A118DD;
        Wed, 16 Jun 2021 07:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623828610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ZIhury5ftO1rCyrI+1BJ+XupQSloUA5hjiMSaC8bUjc=;
        b=ucl+Y4z0TKifrQyD9WE/MlO6t3brYmjm8sEy7S2xiYkp9TKMEnNQoia7hROaajuttppBMM
        To/W7nAXMyuWTS0lz7aUfTW/F1lReXMCZAKCuFhIklT7Kjn/6peAFR9Ao0idHpnKbM7inl
        UTV9wIFj38OuUamOxFEy6iYkjsQaCJM=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id S9dVO4GoyWBfZAAALh3uQQ
        (envelope-from <jgross@suse.com>); Wed, 16 Jun 2021 07:30:09 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: [PATCH 0/2] xen: fix max_pfn handling for pv guests
Date:   Wed, 16 Jun 2021 09:30:05 +0200
Message-Id: <20210616073007.5215-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix some bad naming and setting of max_pfn related variables.

Juergen Gross (2):
  xen: fix setting of max_pfn in shared_info
  xen: rename wrong named pfn related variables

 arch/x86/include/asm/xen/page.h |  4 ++--
 arch/x86/xen/p2m.c              | 31 ++++++++++++++++---------------
 arch/x86/xen/setup.c            |  2 +-
 3 files changed, 19 insertions(+), 18 deletions(-)

-- 
2.26.2

