Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C68A845E85
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 15:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbfFNNkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 09:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbfFNNkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 09:40:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AC8A20866;
        Fri, 14 Jun 2019 13:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560519639;
        bh=xPuGEP6t8sHLiPHvg2UwBF+Gx5tetd6fRaLmatb03QY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V/B529/d6Xc3K1yCGqkrpvtbE1CnLAL8/JYTR+JyAHlIyJufZkCfF1YihjakbM9TG
         RKk/6gC2o7jKOd8+OR8f/iCVkdGUlqsMpexInjphMlRv8l3IoTnSlQH8wBFb97HOXL
         aak59fWfxsZ57qndKulDE5z52bexBdGC/TymWO28=
Date:   Fri, 14 Jun 2019 15:40:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable-5.0+ 3/3] nvme-tcp: fix queue mapping when queue
 count is limited
Message-ID: <20190614134036.GC1076@kroah.com>
References: <20190610045826.13176-1-sagi@grimberg.me>
 <20190610045826.13176-3-sagi@grimberg.me>
 <20190613074516.GB19685@kroah.com>
 <2efe1238-b183-6a70-25a5-d31666a1df17@grimberg.me>
 <20190614134000.GB1076@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614134000.GB1076@kroah.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 14, 2019 at 03:40:00PM +0200, Greg KH wrote:
> On Fri, Jun 14, 2019 at 06:29:39AM -0700, Sagi Grimberg wrote:
> > Its on its way to Linus...
> > 
> > Should I just respin again once it lands there?
> 
> Yes please, there's nothing we can do until then.

And you have read the documentation for how to do all of this properly,
right?
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
