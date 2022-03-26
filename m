Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498504E7EC1
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 04:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiCZDWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 23:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbiCZDWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 23:22:11 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB9C532DD
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 20:20:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id n7-20020a17090aab8700b001c6aa871860so10296655pjq.2
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 20:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lWm9ycIfThVYctPz0nN/QIQj53UmIyPGIUl0jzAeMI0=;
        b=D+8p2sxBVhas58fdNDTSq8NZVsIXM4Jcy4CmIgp5WZgZZdrh8dO7yPxHD19WOykbpm
         OeJiPD8LIDXkR+7UONekJk81HybncPndwPZXFJd5sZbKiw6uBZlcOw3dAEFGCLDo6Er2
         3nQlQCS8DGo1P+UJ5GU2nq7UPFUMf1TvHDEPA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lWm9ycIfThVYctPz0nN/QIQj53UmIyPGIUl0jzAeMI0=;
        b=xL73zlNS+m8c2eLmQAWChoPlL8UEmsRYhkmQs/1pPDdOc2El6xudcGw1Cb91YgN6WB
         ORFbO99HyO3enbCOKMc2QkU7GHk39I1ujE2kBSim/d6nadK6aWWXikTcFS//xuPyGBnd
         DlZrKT6oZposYJYgobFDWoL7HLNjgwbtaI4ZvuuJZUblfd4riFwaXIkjsyVU3BN61Kkr
         L8/nGBmltLJCZH6EQIiWYD479c5kmbnWRlG1iy3XjPBCJcBjCFP81Z7muMicR/QEFPD4
         sqbUoztFw5Z9V6kj3MR+fifAzFzSbGub0odC+xwxthbsN/MgeyBDCbRfUui9LXlg7S75
         HTBA==
X-Gm-Message-State: AOAM532QYfHILawzBAyF+jsfTN+c3YgwdiBy3vw1hjET28b38y21nSub
        dZghhPQXIMwJiDVKPc6h/S5ONg==
X-Google-Smtp-Source: ABdhPJyB7Zc3sN8BPC2j2aYVDZAIXSkHgYXpUWPdhksJY1X15Msxf/Z3MoTs3diuQFkeHporCw7SvQ==
X-Received: by 2002:a17:90b:4d85:b0:1c7:3933:d810 with SMTP id oj5-20020a17090b4d8500b001c73933d810mr28939276pjb.129.1648264834962;
        Fri, 25 Mar 2022 20:20:34 -0700 (PDT)
Received: from ba72772bdc1f ([203.221.136.13])
        by smtp.gmail.com with ESMTPSA id h20-20020a056a001a5400b004fb1b4b010asm2954661pfv.162.2022.03.25.20.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 20:20:34 -0700 (PDT)
Date:   Sat, 26 Mar 2022 03:20:27 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Ronald Warsow <rwarsow@gmx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.17 00/39] 5.17.1-rc1 review
Message-ID: <20220326032027.GA7@ba72772bdc1f>
References: <67e05375-077f-ebc7-c691-b0a0a31b3479@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67e05375-077f-ebc7-c691-b0a0a31b3479@gmx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 25, 2022 at 05:45:45PM +0100, Ronald Warsow wrote:
> hallo Greg
> 
> 5.17.1-rc1
> 
> compiles, boots and runs on my x86_64
> (Intel i5-11400, Fedora 35)
> 
> btw I get:
> 
> iwlwifi 0000:00:14.3: Direct firmware load for
> iwlwifi-QuZ-a0-hr-b0-69.ucode failed with error -2
> 
> (not a regression in the 5.17-series, but compared to 5.16.x !)

Hi Ronald,

68 is the current correct firmware for the iwlwifi wireless cards
The 69 version (whilst supported by the kernel) is not
yet available. See the git below.

https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git/log/

[    2.797185] iwlwifi 0000:00:14.3: enabling device (0000 -> 0002)
[    2.798575] iwlwifi 0000:00:14.3: Direct firmware load for iwlwifi-QuZ-a0-hr-b0-69.ucode failed with error -2
[    2.803539] iwlwifi 0000:00:14.3: api flags index 2 larger than supported by driver
[    2.803550] iwlwifi 0000:00:14.3: TLV_FW_FSEQ_VERSION: FSEQ Version: 89.3.35.37
[    2.803694] iwlwifi 0000:00:14.3: loaded firmware version 68.01d30b0c.0 QuZ-a0-hr-b0-68.ucode op_mode iwlmvm
[    2.855586] iwlwifi 0000:00:14.3: Detected Intel(R) Wi-Fi 6 AX201 160MHz, REV=0x351
[    2.979429] iwlwifi 0000:00:14.3: Detected RF HR B3, rfid=0x10a100
[    3.044410] iwlwifi 0000:00:14.3: base HW address:
