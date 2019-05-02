Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A961137B
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 08:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfEBGoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 02:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbfEBGoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 02:44:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E03F4208C4;
        Thu,  2 May 2019 06:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556779457;
        bh=kiu0kiYCJm693AxN/CZK7ikgqWBQr0vP+hyr4NAc60Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tx/7wFDQka6+zB8ZpYzkG9e3GjmQ0a074LYzXuRkCWUi8Ht7ApfI1UKc+VWvY6brR
         hrbKxgLUkveQFUHENvsJXWTSdSl9zrMIH6Wl/rW/TGPaWS4k27YKmJ5BXfSf/W/XeU
         WWKelPCQkPc3YBJXUYheN/QnYN7W8HIAq/8Nv9/g=
Date:   Thu, 2 May 2019 08:44:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bharath Vedartham <linux.bhar@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.0 00/89] 5.0.11-stable review
Message-ID: <20190502064415.GA15017@kroah.com>
References: <20190430113609.741196396@linuxfoundation.org>
 <20190502053039.GB419@bharath12345-Inspiron-5559>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502053039.GB419@bharath12345-Inspiron-5559>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 11:00:39AM +0530, Bharath Vedartham wrote:
> Built and booted on my x86 machine. No dmesg regression.

Thanks for testing two of these and letting me know.

greg k-h
