Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D5C571B38
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 15:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiGLN25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 09:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGLN2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 09:28:55 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD9D1209E;
        Tue, 12 Jul 2022 06:28:53 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cp18-20020a17090afb9200b001ef79e8484aso1275376pjb.1;
        Tue, 12 Jul 2022 06:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GnlvcBEXLu8H/KOXfODpSnYO2E3R3GpgxjmeEYK6iRQ=;
        b=Je+3XcYjzIeRdqL0zFrW7wS4YOGSPCu6QFetrjOW4qR2rTRmmHLlOWYyFoPulwdQHo
         eohwWSs4lFN1kiosnPGntxZjlh22YzvjPw/3YNdYj+P4H+lI2ziSay8rFEw3p/IMzEo7
         IH8xFUET6IpKVQmFMC3Bpj6rNHjB9niaQJSNh9yGpdkLyabWMUw2pWkJ8wcZ7aGNe0AK
         s9XRPvw/ccjDktI6vRBhUilJofqKAE56dK2JfGESpyQZ4Acfs4xnytp00HxIihzZfhFJ
         gcvSAQsTEp0LBlI7He/ZS1m4YeZ0pBO7sWRSS2AffVrLrkPtoMHw5vE6O5hFSuQqwfkU
         MJ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GnlvcBEXLu8H/KOXfODpSnYO2E3R3GpgxjmeEYK6iRQ=;
        b=OOmfNCnWo7WXh/X5InyXitnFJJd6L/dzLTindj5ySmV4Jh0aSK1OGtj7Pkwt6LpQtN
         VjDgGPNpxG4ziVU7R+PDIVHULuOmiQ8GksbOu2d9+3pBvSP91zKbffMNmn9akVKWJqNh
         z/JLnGsBPHh7GUQz7jwB8j5VeAOq94M94vEsTTsq91hMWIWXNp8z/nKrHIehsaVFVndq
         Z1PmB7lENq5AdqVNbUbI2zSo5BQdq8Qsj+lD54bm1iaR4uV8hWE5eHE6pknCESTaMtDg
         T1c/yRP5sS2SgjipIiBveE3ZEBEp9dxE+uYZST8PCi6vRYqp0b6A/erBz+lXABukcBkR
         pSKQ==
X-Gm-Message-State: AJIora/19pKDIEOzdYvcKPQxqEE9Ho+iZeUHsIsgtiIwqipndXgG9VOT
        aF6r0XGNIcEmGWccMIkfylpZFwx5ga5jAw==
X-Google-Smtp-Source: AGRyM1slnANxKpyydNeZZHIJvwaDiy3/nDj5pbd1CwktntiCJVsfq2MS8w8vlsRCe5Lq5xOIyQMG0A==
X-Received: by 2002:a17:902:cecb:b0:16c:40a8:88ff with SMTP id d11-20020a170902cecb00b0016c40a888ffmr12781439plg.33.1657632533309;
        Tue, 12 Jul 2022 06:28:53 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h3-20020a170902680300b0016c29dcf1f7sm6788715plk.122.2022.07.12.06.28.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 06:28:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <bf8551f8-c369-1099-e293-c884bde4be54@roeck-us.net>
Date:   Tue, 12 Jul 2022 06:28:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 000/226] 5.15.54-rc3 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220712071513.420542604@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220712071513.420542604@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/22 00:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.54 release.
> There are 226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 07:13:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
