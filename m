Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C971B7176
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 12:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgDXKFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 06:05:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDXKFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 06:05:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AF692071E;
        Fri, 24 Apr 2020 10:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587722722;
        bh=JumVcDKH4EzQAUpWonS8V5ig3D0xLHACTv0XnomERnc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nF7VKFJJdjQTvyOTdgSLqxk0rG7NOPBH62rsty8CurnjDPlyebLd+pEDdN/12fxCV
         qewIjgpNp/Az2Jmv9yN/TfBK1q5qR4PWLe5INQjIs/Uz8oT/3Y/q3rkFQ8FIp19FAC
         hAdaLYAOeDURMQ9zQH4xiWhpyb4EvurRQ87pWeNg=
Date:   Fri, 24 Apr 2020 12:05:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [5.4] f2fs: fix to avoid memory leakage in f2fs_listxattr
Message-ID: <20200424100519.GA381429@kroah.com>
References: <9a4108b50032eb2ae22d3a136fbb74cacd47c60b.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a4108b50032eb2ae22d3a136fbb74cacd47c60b.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 09:14:18PM +0100, Ben Hutchings wrote:
> Please pick:
> 
> commit 688078e7f36c293dae25b338ddc9e0a2790f6e06
> Author: Randall Huang <huangrandall@google.com>
> Date:   Fri Oct 18 14:56:22 2019 +0800
> 
>     f2fs: fix to avoid memory leakage in f2fs_listxattr
> 
> for the 5.4-stable branch.  It's also needed for earlier branches, but
> needs adjustment so I will send a backport later.

Now queued up, thanks.

greg k-h
