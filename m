Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A8A5627E6
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 02:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiGAA6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 20:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiGAA6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 20:58:20 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170D91EAD5;
        Thu, 30 Jun 2022 17:58:19 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h15-20020a17090a648f00b001ef3c529d77so3652257pjj.2;
        Thu, 30 Jun 2022 17:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P6KFV20BvvPiaa/xgd+DUAhE/IME9ZBlIlf7uSH+COs=;
        b=Gl8kxsVtq34PqvePS2EYPc38v/I60nwq5oUdrdODodZpOywu0ZFkBGhZZb6nHgOdis
         hlAjl+86BwW8egq2uuzfR5d/kHSZyuLcWL1gfP1Fhy4XOE3LXXU+ubgrRx6OQzzZnnT2
         vLXjbB/SIEcRcBvqezVv5+Jk3Ye0N48EACo7bAPxR208IptkuJ1AZn2IRNfskZS9rned
         jgsDpb3jcu6yV4/kGmi9zU6pzsFjnEwRjM5GT719nXWLA8gvRuQb0/sb96/YWboigugm
         2o1Mbvc6dhL77OSBFAf1xL4Jb0tRuWKxeRqTrGv4FdKtlnX1lgQia/nKpoGCf3YoD0pm
         p62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=P6KFV20BvvPiaa/xgd+DUAhE/IME9ZBlIlf7uSH+COs=;
        b=NRCJvC9x/kNz3dSW4b0nmFwS4YAu26bMhcZRLyjP7tZT1HUWNEjMORRQlsB3M2FE+h
         72Uu4/IBl8qBUTqipdACWsn5dOXE190s4e4F9VuJsU2NLx+J0PWyylWZ/+xp4zRuXONc
         u8xfYHeqbjyF1z1ly6x/7WmbDbaX+UcpN8JulnTpbocXAly6FO/yKi3yMH/8fZ8ORCwY
         qrL3R7eBBq6sf4mXO4x0hlW+OfWsyM54MVljgjcO4VWf29kAHlV8+xY0G14jJHGZJIe4
         n7hC95+2nw+xcsIPCVoBk8QkMAi34s+jl3gRhxQgygQJ6IgZMog/9wo56zq5nP1cexpe
         XvOQ==
X-Gm-Message-State: AJIora93G8fpZ9FDyk7xbz+4Xa8O+fsBYuGF2ahGT3IkZnUWaw/Mr+jt
        HqkiO9iML4JXHv5oGyTwyqM=
X-Google-Smtp-Source: AGRyM1tH5pMca2r2MB9Y1kerqykK6OPusO6FyLoaq0Xcrcqyr+sNGiCKKgErj3EOcUj/DUNXoS95zA==
X-Received: by 2002:a17:902:6b0c:b0:16a:5973:df32 with SMTP id o12-20020a1709026b0c00b0016a5973df32mr17329667plk.70.1656637098626;
        Thu, 30 Jun 2022 17:58:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bf27-20020a056a000d9b00b0051bd9981ccbsm13876169pfb.39.2022.06.30.17.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 17:58:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 30 Jun 2022 17:58:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/28] 5.15.52-rc1 review
Message-ID: <20220701005816.GF3104033@roeck-us.net>
References: <20220630133232.926711493@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
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

On Thu, Jun 30, 2022 at 03:46:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.52 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
