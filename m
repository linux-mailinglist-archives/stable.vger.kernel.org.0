Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8873D7C9E6
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 19:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbfGaRFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 13:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728781AbfGaRFr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 13:05:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92E7621852;
        Wed, 31 Jul 2019 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564592747;
        bh=L3gzyj0Bf5T2JOyiCBjjVvtUSwX1i/8yfo6bEx9KXps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xq8v5cdYUmxOkz410SjHmnJAFRmmUKwibQkMhbgas7+CxkzBDNOLrg3rGm2WmLGvv
         ZWZCvt/S84P9Y9xNylItyFFdww4Le8Lhctjqu0nPNBV/CZh+Z1iUtljDQHUrQHLPYl
         mm++EQmH+soLKYA2+JfPhaiyK10Ehpd3cZTEVogo=
Date:   Wed, 31 Jul 2019 19:05:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     stable@vger.kernel.org, 0x7f454c46@gmail.com,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        iommu@lists.linux-foundation.org
Subject: Re: [PATCH-4.19-stable 0/2] iommu/vt-d: queue_iova() boot crash
 backport
Message-ID: <20190731170542.GB22660@kroah.com>
References: <20190731162220.24364-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731162220.24364-1-dima@arista.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 05:22:18PM +0100, Dmitry Safonov wrote:
> Backport commits from master that fix boot failure on some intel
> machines.
> 
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>

Thanks for the backports, 4.19.y and 4.14.y patches now queued up.

greg k-h
