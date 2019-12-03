Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34FD10F7EF
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 07:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfLCGlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 01:41:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbfLCGlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 01:41:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCA1C206DF;
        Tue,  3 Dec 2019 06:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575355304;
        bh=qMuj5cgIyZLiZwDa2azGWSuf3/RSlu2bWI2PuW4DtSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j1v/ehhKMcxzHyk943lU9wYre6b3OBlI3nmSY8reHWkdD3P2aS/GJT4uQ6rzK7rgL
         NUlCqUYlDaGDrpA5kIXBp3CL7PAsXsV9gCp4+a8TJ/Jevxev4JlEhHwEKjeem1WYTL
         XTWJVBG2UpX/EH0uxh5PzLSZqVhfqN+SJ8Uvg64I=
Date:   Tue, 3 Dec 2019 07:40:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amol Grover <frextrite@gmail.com>
Cc:     stable@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [STABLE TEST] 5.3.13
Message-ID: <20191203064052.GA1788679@kroah.com>
References: <20191203062503.GA3467@workstation-kernel-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203062503.GA3467@workstation-kernel-dev>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 11:55:03AM +0530, Amol Grover wrote:
> Compiled, Booted, however I'm getting the following errors when running
> "make kselftest"
> 
> sudo dmesg -l alert
> 
> [34381.903893] BUG: kernel NULL pointer dereference, address: 0000000000000008
> [34381.903904] #PF: supervisor read access in kernel mode
> [34381.903908] #PF: error_code(0x0000) - not-present page

Which test causes this problem?

ANd is it new in 5.3.13?

thanks,

greg k-h
