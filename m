Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB46134F1E1
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 21:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhC3T56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 15:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233239AbhC3T5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 15:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D95D619B9;
        Tue, 30 Mar 2021 19:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617134272;
        bh=amnJwNIWJp7JD/MafLfec5USWg68cXSzVyaFBlWgleg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ulIrPBc+d6yWdFT/4iQRhxee5h9KgBpehdTWbPzo39MZ6v4vGddHXIy+1k+USTNSp
         6CLPVhILfAbod++YPFyD7wHb/Hq7MJjXmI4UrvIKyrYAH12/xbMeatVltbOTmoQbLF
         6np/QkmCSehWjjYcvhzo6jR090GZDxUCddD+C5EE=
Date:   Tue, 30 Mar 2021 21:57:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Patrick Mccormick <pmccormick@digitalocean.com>
Cc:     stable@vger.kernel.org
Subject: Re: stable/linux-5.10.y - 5.10.27
Message-ID: <YGOCvMzJmgAhUYJb@kroah.com>
References: <CAAjnzA=2AwmEfPVKb9qo2LyzhZnF5orb3DGubTy2dc0hbQBXVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAjnzA=2AwmEfPVKb9qo2LyzhZnF5orb3DGubTy2dc0hbQBXVQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 30, 2021 at 12:14:01PM -0700, Patrick Mccormick wrote:
> JOB ID     : 29cbaf7acada1e4b67b23f0841955606b597319a
> 
> JOB LOG    : /home/ci-hypervisor/avocado/job-results/job-2021-03-30T18.59-29cbaf7/job.log
> 
>  (1/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_nptl:
>  PASS (6.21 s)
> 
>  (2/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_math:
>  PASS (2.01 s)
> 
>  (3/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_hugetlb:
>  PASS (0.08 s)
> 
>  (4/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_ipc:
>  PASS (20.08 s)
> 
>  (5/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_uevent:
>  PASS (0.06 s)
> 
>  (6/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_containers:
>  PASS (36.90 s)
> 
>  (7/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_filecaps:
>  PASS (0.11 s)
> 
>  (8/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/ltp.py:LTP.test_hyperthreading:
>  PASS (71.20 s)
> 
>  (9/9) /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/kpatch.sh:
>  PASS (13.63 s)
> 
> RESULTS    : PASS 9 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT 0
> | CANCEL 0

Any hints as to what all of this means?

thanks,

greg k-h
