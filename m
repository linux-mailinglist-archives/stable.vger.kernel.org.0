Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABC711C8DA
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 10:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfLLJK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 04:10:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728147AbfLLJK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 04:10:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 879F424654;
        Thu, 12 Dec 2019 09:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576141826;
        bh=0i4tI+sa7hEpvsrpadAu5+m5FLYY3GP6SUEIF60HAxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hulzcY/Jm/LOCC9/8M0QCvj/d+QibiiKJbiyPAWVXOxPDMDgYslhWo+5vsk5ezSGt
         VXUc7aCPVvomSiNwgaLa3baH6TY95qgNgzvAzpWAlBqDrOKLVXlcWGSUJhUvXo/Cdx
         IBSF5icEe2fHYinQv+Xh9EkqUIR5LD0xml6t8AlM=
Date:   Thu, 12 Dec 2019 10:10:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/105] 5.3.16-stable review
Message-ID: <20191212091023.GB1372814@kroah.com>
References: <20191211150221.153659747@linuxfoundation.org>
 <20191212065214.GA3747@debian>
 <20191212074124.GA1368279@kroah.com>
 <20191212080518.GA2657@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212080518.GA2657@debian>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 01:35:18PM +0530, Jeffrin Jose wrote:
> On Thu, Dec 12, 2019 at 08:41:24AM +0100, Greg Kroah-Hartman wrote:
> > Are these things new to this release, or have they always been there?
> Normally these are not new things. it has been there.

Then nothing new broke :)
