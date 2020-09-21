Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E585272461
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgIUMzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726644AbgIUMy7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:54:59 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E162221D7A;
        Mon, 21 Sep 2020 12:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692899;
        bh=Vc6rMCqCkpc10FhLC2rKcAKjONMeYhLUnC5nuRWW5m4=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=0FwRHOr4VraeDMjs4xiIqy6vcVbcg4dGRN+PbX128RPJUsSX3WSY2Fd7ZVlmNqe0A
         ddlisDWaL64SPA7zEdqYSdPgED4WtEjVSfUZbFBShkGPI/Nnyq0sE5qszEQ+9Z/OjH
         WnBiBm/WE+ch2pfpYWFI5fWX6cP/XaTxCxfCo9RQ=
Date:   Mon, 21 Sep 2020 12:54:58 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Vijay Balakrishna <vijayb@linux.microsoft.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [v2 2/2] mm: khugepaged: avoid overriding min_free_kbytes set by user
In-Reply-To: <1600204258-13683-2-git-send-email-vijayb@linux.microsoft.com>
References: <1600204258-13683-2-git-send-email-vijayb@linux.microsoft.com>
Message-Id: <20200921125458.E162221D7A@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.10, v5.4.66, v4.19.146, v4.14.198, v4.9.236, v4.4.236.

v5.8.10: Build OK!
v5.4.66: Build OK!
v4.19.146: Build OK!
v4.14.198: Build OK!
v4.9.236: Build OK!
v4.4.236: Failed to apply! Possible dependencies:
    0b57d6ba0bd1 ("mm/mmap.c: remove redundant local variables for may_expand_vm()")
    1170532bb49f ("mm: convert printk(KERN_<LEVEL> to pr_<level>")
    5a6e75f8110c ("shmem: prepare huge= mount option and sysfs knob")
    756a025f0009 ("mm: coalesce split strings")
    84638335900f ("mm: rework virtual memory accounting")
    8cee852ec53f ("mm, procfs: breakdown RSS for anon, shmem and file in /proc/pid/status")
    b46e756f5e47 ("thp: extract khugepaged from mm/huge_memory.c")
    d07e22597d1d ("mm: mmap: add new /proc tunable for mmap_base ASLR")
    d977d56ce5b3 ("mm: warn about VmData over RLIMIT_DATA")
    d9fe4fab1197 ("x86/mm/pat: Add untrack_pfn_moved for mremap")
    eca56ff906bd ("mm, shmem: add internal shmem resident memory accounting")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
