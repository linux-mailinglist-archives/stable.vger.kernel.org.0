Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9988E18BA10
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 16:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgCSPCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 11:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727720AbgCSPCU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 11:02:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E0ED2072D;
        Thu, 19 Mar 2020 15:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584630139;
        bh=Wm4G73npLtlzYtMDeYoIvvpBN/OsexLDrTVojSELgIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PGeWkMTEGWHJZUFxJh8T9pY9JKxXDk3gvf3lxJo+22KKLhcYir3HCBSpi5jaWn7Zf
         rEC61zXFOLTXUeluEeWH7Cr10XAS+cJRj1xT2Qvau3BHQSvrPUy6LYfLyIokNJUKq0
         j0zPdjALKq6LUWyq8ALG2Xs1LVeUCuB6zX9EVL+4=
Date:   Thu, 19 Mar 2020 16:02:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 00/64] 5.5.11-rc1 review
Message-ID: <20200319150216.GD92193@kroah.com>
References: <20200319145826.910131145@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319145826.910131145@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 03:59:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.11 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 21 Mar 2020 14:57:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.11-rc1.gz

Crap, this should have been -rc2, let me go fix that...

