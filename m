Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A221D32B277
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343851AbhCCAx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1835365AbhCBTED (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 14:04:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C77C6146B;
        Tue,  2 Mar 2021 19:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614711797;
        bh=JzCpj+LSoRjjpqXLRgcrM4z5TZSRsH5dn+iRqjjl010=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D//rQmhT5Wn6vaKHoQ5Im9tH022MlX2Y2JndkWlZJmXNR6h3lofz1SS4x+MY6Ueqi
         s4djJsL57mq7WQ3ZSW++27EvJjhv6+OTcSkrZKknGdrrIf/GpIfkkqBaa+31eZIHO4
         PiINXi2xeH7fLgAd3skcj2kmezj5BUjrLUU1NmUI=
Date:   Tue, 2 Mar 2021 20:03:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/658] 5.10.20-rc3 review
Message-ID: <YD6L8/4q6Y9jA3VL@kroah.com>
References: <20210302123520.857524345@linuxfoundation.org>
 <b0456766-0744-2086-a9ba-daa6aba5e896@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0456766-0744-2086-a9ba-daa6aba5e896@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 10:44:15AM -0800, Guenter Roeck wrote:
> On 3/2/21 4:38 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.20 release.
> > There are 658 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 04 Mar 2021 12:32:41 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building arm:allmodconfig ... failed
> --------------
> Error log:
> drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c: In function 'mtk_aal_config':
> drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:183:54: error: 'struct mtk_ddp_comp' has no member named 'dev'
>   183 |  struct mtk_ddp_comp_dev *priv = dev_get_drvdata(comp->dev);
>       |                                                      ^~
> drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:185:44: error: dereferencing pointer to incomplete type 'struct mtk_ddp_comp_dev'
>   185 |  mtk_ddp_write(cmdq_pkt, w << 16 | h, &priv->cmdq_reg, priv->regs, DISP_AAL_SIZE);
>       |                                            ^~
> drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:185:2: error: too many arguments to function 'mtk_ddp_write'
>   185 |  mtk_ddp_write(cmdq_pkt, w << 16 | h, &priv->cmdq_reg, priv->regs, DISP_AAL_SIZE);
>       |  ^~~~~~~~~~~~~
> drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:89:6: note: declared here
>    89 | void mtk_ddp_write(struct cmdq_pkt *cmdq_pkt, unsigned int value,
>       |      ^~~~~~~~~~~~~
> make[5]: *** [drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.o] Error 1
> make[4]: *** [drivers/gpu/drm/mediatek] Error 2
> 
> ---
> Building arm64:allmodconfig ... failed
> --------------
> Error log:
> drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c: In function 'mtk_aal_config':
> drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:183:54: error: 'struct mtk_ddp_comp' has no member named 'dev'
>   183 |  struct mtk_ddp_comp_dev *priv = dev_get_drvdata(comp->dev);
>       |                                                      ^~
> drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:185:44: error: dereferencing pointer to incomplete type 'struct mtk_ddp_comp_dev'
>   185 |  mtk_ddp_write(cmdq_pkt, w << 16 | h, &priv->cmdq_reg, priv->regs, DISP_AAL_SIZE);
>       |                                            ^~
> drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:185:2: error: too many arguments to function 'mtk_ddp_write'
>   185 |  mtk_ddp_write(cmdq_pkt, w << 16 | h, &priv->cmdq_reg, priv->regs, DISP_AAL_SIZE);
>       |  ^~~~~~~~~~~~~
> drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:89:6: note: declared here
>    89 | void mtk_ddp_write(struct cmdq_pkt *cmdq_pkt, unsigned int value,
>       |      ^~~~~~~~~~~~~
> make[5]: *** [drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.o] Error 1
> 
> 
> The same problem also affects v5.11.y.
> 
> Am I missing something here ? Why do I see that problem ? It seems to be very basic.

You aren't the only one, I got an off-list response that this was seen
as well.  Let me dig into it...

greg k-h
