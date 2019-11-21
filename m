Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C25F5105B0C
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 21:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfKUUVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 15:21:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbfKUUVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 15:21:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3746420672;
        Thu, 21 Nov 2019 20:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574367666;
        bh=HgxTSBNdBflEaa2mhxi0rIBzCeKSbmDGPn7oUaS9/jw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qZETbOGrs6HkcD335esHHSk5upUtshvkNT3XL3+bGIsebnSyLJlSLxpba4mRB/6K/
         hLPYK1DtXbTgqj1vvzIkvrNbQnIa3A49cQWA4U7zTTZV8xxorjSM+iFjuP4EmuL8/Z
         OYyaXHKsDbOqTfUOoTkWf6lGFLp8DlnGQaPVn9Ro=
Date:   Thu, 21 Nov 2019 21:21:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
Cc:     stable@vger.kernel.org, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: Linux 5.3.12 BOOT TEST: Compiled, Booted, everything OK.
Message-ID: <20191121202104.GA812038@kroah.com>
References: <a02e01c5-635f-60c3-9d27-6c13abda8ffa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a02e01c5-635f-60c3-9d27-6c13abda8ffa@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 21, 2019 at 03:55:34PM -0300, Daniel W. S. Almeida wrote:
> ~ 2hr uptime: no crashes, no new errors on dmesg, everything looks good.

Thanks for testing.

> *This pops up after diffing the output of kselftest though:*
> 
> < # ./reuseport_bpf: Unable to open tcp_fastopen sysctl for writing:
> Permission denied
> ---
> > # ./reuseport_bpf: ebpf error. log:
> > # 0: (bf) r6 = r1
> > # 1: (20) r0 = *(u32 *)skb[0]
> > # 2: (97) r0 %= 10
> > # 3: (95) exit
> > # processed 4 insns (limit 1000000) max_states_per_insn 0 total_states 0
> peak_states 0 mark_read 0
> > #
> > # : Operation not permitted
> 
> I did not run kselftest as root. I assume it is nothing noteworthy?

Is this a new issue, or has it always been there?

thanks,

greg k-h
