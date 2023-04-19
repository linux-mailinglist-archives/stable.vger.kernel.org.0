Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADAF6E71A1
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 05:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjDSDeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 23:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbjDSDeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 23:34:15 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4483C2B;
        Tue, 18 Apr 2023 20:34:14 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id w11so28264784plp.13;
        Tue, 18 Apr 2023 20:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681875253; x=1684467253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RfBfcpS+L63GdTTNo+3CNcyPC/4C30kAdFfVzUywa8E=;
        b=LNr3G2rN6WuwmVXL/AnNLsAvn7Q8CFUyy1X9HAt4E3FSphBYD0hbrBQ2fSyLc4aR4v
         VxS5dd2N3amFj9wrTZrcsPF5Y8YqN/91b0gBtc8gXGESK+wemCX3LlM5EUAW7N0O3s9y
         sk6lEHkmJbFAq0Yd8xutBqYlfNXrEnEm+6dJiCyQ0adLIspxrx/0orhyqpP7cC3eCnnf
         uDi4Uz1PHaxHzea3C8901BQ2mxeXqdNufvA2qzT+1BY7KoOunpzaCF4Dbf/0Iow9931O
         LQoyMi3lGdfMOAqAB2YEtTEPqMoxRRoWRcLCMbcvWgt5iFF4tMI40xQqQ4B3bBgsmB1K
         /y9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681875253; x=1684467253;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RfBfcpS+L63GdTTNo+3CNcyPC/4C30kAdFfVzUywa8E=;
        b=XMgjB+vomCFScPeO8SFJaq5f5L21A/ok55V+IKnRJ8n28i+fwc8dQp55LXGjsrDyp3
         SgSerTmERTZetFL+tEo0wUm7pi/1NrLLizGi2q60b1ejfo5ueKTnz6jnnfyWL1G1J3T6
         QKq1vWdsfLfZ5UuC5xTTWww8e3xcTq/sO80s0E+eF55rW8IgL8uCWlDRrmpUkIQVit8I
         nQ+0RJvXw6OxdRG7MylxDi6cLzvRLecuqdGA2Cp4J9UU46XXACO3Lhua1KIk+Nae4c1a
         pCPmP4tCycWVJTrqOcXrrgC7jjVEB4+MJlXYE4ju9sl5trC5o5cPkf4E0MRLX1kMtBaf
         btew==
X-Gm-Message-State: AAQBX9e3fQwpsn/a3iV9sDu73s+UXsmjg/xbLyeyn10ziGfboYJC8qsB
        2Fn3jf45A75rmxbp2mtp/aY=
X-Google-Smtp-Source: AKy350bvqjqUG+U16npP4rvjE4Y900PulxQTY52CJ8wAT4yDxw565HXPW1SyFJIoQxVrLUGGZCjkaA==
X-Received: by 2002:a05:6a20:430c:b0:ef:7b11:3ae with SMTP id h12-20020a056a20430c00b000ef7b1103aemr2022568pzk.52.1681875253457;
        Tue, 18 Apr 2023 20:34:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v26-20020a63481a000000b0051f14839bf3sm2216130pga.34.2023.04.18.20.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 20:34:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 18 Apr 2023 20:34:12 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/92] 5.4.241-rc1 review
Message-ID: <931f7cb4-923b-4ab8-8b44-fd4a9d24c210@roeck-us.net>
References: <20230418120304.658273364@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 02:20:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.241 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
