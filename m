Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F476B2DFA
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 20:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjCITxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 14:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjCITxK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 14:53:10 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D15A267;
        Thu,  9 Mar 2023 11:53:09 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-176b90e14a9so3467979fac.9;
        Thu, 09 Mar 2023 11:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678391588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MvMVuj1YYfAwGHDiRte1xIKNtCoI7g0aNfnni9Ql/Lw=;
        b=WqAgLHW8B0jrm/YOu7zDvVQ5aK4NBR3+MzQkrRkeeFyN0skUylsiQX9KKfQ3P43tfP
         PLCPBvc9qleOMaESQRGFYgjzc0JseN3+aPI7Cxo+53CcbuITtxzMMo7OdH+bvsG8SkQK
         E6QPDphMq6BqUg5wu6O1OFxlZIuooYm/C8miqR3oa9benAXKQX0AVUvvr9pKFZkAkP49
         0OCjC2tbUZAvPDGKWBRry8E5SDdE20up3gL36H6k0FwItaF3jJNQfGcmpH6iK1ayinfh
         wKwmPP/ltTBW81LnXIipeShGqiKqJp+WiTZ/+f4Dap2oYY4OKXtMX2mNj0eOr5FeVhaK
         MV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678391588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MvMVuj1YYfAwGHDiRte1xIKNtCoI7g0aNfnni9Ql/Lw=;
        b=SwS+Cih80nutZomzgWh7gEfIjdsHzVNzGO1VuEi0kSyjBupeczNkz4hxPCBcQ/FsiH
         IeGzZ+OcCQlO0UsbSOonzrlE/Y6m+fSnrTUdJHQRYP/GGCcNW1bIzsSZH2ZUmmqIFz68
         WFe5uzBZGhg9yeX9hg0f7VPE7m6+s6UQcR0IIeD3nmeH9kG0mjyoQfQr8KTfclKhe7Me
         62QisMPXNyoNwzgQl6WLFAgr56HE0lc+NhljELOFMoseXXB+650uJEwyIf19OEKxBVHk
         4wjRpsGqwFJsvouuTGiDYCJYew8fBFstmw8FmsFe579VXSW38A0nLr2g0FdM5OBtmPvc
         SMbg==
X-Gm-Message-State: AO0yUKXq3JY52JdEg+nYzKIcYACWHPAEPq23ylLB1fkXbUIrBGDSQ7HO
        gJkrQ4SlXzchlqT5T6gWqDY=
X-Google-Smtp-Source: AK7set9ywH0iPXbx8MLsKKqviQkeTLzJRDrBRAxLuJBw8HSmq7UChKtBfFkT18N9TWB3movRkBUPdg==
X-Received: by 2002:a05:6870:7394:b0:16d:eac4:7b5f with SMTP id z20-20020a056870739400b0016deac47b5fmr14214221oam.48.1678391588740;
        Thu, 09 Mar 2023 11:53:08 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a18-20020a05687103d200b0017293fa734asm98142oag.48.2023.03.09.11.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:53:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 9 Mar 2023 11:53:07 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/887] 6.1.16-rc2 review
Message-ID: <2816288c-1701-41bf-ae66-53cf5d2a9fae@roeck-us.net>
References: <20230308091853.132772149@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308091853.132772149@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 08, 2023 at 10:29:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 516 pass: 516 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
