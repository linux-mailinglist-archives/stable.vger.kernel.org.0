Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0783D87F0
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 08:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbhG1Ga5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 02:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231484AbhG1Ga4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 02:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DBA8601FE;
        Wed, 28 Jul 2021 06:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627453855;
        bh=jYbmCznlnAxntCDoWWWbOp/BTUdcMMju2H31HIK4w80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fYXIjfWfibqAzvx9wsNvDvtB0pl0j/O0XZTZFLG2PkPDt18xtteMpWfxNUm7Ypq5B
         0Dh6gj+u2LedB07PKdPWGTp5plPL0YW/isJwJlFVg1Fo1IpUPnJHPX5b7uiTU8vm7I
         zFQOZKtjESKDlUmH4UUXMBcei2/riNU9LA4tSS80=
Date:   Wed, 28 Jul 2021 08:30:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adrien Precigout <dev@asdrip.fr>
Cc:     stable@vger.kernel.org
Subject: Re: Unable to boot on multiple kernel with acpi
Message-ID: <YQD5nXW8y6r1IyvJ@kroah.com>
References: <9ad7219f-e8db-48b9-ad65-571bc12322d8@asdrip.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ad7219f-e8db-48b9-ad65-571bc12322d8@asdrip.fr>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 04:49:40AM +0000, Adrien Precigout wrote:
> Hi,
> On my acer swift 3 (SF314-51), I can't boot on my device since 4.19.198 (no issue with 4.19.197) without adding "acpi=off" in the parameters. Same thing happens on 5.12.19 (didn't happened in 5.12.16), 5.13.4 and .5 and 5.10.52.

Please see this thread:
	https://lore.kernel.org/r/1231e3e3-d510-43ec-522a-75e3fe9175fb@gmail.com

I think we need to revert the change in the stable trees, as this is
affecting more people than realized...

thanks,

greg k-h
