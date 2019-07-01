Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F125C071
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 17:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfGAPkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 11:40:42 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51481 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727279AbfGAPkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 11:40:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1BB4921650;
        Mon,  1 Jul 2019 11:40:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 01 Jul 2019 11:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=rt4pQ9arKU1gW4UOxVi9M3zQ23t
        v06dyxThOMzU2cS8=; b=MANOIRBq67ZHKYWjDh21sSH+TZ3oELGkohW3hBHIL7O
        2I/F03kE6TGP6VTz551EOi5/+/JrBMy4vxrD+9+Z2mjYuTgOaSZUaJgPLbjBydxI
        VmhhfYoiKCLhkt5MXKG8fknaYhBb+cnCmRNGgWwDBwOvbDE58EiTIEIYvddJ6SAH
        Vy6eM9joVq3ofotZ0QnuyoB/bsEwxt+jgkG0BPUMxMqtovk6KR+XGCWdI6lZ7qoD
        2GbF6gsMPGvmeF5ozUa5GZ+G9F5yCmfZbXBiL4aemO1QfG+x06M2+Tv4dy8qo3Cu
        SRFMDfcB/46kMJ7ArTrPZVFSdjAGdpSUVE2h55xRvOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rt4pQ9
        arKU1gW4UOxVi9M3zQ23tv06dyxThOMzU2cS8=; b=CCZKSMHWs3z9jHI/PU78Le
        dWBPgWMq+5nwoMTy0MHWNUcmKXOjM0gIAuDofG5VuL8fp4EZl8jxUiRNtPNmQSgW
        gT35bfMnP9Dfk5ajN6UZAHOcFYwLwegR9H6wedt5SvQCJ6VZuBqOOKdB6lvMtQmR
        VgpAp9wd/ZSCntUuld2FplGEA3JuaG7U62pu0z6JVk0mvwUuSOizsC0D1MhzW8E6
        MTqU1/Hw7pXkehwbz+4zN127ZEDJ5CaDf+fJU0f5CmZmR/k4uOxNMjgv814RJ3pw
        BMhLUfuNKGnt4z7FB4vKVo1GPLjjXpizRxnePwxkDHZ+FZDKR52UTswvr0i3AKNQ
        ==
X-ME-Sender: <xms:dykaXTnysxB5_3Ng-1uJW0Szzw8OM848G0y0Jea0XNmpAjxL1oEIOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdeigdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:dykaXXMfKM1lBx8nMgQiPPx9fepam5EJNwx0OaUr0VoCz-WsNl_6yg>
    <xmx:dykaXRh8Sx2y2stQ-iT0i8UqAFubS4VQZWpCsQ2F4KnXAF34GsYykA>
    <xmx:dykaXZRGrrX365ZBy2TefDsrra-J_akSvC4S6M-Ngj1n7pXks0Tv4g>
    <xmx:eSkaXYfPRt0IxWY48wS7UF2ahnvU7biWHWs4TLEu8hMFVDr45mrXmg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2692B80060;
        Mon,  1 Jul 2019 11:40:39 -0400 (EDT)
Date:   Mon, 1 Jul 2019 17:40:36 +0200
From:   Greg KH <greg@kroah.com>
To:     Mark Jonas <mark.jonas@de.bosch.com>
Cc:     stable@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Kjetil Aamodt <kjetilaamodt@gmail.com>,
        Wang Xin <xin.wang7@cn.bosch.com>,
        Leo Ruan <tingquan.ruan@cn.bosch.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: Re: [PATCH 4.19] commit 9a9e295e7c5c0409c020088b0ae017e6c2b7df6e
 upstream.
Message-ID: <20190701154036.GA7360@kroah.com>
References: <20190626151416.10997-1-mark.jonas@de.bosch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626151416.10997-1-mark.jonas@de.bosch.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 26, 2019 at 05:14:16PM +0200, Mark Jonas wrote:
> From: Wang Xin <xin.wang7@cn.bosch.com>
> 
> eeprom: at24: fix unexpected timeout under high load
> 
> Within at24_loop_until_timeout the timestamp used for timeout checking
> is recorded after the I2C transfer and sleep_range(). Under high CPU
> load either the execution time for I2C transfer or sleep_range() could
> actually be larger than the timeout value. Worst case the I2C transfer
> is only tried once because the loop will exit due to the timeout
> although the EEPROM is now ready.
> 
> To fix this issue the timestamp is recorded at the beginning of each
> iteration. That is, before I2C transfer and sleep. Then the timeout
> is actually checked against the timestamp of the previous iteration.
> This makes sure that even if the timeout is reached, there is still one
> more chance to try the I2C transfer in case the EEPROM is ready.
> 
> Example:
> 
> If you have a system which combines high CPU load with repeated EEPROM
> writes you will run into the following scenario.
> 
>  - System makes a successful regmap_bulk_write() to EEPROM.
>  - System wants to perform another write to EEPROM but EEPROM is still
>    busy with the last write.
>  - Because of high CPU load the usleep_range() will sleep more than
>    25 ms (at24_write_timeout).
>  - Within the over-long sleeping the EEPROM finished the previous write
>    operation and is ready again.
>  - at24_loop_until_timeout() will detect timeout and won't try to write.
> 
> Cc: <stable@vger.kernel.org> # 4.19.x

This and the 4.14.y version now queued up, thanks!

greg k-h
