Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A36F340AD3
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 18:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhCRRC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 13:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhCRRCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 13:02:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF8A64E07;
        Thu, 18 Mar 2021 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616086916;
        bh=I+1tJaROjaJ2NLUs21QiIetoDQNwWx//QTiUSM9j4cg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aNpMoVHPxFHJZw4WcY7Vu0ygCumpxDxXXnErqv2bxlUYJNawbUA/YRNMb+NSqG1oJ
         4ohWHclFIBMD7KoZMao08chX3xqNFexR0as3skRjb1+vq1nlt1UNxwrfdmL8EEmsgp
         0oZJf0DGlstrG0j0aYz3v0ccvt5Bf2hsJJpwPfnA=
Date:   Thu, 18 Mar 2021 18:01:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>
Cc:     wsa@kernel.org, paul@crapouillou.net, stable@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, sernia.zhou@foxmail.com
Subject: Re: [PATCH] I2C: JZ4780: Fix bug for Ingenic X1000.
Message-ID: <YFOHgfEMrEhgbdyO@kroah.com>
References: <1616084743-112402-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1616084743-112402-2-git-send-email-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1616084743-112402-2-git-send-email-zhouyanjie@wanyeetech.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 12:25:43AM +0800, 周琰杰 (Zhou Yanjie) wrote:
> Only send "X1000_I2C_DC_STOP" when last byte, or it will cause
> error when I2C write operation.
> 
> Fixes: 21575a7a8d4c ("I2C: JZ4780: Add support for the X1000.")
> 
> Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
> ---
>  drivers/i2c/busses/i2c-jz4780.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
