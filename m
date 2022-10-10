Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2CA5F9FC1
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 16:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiJJODU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 10:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJJODT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 10:03:19 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5613CBD6;
        Mon, 10 Oct 2022 07:03:18 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id j23so13248450lji.8;
        Mon, 10 Oct 2022 07:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=KNC0x1NT1G6WocYzRu2s+IU+n1bM4+6bJosXAT8XLIRxxeMhehCS4KOIFc7UfpdngH
         yyObuQ0xQixHHD3+IHjca79034qNpdfqLHPy20QZpOw2hhRR7niqOqzHLNzKWRrV70sx
         J3vcN2aL8dhHDkQAVZfId41b1j/ecITAxY8wCEh7DzUzx0OPd0/T2wpmhEMHTsXCY10g
         0joc/M16dU0uY3s6sgWoV5IpAIDjbV0ZaH++IJ47muPyqXCGS777VxrBdwQvfBlFTHdL
         xEWm+LyqFdQyEYk5Mm4hLLZd+k/KMKVVq0onU2o6Hvmk/CZOj9mERxWLajCMDJInSCxQ
         qaKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=G/UQ3UYP5820WziAqf9gnFDJEs0zAz46zFHa091EIS/RNi5Lo5ApFbuFJbAQO5oXoY
         KervaAOQnm6pDejzmPu1o+LDM2ozNKxWfCCxWvyPgB0y0pAlKXgCh/RVeBA3KaasilvT
         bg9BgBNc0BFLMw+73oeDxjPIN9Z5aymRgMIJZi1lty2EwD+8H/WE50ZFlVrbKrXWN7tx
         ArLb4gvCO//sj1exdXxgtVgAM13fkZg+BgPdGxY2aDEesPYAMLbwRKVmrDHm+mzsZlU7
         aDix/GKCQ2GgdKMpHu1Cy15vxyhqzft6s6t6NQmtzaTga99eG8vVYBlLpW7cd1bbDuah
         JYpA==
X-Gm-Message-State: ACrzQf0Rb4XCgrYZguXZVShts6sUTr8E+4VlPDOkDzYeyyzBkooyZTDF
        0kYpcAx3YI2s5chqk5FzH/mv8+RI6hKsjjxwrHxdWtd1Gks=
X-Google-Smtp-Source: AMsMyM6yEXSvGPsBByO/7Xdnom54+8SkD1GMf4I59K6HB7rkrqDLu2vyHPhaVYnHr9usFRYGyvaQoqO0BGPef5r6B+c=
X-Received: by 2002:a05:651c:1786:b0:26d:aaec:1487 with SMTP id
 bn6-20020a05651c178600b0026daaec1487mr6972005ljb.287.1665410596981; Mon, 10
 Oct 2022 07:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <20221010070330.159911806@linuxfoundation.org>
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Mon, 10 Oct 2022 19:33:05 +0530
Message-ID: <CAHokDBmh7NGD5ru9iPwbD4rxL46Vrgtu0KMRJHe_p3a1-3q7kg@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regressions found

Tested-by: Fenil Jain <fkjainco@gmail.com>
