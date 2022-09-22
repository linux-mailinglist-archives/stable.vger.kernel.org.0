Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFAC5E68C3
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 18:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiIVQpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 12:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiIVQo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 12:44:58 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5D546213;
        Thu, 22 Sep 2022 09:44:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id d64-20020a17090a6f4600b00202ce056566so2978402pjk.4;
        Thu, 22 Sep 2022 09:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=LBk8RP/Al3SUhAyoThFlNoigk2FywB1qRMNqEYYKw3Q=;
        b=FO34frMZwkwA5Vg7V+0ZfZlpz3iLzjSgNid2K8NEXrO54HDbU7KZ9Qcd9iN4c+C7U5
         iD+6W7fojqjmr9daT1Y8i5hBAlS7HTEvVVw3stjJ8nTLDdFWkBzio7UuEbeCfsQpiVBc
         MWgFw6H8k1Iyw44ZEn/KuoljWoG+wUFJUKlMMbskP8PYJ6POYosDtiFnByyPSTj9sQrs
         jiG3bAuDC0QTGkkML6Sz0fWfTTW8cQAyVZ3g7BWl4ga41Yo8sX8L/ch7Em53weQ06vxg
         QmEVbnIal4k9xqDzYYbecHx2oWC76PevP/jrpMLcAYeQacoTOKETntaLDh2K9LH6/rlL
         farw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LBk8RP/Al3SUhAyoThFlNoigk2FywB1qRMNqEYYKw3Q=;
        b=A6ehvXtQjHrMwWCJ+vZkMzYz1jgSGygQmtJ9WNrKSv5ZtmCXwtoVJGRdw3bpn2CoKY
         v/qsgfqw1H3u+fuKBEvMRQLlKojJsYwMPhgOHS5sbZx/PhxyB0G+Kb2tRX7eMAe9YCTv
         TOd6860GjEnYW8x70yrFO9PBCePn80fyOLQ3WPyxrCmE28i7umhSKBCunsdw+EY33BbG
         mKK5GKmLa+T50bithjwSmWLVZ8yyHRJig4nyNQIjKORMvXL1fPjFl1zArzzB2ovaIE5l
         G9GpJbN6HpUxbqCPK5VOaYxx448aJ3lQnaJ/+PzB6+QHJvmhawydOFtSNyc6xqEDtYFI
         F8Gg==
X-Gm-Message-State: ACrzQf39iWKDtwBnlki5rUYNJN3o98AxNrbOBOvOzVf2o0lV3XNdNAD0
        YV3XVAMaW/c+ltLVlgnTz/c=
X-Google-Smtp-Source: AMsMyM4XcdqX4GY2chg3zGr2GLVFBgOpRu1oNhw1W8Csn4GKxL14/DRUOvPQ2Unh6kJPjBLfe3gysQ==
X-Received: by 2002:a17:902:a9c1:b0:178:60a9:8f30 with SMTP id b1-20020a170902a9c100b0017860a98f30mr4283440plr.0.1663865094296;
        Thu, 22 Sep 2022 09:44:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902f54d00b0016dbaf3ff2esm4371601plf.22.2022.09.22.09.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 09:44:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 22 Sep 2022 09:44:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 00/39] 5.19.11-rc2 review
Message-ID: <20220922164452.GD1138811@roeck-us.net>
References: <20220921164741.757857192@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921164741.757857192@linuxfoundation.org>
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

On Wed, Sep 21, 2022 at 06:47:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.11 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 16:47:28 +0000.
> Anything received after that time might be too late.
> 

Sorry, this is the one I should have replied to.

Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 490 pass: 490 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
