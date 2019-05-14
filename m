Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78FAC1C39C
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 09:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfENHFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 03:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfENHFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 03:05:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4B9D2086A;
        Tue, 14 May 2019 07:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557817514;
        bh=8hs7Xcl5TFH1iWCZIg0nQD01cSQmtLRwbxKGpKk8ND0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NX57qEPQuFUFp7hNAvrfVcBhFpGsf8JlJhizpUha0i5KaC1bAqC8ToOZckdblC3hN
         rKs1jGfaR8L6AHCOkKtDkaF+ryhbRFsC+uXkMMS2ChdU2m6tVCZ5gb33rFgJngL2TT
         dsxAwrXT16gYge7Fm4awe6FtTuKu3IFuNMhGQpkM=
Date:   Tue, 14 May 2019 09:05:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org, erhard_f@mailbox.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Bug 203597] New: kernel 4.9.175 fails to boot on a PowerMac G4
 3,6 at early stage
Message-ID: <20190514070511.GA14854@kroah.com>
References: <bug-203597-206035@https.bugzilla.kernel.org/>
 <e1a6f0c2-c93a-05bd-0623-ccffa733c5a7@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1a6f0c2-c93a-05bd-0623-ccffa733c5a7@c-s.fr>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 06:56:03AM +0200, Christophe Leroy wrote:
> Hi Greg,
> 
> Could you please apply b45ba4a51cde29b2939365ef0c07ad34c8321789 to 4.9 since
> 51c3c62b58b357e8d35e4cc32f7b4ec907426fe3 was applied allthought marked for
> #4.13+

It does not apply there (nor to the 4.4.y queue, which will need it as
well), so can you provide a working backport so that I can queue it up?

thanks,

greg k-h
