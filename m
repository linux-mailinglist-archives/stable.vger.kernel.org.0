Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBA33DB5DD
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 11:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238183AbhG3J0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 05:26:30 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56684 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbhG3J0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 05:26:30 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 35F4F22403;
        Fri, 30 Jul 2021 09:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627637185; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=KLOQ45tHzHizx5aX7vlKbtwG56MywBepSJB+3y/J3Tc=;
        b=uyzDER+QUurfThKtVP3oER06ju28BMg5KqItSY0E+H65vbfhfpNK3fN+FNbupsalv+jkdT
        XgFWGeSve/iCGZYPrH9Ut2yJUEYs3LUabKIEeTJn8FIo95mdeigRzq1ca5jS8aPtZRDwIO
        CKYPoNU7bo2W+ywawr0yXSnK6NYOYeU=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id D541313748;
        Fri, 30 Jul 2021 09:26:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id G5/PMsDFA2GeIwAAGKfGzw
        (envelope-from <jgross@suse.com>); Fri, 30 Jul 2021 09:26:24 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: [PATCH v2 0/2] xen: fix max_pfn handling for pv guests
Date:   Fri, 30 Jul 2021 11:26:20 +0200
Message-Id: <20210730092622.9973-1-jgross@suse.com>
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
 arch/x86/xen/p2m.c              | 33 ++++++++++++++++++---------------
 arch/x86/xen/setup.c            |  2 +-
 3 files changed, 21 insertions(+), 18 deletions(-)

-- 
2.26.2

