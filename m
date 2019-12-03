Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B94A10FD83
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 13:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfLCMWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 07:22:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:42572 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbfLCMWj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 07:22:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C9801B193;
        Tue,  3 Dec 2019 12:22:37 +0000 (UTC)
Date:   Tue, 3 Dec 2019 13:22:37 +0100
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Rachel Sibley <rasibley@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Subject: Re: [LTP] ??? FAIL: Test report for kernel 5.3.13-cc9917b.cki
 (stable-queue)
Message-ID: <20191203122236.GC2844@rei>
References: <cki.B4696121A3.SRVKVUGWT3@redhat.com>
 <546bd6ac-8ab1-9a9b-5856-e6410fb8ee89@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546bd6ac-8ab1-9a9b-5856-e6410fb8ee89@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!
> > We ran automated tests on a recent commit from this kernel tree:
> > 
> >         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
> >              Commit: cc9917b40848 - mdio_bus: Fix init if CONFIG_RESET_CONTROLLER=n
> > 
> > The results of these automated tests are provided below.
> > 
> >      Overall result: FAILED (see details below)
> >               Merge: OK
> >             Compile: OK
> >               Tests: FAILED
> > 
> > All kernel binaries, config files, and logs are available for download here:
> > 
> >    https://artifacts.cki-project.org/pipelines/309848
> > 
> > One or more kernel tests failed:
> > 
> >      ppc64le:
> >       ??? LTP
> 
> I see a slew of syscalls failures here for LTP:
> https://artifacts.cki-project.org/pipelines/309848/logs/ppc64le_host_1_LTP_resultoutputfile.log
> https://artifacts.cki-project.org/pipelines/309848/logs/ppc64le_host_1_LTP_syscalls.run.log

There are a few syslog failures, which does not seem to be related to
the kernel commit at all. The commit above seems to touch error handling
in a mdio bus which is used to configure network hardware. I would say
that this is connected to the rest of the unexplained failures on
ppc64le that seems to happen randomly.

-- 
Cyril Hrubis
chrubis@suse.cz
