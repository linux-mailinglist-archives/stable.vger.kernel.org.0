Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D34618CCF2
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 12:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCTLZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 07:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbgCTLZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 07:25:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79AEA20784;
        Fri, 20 Mar 2020 11:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584703557;
        bh=AhAOPcMykzQvSYo14JP+93c/cXud2MuMQnH/btDCl4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C/dihEo1ABKbpClWDQWtsHzFRkFH/N1SMzBA+WUSdlp9P+MXRt47fU/38FcLZmB2m
         TjrXkl1080Bch3ZJg0YsrMV7yjS4GbWN/gAzjH/vHnkvC5dcP6cheAnldeZ3KhvsM+
         +LAHsYZ2m8DggMy+rM6qHkJW+9BkYtjfv9LgqFIY=
Date:   Fri, 20 Mar 2020 12:25:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.5.11-rc1-e9842f9.cki (stable)
Message-ID: <20200320112555.GA486174@kroah.com>
References: <cki.28F54CE28E.1MI2V6WHXV@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.28F54CE28E.1MI2V6WHXV@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 20, 2020 at 11:04:10AM -0000, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>             Commit: e9842f9e58e1 - Linux 5.5.11-rc1
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: FAILED

Odd, you caught the tree when I knew it was broken, oh well, should be
fixed now...


