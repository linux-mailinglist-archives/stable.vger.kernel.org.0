Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF9154B508
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 17:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245143AbiFNPsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 11:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244359AbiFNPsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 11:48:52 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B882182C;
        Tue, 14 Jun 2022 08:48:50 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y196so8914310pfb.6;
        Tue, 14 Jun 2022 08:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ReMfmyhV636BKHluPmxrRh/9FnLApqDbgajop+vcehk=;
        b=OJ7mlWWYdccKNB56VGU9kfXkNVW14GsvyNNva7mbq+/DQMwQ9eoqjO4S6AVdnx8WC7
         JFACeWxRBbNSWFSObW9Qab7IWB8REeTMdT7O72YNyz7VGtL0e1zLPQaYpfnjjE5bAKn4
         WCZU1X/qKyz24gc/8VRZcLD0b8rD22TXgJscIwwNG/F92l3+RoDrfWWgehTec6OBTEd/
         3h5pyRpZzXReAdIYsxR6VsA97gj7KTqXUWhAQZKYZ4gSIkKs5a7UJhvT0+cJAVPpGOCS
         apo4nJybSzumIeVTATOq6v50WmMQSIpvLv3/fSTVnBJKByu22rAp+l+8qOpIdWfT1fmg
         wFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ReMfmyhV636BKHluPmxrRh/9FnLApqDbgajop+vcehk=;
        b=xvMKgsN6ElPCYNiJsjXXaQetODHW2K+WyA9XrnM6bXva2aQ4ewF8OkRFusAZQ2kN1q
         E/cH6SSRPO+JfamDu0MDai9IpPFS4fgFyFod/X+nPRzwB8C4KigLj9X0mE6K3DnpD1Rp
         Shrj8inQtkAVyMQlnHe3upaIajlB51n4a+3ES1zAuXgne8l3y2PvfcJ6H5thWFmvoa3e
         icjKv83gQVVy4/l0UvqLO6wKVs1gX6Ab9cjo989/nnqpUxup1L5HKiXBUf7SvfWCQa6h
         8wENfr0NgIbYXBpQtfq+Q+xDohVSF21a4C6l5MRdU1iNZFNSK1WSRfrJJdAvQb8lFu1q
         hfFg==
X-Gm-Message-State: AJIora9xWpaUH2ngd+xyCxXwZ71PszCbDqygEWrmDkgt+0wt++SSWRCl
        lWYlw9iLSS994VTaonR6hvs=
X-Google-Smtp-Source: AGRyM1t3b0rNThIFq8QkHcA0vfRDTDU8VdBfnOZI3WwLFwAdf4Lj3KOo/Hb3IM7PJ6/lp1aicdwezQ==
X-Received: by 2002:a63:8b42:0:b0:408:a938:289b with SMTP id j63-20020a638b42000000b00408a938289bmr3036453pge.201.1655221730184;
        Tue, 14 Jun 2022 08:48:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x10-20020a627c0a000000b0050e006279bfsm7769401pfc.137.2022.06.14.08.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 08:48:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 14 Jun 2022 08:48:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/343] 5.18.4-rc2 review
Message-ID: <20220614154848.GA3192067@roeck-us.net>
References: <20220613181233.078148768@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613181233.078148768@linuxfoundation.org>
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

On Mon, Jun 13, 2022 at 08:18:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.4 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:11:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
