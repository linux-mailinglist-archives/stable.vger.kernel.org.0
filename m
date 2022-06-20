Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADD3552446
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 20:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244551AbiFTSxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 14:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343680AbiFTSxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 14:53:34 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C76C1D33B;
        Mon, 20 Jun 2022 11:53:33 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 23so4853225pgc.8;
        Mon, 20 Jun 2022 11:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ubIwgzR3dRtrzrZ+Ecwh20luGvcEvgOQMl0qCmxH7MQ=;
        b=EurIFJklMfGESJ+gTISFbedyhNACAsWAZ96xXe3gghAasr89Tquf3TYoyfZCDTN3r5
         /pn6daZiZUPh7OigBBEtbzSGgOGzLkbwhjJoGNHnHUry3uN0CnbfZp43FccGw2f9WQW0
         DogsBMMWhJyPKpeJsIAS6qnz7QQ6NiKTEfG9S57N8l36hMAUBCVzbAKtejx16rbfIHOF
         jNLzxmEHkP/6yEKWbAqkv/vmQqHFXODRkpyjw1CzhOpiSo2tKQ7IEnUFkPMx0X5UYUOm
         2ZMkgmXBqHsXa/MaOh+Oj91Q9fhfMvdacrqhOMHBYgNUlFfPidg2rlDeN9kmafZir7/W
         rQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ubIwgzR3dRtrzrZ+Ecwh20luGvcEvgOQMl0qCmxH7MQ=;
        b=JeOYHy0gVKX6zGXClPLm9f7Dtg680HcwDmgpkmDW0B8gpiySL+Mgof2npXUZsD0Lyw
         vAytlCPGDKKJzTXUBdfEJozx9gB3clxFqaeBlTajWDnJtthDdVf1YCFxd2AMrENdge4k
         kr3GxS2drHkchaBGxc75LkyJoFfeX5Oca0mFUihZ1NDE9TSuOZzBDv8J3i9PV5AT4csa
         klvvefR5gJ6bNDflVW5LFIaIdg2lqBSPbIZwPELEiOYuA4j8c8YRr55/XfLLIMeLpJZY
         eyDdCyxvmZNkWwxq4DnbEjuJdPd4vZyvydo6PbUpJX0Mdy3xQcqXj7RoUPI8fikaRiNU
         /kHA==
X-Gm-Message-State: AJIora/VWj7zXskX6Gj6dfZi7S/egOKzCvmnQEF42teInOvH+KqAd/l6
        /Qot7mQKxvZHtWmVYG04SzGvjm+pugMxlbSK
X-Google-Smtp-Source: AGRyM1tENniEux0DTPy0i/rDdBO0g9wqy5JrcUp88+nO5Y3Y9XDAd34cQR8w3kk1uzu+lJlEQqUDpA==
X-Received: by 2002:a05:6a00:e12:b0:525:21db:1ad with SMTP id bq18-20020a056a000e1200b0052521db01admr7216869pfb.68.1655751212528;
        Mon, 20 Jun 2022 11:53:32 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id h9-20020a17090a2ec900b001e29ddf9f4fsm8618250pjs.3.2022.06.20.11.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 11:53:32 -0700 (PDT)
Message-ID: <62b0c22c.1c69fb81.4e15d.c0ad@mx.google.com>
Date:   Mon, 20 Jun 2022 11:53:32 -0700 (PDT)
X-Google-Original-Date: Mon, 20 Jun 2022 18:53:25 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
Subject: RE: [PATCH 5.18 000/141] 5.18.6-rc1 review
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

On Mon, 20 Jun 2022 14:48:58 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.18.6 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.18.6-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

