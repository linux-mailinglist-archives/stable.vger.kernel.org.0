Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A6254BFA3
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 04:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiFOCWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 22:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbiFOCWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 22:22:41 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D3D2DC3;
        Tue, 14 Jun 2022 19:22:37 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id y17so7864651ilj.11;
        Tue, 14 Jun 2022 19:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=+OM5i749HJ0lbgx3f4hiitPP5AQjnk1kKAY5+9r81pk=;
        b=VdL98t24mTd2/nf3gNu7xMuDvqAr6a1FOPUQklAO1iYbcaAiL/bhyOodSCxa+gnnDw
         VsR6uJEP/ssbpy3WliOrhYVCCPMLO504qv+tRdfsSKxnDJlWBKmUM57f2Y5UVwqtK39l
         Jvg3O8ypwg4B24s4DJCiLZDjRUfJ5Ychr7jRjewg/KHKjSlV2ZQjsUlo90cCr+y77A4l
         8n/7hkQtYXr5IUxm4sFi9A+xtXPD8CEjBrUET1ND2xeJ9gX64sK2tmWfbo6kBeadVwVE
         8uh1CPBptFaNc/yRbcQDFc3WmayMDSCi4CHGy0YdTuq0WegPub/o7qDx72ubMxWGcaC1
         9ikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=+OM5i749HJ0lbgx3f4hiitPP5AQjnk1kKAY5+9r81pk=;
        b=Z/o8WxlEEmlb8S2kCCMQYNRRxmE2WNa6kZinZMD5eIKXrDzahxn1SEEAOQjwGRNMgp
         Py79WzBLqPV6RDLbS/o1NbV3JWNvUriyOvIaRmBnfmvq8PByMgTvugdO6wVbzr5Goh/0
         m/CAHrP6XqGrRNN3RfG1EEuYdL0ONTqLc1MCIFsivMcNjRA7+wyf7r28FArHYkFhhh0v
         EdMyHOYiV0vPnwckQ9nCKogtKMZjCl0kdDV5gyrGy9Pn/SDdu0gyf/f64QNW35lJrV7v
         6NVtohlWPn7CJxyzueM17HcAIvFwAgNocDqSlEmhZcFb+nkXFKEtBy88Bse8l87/OAjO
         k3ng==
X-Gm-Message-State: AJIora/h19FWcL33fxzajagLbHgehZNxp1+4YOpZDoijYbXRgA97l3qT
        SgrXDv0E6sZT6Kx0JHChtAjyshHx3FN4hQ==
X-Google-Smtp-Source: AGRyM1tB48dDe8RQQl6d6FDNI4bx9iP6CsGfEijr1HdTyqqrfgj4iw+4mTghJV8VC1a8ulSVcVoLIQ==
X-Received: by 2002:a05:6e02:967:b0:2d3:9b99:e8af with SMTP id q7-20020a056e02096700b002d39b99e8afmr4446782ilt.202.1655259756074;
        Tue, 14 Jun 2022 19:22:36 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id l44-20020a02666c000000b0032b3a781767sm5576305jaf.43.2022.06.14.19.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 19:22:35 -0700 (PDT)
Message-ID: <62a9426b.1c69fb81.a50a5.65b4@mx.google.com>
Date:   Tue, 14 Jun 2022 19:22:35 -0700 (PDT)
X-Google-Original-Date: Wed, 15 Jun 2022 02:22:34 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220614183720.861582392@linuxfoundation.org>
Subject: RE: [PATCH 5.18 00/11] 5.18.5-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 14 Jun 2022 20:40:37 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.18.5 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.18.5-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

