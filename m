Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263423272DC
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 16:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhB1PPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 10:15:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230178AbhB1PPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Feb 2021 10:15:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A78364D5D;
        Sun, 28 Feb 2021 15:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614525298;
        bh=0kulXnCuqpoPXjGDFeQl9JUjBoEgX7xs0FQJrTbfftk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s09CCmIcu3lwICBYaOp9HuCq+Ghwx2/jJ4pBpwcbYJzdNzECgSp3Qo8G0/6U4rCHC
         cjEHP6meZG8xStvlqoKgM/TIpS3O0DaSfAY2oH2SGcqnkyll0VrvwtTDrceENeQExx
         hEQUgWhF5gRrbcbINAS1ngHXxlaUmuDFPXrs9Qh0=
Date:   Sun, 28 Feb 2021 16:14:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Diego Calleja <diegocg@gmail.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: -stable regression in Intel graphics, introduced in Linux 5.10.9
Message-ID: <YDuzbvIjMO5mFcYm@kroah.com>
References: <3423617.kz1aARBMGD@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3423617.kz1aARBMGD@archlinux>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 28, 2021 at 03:29:07PM +0100, Diego Calleja wrote:
> Hi,
> 
> There is a regression in Linux 5.10.9 that does not happen in 5.10.8. It is still there as
> of 5.11.1

Is this the same issue reported here:
	https://lore.kernel.org/r/f1070486-891a-8ec0-0390-b9aeb03178ce@redhat.com
?

If so, is this a problem in 5.11 as well?

thanks,

greg k-h
