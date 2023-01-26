Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFC267CA9C
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 13:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjAZMLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 07:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbjAZMLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 07:11:24 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FFB42BFC
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 04:11:22 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id g23so1608684plq.12
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 04:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sNH9BgItuJxPa+eQE400FTpJfbjpuq0SQX7Oz1zEQmQ=;
        b=nyYH+EAa9sQBNFb0LS1x4ubn81c7aVwrrxUpsSuNx8DZUFVMayUTE9ud3+tX6T1/f1
         rMX3w5m/I+B+MFyi3tmFjvNCuYLhnv7NM/rXOPXSKwBU+c0s1c8wbfDL6MS8QauEpvy0
         jq/Yrziow9vdDMpxADYNq9+GaL/1AZ6iQStgF7m+KRZy5litKOBQOAUtAJHU9IOej3Sd
         w65H1JxYMYngmHmVQNIxdTfYfMnccQ5qR2x0Pa/4v+cPac5wGoAXv81drjyadRfmaflC
         2rX0Jud0yZZzbPROqv7QxZvJtG/NRcT69giK8cH7lk7K8t1aAsohOv6T27cgxab5xaV/
         K9/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sNH9BgItuJxPa+eQE400FTpJfbjpuq0SQX7Oz1zEQmQ=;
        b=rVnIa3pISOCTE+j1Peu1eS8jFRQWVwbt7TGevJpDBcAyI2nn16xfGtFahMSo77kgwS
         xUVpFmMk/U4yDPMJdvsZsI2cdSgMS4vBWAquQfWR55FlP5KYjRKYtzykg1LXaGb3FwBB
         x9QXgZUGSEEewPbEg+y3ASIdnIpUbzguLw48hN9TLMbwFlWbeWLiVuNuCKe1KgRfCYuu
         QTtu9bSwm+zy8NyYLppRtDf2kxtrTMP4Lf2L4wAhKTizb8bYxaXJZ7M1PFJIJr1Va4Fb
         tDNX9FxlgafVsNvmzTxaafLlhOM7e30oEIAhzNjHvoICm6ilL+Zdgt6H+8hnSzwMfpRB
         WXGw==
X-Gm-Message-State: AFqh2krDA+2tcG0WJ+vqeLNC/Bk2AQZhNU7n6mDMDZ9gKKGfJFFopm5k
        bczbyuflBcBpw4D7gp3XHCW3ITCMonbKajH3C8g=
X-Google-Smtp-Source: AMrXdXuFqtx7VJhHOePOU1h6zSNyVQV15v5UxhfACqGq2uTSZYIrTFAIz4zRPIVRSkL+pDde7okQ8SFWXRuJ42y0i8A=
X-Received: by 2002:a17:902:b111:b0:189:a50d:2a23 with SMTP id
 q17-20020a170902b11100b00189a50d2a23mr4021705plr.32.1674735082305; Thu, 26
 Jan 2023 04:11:22 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:522:a50f:b0:4ba:defb:97e4 with HTTP; Thu, 26 Jan 2023
 04:11:21 -0800 (PST)
Reply-To: fionahill.2023@outlook.com
From:   Fiona Hill <angelaemmanuel672@gmail.com>
Date:   Thu, 26 Jan 2023 04:11:21 -0800
Message-ID: <CA+OK53=jt2wyk=jhSUx8bm7_q8=eMRc88e1ga3+H6piLEPE+Jw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello,did you receive my message?
