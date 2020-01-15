Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F14D13C6C6
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 15:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgAOO6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 09:58:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728931AbgAOO6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 09:58:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2E6824679;
        Wed, 15 Jan 2020 14:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579100280;
        bh=q6ELm/Vl9XcAEhYUcCxIkQJDRaRPF3X14OaCOhTSKUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LubY2qrl2wQ/9xZ1VeF+zvkaFRdxoAjqbT6cxHAfzCZgC7LqCobAWeNWfPPQ44RGI
         pBRgPp4T8Zj4Ub7B0P8V1CLfzMdQGgNPLALenFB0RbQkO0X5KcxN8LUktyN69xIbQ+
         V6of7npsqgS1TZEtEU5q/DTEnx7Z4ua+TNstKAaI=
Date:   Wed, 15 Jan 2020 15:57:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.19-stable] Mostly securit y fixes
Message-ID: <20200115145757.GA3724440@kroah.com>
References: <1eaa745218d25ab3c5c61361ae0d9b0601f1d99f.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1eaa745218d25ab3c5c61361ae0d9b0601f1d99f.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 14, 2020 at 02:47:31PM +0000, Ben Hutchings wrote:
> Some more fixes that required backporting for 4.19.  All these fixes
> are related to CVEs though some of them don't seem to have any security
> impact.

All now queued up, many thanks for these.

greg k-h
