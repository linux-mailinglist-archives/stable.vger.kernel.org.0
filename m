Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC2111F9E4
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 18:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfLORti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 12:49:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfLORti (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 12:49:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0B8520663;
        Sun, 15 Dec 2019 17:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576432178;
        bh=hctef1tn9zXmsGQ0XGfAjL1OEr3jtf46egS2BSg5ykE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wy+LIygcFu95SuAsXZQuFVSon1n3MRhvHSPBd02Pa2R8Fu+HoboTtzDvQ3R7qTncX
         AqoiclYul/9fCVPCq6YUyGMCC2DIb4GLwSkqtoG1V8+rng/zyl0Fc75qEkQLIIlB/T
         Idk8/tS2XM+blPeJo3pKIR7a0X6BeyHQw5fo2q0A=
Date:   Sun, 15 Dec 2019 18:49:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     stable@vger.kernel.org, tony@atomide.com, ulf.hansson@linaro.org
Subject: Re: FAILED: patch "[PATCH] omap: pdata-quirks: remove openpandora
 quirks for mmc3 and" failed to apply to 4.14-stable tree
Message-ID: <20191215174935.GA856758@kroah.com>
References: <157641677913676@kroah.com>
 <B77B52F8-BD0E-41D1-ACEF-6440E9C59CED@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B77B52F8-BD0E-41D1-ACEF-6440E9C59CED@goldelico.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 06:37:34PM +0100, H. Nikolaus Schaller wrote:
> Please apply this before: https://patchwork.kernel.org/patch/11232473/

Links are fun :(

What is the git commit id of the patch in Linus's tree to apply first?
That I can work with.

thanks,

greg k-h
