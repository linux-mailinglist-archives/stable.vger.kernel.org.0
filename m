Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A25569E463
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 17:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbjBUQUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 11:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233175AbjBUQUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 11:20:00 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9B1B744;
        Tue, 21 Feb 2023 08:19:59 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id c4so1997185ilr.13;
        Tue, 21 Feb 2023 08:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+/79zT62eGCeTFbWWbHZL6SBnBvWoPl0VA/4YXAtBMc=;
        b=EVyPHg71f/yKSKB5OafAD95khw/bL23Oai7yCp7FNOGc6yGMy9g/mtIxHqykPafOL+
         d0AKdIuCQObsBeKfN+W1N/bIeNQaxT4ceDo3TDDJNAWOBjbC6sf40Mps7OE9hG+eFb06
         pRCjaWXKh7xkOO/WME/B1pyeGdogCSRl11VUcQzcY1LeDJbeasJ+DjFHU1f6UpXIiAC3
         ortf0WQLBTvkhrrWZ9s9YwnEy7E/bXa8TAsm/0jXtBIsWQbWA+R6fOY2RXI/YBGvaUXq
         +sVoYDGu93tvS5ToP59tRnaARrFzptUgPm541oLl3zmP3WgFBvg43DJx5rK8pTJ1F1nS
         ZhSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/79zT62eGCeTFbWWbHZL6SBnBvWoPl0VA/4YXAtBMc=;
        b=MpWJKqgV/Vmi7KJeh6iZWtwpQoqCli7A/5zaU1mn00H0adhOgGDDqFAsytVBXGj0r/
         iMNTU2VwT95isLLKRnKoPc09afz7B3+EwTlJwe5CkfiA9tSpHMS8SwMJS019BMz3TBWF
         WbV6Z5ukxEcAAI5GSxXthoWjtsNp9cfyvx5FeAyKx++zLCFBi9kgzCSaXLQMY5iADLWr
         wWLNj/eieidxMHS8fCbfvvXNAORnhZNw72qU8LcyT6FdvUjPXXfoEK5ql3/6dgUtrRez
         6Ytb1md1hY6xL9eX/+GaDZ5heZxoozImp455xFON15pvmuIqOKtDB+EdDWLd7dM9w4/G
         sLrw==
X-Gm-Message-State: AO0yUKVsWa32N/JUU5FToej2bPu1MMpVqUJli7tQKU0zQJmvKdfV95nI
        wOlUNFEFEVMar0SRLPCKykU=
X-Google-Smtp-Source: AK7set9zvHNw4dzbMz9oI64UVgh/6agPhRRFT2OvDtuxnoiGrvqZa9PP/Jt4a91atpU+n49M8cENeA==
X-Received: by 2002:a92:c242:0:b0:315:5131:f8c5 with SMTP id k2-20020a92c242000000b003155131f8c5mr5886053ilo.31.1676996398693;
        Tue, 21 Feb 2023 08:19:58 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k9-20020a056e02156900b00316e39f1285sm222265ilu.82.2023.02.21.08.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 08:19:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Feb 2023 08:19:56 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/53] 4.14.306-rc1 review
Message-ID: <20230221161956.GA1588041@roeck-us.net>
References: <20230220133548.158615609@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
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

On Mon, Feb 20, 2023 at 02:35:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.306 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
