Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F791DC6B4
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 07:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgEUFur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 01:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgEUFuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 01:50:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FD2D2070A;
        Thu, 21 May 2020 05:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590040246;
        bh=ewfzEifxFa3vrWphej2OMKEoPCkd1LapCDZjg6QwIHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lRTwCbFEbSfkgBENhnv+SX3QQbPVpDbaL1bIIYzhgjrv4cGoENWMpn5hq5siuaHW/
         3xCHThkj/paHGEhExFJ++C1ocGm4wPLmiyvNmcZAdLGsA3MMygzKAjLlKvg7cNlapl
         ENK5MzOIhksXDyDirJG07kmZBEfHtGW5LHXdX36M=
Date:   Thu, 21 May 2020 07:50:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] KVM: SVM: Fix potential memory leak in svm_cpu_init()
Message-ID: <20200521055044.GB2330588@kroah.com>
References: <dd3fae1fef7287e944e66333762ed16600449484.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd3fae1fef7287e944e66333762ed16600449484.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 08:57:00PM +0100, Ben Hutchings wrote:
> Please pick this fix for 4.19 and 5.4 stable branches:
> 
> commit d80b64ff297e40c2b6f7d7abc1b3eba70d22a068
> Author: Miaohe Lin <linmiaohe@huawei.com>
> Date:   Sat Jan 4 16:56:49 2020 +0800
> 
>     KVM: SVM: Fix potential memory leak in svm_cpu_init()
> 
> It applies cleanly to both.

Now queued up, thanks.

greg k-h
