Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFF42DEECE
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgLSMlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:41:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbgLSMlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:41:20 -0500
Date:   Sat, 19 Dec 2020 13:42:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608381640;
        bh=2HJ8DjQmIdM/0FvBHgfOF+DuRG/itKebLF313rjjt0A=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=XC7zzONAUPILfmqbeEfvN9+dk5AalwthO8JbnFjhrTxu0sAzxheVmILssSZNW7mu2
         9Nre01wIJE/WEiXYQjVIsR/y3bTFS/KzQbTRruMwJoF5uU4cM8QZdtEOQcOqfYNb6N
         UGbhS7u2fRa31KcqNwLOS55HIFXsDVna5lKmtcgg=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     xiongx18@fudan.edu.cn, lyude@redhat.com, stable@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn
Subject: Re: FAILED: patch "[PATCH] drm: fix drm_dp_mst_port refcount leaks
 in" failed to apply to 4.19-stable tree
Message-ID: <X931GEZTdrjP6ugm@kroah.com>
References: <1597912668169213@kroah.com>
 <20201216134655.6kkrltmgoy7mq24f@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216134655.6kkrltmgoy7mq24f@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 16, 2020 at 01:46:55PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Thu, Aug 20, 2020 at 10:37:48AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. Will also apply to 4.14-stable.

Thanks, now queued up.

greg k-h
