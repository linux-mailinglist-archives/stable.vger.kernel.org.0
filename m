Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61F84743AC
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 14:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhLNNkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 08:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbhLNNkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 08:40:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C221FC06173F
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 05:40:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8990DB819A1
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 13:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB49BC34605;
        Tue, 14 Dec 2021 13:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639489239;
        bh=SzL+NDiVWiYcv3caZLtHUlvR/HiLsQL2RNRnycdB/HA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=boJDlubEyNZuRiSZmvcg9GVTwS9SFBLdqaH4AoTqy5KVl9dpBURK/E3wiqgTlPMiT
         q45VQY2T4NyQuu/esyw40aTtUFk6t8Y74UdmYJvIzsqe/OlLapEf7tP9Ww6iN5Ylii
         tGpQU1ZGfBE5e+gipAEC2WNmhYCDIo3rO3/e4nGY=
Date:   Tue, 14 Dec 2021 14:40:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] x86/sme: Explicitly map new EFI memmap table as encrypted
Message-ID: <Ybie1MoJE3v95NOx@kroah.com>
References: <2e06a99ba4c4b1bc6663605414f7518e4c43d188.1639243140.git.thomas.lendacky@amd.com>
 <YbhfWHTL8Kobq9vv@kroah.com>
 <b50c83fa-ada2-23e8-c797-767190c08934@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b50c83fa-ada2-23e8-c797-767190c08934@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 14, 2021 at 05:54:56AM -0600, Tom Lendacky wrote:
> On 12/14/21 3:09 AM, Greg Kroah-Hartman wrote:
> > On Sat, Dec 11, 2021 at 11:19:00AM -0600, Tom Lendacky wrote:
> 
> > 
> > This seems to cause config warnings as reported here:
> > 	https://lore.kernel.org/r/CA+G9fYsEQCjOi_58WcMb4i-2t1Gv=KjPuWa6L792YAZF=zzinw@mail.gmail.com
> > and:
> > 	https://lore.kernel.org/r/CA+G9fYuCFSbLMarXOnapUXN_NRgQMkjfr_rSTPjzBJQ-FT-Q3g@mail.gmail.com
> > 
> > so I will be dropping this commit from the 4.14, 4.19, and 5.4 trees.
> > Can you please fix this up and resend?
> 
> Yes, I'll look into this.

Looks like 5.4.y is working ok, I'll leave the change in there.

thanks,

greg k-h
