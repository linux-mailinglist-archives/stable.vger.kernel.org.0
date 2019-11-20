Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F461038CB
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 12:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfKTLfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 06:35:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:55320 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727900AbfKTLfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 06:35:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4E70FBD36;
        Wed, 20 Nov 2019 11:35:35 +0000 (UTC)
Date:   Wed, 20 Nov 2019 12:35:34 +0100
From:   Cyril Hrubis <chrubis@suse.cz>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Subject: Re: [LTP] ??? FAIL: Test report for kernel 5.4.0-rc8-4b17a56.cki
 (stable-next)
Message-ID: <20191120113534.GC14963@rei.lan>
References: <cki.6D94BD5731.3IAGHB25D8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.6D94BD5731.3IAGHB25D8@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!
> One or more kernel tests failed:
> 
>     ppc64le:
>      ??? LTP lite
>      ??? xfstests: ext4

Both logs shows missing files, that may be an infrastructure problem as
well.

Also can we include links to the logfiles here? Bonus points for showing
the snippet with the actual failure in the email as well. I takes a fair
amount of time locating them manually in the pipeline repository, it
would be much much easier just with the links to the right logfile...

-- 
Cyril Hrubis
chrubis@suse.cz
