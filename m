Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D3DF87F8
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 06:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKLFcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 00:32:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfKLFcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 00:32:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BC0E21872;
        Tue, 12 Nov 2019 05:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573536742;
        bh=JM5RRXlxHYLYh7AnnJJzStdbjk+LhcyzPExflUbN4qw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=isin37MMxUfHSXUE/KnS5nnxeGvL/fro2ioY4QcQb6ue/jbt5vKACgNK/1Wba8VXv
         klsYW+wGU4/siMxykiWsCUeVt/tWUmFMGgs6vQQewUu3Wvy9aNgs51A8r++TBJvlae
         bNXOy/oSzIruzIVdQ69VgtMfvU+U9OoQAsKZGgjM=
Date:   Tue, 12 Nov 2019 06:19:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "kernelci.org bot" <bot@kernelci.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/105] 4.14.154-stable review
Message-ID: <20191112051916.GA1196819@kroah.com>
References: <20191111181421.390326245@linuxfoundation.org>
 <5dca16a0.1c69fb81.35eb7.dbb1@mx.google.com>
 <20191112051035.GA1160399@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112051035.GA1160399@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 12, 2019 at 06:10:35AM +0100, Greg Kroah-Hartman wrote:
> On Mon, Nov 11, 2019 at 06:19:12PM -0800, kernelci.org bot wrote:
> > stable-rc/linux-4.14.y boot: 112 boots: 104 failed, 0 passed with 8 offline (v4.14.153-106-ga46a2b6a665b)
> 
> wow, everything dies :(
> 

Ok, pushing out -rc2 now to hopefully resolve this.

thanks,

greg k-h
