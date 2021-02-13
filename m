Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2969831AA7D
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 09:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhBMI0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 03:26:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhBMI0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 03:26:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA71E64E26;
        Sat, 13 Feb 2021 08:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613204735;
        bh=50KNQHDI+UtME2e37oYorZWzoM1e0cnXgJn1HF4ZaA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kDJHiYqEr90OqaZkkKLrkxB5Ba2/MIONIJs3sKYODIC3LEHL03RFHdaDaB5eBKuyb
         5ZcyZzsSuKq1UEHf90hzVaZ1u/bB4iUfPDLnm8Zer2VITouExdJhUAx12auzmc8ywc
         DAKMOXRZgei3hA4YRedsAgrk8DgXw0xNry+Fsh6Q=
Date:   Sat, 13 Feb 2021 09:25:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jonathan Marek <jonathan@marek.ca>, stable@vger.kernel.org
Subject: Re: [PATCH v2] misc: fastrpc: restrict user apps from sending kernel
 RPC messages
Message-ID: <YCeM+0JUEPQQkGsF@kroah.com>
References: <20210212192658.3476137-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212192658.3476137-1-dmitry.baryshkov@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 10:26:58PM +0300, Dmitry Baryshkov wrote:
> Verify that user applications are not using the kernel RPC message
> handle to restrict them from directly attaching to guest OS on the
> remote subsystem. This is a port of CVE-2019-2308 fix.

A port of the fix of what to what?

Is this to go only into a stable tree (if so what ones and what is the
id in Linus's tree), or is it to go into Linus's tree like normal (if so
how can this be a port)?

thanks,

greg k-h
