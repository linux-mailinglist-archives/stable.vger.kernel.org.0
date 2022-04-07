Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5334F867D
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 19:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243349AbiDGRqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 13:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243367AbiDGRqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 13:46:45 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BAC22C8D7;
        Thu,  7 Apr 2022 10:44:43 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id e189so6373661oia.8;
        Thu, 07 Apr 2022 10:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iV/MD9uIbwqu4F+SXP7ZcMowP52qdXB8VskgOt6wyOQ=;
        b=er1AUU+/TBDgn5+7BW6o/CiyuHIkeJ2btYg7pyDopQG+roc5yO5tFd/Bm7y4TavWqm
         oGdPB1tB4DGn1FnT1594tRQM6SjEZ0NEGYiDjQ9sc1vfaho1ZzbhqMI+DtcjAWfoqUat
         AY5E+ztoerX9Bn7Lm5qap6VjJVSfeApd4P7cVp7NBbbFUDn1ijAVi8Fh65CWs3KTRMlr
         u4j5PVDov8HbScUx9SLqI7haUEDLOIpnjKX+JmPjX2UUNoZFZiJ48kHYQOx9VIomkS3N
         2Ibot9bSIDGmCRn9kBfY/xqJrniKNNo5/M7Sv9ebK8eTnR4wgxPBd04j3uU7qNaJYYvf
         Y0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=iV/MD9uIbwqu4F+SXP7ZcMowP52qdXB8VskgOt6wyOQ=;
        b=Tj4PUN0Dl/x8+S11koJrATaoT5cpd6ddoQyQJU7Cq8Q+OnKCOs1Hjq9gqNEyWC0CDq
         f3+KTC6otUCnnLkoVa5nrcrN9Ibz+GY4izFYlEU8gigVUjSnKZkUERD7wcvtKcVFS/A7
         p9/qKSNm3ElGrO06ZP/ZzMHeHibM2jwIOfqgPh5gx9iwJl6UyzrlOIgxzyxq1+qhYc4Z
         BsW8tT3eRzBf0L9jyF09h+Gt/WvaEGLJjcOWJeKq98K7/ldZ6pKx/+0D8eKqdfVkPFOj
         LVn1WW8N1MxRog08at8+Vm0em0k2+6YTpku0ihUmhGk5xmLATMAk4wqFI4OL6kFn+0Vl
         p11g==
X-Gm-Message-State: AOAM530DwIV/utS8kJtqdZKcvo32rkyuK3MJYsBLed5AvrCx/yH53JFL
        54msC72IUaVzyVMOPmIno5MdkQp5JSo=
X-Google-Smtp-Source: ABdhPJwZsZsecesnYWSOqbz/U0tqnH0rkrTG8DgIp285MIMinXGbztBv++QCaDsGnqfnpBaxkEnB2g==
X-Received: by 2002:aca:90e:0:b0:2ee:e8d1:5e28 with SMTP id 14-20020aca090e000000b002eee8d15e28mr6117873oij.245.1649353482908;
        Thu, 07 Apr 2022 10:44:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p14-20020a056830304e00b005b246b673f2sm8167939otr.71.2022.04.07.10.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 10:44:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 7 Apr 2022 10:44:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
Message-ID: <20220407174440.GC1827081@roeck-us.net>
References: <20220406133122.897434068@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406133122.897434068@linuxfoundation.org>
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

On Wed, Apr 06, 2022 at 03:44:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter
