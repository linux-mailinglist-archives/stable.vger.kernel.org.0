Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71AE6462FC
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 22:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiLGVJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 16:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLGVJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 16:09:13 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C569869305
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 13:09:12 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id j16so1759961qtv.4
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 13:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mZhFdqdnzb1+0QwUzU6FnrG36m9/DXGLr/7x1WFMUls=;
        b=Z51Ml8LCc+BtBjMoUAXfoL5BKhpmUtUIMj7Na4xAiwL/RKtEytDPnD2HfmNvD31RO3
         182QG1lxmKnLBtubf8lXwG+eMXbizYr3U3FUOXI/A4equavF/JCEJznbr3UKEdGQRMHG
         A2aGDFFsHuIGPrC2Mo3Yl3CrpMRR22WfgFr0xUQcX28rv9jRoawImMPJx0W6fkld9GrO
         Cz1Rt/RrTCWkOJ/1DxMhm6Izi8vCROQCwTdNs7XhR5QuPcW+9T7BiYhxciIWYdbIIPD7
         pcZ6TDW4EFytR7m46WIGO/gtC4uWGg5NyX/F97GYU8w69L7nn6mBhL/BjtizryaSrLl4
         UO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mZhFdqdnzb1+0QwUzU6FnrG36m9/DXGLr/7x1WFMUls=;
        b=1H+mwDN/+O3MaVeGMV00lXSXcPu1HLl1i92c/6TX1ADKbwyDfm3O4bWtgzrA583WyA
         9lr9+vJkAwAczNX1NIRjRJWJY0OAZBrA1fJHFQOfwsxZOrN1SYMS3DFtz3kOdAF4x10W
         3gFn3+UrlCAkBO0ik9ZJwgh6jGBxI+RRoiPidlluxbEsJ0ftUVNISCJ6vX3o6ptymCwU
         Tsln9U67hq45u9MlevKOb1bqCpGZc6AHCin6ZqSrr5Lhw5hG1EkOIHnQsBgL1HzHaoIT
         iQ1Tfbpyi0d3yavgP0eJuGXBe145WlLxsHK6A9FNxIQ9wtRp37VjVVmNG2niDOWJvbeS
         pK4Q==
X-Gm-Message-State: ANoB5png6Ib7Zm7LLiI0jKKk/AfU8afuM+yoJ/6DYEGUgXiuBov4NQmW
        x1r0tzGVOB9PA4hEelBTaR0pCvBkKqrl/A==
X-Google-Smtp-Source: AA0mqf58tk+j82vPffCK7W2f76dfX3D6YgHZJL0o1NR9RQtJJ6BShMEnCBeQ4EFRTKnZY3wx8IiFeA==
X-Received: by 2002:ac8:544c:0:b0:3a7:e8da:6788 with SMTP id d12-20020ac8544c000000b003a7e8da6788mr9782244qtq.85.1670447351694;
        Wed, 07 Dec 2022 13:09:11 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bw8-20020a05622a098800b003a7f3c4dcdfsm1484071qtb.47.2022.12.07.13.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 13:09:11 -0800 (PST)
Message-ID: <23ecd021-8ea5-341e-16c7-f76ec7a641f4@gmail.com>
Date:   Wed, 7 Dec 2022 13:09:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH linux-5.4.y only] Revert "net: dsa: b53: Fix valid setting
 for MDB entries"
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20221207070155.12389-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221207070155.12389-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/22 23:01, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This reverts commit 1fae6eb0fc91d3ecb539e03f9e4dcd1c53ada553.
> 
> Upstream commit was a fix for an overlook of setting "ent.is_valid"
> twice after 5d65b64a3d97 ("net: dsa: b53: Add support for MDB").
> 
> Since MDB support was not backported to stable kernels (it's not a bug
> fix) there is nothing to fix there. Backporting this commit resulted in
> "env.is_valid" not being set at all.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks for catching this!
-- 
Florian

