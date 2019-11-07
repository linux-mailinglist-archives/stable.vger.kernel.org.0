Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB6A9F298D
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 09:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733264AbfKGIox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 03:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbfKGIox (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 03:44:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4BDD21D79;
        Thu,  7 Nov 2019 08:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573116292;
        bh=6JG2jHSq+7WpmqBEmPdYk14g3REa4K6JE9uXqhH3ZtI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k2Mhl2+QSnnHnT/ZYPZgwf9YxaOSEHwOTV6DzZsmENj/R2eJYD0UbanOivYhLS8vp
         JUNOM/+eHRJUmld3Xqmi/lPWO08K/fBZzGUIGVRzEwlzV9kVvS1poXxUtkl3aVincR
         6mRL07Z9YPDmPJhvED7V8Whhj/6ugOTbGa/aVHWw=
Date:   Thu, 7 Nov 2019 09:44:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Doug Berger <opendmb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "net: bcmgenet: soft reset 40nm EPHYs before MAC init" has
 been added to the 5.3-stable tree
Message-ID: <20191107084450.GB1218282@kroah.com>
References: <157305078718623@kroah.com>
 <CA+PBWz0ukwrZw6hmjeJ4xDgPZ0=YaCaVYTAXdUcXqfnpsTrjjw@mail.gmail.com>
 <20191106145629.GA3730817@kroah.com>
 <CA+PBWz092XryavGihP3uTBoiDRpGSAJh=apEiTHYSKBCjZAhzA@mail.gmail.com>
 <f2734ecb-1e1a-3580-dcc6-5bd09e2e2471@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2734ecb-1e1a-3580-dcc6-5bd09e2e2471@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 06, 2019 at 11:55:38AM -0800, Doug Berger wrote:
> For clarity, this commit should be handled the same way for all stable
> trees (not just 5.3), and I am replying again since my phone used HTML
> which was blocked by the mailing lists :(.
> 
> My preference is to omit this commit rather than reverting it in the
> near future, but if you would prefer to add this one and then revert it
> because it is easier for you I will let you make that call.

Not a problem, I've dropped it now from the 5.3.y queue, thanks!

greg k-h
