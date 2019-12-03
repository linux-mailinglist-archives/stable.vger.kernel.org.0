Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDBD10FDAE
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 13:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfLCMcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 07:32:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:47038 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726074AbfLCMcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 07:32:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 40725ABB1;
        Tue,  3 Dec 2019 12:32:06 +0000 (UTC)
Date:   Tue, 3 Dec 2019 13:32:05 +0100
From:   Cyril Hrubis <chrubis@suse.cz>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Subject: Re: [LTP] ??? FAIL: Test report for kernel 5.3.14-d6885f7.cki
 (stable-queue)
Message-ID: <20191203123205.GE2844@rei>
References: <cki.37B8559E6E.L9FDDMGAEJ@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.37B8559E6E.L9FDDMGAEJ@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
>             Commit: d6885f794222 - i40e: Fix for ethtool -m issue on X722 NIC
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
> 
> All kernel binaries, config files, and logs are available for download here:
> 
>   https://artifacts.cki-project.org/pipelines/319850
> 
> One or more kernel tests failed:
> 
>     ppc64le:
>      ??? LTP

This is another ppc64le failure on a driver commit, my guess is that
something is corrupting memory on ppc64le which trips on random commits
and random tests.

-- 
Cyril Hrubis
chrubis@suse.cz
