Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E504026DE89
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgIQOhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:37:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727410AbgIQOfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:35:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B8492223C;
        Thu, 17 Sep 2020 14:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600353298;
        bh=5PnHZv1tG0TgArjQIcl+nRWQEyGhypjOtwd8mQPhQco=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XSQy4pBbtHqphisQ0vWL4vRvDhm6/wqkXSThcZp3FEWxV5woRFK+KiqT8NVh5YEkQ
         FFjz2UKg4WntzP8epCsSqV4cIdBI0sl7LApQ+h3iGEpYE0xypEVo7t+7g7PaH18h4m
         ZewS+5vofTFQohzxyvpqhSq2vOqVIBzPmYOefyR8=
Date:   Thu, 17 Sep 2020 16:35:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Patch "iommu/amd: Use cmpxchg_double() when updating 128-bit
 IRTE" has been added to the 5.8-stable tree
Message-ID: <20200917143529.GG3941575@kroah.com>
References: <20200907030521.EF51E2075A@mail.kernel.org>
 <831ea167-0e19-3557-8812-b42a8ef23d1f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <831ea167-0e19-3557-8812-b42a8ef23d1f@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 08:19:37PM +0700, Suravee Suthikulpanit wrote:
> Sasha,
> 
> This patch and the upstream commit 26e495f34107 ("iommu/amd: Restore IRTE.RemapEn bit after programming IRTE")
> are related. Since the commit 26e495f34107 has been back-ported to linux-5.4.y branch of the stable tree,
> this patch should also be add to linux-5.4.y as well.

It doesn't apply to 5.4.y at all, can someone please provide a working
backport?

thanks,

greg k-h
