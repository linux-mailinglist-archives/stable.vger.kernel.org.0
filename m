Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AFD3AA729
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 01:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhFPXEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 19:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhFPXEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 19:04:54 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D69C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 16:02:46 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so4241778otl.3
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 16:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version;
        bh=Lye0Mgp/HjuvXt0IdKZV88h5bOqFEpa8BW0zYPLSUAY=;
        b=vUfo5C1HkAGpLwMmyiUQFSmVisU6lpiHvJh0z8BG3si+I9SiY5huf8ajctOCaqGHaA
         Ll0a0OW6dZ2dG/ixYAcKlXDZfWHThLp68u3fvZzlA/cExBVF8172UCaDQq5WioRZTp7x
         DYVMYgoNPRDnVzkUFSKJ+w8rNhHq69W25H+qpuR2wgDczI/S8CyW7Pqs/NYn03GNBqiN
         3bqPZDP1MwTi6fauFi5NhduUytuyPWYBPfnnDiLnQ731rRBn6BRzUdQkBhNQinVnBPjE
         UZlGT2KlbFK7zeJSOHrjRtlr9ErYdLscMN7VCKi2gv9tyT4iMVGCAm23WQ0zfz50dnWU
         cAgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version;
        bh=Lye0Mgp/HjuvXt0IdKZV88h5bOqFEpa8BW0zYPLSUAY=;
        b=SkHI3j6PBnhOWJ6d7+k4/S0A1kkMRYDhAdgddpPzV0Lvx88LSpgu9Ovx7EdrfignUj
         3x2kiacyjJALcXD1e0B61plqYFZiC5TlmV1Of8crs/sSf6S9qzT2+weEhsDNwz+9C192
         jhfo+8SKOf+i8IjwcYKcXm1jqgs08ZkxgbnS+RIaA/TM5Mw77iiRybcdWL4ARG3474Sc
         eTv2WncuPKMGbZNeXJSGKXAA9XZeyksa7HsywBtP0xY6EjFX7wZpr6+bSlnpl43yOHOW
         kO+5WnICAdFJlboFcxaVXN1xJkOMOiW79D375veE5qSGAQ18IQAGT4WSyucNwtqxJLvJ
         ilYw==
X-Gm-Message-State: AOAM5307lj60Dso+5ijbsh9PXmajGouy0+/XQVNl/p2AnxCdFTh6JRDl
        Kf5a0Nve8yG53u9KLVCCBdssKA==
X-Google-Smtp-Source: ABdhPJzHER2nMLTRFV1IliO73gpBmWRNIwkqHB9VjGw/IYORSfBsUpJF3595SATt1BaeAYACkMh1tw==
X-Received: by 2002:a9d:2aa4:: with SMTP id e33mr1830585otb.330.1623884565777;
        Wed, 16 Jun 2021 16:02:45 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id u15sm782926ooq.24.2021.06.16.16.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 16:02:45 -0700 (PDT)
Date:   Wed, 16 Jun 2021 16:02:32 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Xu Yu <xuyu@linux.alibaba.com>, Jue Wang <juew@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Hugh Dickins <hughd@google.com>, stable@vger.kernel.org
Subject: mm/thp commits: please wait a few days
Message-ID: <88937026-b998-8d9b-7a23-ff24576491f4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Linus has taken in a group of mm/thp commits Cc stable today:

504e070dc08f mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split
22061a1ffabd mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()
31657170deaf mm/thp: fix page_address_in_vma() on file THP tails
494334e43c16 mm/thp: fix vma_address() if virtual address below file offset
732ed55823fc mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
3b77e8c8cde5 mm/thp: make is_huge_zero_pmd() safe and quicker
99fa8a48203d mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
ffc90cbb2970 mm, thp: use head page in __migration_entry_wait()

and I expect some more to follow in a few days time (thanks Andrew).

No problem with the commits themselves, but I'm aware that some of them
have dependencies on other commits not yet in stable, which I have to
sort out for you now.

I'd prefer to avoid a deluge of "does not apply" messages, so ask you
please to hold off trying to merge these into stable trees for a few days:
I'll get back to you with what's needed for them to apply.

Thanks,
Hugh
