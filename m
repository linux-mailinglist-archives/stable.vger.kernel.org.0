Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0B611CCE6
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 13:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbfLLMSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 07:18:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728996AbfLLMSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 07:18:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8F4521655;
        Thu, 12 Dec 2019 12:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576153087;
        bh=kcRAiUVM6uCVLF5RFVgg3i1SM/L5Afj/d2s24LWGAx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2rXTJmdy+1+JBIhhBCvogRAbIwFuitwcX5haXJlVoU6lEVg8aknzibwUGW7Wh+9y5
         bCnQPPFbKHq6S+9gS+XTD94PTdd3U8gdntkOZxiYwMrshSYFTDer3lsJJ11UNhkUv2
         u7b8A7f0H7Z7E1/sko8kEIqTfSvq9e6EyY+QzpBM=
Date:   Thu, 12 Dec 2019 13:18:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/105] 5.3.16-stable review
Message-ID: <20191212121805.GB1540720@kroah.com>
References: <20191211150221.153659747@linuxfoundation.org>
 <20191212100456.GB1470066@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212100456.GB1470066@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 11:04:56AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Dec 11, 2019 at 04:04:49PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.16 release.
> > There are 105 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.16-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> 
> I have pushed out -rc2 with a number of additional fixes:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.3-rc2.gz

That was the 5.4 patch, here is the correct 5.3 patch:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.16-rc2.gz
