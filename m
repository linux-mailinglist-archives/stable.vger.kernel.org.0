Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942664B6424
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 08:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbiBOHSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 02:18:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiBOHSs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 02:18:48 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6A2CCC40;
        Mon, 14 Feb 2022 23:18:39 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id f6so12435278pfj.11;
        Mon, 14 Feb 2022 23:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SISmdrogFQ6Wpdq6L/IBt8vJfswq/0rWbf4LzZ48HYs=;
        b=l4LG3XVOJMAoLEx2qWOJlsmfTxjgvWI3mcwTAl5BdAFyz0zDn8nSHxEK0vARgahUPh
         ovVOlhmFtsMbajkVoQuLSGTf7ZqMXox8M/O+HvOX+Z0ijWSBzMCQBGivTtJRWO2HgyiK
         1ByJPV3zdyCzp9vlIZN6RLwow8M4nbU91BXLeCuORpKtU+zKo8e/5n5cC0FODgG2fPMK
         weDZ9utHmmdPlnu1uWJpwc6RPgImiAdX0RDzux+lZpQ91xMu6s4njWeE+yurSbRQ0ntL
         FwGBDlEEo71rSTCWvkPXU6g0ddraFItHlCzUMxnkaLt5wWiIyx88Qsa4MfXBat7X6Cpl
         VlwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SISmdrogFQ6Wpdq6L/IBt8vJfswq/0rWbf4LzZ48HYs=;
        b=H60HClR1YgAmdrdLBb0GbcbTGVYXSsDvT5uk7d1cb4es+h1mQZ9Z1VBpl0gJJXr9i2
         1OU6qV17VR7A0eu9qFM2ncNHkF5q3b1le4FMSTgkTJWdVr31mrd/t39Z6ALxe7TFJCA7
         240BGSHzXjqc2lQsqzQUJOdbYZtuiTmd1lk1Eqp7/fGHbduSNUv0YpPE3CchL6Vq39u7
         NQ9hzH6S1EJqItREdTsDFOVtZAsp5S1/nG5W8s46VLj/5K8r1F/0Kc2XQ2cNDlHaOKgW
         H/laj/cGvckNMBdqOzKGszMSYVlVEtvacNr2vjMMZsKbE1SR2hokbG4kx/w2H60hipez
         tMbQ==
X-Gm-Message-State: AOAM530EwLyM+Py1wq5zVx0Q/EBOgikS2x07L47N9T96eveYkjilc91z
        MwpYn7tI+Q+jhVVydgMQ4jE=
X-Google-Smtp-Source: ABdhPJw3yruIS2d5BuDXJw18RRpWQ+JA0K/ybcY3VH6BYtmuOR5wYSHHVC2WKzGddwIF/+GYPO0YyQ==
X-Received: by 2002:a62:bd0c:: with SMTP id a12mr3058724pff.26.1644909518866;
        Mon, 14 Feb 2022 23:18:38 -0800 (PST)
Received: from [192.168.43.80] (subs09a-223-255-225-76.three.co.id. [223.255.225.76])
        by smtp.gmail.com with ESMTPSA id g126sm1558284pgc.31.2022.02.14.23.18.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 23:18:38 -0800 (PST)
Message-ID: <d81b3498-f3c7-c31b-f53e-19e94f699374@gmail.com>
Date:   Tue, 15 Feb 2022 14:18:32 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 5.15 000/172] 5.15.24-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220214092506.354292783@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/02/22 16.24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.24 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, clang 13.0.1)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
