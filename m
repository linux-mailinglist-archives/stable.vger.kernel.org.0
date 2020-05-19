Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6331D8F50
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 07:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgESFoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 01:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgESFoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 01:44:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FE9120708;
        Tue, 19 May 2020 05:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589867052;
        bh=VgALpXRpRPAfU0StIWrT/xcCnWfFtp3D/DBecKiFgio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hN6WVDxPCY5tD0RBbUnSYiOH67oZLMI91RuoN/Wn53wrVihA3Aug82q5iTLvXumg8
         Fzr5e63Xb6rDDCfcj71QYmtd1cAEQ3rSvY+jvaahCsTjsD6vPVtDyb7PzKY0WhE0TE
         GPiKkea44+aE9sVj6iG+2KhLnYUxzIG95w9xo8K8=
Date:   Tue, 19 May 2020 07:44:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Olsak, Marek" <Marek.Olsak@amd.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Pelloux-prayer, Pierre-eric" <Pierre-eric.Pelloux-prayer@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.6 061/194] drm/amdgpu: bump version for invalidate L2
 before SDMA IBs
Message-ID: <20200519054410.GB3791824@kroah.com>
References: <20200518173531.455604187@linuxfoundation.org>
 <20200518173536.800109596@linuxfoundation.org>
 <CH2PR12MB42467AF7BC0405001FD91207F9B80@CH2PR12MB4246.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB42467AF7BC0405001FD91207F9B80@CH2PR12MB4246.namprd12.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 10:34:34PM +0000, Olsak, Marek wrote:
> [AMD Official Use Only - Internal Distribution Only]
> 
> Hi Greg,
> 
> I disagree with this. Bumping the driver version will have implications on other new features, because it's like an ABI barrier exposing new functionality.

And yet another reason why driver versions are a total mess and
shouldn't be in in-kernel drivers :(

Ugh.

I'll go drop this, thanks.

greg k-h
