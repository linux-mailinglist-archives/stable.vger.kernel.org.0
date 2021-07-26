Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADA33D56C9
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 11:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbhGZJEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 05:04:53 -0400
Received: from phobos.denx.de ([85.214.62.61]:46508 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232482AbhGZJEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 05:04:53 -0400
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 0D024832B0;
        Mon, 26 Jul 2021 11:45:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1627292721;
        bh=evFCuW5/Fj9lLkAb8eYsA2cuyfQ7exdLQrH9WF222D8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=V8eHQsbfJJyD6CnxSSLNlc2zj4qBYQszBI6OcCog/iVZN702BVFIF2fiD822XlQew
         YQvMRsI3CEJ96C2cjslsY8ctWsi7I+1gKMb++FmsTFqhQ+EjSmSLCZn2NaeEmt3Hq6
         TM0IUNPkr19Hdtk5Gz7g6uzxPnJDz6QfuZuV9PcnhpH18eWZWcbBPlYs6JAIaRBk/Y
         W+NHtHmK23cl/OBqWiHwO7aLT0jdOj3osNv4r/hW1y/zmicm6OTq3Iov6GRTFBx2/3
         m45tEc6sUALiYcrj9PckyL+/XK2DrwX1emYGvWWUc19aEKEv/PpENz5MA7TqWFyXnD
         FhT3RT6vLnDzw==
Subject: Re: Patch "spi: imx: mx51-ecspi: Reinstate low-speed CONFIGREG delay"
 has been added to the 5.4-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org,
        linux-stable <stable@vger.kernel.org>
References: <20210726024900.3BE0C60F47@mail.kernel.org>
From:   Marek Vasut <marex@denx.de>
Message-ID: <e8f0f5b3-c413-0f72-d94d-84833d7e771c@denx.de>
Date:   Mon, 26 Jul 2021 11:45:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210726024900.3BE0C60F47@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 4:48 AM, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>      spi: imx: mx51-ecspi: Reinstate low-speed CONFIGREG delay
> 
> to the 5.4-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>       spi-imx-mx51-ecspi-reinstate-low-speed-configreg-del.patch
> and it can be found in the queue-5.4 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

There is a subsequent fix for this patch posted to the SPI ML, so please 
drop this for now.
