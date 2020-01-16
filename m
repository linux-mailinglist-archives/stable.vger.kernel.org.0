Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D155613DF81
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgAPQCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:02:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:45978 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgAPQCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:02:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 44899B25FB;
        Thu, 16 Jan 2020 16:02:45 +0000 (UTC)
Date:   Thu, 16 Jan 2020 17:02:44 +0100
From:   Cyril Hrubis <chrubis@suse.cz>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Jianwen Ji <jiji@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jianlin Shi <jishi@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        William Gomeringer <wgomeringer@redhat.com>
Subject: Re: [LTP] ??? FAIL: Test report for kernel 5.4.12-rc1-5c903e1.cki
 (stable)
Message-ID: <20200116160244.GC558@rei>
References: <cki.04B50782AB.76013V5U5A@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.04B50782AB.76013V5U5A@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!
This looks like max_map_count failure again.

...
<<<test_output>>>
tst_test.c:1215: INFO: Timeout per run is 0h 05m 00s
mem.c:817: INFO: set overcommit_memory to 2
mem.c:817: INFO: set max_map_count to 1024
max_map_count.c:198: PASS: 1024 map entries in total as expected.
mem.c:817: INFO: set max_map_count to 2048
max_map_count.c:198: PASS: 2048 map entries in total as expected.
mem.c:817: INFO: set max_map_count to 4096
max_map_count.c:198: PASS: 4096 map entries in total as expected.
mem.c:817: INFO: set max_map_count to 8192
max_map_count.c:198: PASS: 8192 map entries in total as expected.
mem.c:817: INFO: set max_map_count to 16384
max_map_count.c:198: PASS: 16384 map entries in total as expected.
mem.c:817: INFO: set max_map_count to 32768
max_map_count.c:198: PASS: 32768 map entries in total as expected.
mem.c:817: INFO: set max_map_count to 65536
max_map_count.c:201: FAIL: 65273 map entries in total, but expected 65536 entries
mem.c:817: INFO: set max_map_count to 1024
max_map_count.c:198: PASS: 1024 map entries in total as expected.
...

-- 
Cyril Hrubis
chrubis@suse.cz
