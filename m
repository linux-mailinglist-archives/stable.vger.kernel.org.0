Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E904419859
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 08:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfEJGZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 02:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfEJGZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 02:25:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7F9B217D6;
        Fri, 10 May 2019 06:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557469524;
        bh=xCyIuPEcqKdpdBDeoKypAEdjrtjwfp4VH1BUPkegH80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FiRY9DuruDcwKWvOXqpN3jKQqnB4xiqy9Nty2e6e0BOWTFviDQtiWzbptmkcKxzSD
         nP/wlYefoVuHOueZ+JSQULEq/A98qqvDWpw8QpcTMn1dA/1+QTFe2BHxiXdb2GyoK/
         YX5+Irq7dzoAs+l9Tp6+uCsnRP33jC3mAV8uoYp8=
Date:   Fri, 10 May 2019 08:25:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "kernelci.org bot" <bot@kernelci.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.0 00/95] 5.0.15-stable review
Message-ID: <20190510062521.GC18014@kroah.com>
References: <20190509181309.180685671@linuxfoundation.org>
 <5cd4c561.1c69fb81.ca185.0137@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cd4c561.1c69fb81.ca185.0137@mx.google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 05:27:13PM -0700, kernelci.org bot wrote:
> stable-rc/linux-5.0.y boot: 143 boots: 1 failed, 141 passed with 1 untried/unknown (v5.0.14-96-gdf1376651d49)
> 
> Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux-5.0.y/kernel/v5.0.14-96-gdf1376651d49/
> Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y/kernel/v5.0.14-96-gdf1376651d49/
> 
> Tree: stable-rc
> Branch: linux-5.0.y
> Git Describe: v5.0.14-96-gdf1376651d49
> Git Commit: df1376651d496484d341d374c3d2566a089b1969
> Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Tested: 77 unique boards, 25 SoC families, 15 builds out of 208
> 
> Boot Failure Detected:
> 
> arm:
>     multi_v7_defconfig:
>         gcc-8:
>             stih410-b2120: 1 failed lab

Is this a "real" issue?
