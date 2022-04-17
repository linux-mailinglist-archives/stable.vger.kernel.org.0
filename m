Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CF25047B5
	for <lists+stable@lfdr.de>; Sun, 17 Apr 2022 14:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbiDQMTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Apr 2022 08:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbiDQMTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Apr 2022 08:19:44 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C082314;
        Sun, 17 Apr 2022 05:17:09 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ck12so1185527ejb.4;
        Sun, 17 Apr 2022 05:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:cc:references:subject
         :content-language:from:in-reply-to:content-transfer-encoding;
        bh=4AWzMkn2REJdxzoBq8sd8O7Q8q12XiYN49koYpewt9c=;
        b=iexMTYj3Hrug4YHuzpVDDhxhxuJUn+FHke1lHNEUBr0bvaM3tl/UxQbYtBQbT8F7q7
         BdU+tVyzAENMkP032YHgGhgy21L+xok792Ee+NFlOsIfBFr8Zms5vUs9DNZQpmRAl0t/
         TfjMRbQq3uVd5WjkVQDlnNxTrTzg3seXavSaTb3Y1eW2SjfoMNUpD3WGukH3tz3OATsS
         Ij7Ivgn2lu5kp3oumOHFNm00XrAEj1LYXY3J+Y+McbmRLkxmZvbFZNvlHYr3gxOgsOKW
         +ylj/tbV+bltc1wRFBWm/71Ofm7S1AWEDw1zFtj/sjI/TofuZ1PUWiEDfYHj7J0vjmjy
         qmhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:to:cc
         :references:subject:content-language:from:in-reply-to
         :content-transfer-encoding;
        bh=4AWzMkn2REJdxzoBq8sd8O7Q8q12XiYN49koYpewt9c=;
        b=POVKzzSnAIK7FcR1IXTKfUQjex6a/DkgRRvBRO9Yazrf8ZItxTTkto0OBIMexICxTN
         6y7TD5E//DLaYXaTO2nNEIsYPIDt6gyJIAwEkEuLxqppNgFy5IckikF3QhwuXpRaEjsx
         Jt+j39YKR/tS7BZWfPoDz06DhC6dLdAuN6AjyQEVQOMoEqAqQBxbO6FJSTDTE3gu8dO/
         1xHJLyeX7nJJNP3H6MAgVvA29PpbY/atsXMhHruKNlTbi3hbJZvIRXdmN4p/OQNETpLu
         xrVNFdXR6j4HJYR5LXENUeh55Vl6ldm7Oy4BB1mGtbERCkEMCP3asnmu1RrfcKlyhyk/
         VHgQ==
X-Gm-Message-State: AOAM530RQT5YDF1iCHioPOpN23Reesj8QlDyiAGQCQxDBGIk1mC9iCXV
        Zwxq6XszqSXFKqtc+NrfKHg=
X-Google-Smtp-Source: ABdhPJx5tgmeQ8i9GZOmuTQvKSoK1/5kLvvROaCFuHdZoGEDAdpwkzmBXe8UsRVfCw0Ub5tUeyJ3Lg==
X-Received: by 2002:a17:907:97d3:b0:6ef:6af8:7352 with SMTP id js19-20020a17090797d300b006ef6af87352mr1906059ejc.29.1650197827886;
        Sun, 17 Apr 2022 05:17:07 -0700 (PDT)
Received: from [192.168.1.84] (host-79-32-251-169.retail.telecomitalia.it. [79.32.251.169])
        by smtp.gmail.com with ESMTPSA id g24-20020a056402321800b00423e43ebb60sm514743eda.61.2022.04.17.05.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 05:17:07 -0700 (PDT)
Message-ID: <4ded2708-aba6-ffb2-f787-7c78f9d12a11@gmail.com>
Date:   Sun, 17 Apr 2022 14:17:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To:     mario.limonciello@amd.com
Cc:     Basavaraj.Natikar@amd.com, Richard.Gong@amd.com,
        andy.shevchenko@gmail.com, brgl@bgdev.pl, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        shreeya.patel@collabora.com, stable@vger.kernel.org
References: <20220414025705.598-1-mario.limonciello@amd.com>
Subject: Re: [PATCH] gpio: Request interrupts after IRQ is initialized
Content-Language: en-US
From:   luke <lukeluk498@gmail.com>
In-Reply-To: <20220414025705.598-1-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested-By: lukeluk498@gmail.com Link: 
https://gitlab.freedesktop.org/drm/amd/-/issues/1976

