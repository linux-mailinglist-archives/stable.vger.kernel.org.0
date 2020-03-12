Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A77D18296E
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 08:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388004AbgCLHCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 03:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387955AbgCLHCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 03:02:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B2D8206B1;
        Thu, 12 Mar 2020 07:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583996562;
        bh=RoDs+BZ8xZZ2MVR/CWWKnEHPByp/T5HVVPijHZAYftY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aYc1X675fzGC9pZTGUhNN6xAgyVkfy/3fQzSQdf1Qk4drBiTeL2emyojaTrj6fSaO
         lWN8Y71PRGatZWPelR2qQSmAQPbGXD5b3a4xygWzwQLa+TA1yUGtlWjELDJuJM7T1C
         PvmGd8FePuCJQfqSbxUZL4StoGvbFkBlELze+JT8=
Date:   Thu, 12 Mar 2020 08:02:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/169] 5.4.25-rc4 review
Message-ID: <20200312070240.GA4157582@kroah.com>
References: <20200311204002.240698596@linuxfoundation.org>
 <5371323a-516e-cfa0-d8c0-c37599fb6442@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5371323a-516e-cfa0-d8c0-c37599fb6442@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 03:06:04PM -0700, Guenter Roeck wrote:
> On 3/11/20 1:41 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.25 release.
> > There are 169 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 13 Mar 2020 20:39:27 +0000.
> > Anything received after that time might be too late.
> > 
> 
> drivers/gpu/drm/virtio/virtgpu_object.c:31:67: error: expected ')' before 'int'
>    31 | module_param_named(virglhack, virtio_gpu_virglrenderer_workaround, int, 0400);
> 
> Commit b0138364da17 ("drm/virtio: module_param_named() requires linux/moduleparam.h")
> is still missing.

Now added, thanks.

greg k-h
