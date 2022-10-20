Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36E5605523
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 03:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiJTBqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 21:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiJTBqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 21:46:30 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724E6182C53;
        Wed, 19 Oct 2022 18:46:29 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id f9so470235plb.13;
        Wed, 19 Oct 2022 18:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tn04uKVcL+tZBjaUZs/YKjiSbekOuRMEOqC+T3cEAyA=;
        b=YslriB2C/MUGQ+3mDRVYdXRyAQPQCDHX6qqBLa8lfuWIIOBAmEISEAwqKwqsmW9ZEB
         X28lS0h8JFPi44eaElEe/8D1LZx+yttIIqp+ALbuLK9+JXSjDu2bIOK1GEF01SypLXca
         BjDRLVmEXEZFSmivvOoMxnmLFksDl14oaZTwX8XLv0Gg52YLWq2ZxBIFzuFd9Y7h86r8
         JvRIMPzyL6M1fovyWabkX1SZG7Ya66U8fjO1Zd37hgyXLSLNEcTDKPREf8TnFMjS6too
         PwldgdV9p/rIjoVY62doCme0hrlYQVVQiQwLTf0OA+3KbocUs32eAHHBVGt6FTCTuKxL
         qOuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tn04uKVcL+tZBjaUZs/YKjiSbekOuRMEOqC+T3cEAyA=;
        b=xReD0wwFSWYDbI/ZkwVb5zNDcoliu0tlnOas0I6guY6KU/fZ4iFeztgvJzOlPT4OjG
         HZ13JadNdXVONlh48ZhcXW+oFKK/yweE9a5LqRwXxdxQ//buXzSu2bfQvIMcg/RK5lCF
         xZPOH96dm3uQYTA5QFr7ddNcyYevzk4F4YJP1IKMuolJMdg5YqGVtRi5dLwUNkrxRMP1
         sY4Sbty9bhbjig1DM9Efn0qwO/BMSUmWQhGCXjuu5wXOvQUON9TTlw9DSY8koLCW5SWa
         4C73pnfYCPwzIFxaUw+VfMFDPq7rAtHUs4I77wnKyrun9xk+KOZ8qqZy+ihBhCP3c+r9
         qPbw==
X-Gm-Message-State: ACrzQf2iPn4iVPLhfNP1sP0WF54eBQXtNXstEC8T+mdfxILd5amKIQSq
        gv4VSpXiYNuRe+MaKzfaylY=
X-Google-Smtp-Source: AMsMyM6H3onhDGXAvA4+BUQP2G6ayeuIDQOpbQmZaZ9HBOyRLXakXnRQj8NqZrfgA5Ec3rSZg/oUpg==
X-Received: by 2002:a17:902:e88b:b0:17f:8514:cf5f with SMTP id w11-20020a170902e88b00b0017f8514cf5fmr11374761plg.163.1666230388688;
        Wed, 19 Oct 2022 18:46:28 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-16.three.co.id. [180.214.232.16])
        by smtp.gmail.com with ESMTPSA id q18-20020aa79612000000b00537b6bfab7fsm12361736pfg.177.2022.10.19.18.46.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 18:46:28 -0700 (PDT)
Message-ID: <a3679479-b1fd-29c6-d6b5-502b15ffbd4a@gmail.com>
Date:   Thu, 20 Oct 2022 08:46:22 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: =?UTF-8?Q?Re=3a_=5bPATCH_6=2e0_659/862=5d_ARM/dma-mapp=d1=96ng=3a_d?=
 =?UTF-8?Q?ont_override_-=3edma=5fcoherent_when_set_from_a_bus_notifier?=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083319.087440003@linuxfoundation.org>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221019083319.087440003@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/19/22 15:32, Greg Kroah-Hartman wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> [ Upstream commit 49bc8bebae79c8516cb12f91818f3a7907e3ebce ]
> 
> Commit ae626eb97376 ("ARM/dma-mapping: use dma-direct unconditionally")
> caused a regression on the mvebu platform, wherein devices that are
> dma-coherent are marked as dma-noncoherent, because although
> mvebu_hwcc_notifier() after that commit still marks then as coherent,
> the arm_coherent_dma_ops() function, which is called later, overwrites
> this setting, since it is being called from drivers/of/device.c with
> coherency parameter determined by of_dma_is_coherent(), and the
> device-trees do not declare the 'dma-coherent' property.
> 
> Fix this by defaulting never clearing the dma_coherent flag in
> arm_coherent_dma_ops().
> 

The patch subject looks mangled, right?

-- 
An old man doll... just what I always wanted! - Clara

