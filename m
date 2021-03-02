Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBBB32B261
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343734AbhCCAxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377607AbhCBSpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 13:45:13 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BD8C06178B;
        Tue,  2 Mar 2021 10:44:19 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id d9so20958022ote.12;
        Tue, 02 Mar 2021 10:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wcqW2X8n8SBjvwa37/32ctpO7IKvAnfnyRFYSshe08c=;
        b=ks3JIk+LEDdNV+tAUwG/PwUTP+0vTDqti7AqZ5mUZuXMfeQX+2ZnFo3Hl95/7jNyJ1
         gUopllkrKYQUnDaMFDaFQwKaddm0i5YFM8gj5n4QGI3lJcmltilDfpo95JcmS99XtMXj
         UgpfQVNc/Xpd98lo/iGxBcYFqdDQW6xlLvNdl/dP+TE+Z7qUcKheLAnRbcMhMaJkDjaK
         juJjlkBeaK54Bpm3+hS5fkyLypVHpRJVlNBhh5tVIU1fEfZHIh2t39FKrz/uj1m9Zx5+
         U2eljCA2AxwERaVRqOcuoRed/OjVrxEoGR36D7j1KGtUUflNthHcrqCgzxpzGHmoknch
         zSTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wcqW2X8n8SBjvwa37/32ctpO7IKvAnfnyRFYSshe08c=;
        b=PCTi21clQG8z2D3ZGVtcKgJuwKQN0yuvUIr33A4mAOP+3jVKvs0Wfug4SCEP2mofCV
         kl1yciDAqmI2V96eF16XhRlgiCuQXZi4XRm391p+zsmf2kAgRbJmAD8D18KobMUPmFFR
         ehqUyOHwbBYVatjrfpV0IPUjGb8majQ/P9rCOEOOUsBy2/Ra4BDT+QmBe/jOt6dJEqht
         qR0LDfLMEpLfcGB/Kr5wupBupZyI7WF840wUkB9rf5hiIQNY3MfaH7d3GOEXXG6zL8oF
         yP+weQHx+XmlyLNTTNf2pFfROSeDftCm+iaAq85oo+uzMi2T20WvpnrmTeth3y6NVniR
         7xRw==
X-Gm-Message-State: AOAM5312m6aqZ+sUzNCXWHk7TLaSP9mVws3MkwwqvAqyQHJRWctXcib6
        RwEVQhD0AKsftXX25W2lvz3INddRGI0=
X-Google-Smtp-Source: ABdhPJx+/qgHVZzNJO2iFVFVvj2742VtYSQKKRawibgFwLdp+RBxb+2Vv40KibCe7ky9wSfuAqTnKw==
X-Received: by 2002:a9d:ea8:: with SMTP id 37mr19507133otj.312.1614710657654;
        Tue, 02 Mar 2021 10:44:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f29sm4238868ook.7.2021.03.02.10.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 10:44:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.10 000/658] 5.10.20-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210302123520.857524345@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <b0456766-0744-2086-a9ba-daa6aba5e896@roeck-us.net>
Date:   Tue, 2 Mar 2021 10:44:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210302123520.857524345@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/2/21 4:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.20 release.
> There are 658 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 12:32:41 +0000.
> Anything received after that time might be too late.
> 

Building arm:allmodconfig ... failed
--------------
Error log:
drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c: In function 'mtk_aal_config':
drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:183:54: error: 'struct mtk_ddp_comp' has no member named 'dev'
  183 |  struct mtk_ddp_comp_dev *priv = dev_get_drvdata(comp->dev);
      |                                                      ^~
drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:185:44: error: dereferencing pointer to incomplete type 'struct mtk_ddp_comp_dev'
  185 |  mtk_ddp_write(cmdq_pkt, w << 16 | h, &priv->cmdq_reg, priv->regs, DISP_AAL_SIZE);
      |                                            ^~
drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:185:2: error: too many arguments to function 'mtk_ddp_write'
  185 |  mtk_ddp_write(cmdq_pkt, w << 16 | h, &priv->cmdq_reg, priv->regs, DISP_AAL_SIZE);
      |  ^~~~~~~~~~~~~
drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:89:6: note: declared here
   89 | void mtk_ddp_write(struct cmdq_pkt *cmdq_pkt, unsigned int value,
      |      ^~~~~~~~~~~~~
make[5]: *** [drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.o] Error 1
make[4]: *** [drivers/gpu/drm/mediatek] Error 2

---
Building arm64:allmodconfig ... failed
--------------
Error log:
drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c: In function 'mtk_aal_config':
drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:183:54: error: 'struct mtk_ddp_comp' has no member named 'dev'
  183 |  struct mtk_ddp_comp_dev *priv = dev_get_drvdata(comp->dev);
      |                                                      ^~
drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:185:44: error: dereferencing pointer to incomplete type 'struct mtk_ddp_comp_dev'
  185 |  mtk_ddp_write(cmdq_pkt, w << 16 | h, &priv->cmdq_reg, priv->regs, DISP_AAL_SIZE);
      |                                            ^~
drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:185:2: error: too many arguments to function 'mtk_ddp_write'
  185 |  mtk_ddp_write(cmdq_pkt, w << 16 | h, &priv->cmdq_reg, priv->regs, DISP_AAL_SIZE);
      |  ^~~~~~~~~~~~~
drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c:89:6: note: declared here
   89 | void mtk_ddp_write(struct cmdq_pkt *cmdq_pkt, unsigned int value,
      |      ^~~~~~~~~~~~~
make[5]: *** [drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.o] Error 1


The same problem also affects v5.11.y.

Am I missing something here ? Why do I see that problem ? It seems to be very basic.

Guenter
