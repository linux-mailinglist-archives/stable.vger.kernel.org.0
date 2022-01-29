Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174C34A2E58
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 12:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbiA2Lss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 06:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236846AbiA2Lsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 06:48:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9DEC061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 03:48:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB89C60B84
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 11:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDD2C340E5;
        Sat, 29 Jan 2022 11:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643456925;
        bh=nGO1IT+6qgTzP07dVXTja7kwL1LfmNeekO8jM/p6aqA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y0xtTMo9B2j1MQJFfirCa1Kq03KLSHqkEsnpFW3b4RBukZdcV8+Y8/bIKuSChMQD7
         SsuvmT9P7VqCAbgKa6/Wd+k+KNwG/C9NDZzPhH8YlOyZJ0eUpa9MKS9qN1vbj7nXPC
         GWM5PuVqzqaJL3IDOrlGwIxLvW+ShJdnj4vMR+YY=
Date:   Sat, 29 Jan 2022 12:48:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <groeck@google.com>
Cc:     Martin Faltesek <mfaltesek@google.com>, bryan.odonoghue@linaro.org,
        stable <stable@vger.kernel.org>
Subject: Re: issue with patch: media: venus: core, venc, vdec: Fix probe
 dependency error
Message-ID: <YfUpmvf096v6UV1T@kroah.com>
References: <CAOiWkA-_CJ7VXEo8NicmFqi_3Z78A4662x-ydrH2F4YA+qibwQ@mail.gmail.com>
 <CAOiWkA_HQrnhDOOKWfXd3eP_e0g68vWiaGP361DAhvENdh=4Tw@mail.gmail.com>
 <CABXOdTcCJC2Xt-5iRkCtEZnU6FGn+CChu30LDgW9NP=eUzSBWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABXOdTcCJC2Xt-5iRkCtEZnU6FGn+CChu30LDgW9NP=eUzSBWw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 02:28:56PM -0800, Guenter Roeck wrote:
> On Thu, Jan 27, 2022 at 1:44 PM Martin Faltesek <mfaltesek@google.com> wrote:
> +stable@
> >
> > +gregkh@linuxfoundation.org
> >
> > ddbcd0c58a6a is upstream fix for this and needs to be applied to affected stable releases.
> >
> My little tool tells me that this is only needed in v5.10.y.

Now  queued up, thanks.

greg k-h
