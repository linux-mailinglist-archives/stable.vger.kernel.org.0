Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26556D9C5A
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437480AbfJPVRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:17:01 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:35845 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727542AbfJPVRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 17:17:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id A5FBB721C;
        Wed, 16 Oct 2019 17:16:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 16 Oct 2019 17:16:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=TDIuhUqyETt+wUzSenxW4gSfVzI
        J3N49EH7vP3P1UPw=; b=crNv5j1k2SsRQS5f3cUQ7HdTBDG9uyu6KGfumMMf8sY
        QhcJ8T/vsPywtbJyLI6LJ9+lkZCX+RnrDr5JJ7fSpzV2gVAVAN2ou9WKGsTqW1kd
        6PDH4Y/s15dI+UHZ18MVIaKU+WBKcUbgN6XTKRZxg4hRLZmBOBCyFEK5HP0Ia1Ht
        HWldOZQRiNWk+V5vxEcADntiSkqHPW2/a/atQvMr9ECXqxkdam28dbrLSS0NPoyf
        eIVLBC8RkZcm3lB7jLwzJsw0GBWq2bon4Mv7+dlGFEAcNRvv69WxBkDb20yJFsC8
        kXotq9zNaeBAG/khmhggLIAY9+YeBy8ZmNCi/8WyRdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TDIuhU
        qyETt+wUzSenxW4gSfVzIJ3N49EH7vP3P1UPw=; b=e74ZIf2bn1B7OgTPPafrLu
        j7JMRX4NTZVdbpL6bIchqZhpptR3p1WOEDkEKmSfqD6d0anip+aEipGyiyW2fqIy
        GtGVu4+9KdOG4RhE0CrnJn8VWMF0IdGgy0RB/xAkG0cbU2YZnDhEh5eRmjkEGr0g
        EXnxUDfKHYw+vUKWn/Siqse7uSjFs4e1papPgp/87zIrpZjHL2YGZELC4zFuK+sk
        9cU6caTi77OXbigCyEDrtj5d8yUKvNv1xS3NF13D4WYiC6k6wtnh92JwUPqrymae
        j+0U12zsrIL5oVf+/4pq3sweO6DaQe+hQtj9iSuYg+ZDhMKdPzDNJ8Wgw8bywxXA
        ==
X-ME-Sender: <xms:yoinXfuzRqRkM5zUeUHD_u8JNS8eqrWBSsCKr4L4UKqAL1GnI5avEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeehgdduiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepudejvddruddtgedrvdegkedrgeegnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:yoinXUwPyqot8LUwlkCVowN-Yi6X4gfRrFStBg9sPtuxTIijnf3JMw>
    <xmx:yoinXR5-ax-XZ5wdOUGlhcZ7jQ1YkA5fsw5fTUCBrC8t-lsD_0E17Q>
    <xmx:yoinXWWeje0aVM_vhnZLzW8lX4RrC1FUWZ-cYd1pxGnhe29gNTKOdQ>
    <xmx:y4inXQnwQ-D5thTWP5pf2YvGFNuRrkktvovmLzbyB65svFqHWtAl-w>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3DADFD60063;
        Wed, 16 Oct 2019 17:16:57 -0400 (EDT)
Date:   Wed, 16 Oct 2019 14:16:54 -0700
From:   Greg KH <greg@kroah.com>
To:     Richard Leitner <richard.leitner@skidata.com>
Cc:     stable@vger.kernel.org, festevam@gmail.com, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>
Subject: Re: [PATCH v5.3] ASoC: sgtl5000: add ADC mute control
Message-ID: <20191016211654.GB856391@kroah.com>
References: <20191016091304.15870-1-richard.leitner@skidata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016091304.15870-1-richard.leitner@skidata.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 11:13:04AM +0200, Richard Leitner wrote:
> From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
> 
> Upstream commit 631bc8f0134a ("ASoC: sgtl5000: Fix of unmute outputs on
> probe"), which is e9f621efaebd in v5.3 replaced snd_soc_component_write
> with snd_soc_component_update_bits and therefore no longer cleared the
> MUTE_ADC flag. This caused the ADC to stay muted and recording doesn't
> work any longer. This patch fixes this problem by adding a Switch control
> for MUTE_ADC.
> 
> commit 694b14554d75 ("ASoC: sgtl5000: add ADC mute control") upstream
> 
> This control mute/unmute the ADC input of SGTL5000
> using its CHIP_ANA_CTRL register.
> 
> Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
> Reviewed-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> Reviewed-by: Igor Opaniuk <igor.opaniuk@toradex.com>
> Reviewed-by: Fabio Estevam <festevam@gmail.com>
> Link: https://lore.kernel.org/r/20190719100524.23300-5-oleksandr.suvorov@toradex.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Richard Leitner <richard.leitner@skidata.com>
> Fixes: e9f621efaebd ("ASoC: sgtl5000: Fix of unmute outputs on probe")
> ---
>  sound/soc/codecs/sgtl5000.c | 1 +
>  1 file changed, 1 insertion(+)

Now applied, thanks.

greg k-h
