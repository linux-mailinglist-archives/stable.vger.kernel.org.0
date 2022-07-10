Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D62456CF58
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 16:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiGJOIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 10:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJOIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 10:08:04 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709FEBF4A
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 07:08:03 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id d2so4897035ejy.1
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 07:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=k8DpnoCNEPeOsFVCRupJioqWKpROk35oxUCGnISy0Lo=;
        b=KkOQ1PmCtb4OhZ+0PcQzLEzLQHYmDGnHFCv61erPO8fSoprsYmSXF/JXiLviDxELZx
         C+Lfkfm/C2Dc/kmbNCeVaVO+b/8f/qhD1T1gLB1/NuWOv3xpqPYJOtdz2mqXEqljZGiK
         WxGVOJ5bTDZqSZZyp0hDnwp4SRpqRXnsqMHBwe8u8tRh32JMQh6dGqmwPP+6nb3xRn0X
         stKVkPeshzPJnug28U3c4VL7+ffKQATFHVoog7apTCC0H0TM3iRbOZu0p84GO+D4qU8Q
         z3L02wU9nAKsTFjVkiOXo78bcZDHDRTobUfnSIS3mmTBk2Q6xAmudZpiKJgUVvNIE9V7
         L8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=k8DpnoCNEPeOsFVCRupJioqWKpROk35oxUCGnISy0Lo=;
        b=14go7LY0wjJUjdjw21ttSB2k5Eenfk11tHktEIk0iYHpYn+KuKH+QDzXrLR0kj7mFF
         Tj8hCbX+IsPvI3GyRNoteeB64+ND/a9wNlNjHUX78toFkLSlpCvk4u/b6a7X8FlryQMb
         +Byl3eoOKuK+LTyW9NcqEtO/jtnjU2KbIG3Cxm+e7kNFTV7SXlKkxTwnQkgZQMWIhSA8
         b6zLtJfbFEF3lBGdp5h8uzKW2IaR1gDTPM4cTlOUBWFVL7wOsYjsgJopZXL74BBTKTRz
         neIUuLZBrGnTTvMzt1Ns9iwry774lDbzbboN0fiAo4ui2AOPmoGxNSaM40mI6ISbpE4B
         DRXA==
X-Gm-Message-State: AJIora8ZYBsOwAIBk+7eAFgvCS4H8zTJshfwWgsLLbUSAcgYGRjL+HHR
        zbdGiUJRWAzKb1nm4T8RiTQ=
X-Google-Smtp-Source: AGRyM1tD8FGrRzNRxnKKaiLyRU6XxFZGsFAFZjf9RhmH9Cf14en/1OrGMPPP/1WmyYJpv8eZnH8G/A==
X-Received: by 2002:a17:907:96a9:b0:726:a82a:ad6d with SMTP id hd41-20020a17090796a900b00726a82aad6dmr13793081ejc.480.1657462081802;
        Sun, 10 Jul 2022 07:08:01 -0700 (PDT)
Received: from ?IPV6:2003:f6:af42:a000:bd65:5b56:da6a:a3d? (p200300f6af42a000bd655b56da6a0a3d.dip0.t-ipconnect.de. [2003:f6:af42:a000:bd65:5b56:da6a:a3d])
        by smtp.gmail.com with ESMTPSA id q21-20020a17090676d500b006fe8a4ec62fsm1616461ejn.4.2022.07.10.07.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 07:08:01 -0700 (PDT)
Message-ID: <cbc4d668-819e-26e9-52c6-01ea4b62892e@gmail.com>
Date:   Sun, 10 Jul 2022 16:08:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/2] security: introduce CONFIG_SECURITY_WRITABLE_HOOKS
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, James Morris <jmorris@namei.org>
References: <20220710131055.12934-1-theflamefire89@gmail.com>
 <YsrTlX6MHQWazszI@kroah.com> <YsrT3AjiVaK4oCi/@kroah.com>
From:   Alexander Grund <theflamefire89@gmail.com>
In-Reply-To: <YsrT3AjiVaK4oCi/@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.07.22 15:27, Greg KH wrote:
>> What kernel version(s) are you wanting this applied to?

That should go onto 4.9, I see I should have used `--subject-prefix`.

>> And your email send address does not match your signed-off-by
>> name/address, so for obvious reasons, we can't take this.

My 2nd email (from GMail) is much easier to setup but I'd like to keep my usual signed-off tag.
Would `--from=git@grundis.de --reply-to=theflamefire89@gmail.com` be acceptable?
 
> And of course, why is this needed in any stable kernel tree?  It isn't
> fixing a bug, it's adding a new feature.  Patch 2/2 also doesn't fix
> anything, so we need some explaination here.  Perhaps do that in your
> 0/X email that I can't seem to find here?

Good point, so I need to use `--cover-letter` even for backports. Makes sense.
The previous discussion can be found at [1].
The essence is that this adds security hardening by disallowing writes to LSM hooks after initialization.
Additionally included here to reduce divergence with mainline to ease application of further (backported) commits.

Regards,
Alex

[1] https://patchwork.kernel.org/project/linux-hardening/patch/alpine.LRH.2.20.1702150016220.32759@namei.org/
