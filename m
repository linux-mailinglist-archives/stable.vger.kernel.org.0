Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF9E13F40
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 13:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfEELxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 07:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfEELxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 May 2019 07:53:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC6642087F;
        Sun,  5 May 2019 11:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557057195;
        bh=DYdpLqtfcF1rL1yXUP0EdvXEz8Qfd3bfTA8RJWXtmD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iTXk3k/4ypU9dOnCVJnSKxI1QCvla/As8HWar82XXv42cAShsxkXZsmbHvPWAllyQ
         +k6tOxczrrNiIxgSIF72+w3zqgHeQ8jEM5nhabF8QarVbCSzTwiHgWDKr35addiBn6
         BCUPN/kuJYU/Q9fznoJBq3chpo010nFG7D0PWyMY=
Date:   Sun, 5 May 2019 13:53:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bharath Vedartham <linux.bhar@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/23] 4.19.40-stable review
Message-ID: <20190505115312.GA14436@kroah.com>
References: <20190504102451.512405835@linuxfoundation.org>
 <20190505111246.GA3429@bharath12345-Inspiron-5559>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505111246.GA3429@bharath12345-Inspiron-5559>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 05, 2019 at 04:42:46PM +0530, Bharath Vedartham wrote:
> Built and booted on my x86_64 machine. No dmesg regressions observed.

Wonderful, thanks for testing and letting me know.

greg k-h
