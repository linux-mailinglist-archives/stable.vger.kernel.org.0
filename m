Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 715D02FEA3
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 16:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfE3Oza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 10:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbfE3Oza (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 10:55:30 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C934C25BC5;
        Thu, 30 May 2019 14:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559228129;
        bh=TS9d5DJNY8xbptivYe8XCLfmw2NQ5yz/UxTnwmTfuwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1X5lAJ0vayXqpK7ep/vTQNr/OeBXy2XAz4u7qYZKRJVIGzKzG0gpXAu3co10v6G4o
         vbD1XdviICM/IoRoFQZFjO4WA68dqlcEYBDFjyiIpg/LKcjNK8l72b5kD0cnd24UB5
         uqpYxjLXJM/Fv4sjvx2q1cT906jbHXYIPS38JLVk=
Date:   Thu, 30 May 2019 07:55:29 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 4.19.47-rc1-011862f.cki (stable)
Message-ID: <20190530145529.GA28396@kroah.com>
References: <cki.7068F1D41D.IXWVR9HG1P@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cki.7068F1D41D.IXWVR9HG1P@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 12:08:51AM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>             Commit: 9c8c1a222a6b - Linux 4.19.47-rc1
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
> 
> 
> One or more kernel tests failed:
> 
>   aarch64:
>     ❎ Boot test

Is this something to worry about?

thanks,

greg k-h
