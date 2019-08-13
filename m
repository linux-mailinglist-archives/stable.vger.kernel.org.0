Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5138C085
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 20:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfHMSXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 14:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfHMSXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 14:23:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A2C420665;
        Tue, 13 Aug 2019 18:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565720589;
        bh=C+Tkeug3o2OjzVJilF78uo7O4RC0XPJJVWCnooVI5Sw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g5HTQo48K6sKye9Ne0qLifxI+rdCcXRrWA1+KzMY3t0KedBEYJ4rjeI8TMIsmi1o7
         Zp6TYuS5IAEp5XDcMymtipTJnkyoeogrhcTEkx51nuMBTfCKGxwcMgBQB3GuKCNo2m
         19tt5+oKDp9UBh51oycfajUy0SXTGD/+EmejQVq0=
Date:   Tue, 13 Aug 2019 20:23:07 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Hook, Gary" <Gary.Hook@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] crypto: ccp - Add support for valid
 authsize values less than" failed to apply to 4.14-stable tree
Message-ID: <20190813182307.GA6582@kroah.com>
References: <15655353989018@kroah.com>
 <DM5PR12MB144907F9F3D95886640325F8FDD20@DM5PR12MB1449.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR12MB144907F9F3D95886640325F8FDD20@DM5PR12MB1449.namprd12.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 13, 2019 at 02:00:35PM +0000, Hook, Gary wrote:
> It turns out that this patch has a pre-req that wasn't properly marked as "Fixes" for 4.14 stable.
> 
> If you first apply b698a9f4c5c52, then apply 9f00baf74e4b6, then this be clean.

That worked, thanks!

greg k-h
