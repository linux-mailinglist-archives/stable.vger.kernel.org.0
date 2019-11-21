Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C407B104F3F
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 10:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKUJbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 04:31:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:56666 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726541AbfKUJbx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 04:31:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4303EAE39;
        Thu, 21 Nov 2019 09:31:52 +0000 (UTC)
Date:   Thu, 21 Nov 2019 10:31:50 +0100
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Rachel Sibley <rasibley@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        LTP Mailing List <ltp@lists.linux.it>
Subject: Re: [LTP] ??? FAIL: Test report for kernel 5.4.0-rc8-4b17a56.cki
 (stable-next)
Message-ID: <20191121093150.GA14186@rei.lan>
References: <cki.6D94BD5731.3IAGHB25D8@redhat.com>
 <20191120113534.GC14963@rei.lan>
 <57f8e29e-1d49-e93f-2b03-75a3fd3e6e21@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57f8e29e-1d49-e93f-2b03-75a3fd3e6e21@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!
> >> One or more kernel tests failed:
> >>
> >>      ppc64le:
> >>       ??? LTP lite
> >>       ??? xfstests: ext4
> > 
> > Both logs shows missing files, that may be an infrastructure problem as
> > well.
> > 
> > Also can we include links to the logfiles here? Bonus points for showing
> > the snippet with the actual failure in the email as well. I takes a fair
> > amount of time locating them manually in the pipeline repository, it
> > would be much much easier just with the links to the right logfile...
> > 
> 
> Thanks for the feedback Cyril, we did have links to each failure listed
> before but we were told it made the email look cluttered especially
> if there are multiple failures.

So it's exactly how Dmitry described it, you can't please everyone..,

> The test logs are sorted by arch|host|TC, is there something we can
> do to make it easier to find related logs ?
> https://artifacts.cki-project.org/pipelines/296781/logs/
> 
> Maybe we can look into adding the linked logs to the bottom of the
> email with a reference id next to the failures in the summary, so
> for example:
> 
>      ppc64le:
>       ??? LTP lite [1]
>       ??? xfstests: ext4 [2]

That would work for me.

> We could also look into merging the ltp run logs into a single file
> as well.

That would make it too big I guess. Actually the only part I'm
interested in most of the time is the part of the log with the failing
test. I would be quite happy if we had logs/failures file on the
pipelines sever that would contain only failures extracted from
different logfiles. The question is if that's feasible with your
framework.

-- 
Cyril Hrubis
chrubis@suse.cz
