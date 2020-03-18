Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D6B189980
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgCRKby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:31:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgCRKbx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:31:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80B0B20771;
        Wed, 18 Mar 2020 10:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584527513;
        bh=DB/m/+0nA/txMV8sH3OXk1utW/NQ1JTcugVmYg3VzkQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mt+veHCb/UrmcTPHh3FdDR+QW4EjQqx6MztOqD37KXp2A7tMNhaZEPgGKsEYjunns
         N5dgMyKSDrULMODxEeLVms8qWsNPksX9jB+zhS+6y9B+7pcs2th+9hLkTab5SYpd7o
         KbfTrCiAv6ep7aMOwuESbWdaG+oBCtrz3qNAdgro=
Date:   Wed, 18 Mar 2020 11:31:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [GIT PULL 6/6] intel_th: pci: Add Elkhart Lake CPU support
Message-ID: <20200318103150.GD2183221@kroah.com>
References: <20200317062215.15598-1-alexander.shishkin@linux.intel.com>
 <20200317062215.15598-7-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317062215.15598-7-alexander.shishkin@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 17, 2020 at 08:22:15AM +0200, Alexander Shishkin wrote:
> This adds support for the Trace Hub in Elkhart Lake CPU.
> 
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/hwtracing/intel_th/pci.c | 5 +++++
>  1 file changed, 5 insertions(+)

And again, for 5.6.

Wow this pull request was messed up.  Let's go back to just normal patch
series submissions please.  If I hadn't seen that build warning, this
would have been a mess.

greg k-h
