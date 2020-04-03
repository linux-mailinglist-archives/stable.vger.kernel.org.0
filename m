Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D614019D339
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 11:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388221AbgDCJMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 05:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732595AbgDCJMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Apr 2020 05:12:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1532E20787;
        Fri,  3 Apr 2020 09:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585905124;
        bh=Dq2bhaYM74yoMEleEz8AwU4odSwlFg8pjuATFM1XS4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DZ89oRDBudO/p5wx4MZLC5sS0y4i9jKftl4XFn0B3sojBt2hUcxR9JtyEmVGzfM4T
         zuJmJioT88aT7UtS9tuGvoBHKXF1C48+OXlbFksGuqGHG2zrnnxMVeq+BCWqQlAh7e
         j92z5ksQKFWoT8uf8II7XWupMKUF9tz94zeJA3iY=
Date:   Fri, 3 Apr 2020 11:12:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 01/14] clk: qcom: rcg: Return failure for RCG update
Message-ID: <20200403091202.GA3739689@kroah.com>
References: <20200402191220.787381-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402191220.787381-1-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 08:12:07PM +0100, Lee Jones wrote:
> From: Taniya Das <tdas@codeaurora.org>

<snip>

you sent a bunch of patch series here, but no explaination of what these
are, what they are for, or why we should apply them at all.

Any hints?

Usually a 00/XX email is nice to describe all of this...

thanks,

greg k-h
