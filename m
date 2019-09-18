Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2EDB64C0
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 15:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbfIRNie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 09:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbfIRNie (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 09:38:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DE2F20856;
        Wed, 18 Sep 2019 13:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568813914;
        bh=VB8d4wSh+KQLr4xFXKtkgNSqUSfmypxcsibtPs/IHWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IxV1RfhfWZVRHsr5n7M65s1DtRZ/y61yHJDSoA+hWLvIXpBnFdBTYVQxkpcjtIi5C
         NhLF69V/8ctyQOdzi2WDxavekZbnSfJBCb57LLI5stfRwwRajOe+qSWPHuFiRSVQIO
         zxYKC/CJL35i72leF0dn8i+lZ5fDOtpjnHuZxuwY=
Date:   Wed, 18 Sep 2019 15:38:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org
Subject: Re: Please apply 02eec6c9fc0c ("MIPS: netlogic: xlr: Remove
 erroneous check in nlm_fmn_send()") to v4.4.y
Message-ID: <20190918133831.GD1908968@kroah.com>
References: <86e853f7-cc89-ec97-e9d0-e6abb8c5ed6f@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86e853f7-cc89-ec97-e9d0-e6abb8c5ed6f@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 06:28:06AM -0700, Guenter Roeck wrote:
> Commit 02eec6c9fc0c ("MIPS: netlogic: xlr: Remove erroneous check in nlm_fmn_send()")
> fixes a build error in v4.4.y, seen when building mips:nlm_xlr_defconfig.
> 
> In file included from ../arch/mips/netlogic/common/irq.c:65:
> ../arch/mips/include/asm/netlogic/xlr/fmn.h: In function 'nlm_fmn_send':
> ../arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise comparison always evaluates to false
> 
> The patch is only needed in v4.4.y; it has already been applied
> to more recent branches.

Now queued up, thanks.

greg k-h
