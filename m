Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8937E13DEF0
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 16:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgAPPhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 10:37:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:56784 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726744AbgAPPhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 10:37:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EC8AB6A409;
        Thu, 16 Jan 2020 15:37:42 +0000 (UTC)
Date:   Thu, 16 Jan 2020 16:37:42 +0100
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Rachel Sibley <rasibley@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Jianwen Ji <jiji@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jianlin Shi <jishi@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Subject: Re: [LTP] ??? FAIL: Test report for kernel 5.4.13-rc1-7f1b863.cki
 (stable)
Message-ID: <20200116153741.GA558@rei>
References: <cki.FA900DB853.LBD049H627@redhat.com>
 <84944fa0-3c18-f8a4-47ca-7627eb4e0594@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84944fa0-3c18-f8a4-47ca-7627eb4e0594@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!
> > One or more kernel tests failed:
> > 
> >      ppc64le:
> >       ??? LTP
> 
> Hi, I see max_map_count failed on ppc64le:
> https://artifacts.cki-project.org/pipelines/385189/logs/ppc64le_host_2_LTP_mm.run.log

That's strange, we do attempt to map 65536 mappings but we do not touch
them, so these shouldn't be faulted in, so there is no real reason why
mmap() in the child process should stop prematurely at 65532.

I guess that we cannot do much here, unless it's reproducible, because
there is not much information there.

-- 
Cyril Hrubis
chrubis@suse.cz
