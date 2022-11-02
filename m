Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660A4615B5E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 05:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiKBETv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 00:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKBETu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 00:19:50 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FCB1707D;
        Tue,  1 Nov 2022 21:19:49 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so831216pjl.3;
        Tue, 01 Nov 2022 21:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5keqTtPI9E/C6kmYZ6zrLzVi1P0iB+SBY54miNIX3PM=;
        b=W7DQrcn1dwoipKG7MoiSCGRtQbcVbDxbHnTjy0PgMXL2gC2mNbo6XajRNZHQak1yxv
         H2cd2E10Z45IAW19sjm2fCKVSasp93T1mz2PdrkbBbvPRocT63lItmQ9F45QaHW3vsMM
         NxavBZQsT2jqgc27rjbNdqgweHOSkEsXK4MmpG06Da776Dw1eZaLdFFeD66VQCQhQzmF
         q4HGUYTqHQ26K3lyWHyEiH9PMTEnrPWTqx69X+zpgSX6x8Cx42jqV39wIUMaMbtyWpLb
         2gFK5T6vnUfTVbFs+lcukYp//Dk6Qbvn08tZ20Ectr6XY1qBMBJzcC/LRUQmOdGfLwwS
         N1iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5keqTtPI9E/C6kmYZ6zrLzVi1P0iB+SBY54miNIX3PM=;
        b=DIgpMvvKFbbnSTuN1D01jcPDuC/u2B+gqa58dOT80mCIdQEYBuyL0Br9/mxndx1ygC
         HJuVVf80o/zu1fskYQCHK+9QEUmD64NMBb7Q9x1jb4aiGQ5uEDd6RmCO9d7RsrJnLWa7
         n08go8elc5tLwcpYSUQzgpD5J2AMBMptS4B+JuK/PzNQpyPUYWvC0HjIUaDPexVLChUS
         vL458tU/q5Tdhan89XNzBcdygedbadmr5OJOfHG+Vw+yoYjBrLmIHuClXRxFGddlLtAx
         riCQOyU57YHjxwtBne1FTHjXX+fWpWF9wmo2smTt/eC6DUS/TO2AFZBBQhMGQax2YMxs
         tz7A==
X-Gm-Message-State: ACrzQf39mjOQqKTZxwUS4VYu793rorWP8ihuwQqS9cWyIGICAff+QYCk
        LxA5vEM1ICJ2fv1cWrXsUYefewMPCgdS8g==
X-Google-Smtp-Source: AMsMyM4Tzy8kXq9CySKjOz7rMt313amDlXD8V9bWf6aGEafrOPEk9R07XoeRjhWQHjbAG+hdTCYPlQ==
X-Received: by 2002:a17:90b:2684:b0:213:8a8:b5df with SMTP id pl4-20020a17090b268400b0021308a8b5dfmr23634380pjb.77.1667362789311;
        Tue, 01 Nov 2022 21:19:49 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-86.three.co.id. [180.214.233.86])
        by smtp.gmail.com with ESMTPSA id 10-20020a63154a000000b004393f60db36sm6640647pgv.32.2022.11.01.21.19.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 21:19:48 -0700 (PDT)
Message-ID: <b1914779-0303-3d37-a504-e1715f7ee0af@gmail.com>
Date:   Wed, 2 Nov 2022 11:19:44 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] Documentation: process: Describe kernel version prefix
 for third option
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@denx.de>,
        Biju Das <biju.das.jz@bp.renesas.com>
References: <20221101131743.371340-1-bagasdotme@gmail.com>
 <Y2EfhWxk0j/oVLJx@kroah.com>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <Y2EfhWxk0j/oVLJx@kroah.com>
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

On 11/1/22 20:30, Greg Kroah-Hartman wrote:
> 
> No, sorry, this is not needed and does not have to be in the subject
> line at all.
> 
> The current wording is fine, it's just that people don't always read it.
> 
> so consider this a NAK.
> 

Hi Greg,

There was a case when a submitter submitted multiple backports (which
qualified for third option) without specifying the prefix, hence a
reviewer complained [1].

[1]: https://lore.kernel.org/all/20221101074351.GA8310@amd/

-- 
An old man doll... just what I always wanted! - Clara

