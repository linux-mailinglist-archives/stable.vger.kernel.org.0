Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C04A4E65B6
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 15:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245483AbiCXO4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 10:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242275AbiCXO4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 10:56:34 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43CC7A987
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 07:55:01 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id t2so4153757pfj.10
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 07:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=PPPE5D7kHhLypK/I13yUGA0LwSYXi2L9dMVxomH615I=;
        b=A+t/aDYTrxH+zqeyxAfc5wHmap3dHJm2jkXy4cBe59b/uuU81X/EvC9slAT3J2PDsP
         J2hW9fv3RUYbHwmMbWGNIfYOhUih7xOqxzEGIT9MJ8T1aMBC4Oc85pu5QsaHt2jFh9Xh
         wC8akQxoIAfdYWwySPbXG8LTI14Jg6fbnkTvZ4GvALZ1NGVD3Y5Y9jxBt/32QvR01rTu
         jlzCNfGYkArrKrLqZHgS5T2BBznSnl1i3We9dR8VSc1vX8IkIOrNLvMI/6OnAWDaOsTG
         GZpX4QgLyp+SoX8SmsKt0K8uwtryHobbGyrj/llZl770ecPA2SPxoSvIVcSViDF5z8Im
         ym8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=PPPE5D7kHhLypK/I13yUGA0LwSYXi2L9dMVxomH615I=;
        b=vU8kojlIfebXm0ndwW3cg8TQrdasjBnllzcvWVpgcpanFQLtoa4KzC+4rPNbFTN4Ku
         UKc5cnVGr1lse2+CA5dFcZvI2ftrKoWVC8jSkwRu/sqZuShy7NHVBD5pVwFkCbk27NCj
         nVPm5WXRI458LaKCT1kN4QvZWAsK41c4uIZyJPPUwGVyBdo11x7KMgM8dSi+wMW5ya5P
         0YwrnCN3B3lNChiys7Ucp7EhroGYOWKW0ihD34btcDDJCGRvHqEmy/UwZEN/tTizb83y
         NjkHDYZ8KF1KI5TV6rVy+4QcW+yRTZw/HX718IVjlzEC1WZwviZQqxPIn9y2M9BRSKYh
         mEZg==
X-Gm-Message-State: AOAM533bKPDRQGVe+dRslO7oigDnAyCO4LIP2lFdGSrk1NcTLWySql/J
        W+6Zpxr4vaofzxP8hxZMj+Mak9bcN1aR048X
X-Google-Smtp-Source: ABdhPJwW2Fb+Re9+inKgegGfGcCCdnruAh0x1RBdBNo4H+UH9ThwdFys0alzAy62LkBjB8BUv9vffg==
X-Received: by 2002:a63:4f08:0:b0:34c:6090:603e with SMTP id d8-20020a634f08000000b0034c6090603emr4191523pgb.15.1648133700942;
        Thu, 24 Mar 2022 07:55:00 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id bx22-20020a056a00429600b004fa936a64b0sm3564351pfb.196.2022.03.24.07.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 07:55:00 -0700 (PDT)
Message-ID: <e7d8a669-b2ba-a7c3-9bcb-24af77a51d7d@linaro.org>
Date:   Thu, 24 Mar 2022 07:55:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Apply "tpm: Fix error handling in async work" to stable
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply upstream commit
2e8e4c8f6673 ("tpm: Fix error handling in async work")
to stable 5.4, 5.10, 5.15, 5.16, 5.17
Link: https://lore.kernel.org/all/20220116012627.2031-1-tstruk@gmail.com/

--
Thanks,
Tadeusz
